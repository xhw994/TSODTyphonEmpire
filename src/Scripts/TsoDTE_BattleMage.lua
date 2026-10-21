-- =============================================================================
-- WP13 战斗法师：湮灭之创、战场再生、通知
-- 环境：Gameplay（InGame AddGameplayScripts）
--
-- 【编队规则】（用户已定，R1，2026-10-21）
--   军团（CORPS，2 人）：只有战场再生（ABILITY_TSOD_ARMY_REGENERATION），每回合回血。
--     不能施放湮灭之创，武器库存为 0。组成时发 REGEN 通知。
--   军队（ARMY，3 人）：有湮灭之创（ABILITY_TSOD_ANNIHILATION_SCAR）与战场再生。
--     武器库存 = 场上军队的数量。组成时发 READY 通知。
--   军团与军队都每回合回血。
--
-- 【按编队计，不按单位计】
--   一个编队里的每个战斗法师都是引擎里的单位对象，编队成员之间靠编队 ID 相连（N6）。
--   本模块按编队 ID 分组，每组选一个主体（ID 与编队 ID 相同者，否则 ID 最小者）：
--     - 库存、湮灭之创、战场再生只算在主体上，成员不计数、不持有能力、不回血；
--     - 每个编队每回合只回一次血（主体回 REGEN_HEAL 点）。
--   已死或已标记延迟死亡（IsDead / IsDelayedDeath）的单位不计入。
--
-- 【湮灭之创】
-- 施放的是武器 WMD_TSOD_ANNIHILATION_SCAR（UNITOPERATION_WMD_STRIKE）。
-- 施放的那支军队整支阵亡（施放者所在编队的全部成员），库存 −1。
-- 库存只由 ReconcilePlayer 维护，只动这一种武器，不碰官方核弹。
-- 非军队状态的施放者发射任何武器都不处理。
--
-- 【对账】
-- ReconcilePlayer 按场上状态重算库存和能力，是「设成目标值」而不是「加减一次」，
-- 所以事件次序不影响结果，重复调用也安全。在回合开始、编队变化、施放开始 / 结束时调用。
-- 军团被打死、被俘之类的边角情况都由回合开始的对账兜底，不逐个处理。
--
-- 【回血】
-- 每个编队每回合开始，主体回复 REGEN_HEAL 点生命（需 ABILITY_TSOD_ARMY_REGENERATION）。
--
-- 【通知】
-- 只发给人类玩家。AI 的阵亡与回血都不发通知。
--
-- 【联机】只读写游戏状态。不用 math.random、不用 ExposedMembers，不做本地玩家判断。
-- 【存档】库存在 PlayerWMDs 里，能力在单位上，读档后由回合开始的对账核对。
--   唯一的 Lua 状态是 tPendingStrike：施放开始到结束之间记下的阵亡名单，结束时清空。
--
-- 【日志】施放相关的行都以 [TsoDTE] 开头：
--   strike: ...          施放开始时的单位、武器、编队状态（Started）
--   strike: victim ...   阵亡前后是否还在单位列表里（Kill 前后）
--   strike end: ...      施放结束时施放者是否还在、补杀了哪些（Deactivated）
--   formation mismatch   编队 ID 分组的人数与引擎的编队人数不符（N6）
--   Battle mage reconcile: 库存变化（只在变化时打印）
--
-- 【需实证】每条的退路见代码对应位置的注释
--   N1  UnitOperationStarted 里 UnitManager.Kill 施放单位，引擎是否还会结算爆炸。
--       Kill 无效时，Deactivated 补杀（见 OnUnitOperationDeactivated）。
--   N2  pUnit:GetOperationParameter 能否读到 PARAM_WMD_TYPE / PARAM_X / PARAM_Y。
--   N3  引擎施放时是否自己扣库存。对账同时挂在 Started 与 Deactivated，两种情况下结果都正确。
--   N4  PlayerWMDs:ChangeWeaponCount 是否接受负数。
--   N5  UnitFormCorps / UnitFormArmy 在 Gameplay 环境是否派发（UI 环境已确认在用）。
--       不派发时，回合开始的对账仍会补上能力，只是缺组成通知。
--   N6  同一编队的成员是否报告相同的 GetFormationID。分组依据，见上文「按编队计」。
--       不同时日志会出现 formation mismatch 行。
--   N7  AI 会不会滥用（WMDCapable=1 之后 AI 可能选这个武器）。
--   N8  军队回血与原版静止回血是否叠加。
--   N9  Game.AddWorldViewText 的第一个参数：这里传施放者 / 阵亡者的玩家 ID。
--       若 AI 施放时人类看不到浮字，改传 0（BlackDeath 原版用的是 0）。
-- =============================================================================

