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
-- 【湮灭之创】
-- 施放的是武器 WMD_TSOD_ANNIHILATION_SCAR（UNITOPERATION_WMD_STRIKE）。
-- 施放的那支军队随之阵亡，库存 −1。
-- 库存只由 ReconcilePlayer 维护，只动这一种武器，不碰官方核弹。
-- 非军队状态的施放者发射任何武器都不处理（F6 已删）。
--
-- 【对账】
-- ReconcilePlayer 按场上状态重算库存和能力，是「设成目标值」而不是「加减一次」，
-- 所以事件次序不影响结果，重复调用也安全。在回合开始、编队变化、施放开始 / 结束时调用。
-- 军团被打死、被俘之类的边角情况都由回合开始的对账兜底，不逐个处理。
--
-- 【回血】
-- 军团与军队的每个战斗法师每回合开始回复 REGEN_HEAL 点生命（需 ABILITY_TSOD_ARMY_REGENERATION）。
--
-- 【通知】
-- 只发给人类玩家。AI 的阵亡与回血都不发通知。
--
-- 【联机】只读写游戏状态。不用 math.random、不用 ExposedMembers，不做本地玩家判断。
-- 【存档】本脚本不存任何 Lua 状态：库存在 PlayerWMDs 里，能力在单位上，读档后由回合开始的对账核对。
--
-- 【需实证】每条的退路见代码对应位置的注释
--   N1  UnitOperationStarted 里 UnitManager.Kill 施放单位，引擎是否还会结算爆炸。
--   N2  pUnit:GetOperationParameter 能否读到 PARAM_WMD_TYPE / PARAM_X / PARAM_Y。
--   N3  引擎施放时是否自己扣库存。对账同时挂在 Started 与 Deactivated，两种情况下结果都正确。
--   N4  PlayerWMDs:ChangeWeaponCount 是否接受负数。
--   N5  UnitFormCorps / UnitFormArmy 在 Gameplay 环境是否派发（UI 环境已确认在用）。
--       不派发时，回合开始的对账仍会补上能力，只是缺组成通知。
--   N6  一支军团或军队只对应一个单位对象（库存计数的依据）。
--       未确认：目前按单位计数，见修复提交的去重说明。
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
-- 对账
-- -----------------------------------------------------------------------------
-- 按场上状态重算库存与能力。
--   库存目标 = 军队数（R1）。军团不计入库存。
--   能力：军队有湮灭之创与战场再生；军团只有战场再生；普通状态的都收回。
local function ReconcilePlayer(iPlayer)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        return
    end

    local iArmy = 0
    for _, pUnit in pPlayer:GetUnits():Members() do
        if IsBattleMage(pUnit) then
            local sState = FormationState(pUnit)
            local pAbility = pUnit:GetAbility()
            if sState == 'army' then
                iArmy = iArmy + 1
            end
            SetAbilityPresence(pAbility, ABILITY_SCAR, sState == 'army')
            SetAbilityPresence(pAbility, ABILITY_REGEN, sState ~= 'standard')
        end
    end

    local pWMDs = pPlayer:GetWMDs()
    local iHave = pWMDs:GetWeaponCount(WeaponIndex)
    if iHave ~= iArmy then
        -- 设成目标值，用差额调库存（N3、N4）。不是「扣一」，所以引擎是否也扣过都不影响结果。
        pWMDs:ChangeWeaponCount(WeaponIndex, iArmy - iHave)
        print('[TsoDTE] Battle mage reconcile: player ' .. iPlayer .. ' stock ' .. iHave .. ' -> ' .. iArmy)
    end
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
--   退路：把阵亡挪到 UnitOperationDeactivated（同一个 hOperation == WMD_STRIKE）里做。
local function OnUnitOperationStarted(iOwner, iUnit, iOperation)
    if iOperation ~= UnitOperationTypes.WMD_STRIKE then
        return
    end
    local pStriker = FindUnit(iOwner, iUnit)
    if pStriker == nil then
        return
    end

    -- N2：武器类型读不到时不处理，只记日志。宁可漏杀也不误杀。
    local iWeapon = ReadOperationParam(pStriker, UnitOperationTypes.PARAM_WMD_TYPE)
    if iWeapon == nil then
        print('[TsoDTE] Battle mage: weapon type unreadable, strike ignored (N2)')
        return
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

    local pVictim = nil
    if IsBattleMage(pStriker) and FormationState(pStriker) == 'army' then
        pVictim = pStriker
    else
        -- F6：施放者不是军队状态的战斗法师，由离目标最近的一支军队代为阵亡（待删）
        pVictim = FindNearestScarUnit(iOwner, iTargetX, iTargetY)
        if pVictim == nil then
            print('[TsoDTE] Battle mage: strike by non-army unit, no army to sacrifice (F6), logged only')
            return
        end
        print('[TsoDTE] Battle mage: strike by non-army unit, unit ' .. pVictim:GetID() .. ' sacrificed instead (F6)')
    end

    local iX, iY = pVictim:GetX(), pVictim:GetY()
    UnitManager.Kill(pVictim)
    NotifyHuman(iOwner, NOTIF_SACRIFICE, TXT_SACRIFICE_MSG, TXT_SACRIFICE_SUM, iX, iY)
    Game.AddWorldViewText(iOwner, Locale.Lookup(TXT_EXHAUSTED), iX, iY)   -- N9
    ReconcilePlayer(iOwner)
end

-- UnitOperationDeactivated(playerID, unitID, hOperation, iData1)
-- 施放结束后再对账一次。若引擎在 Started 之后才扣库存（N3），这里把库存纠正回来。
local function OnUnitOperationDeactivated(iOwner, iUnit, iOperation, iData1)
    if iOperation == UnitOperationTypes.WMD_STRIKE then
        ReconcilePlayer(iOwner)
    end
end

-- -----------------------------------------------------------------------------
-- 回血（军团与军队都回）
-- -----------------------------------------------------------------------------
local function HealFormations(iPlayer)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        return
    end
    for _, pUnit in pPlayer:GetUnits():Members() do
        if IsBattleMage(pUnit) and FormationState(pUnit) ~= 'standard'
            and pUnit:GetAbility():GetAbilityCount(ABILITY_REGEN) > 0 then
            local iDamage = pUnit:GetDamage()
            if iDamage > 0 then
                local iNew = math.max(0, iDamage - REGEN_HEAL)
                pUnit:SetDamage(iNew)
                print('[TsoDTE] Army regen: player ' .. iPlayer .. ' unit ' .. pUnit:GetID()
                    .. ' damage ' .. iDamage .. ' -> ' .. iNew)
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- 回合开始：对账 + 回血
-- -----------------------------------------------------------------------------
local function OnTsoDTEBattleMageTurnActivated(iPlayer, bIsFirstTime)
    ReconcilePlayer(iPlayer)
    HealFormations(iPlayer)
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