local UNIT_BATTLE_MAGE = 'UNIT_TSOD_BATTLE_MAGE'
local WEAPON_SCAR      = 'WMD_TSOD_ANNIHILATION_SCAR'
local ABILITY_SCAR     = 'ABILITY_TSOD_ANNIHILATION_SCAR'
local ABILITY_REGEN    = 'ABILITY_TSOD_ARMY_REGENERATION'

local NOTIF_READY      = 'NOTIFICATION_TSOD_ANNIHILATION_READY'
local NOTIF_SACRIFICE  = 'NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE'
local NOTIF_REGEN      = 'NOTIFICATION_TSOD_ARMY_REGENERATION'

local TXT_READY_MSG     = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE'
local TXT_READY_SUM     = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY'
local TXT_SACRIFICE_MSG = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE'
local TXT_SACRIFICE_SUM = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY'
local TXT_REGEN_MSG     = 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE'
local TXT_REGEN_SUM     = 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY'
local TXT_EXHAUSTED     = 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED'

-- 每回合回复的生命。与原版静止回血是否叠加见 N8。
local REGEN_HEAL = 10

-- 启动时查出来的索引与枚举（InitTsoDTEBattleMage 里填）
local UnitTypeIndex = -1
local WeaponIndex = -1
local FormationCorps = nil
local FormationArmy = nil
local NotifyHash = {}          -- [通知类型名] = 哈希

-- 施放开始时记下的阵亡名单：[玩家ID .. ':' .. 施放者ID] = { 单位ID, … }。Deactivated 时用完即清。
local tPendingStrike = {}

-- -----------------------------------------------------------------------------
-- 基础查询
-- -----------------------------------------------------------------------------
local function FindUnit(iPlayer, iUnit)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        return nil
    end
    return pPlayer:GetUnits():FindID(iUnit)
end

local function IsBattleMage(pUnit)
    return pUnit ~= nil and pUnit:GetType() == UnitTypeIndex
end

-- 返回 'army' / 'corps' / 'standard'
local function FormationState(pUnit)
    local iFormation = pUnit:GetMilitaryFormation()
    if iFormation == FormationArmy then
        return 'army'
    elseif iFormation == FormationCorps then
        return 'corps'
    end
    return 'standard'
end

-- 编队信息只用于日志（N6）：编队 ID 与编队人数。读不到写 ?。
local function FormationDebug(pUnit)
    local bOkId, vId = pcall(function() return pUnit:GetFormationID() end)
    local bOkCount, vCount = pcall(function() return pUnit:GetFormationUnitCount() end)
    return 'id=' .. (bOkId and tostring(vId) or '?') .. ' count=' .. (bOkCount and tostring(vCount) or '?')
end

-- 施放单位与目标坐标从操作参数里读。读不到返回 nil 并记日志（N2）。
local function ReadOperationParam(pUnit, iParam)
    local bOk, vValue = pcall(function() return pUnit:GetOperationParameter(iParam) end)
    if not bOk then
        print('[TsoDTE] Battle mage: GetOperationParameter failed (N2): ' .. tostring(vValue))
        return nil
    end
    return vValue
end

-- 能力按数量授予：要有就保证为 1，不要就保证为 0。返回是否新授予（N5 相关）。
local function SetAbilityPresence(pAbility, sAbility, bWanted)
    local iCount = pAbility:GetAbilityCount(sAbility)
    if bWanted and iCount < 1 then
        pAbility:ChangeAbilityCount(sAbility, 1)
        return true
    elseif (not bWanted) and iCount > 0 then
        pAbility:ChangeAbilityCount(sAbility, -iCount)
    end
    return false
end

-- 通知只发给人类玩家
local function NotifyHuman(iPlayer, sNotif, sMsg, sSum, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() then
        return
    end
    local hType = NotifyHash[sNotif]
    if hType == nil then
        print('[TsoDTE] Battle mage: notification type not registered: ' .. sNotif)
        return
    end
    NotificationManager.SendNotification(iPlayer, hType, Locale.Lookup(sMsg), Locale.Lookup(sSum), iX, iY)
end

-- -----------------------------------------------------------------------------
-- 编队分组（按编队计，见文件头）
-- -----------------------------------------------------------------------------
-- 已死或已标记延迟死亡的单位不计入（引擎里它们可能仍在列表中，UnitFlagManager 也是这样跳过的）。
local function IsGoingToDie(pUnit)
    return pUnit:IsDead() or pUnit:IsDelayedDeath()
end

-- 编队键：同一编队的成员报告相同的 GetFormationID（N6，需实证）。
-- 读不到或为负数时，该单位自成一组（退化为按单位计数，日志里会有 formation mismatch）。
local function FormationKey(pUnit)
    local bOk, iId = pcall(function() return pUnit:GetFormationID() end)
    if bOk and type(iId) == 'number' and iId >= 0 then
        return 'f' .. tostring(iId)
    end
    return 'u' .. tostring(pUnit:GetID())
end

-- 主体：ID 与编队 ID 相同者（若存在），否则 ID 最小者。确定性，各端一致。
local function ChooseLead(sKey, aMembers)
    local iFormationId = tonumber(string.match(sKey, '^f(%d+)$'))
    local pLead, pMin = nil, nil
    for _, pUnit in ipairs(aMembers) do
        local iId = pUnit:GetID()
        if iFormationId ~= nil and iId == iFormationId then
            pLead = pUnit
        end
        if pMin == nil or iId < pMin:GetID() then
            pMin = pUnit
        end
    end
    return pLead or pMin
end

-- 收集本玩家的战斗法师，分成编队与普通状态两类。
-- 返回：
--   tGroups[key] = { state = 'army'|'corps', lead = 主体单位, members = { 单位… } }
--   aKeys        = 编队键的列表（顺序不影响结果）
--   aStandard    = 普通状态的战斗法师单位列表
local function CollectFormations(iPlayer)
    local tGroups = {}
    local aKeys = {}
    local aStandard = {}
    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        return tGroups, aKeys, aStandard
    end

    for _, pUnit in pPlayer:GetUnits():Members() do
        if IsBattleMage(pUnit) and not IsGoingToDie(pUnit) then
            local sState = FormationState(pUnit)
            if sState == 'standard' then
                table.insert(aStandard, pUnit)
            else
                local sKey = FormationKey(pUnit)
                local tGroup = tGroups[sKey]
                if tGroup == nil then
                    tGroup = { state = sState, members = {} }
                    tGroups[sKey] = tGroup
                    table.insert(aKeys, sKey)
                end
                if sState == 'army' then
                    tGroup.state = 'army'
                end
                table.insert(tGroup.members, pUnit)
            end
        end
    end

    for _, sKey in ipairs(aKeys) do
        local tGroup = tGroups[sKey]
        tGroup.lead = ChooseLead(sKey, tGroup.members)
        -- 人数核对（N6）：分组人数与引擎报告的编队人数不符时记一行，供实测对照
        local bOk, iCount = pcall(function() return tGroup.lead:GetFormationUnitCount() end)
        if bOk and type(iCount) == 'number' and iCount ~= #tGroup.members then
            print('[TsoDTE] formation mismatch (N6): key ' .. sKey .. ' members ' .. #tGroup.members
                .. ' GetFormationUnitCount ' .. tostring(iCount))
        end
    end
    return tGroups, aKeys, aStandard
end

-- -----------------------------------------------------------------------------
-- 对账
-- -----------------------------------------------------------------------------
-- 按场上状态重算库存与能力。
--   库存目标 = 军队数（每个军队算一次，不按人数）。军团不计入库存。
--   能力只给主体：军队主体有湮灭之创与战场再生；军团主体只有战场再生。
--   成员（被并入的单位）与普通状态的单位两种能力都收回。
-- 返回 tGroups, aKeys，供回血使用。
local function ReconcilePlayer(iPlayer)
    local tGroups, aKeys, aStandard = CollectFormations(iPlayer)

    for _, pUnit in ipairs(aStandard) do
        local pAbility = pUnit:GetAbility()
        SetAbilityPresence(pAbility, ABILITY_SCAR, false)
        SetAbilityPresence(pAbility, ABILITY_REGEN, false)
    end

    local iArmy = 0
    for _, sKey in ipairs(aKeys) do
        local tGroup = tGroups[sKey]
        local iLeadID = tGroup.lead:GetID()
        for _, pUnit in ipairs(tGroup.members) do
            local pAbility = pUnit:GetAbility()
            if pUnit:GetID() == iLeadID then
                SetAbilityPresence(pAbility, ABILITY_SCAR, tGroup.state == 'army')
                SetAbilityPresence(pAbility, ABILITY_REGEN, true)
            else
                SetAbilityPresence(pAbility, ABILITY_SCAR, false)
                SetAbilityPresence(pAbility, ABILITY_REGEN, false)
            end
        end
        if tGroup.state == 'army' then
            iArmy = iArmy + 1
        end
    end

    local pPlayer = Players[iPlayer]
    if pPlayer ~= nil then
        local pWMDs = pPlayer:GetWMDs()
        local iHave = pWMDs:GetWeaponCount(WeaponIndex)
        if iHave ~= iArmy then
            -- 设成目标值，用差额调库存（N3、N4）。不是「扣一」，所以引擎是否也扣过都不影响结果。
            pWMDs:ChangeWeaponCount(WeaponIndex, iArmy - iHave)
            print('[TsoDTE] Battle mage reconcile: player ' .. iPlayer .. ' stock ' .. iHave .. ' -> ' .. iArmy)
        end
    end
    return tGroups, aKeys
end

-- -----------------------------------------------------------------------------
-- 编队变化
-- -----------------------------------------------------------------------------
-- 军团：只给战场再生，通知 REGEN（只发人类）
local function OnUnitFormCorps(iPlayer, iUnit)
    local pUnit = FindUnit(iPlayer, iUnit)
    if not IsBattleMage(pUnit) then
        return
    end
    SetAbilityPresence(pUnit:GetAbility(), ABILITY_REGEN, true)
    NotifyHuman(iPlayer, NOTIF_REGEN, TXT_REGEN_MSG, TXT_REGEN_SUM, pUnit:GetX(), pUnit:GetY())
    ReconcilePlayer(iPlayer)
end

-- 军队：湮灭之创与战场再生，通知 READY（只发人类）
local function OnUnitFormArmy(iPlayer, iUnit)
    local pUnit = FindUnit(iPlayer, iUnit)
    if not IsBattleMage(pUnit) then
        return
    end
    local pAbility = pUnit:GetAbility()
    SetAbilityPresence(pAbility, ABILITY_SCAR, true)
    SetAbilityPresence(pAbility, ABILITY_REGEN, true)
    NotifyHuman(iPlayer, NOTIF_READY, TXT_READY_MSG, TXT_READY_SUM, pUnit:GetX(), pUnit:GetY())
    ReconcilePlayer(iPlayer)
end

-- -----------------------------------------------------------------------------
-- 湮灭之创的施放
-- -----------------------------------------------------------------------------
-- 离目标最近的一支战斗法师军队（F6，待删）。距离相同时取单位 ID 小的，保证各端一致。
local function FindNearestScarUnit(iPlayer, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        return nil
    end
    local pBest = nil
    local iBestDist = nil
    for _, pUnit in pPlayer:GetUnits():Members() do
        if IsBattleMage(pUnit) and FormationState(pUnit) == 'army' then
            local iDist = Map.GetPlotDistance(pUnit:GetX(), pUnit:GetY(), iX, iY)
            if pBest == nil or iDist < iBestDist or (iDist == iBestDist and pUnit:GetID() < pBest:GetID()) then
                pBest = pUnit
                iBestDist = iDist
            end
        end
    end
    return pBest
end

-- UnitOperationStarted(ownerID, unitID, operationID)
-- 需实证 N1：在 Started 里 Kill，引擎是否还会结算爆炸。
--   Kill 没生效时，Deactivated 会补杀（见下）。
local function OnUnitOperationStarted(iOwner, iUnit, iOperation)
    if iOperation ~= UnitOperationTypes.WMD_STRIKE then
        return
    end
    local pStriker = FindUnit(iOwner, iUnit)
    if pStriker == nil then
        print('[TsoDTE] strike: striker ' .. iUnit .. ' of player ' .. iOwner .. ' not found at Started')
        return
    end

    local sState = FormationState(pStriker)
    local bArmyBattleMage = IsBattleMage(pStriker) and sState == 'army'
    local iWeapon = ReadOperationParam(pStriker, UnitOperationTypes.PARAM_WMD_TYPE)
    print('[TsoDTE] strike: player ' .. iOwner .. ' unit ' .. iUnit
        .. ' weapon ' .. tostring(iWeapon) .. ' (WeaponIndex ' .. WeaponIndex .. ')'
        .. ' state ' .. sState .. ' formation ' .. FormationDebug(pStriker))

    if iWeapon == nil then
        -- N2 退路：读不到武器类型时，只有军队状态的战斗法师按湮灭之创处理（它们唯一能放的武器）。
        -- 其他单位读不到就不处理，宁可漏杀也不误杀。
        if not bArmyBattleMage then
            print('[TsoDTE] strike: weapon type unreadable, striker not an army, ignored (N2)')
            return
        end
        iWeapon = WeaponIndex
        print('[TsoDTE] strike: weapon type unreadable, army striker, 按后备规则判定 (N2)')
    end
    if iWeapon ~= WeaponIndex then
        return
    end

    local iTargetX = ReadOperationParam(pStriker, UnitOperationTypes.PARAM_X)
    local iTargetY = ReadOperationParam(pStriker, UnitOperationTypes.PARAM_Y)
    if iTargetX == nil or iTargetY == nil then
        iTargetX, iTargetY = pStriker:GetX(), pStriker:GetY()
        print('[TsoDTE] Battle mage: target unreadable (N2), using striker position')
    end

    -- 阵亡名单：施放的军队整支（施放者所在编队的全部成员）。
    -- F6（待删）：施放者不是军队状态的战斗法师时，由离目标最近的一支军队代为阵亡。
    local aVictims = nil
    if bArmyBattleMage then
        local tGroups = CollectFormations(iOwner)
        local tGroup = tGroups[FormationKey(pStriker)]
        if tGroup ~= nil then
            aVictims = tGroup.members
        else
            aVictims = { pStriker }
        end
    else
        local pNearest = FindNearestScarUnit(iOwner, iTargetX, iTargetY)
        if pNearest == nil then
            print('[TsoDTE] Battle mage: strike by non-army unit, no army to sacrifice (F6), logged only')
            return
        end
        print('[TsoDTE] Battle mage: strike by non-army unit, unit ' .. pNearest:GetID() .. ' sacrificed instead (F6)')
        aVictims = { pNearest }
    end

    local iX, iY = aVictims[1]:GetX(), aVictims[1]:GetY()
    local aVictimIDs = {}
    for _, pVictim in ipairs(aVictims) do
        local iVictimID = pVictim:GetID()
        table.insert(aVictimIDs, iVictimID)
        print('[TsoDTE] strike: victim ' .. iVictimID .. ' before Kill')
        UnitManager.Kill(pVictim)
        -- Kill 之后不再使用 pVictim（引擎可能已释放），只按 ID 重新查
        local pAfter = FindUnit(iOwner, iVictimID)
        if pAfter ~= nil then
            print('[TsoDTE] strike: victim ' .. iVictimID .. ' after Kill, still in list, delayed='
                .. tostring(pAfter:IsDelayedDeath()))
        else
            print('[TsoDTE] strike: victim ' .. iVictimID .. ' after Kill, removed from list')
        end
    end
    -- Deactivated 时据此补杀
    tPendingStrike[iOwner .. ':' .. iUnit] = aVictimIDs

    NotifyHuman(iOwner, NOTIF_SACRIFICE, TXT_SACRIFICE_MSG, TXT_SACRIFICE_SUM, iX, iY)
    Game.AddWorldViewText(iOwner, Locale.Lookup(TXT_EXHAUSTED), iX, iY)   -- N9
    ReconcilePlayer(iOwner)
end

-- UnitOperationDeactivated(playerID, unitID, hOperation, iData1)
-- 施放结束后：1) 名单里还在、又没标记延迟死亡的，补杀（N1 退路：Started 里的 Kill 没生效）；
--             2) 再对账一次，纠正库存（N3）。
local function OnUnitOperationDeactivated(iOwner, iUnit, iOperation, iData1)
    if iOperation ~= UnitOperationTypes.WMD_STRIKE then
        return
    end
    local sKey = iOwner .. ':' .. iUnit
    local aVictimIDs = tPendingStrike[sKey]
    tPendingStrike[sKey] = nil
    local iKilledAgain = 0
    for _, iVictimID in ipairs(aVictimIDs or {}) do
        local pLeft = FindUnit(iOwner, iVictimID)
        if pLeft ~= nil and not IsGoingToDie(pLeft) then
            print('[TsoDTE] strike end: victim ' .. iVictimID .. ' still alive after Started, killing again')
            UnitManager.Kill(pLeft)
            iKilledAgain = iKilledAgain + 1
        end
    end
    local pAfter = FindUnit(iOwner, iUnit)
    print('[TsoDTE] strike end: player ' .. iOwner .. ' unit ' .. iUnit
        .. ' still in list=' .. tostring(pAfter ~= nil) .. ' killed again=' .. iKilledAgain)
    ReconcilePlayer(iOwner)
end

-- -----------------------------------------------------------------------------
-- 回血（每个编队每回合只回一次，回主体）
-- -----------------------------------------------------------------------------
local function HealFormations(iPlayer, tGroups, aKeys)
    for _, sKey in ipairs(aKeys) do
        local pLead = tGroups[sKey].lead
        if pLead:GetAbility():GetAbilityCount(ABILITY_REGEN) > 0 then
            local iDamage = pLead:GetDamage()
            if iDamage > 0 then
                local iNew = math.max(0, iDamage - REGEN_HEAL)
                pLead:SetDamage(iNew)
                print('[TsoDTE] Army regen: player ' .. iPlayer .. ' unit ' .. pLead:GetID()
                    .. ' damage ' .. iDamage .. ' -> ' .. iNew)
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- 回合开始：对账 + 回血
-- -----------------------------------------------------------------------------
local function OnTsoDTEBattleMageTurnActivated(iPlayer, bIsFirstTime)
    local tGroups, aKeys = ReconcilePlayer(iPlayer)
    HealFormations(iPlayer, tGroups, aKeys)
end

-- -----------------------------------------------------------------------------
local function InitTsoDTEBattleMage()
    local tUnit = GameInfo.Units[UNIT_BATTLE_MAGE]
    local tWeapon = GameInfo.WMDs[WEAPON_SCAR]
    if tUnit == nil or tWeapon == nil then
        print('[TsoDTE] Battle mage: unit or weapon row missing, module disabled')
        return
    end
    UnitTypeIndex = tUnit.Index
    WeaponIndex = tWeapon.Index

    if MilitaryFormationTypes ~= nil then
        FormationCorps = MilitaryFormationTypes.CORPS_FORMATION
        FormationArmy = MilitaryFormationTypes.ARMY_FORMATION
    end
    if FormationCorps == nil or FormationArmy == nil then
        print('[TsoDTE] Battle mage: MilitaryFormationTypes missing, module disabled')
        return
    end

    for _, sName in ipairs({ NOTIF_READY, NOTIF_SACRIFICE, NOTIF_REGEN }) do
        NotifyHash[sName] = DB.MakeHash(sName)
    end

    Events.UnitFormCorps.Add(OnUnitFormCorps)
    Events.UnitFormArmy.Add(OnUnitFormArmy)
    Events.UnitOperationStarted.Add(OnUnitOperationStarted)
    Events.UnitOperationDeactivated.Add(OnUnitOperationDeactivated)
    Events.PlayerTurnActivated.Add(OnTsoDTEBattleMageTurnActivated)
    print('[TsoDTE] Battle mage module initialized')
end

InitTsoDTEBattleMage()
