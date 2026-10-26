-- WP13 战斗法师：湮灭之创、战场再生、通知（Gameplay；InGame AddGameplayScripts）。
-- 军团（2 个合成）有战场再生；军队（3 个合成）再加湮灭之创，玩家库存 = 场上战斗法师军队数。

local UNIT_BATTLE_MAGE = 'UNIT_TSOD_BATTLE_MAGE'
local WEAPON_SCAR      = 'WMD_TSOD_ANNIHILATION_SCAR'
local ABILITY_SCAR     = 'ABILITY_TSOD_ANNIHILATION_SCAR'
local ABILITY_REGEN    = 'ABILITY_TSOD_ARMY_REGENERATION'
local PROPERTY_SPENT   = 'TSOD_TYPHON_SCAR_SPENT'
local PROPERTY_REGEN_TURN = 'TSOD_TYPHON_REGEN_TURN'

local TXT_READY_MSG     = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_MESSAGE'
local TXT_READY_SUM     = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_READY_SUMMARY'
local TXT_SACRIFICE_MSG = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_MESSAGE'
local TXT_SACRIFICE_SUM = 'LOC_NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE_SUMMARY'
local TXT_REGEN_MSG     = 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_MESSAGE'
local TXT_REGEN_SUM     = 'LOC_NOTIFICATION_TSOD_ARMY_REGENERATION_SUMMARY'
local TXT_EXHAUSTED     = 'LOC_TSOD_ANNIHILATION_SCAR_EXHAUSTED'

local REGEN_HEAL = 10

-- 启动时填
local UnitTypeIndex = -1
local WeaponIndex = -1
local FormationCorps = nil
local FormationArmy = nil
local NotifyReady = nil
local NotifySacrifice = nil
local NotifyRegen = nil

-- 基础查询
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

local function IsSpent(pUnit)
    return pUnit:GetProperty(PROPERTY_SPENT) ~= nil
end

-- 'army' / 'corps' / 'standard'
local function FormationState(pUnit)
    local iFormation = pUnit:GetMilitaryFormation()
    if iFormation == FormationArmy then
        return 'army'
    elseif iFormation == FormationCorps then
        return 'corps'
    end
    return 'standard'
end

local STATE_RANK = { standard = 0, corps = 1, army = 2 }

-- 按格分组：{ [key] = { lead = pUnit, state = 'army'|'corps'|'standard', members = {...}, spent = bool } }
-- 返回 tGroups 和按 key 排好序的 aKeys（联机各端遍历顺序一致）
-- 同格不可能有两个独立的陆地军事单位，所以每组只认 ID 最小的单位。
local function CollectGroups(iPlayer)
    local pPlayer = Players[iPlayer]
    local tGroups = {}
    local aKeys = {}
    if pPlayer == nil then
        return tGroups, aKeys
    end
    for _, pUnit in pPlayer:GetUnits():Members() do
        if IsBattleMage(pUnit) then
            local sKey = pUnit:GetX() .. ',' .. pUnit:GetY()
            local tGroup = tGroups[sKey]
            if tGroup == nil then
                tGroup = { lead = pUnit, state = 'standard', members = {}, spent = false }
                tGroups[sKey] = tGroup
                table.insert(aKeys, sKey)
            end
            table.insert(tGroup.members, pUnit)
            if pUnit:GetID() < tGroup.lead:GetID() then
                tGroup.lead = pUnit
            end
            local sState = FormationState(pUnit)
            if STATE_RANK[sState] > STATE_RANK[tGroup.state] then
                tGroup.state = sState
            end
            if IsSpent(pUnit) then
                tGroup.spent = true
            end
        end
    end
    table.sort(aKeys)
    return tGroups, aKeys
end

-- 能力按数量授予：要有就保证为 1，不要就保证为 0。返回是否新授予。
local function SetAbilityPresence(pUnit, sAbility, bWanted)
    local pAbility = pUnit:GetAbility()
    local iCount = pAbility:GetAbilityCount(sAbility)
    if bWanted and iCount < 1 then
        pAbility:ChangeAbilityCount(sAbility, 1)
        return true
    elseif (not bWanted) and iCount > 0 then
        pAbility:ChangeAbilityCount(sAbility, -iCount)
    end
    return false
end

local function NotifyHuman(iPlayer, hType, sMsg, sSum, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() or hType == nil then
        return
    end
    local bOk, sErr = pcall(function()
        NotificationManager.SendNotification(iPlayer, hType, Locale.Lookup(sMsg), Locale.Lookup(sSum), iX, iY)
    end)
    if not bOk then
        print('[TsoDTE] Battle mage: notification failed: ' .. tostring(sErr))
    end
end

-- 对账：能力与库存
-- 把能力与库存「设成目标值」，重复调用安全；军队被打死、被俘等边角情况由回合开始的对账兜底。
local function ReconcilePlayer(iPlayer)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or WeaponIndex < 0 then
        return
    end

    local tGroups, aKeys = CollectGroups(iPlayer)
    local iArmies = 0
    for _, sKey in ipairs(aKeys) do
        local tGroup = tGroups[sKey]
        local pLead = tGroup.lead
        local bArmy = tGroup.state == 'army' and not tGroup.spent
        local bRegen = tGroup.state ~= 'standard'
        if bArmy then
            iArmies = iArmies + 1
        end
        for _, pUnit in ipairs(tGroup.members) do
            local bIsLead = pUnit:GetID() == pLead:GetID()
            local bNewScar = SetAbilityPresence(pUnit, ABILITY_SCAR, bIsLead and bArmy)
            local bNewRegen = SetAbilityPresence(pUnit, ABILITY_REGEN, bIsLead and bRegen)
            if bNewScar then
                NotifyHuman(iPlayer, NotifyReady, TXT_READY_MSG, TXT_READY_SUM, pUnit:GetX(), pUnit:GetY())
            elseif bNewRegen then
                NotifyHuman(iPlayer, NotifyRegen, TXT_REGEN_MSG, TXT_REGEN_SUM, pUnit:GetX(), pUnit:GetY())
            end
        end
    end

    local pWMDs = pPlayer:GetWMDs()
    local iHave = pWMDs:GetWeaponCount(WeaponIndex)
    if iHave ~= iArmies then
        pWMDs:ChangeWeaponCount(WeaponIndex, iArmies - iHave)
        print('[TsoDTE] Battle mage reconcile: player ' .. iPlayer .. ' stock ' .. iHave .. ' -> ' .. iArmies)
    end
end

-- 编队变化：只对账（通知在对账里按「新授予」发，不依赖这两个事件在 Gameplay 是否派发）
local function OnFormationEvent(iPlayer, iUnit)
    if IsBattleMage(FindUnit(iPlayer, iUnit)) then
        ReconcilePlayer(iPlayer)
    end
end

-- 施放：Gameplay 环境收不到 UnitOperationStarted，只收得到 Deactivated（hOperation == WMD_STRIKE），到这时引擎已扣掉一发库存（2026-10-21 Lua.log 实证）。
-- 故阵亡在这里做：施放者是军队状态的战斗法师且库存 < 军队数 → 整支军队阵亡。
-- 施放过的单位标 PROPERTY_SPENT：Kill 没立刻生效也不再计入库存，免得「没死就每回合补一发」。
local function CountLiveArmies(iPlayer)
    local tGroups, aKeys = CollectGroups(iPlayer)
    local iArmies = 0
    for _, sKey in ipairs(aKeys) do
        if tGroups[sKey].state == 'army' and not tGroups[sKey].spent then
            iArmies = iArmies + 1
        end
    end
    return iArmies, tGroups
end

local function OnUnitOperationDeactivated(iOwner, iUnit, hOperation, iData1)
    if hOperation ~= UnitOperationTypes.WMD_STRIKE then
        return
    end
    local pPlayer = Players[iOwner]
    local pStriker = FindUnit(iOwner, iUnit)
    if pPlayer == nil or pStriker == nil or not IsBattleMage(pStriker) then
        ReconcilePlayer(iOwner)
        return
    end

    local iArmies, tGroups = CountLiveArmies(iOwner)
    local iStock = pPlayer:GetWMDs():GetWeaponCount(WeaponIndex)
    local tGroup = tGroups[pStriker:GetX() .. ',' .. pStriker:GetY()]
    local sState = tGroup and tGroup.state or FormationState(pStriker)
    print('[TsoDTE] strike end: player ' .. iOwner .. ' unit ' .. iUnit .. ' state ' .. sState
        .. ' stock ' .. iStock .. ' armies ' .. iArmies)

    if sState ~= 'army' or iStock >= iArmies then
        ReconcilePlayer(iOwner)
        return
    end

    local aMembers = (tGroup and tGroup.members) or { pStriker }
    local iX, iY = pStriker:GetX(), pStriker:GetY()
    local aIDs = {}
    for _, pUnit in ipairs(aMembers) do
        pUnit:SetProperty(PROPERTY_SPENT, 1)
        table.insert(aIDs, pUnit:GetID())
    end
    for _, iID in ipairs(aIDs) do
        local pUnit = FindUnit(iOwner, iID)
        if pUnit ~= nil then
            UnitManager.Kill(pUnit)
        end
    end
    local iLeft = 0
    for _, iID in ipairs(aIDs) do
        if FindUnit(iOwner, iID) ~= nil then
            iLeft = iLeft + 1
        end
    end
    print('[TsoDTE] strike end: army at ' .. iX .. ',' .. iY .. ' killed ' .. #aIDs .. ' unit(s), still listed ' .. iLeft)

    NotifyHuman(iOwner, NotifySacrifice, TXT_SACRIFICE_MSG, TXT_SACRIFICE_SUM, iX, iY)
    local bOk, sErr = pcall(Game.AddWorldViewText, iOwner, Locale.Lookup(TXT_EXHAUSTED), iX, iY)
    if not bOk then
        print('[TsoDTE] Battle mage: AddWorldViewText failed: ' .. tostring(sErr))
    end
    ReconcilePlayer(iOwner)
end

-- 读档、重连会让 PlayerTurnActivated 同一回合再来一次：按回合记一笔，每个编队每回合只回一次。
local function HealFormations(iPlayer)
    local iTurn = Game.GetCurrentGameTurn()
    local tGroups, aKeys = CollectGroups(iPlayer)
    for _, sKey in ipairs(aKeys) do
        local pLead = tGroups[sKey].lead
        local iLastTurn = pLead:GetProperty(PROPERTY_REGEN_TURN)
        if iLastTurn ~= iTurn and pLead:GetAbility():GetAbilityCount(ABILITY_REGEN) > 0 then
            pLead:SetProperty(PROPERTY_REGEN_TURN, iTurn)
            local iDamage = pLead:GetDamage()
            if iDamage > 0 then
                local iNew = math.max(0, iDamage - REGEN_HEAL)
                pLead:SetDamage(iNew)
                print('[TsoDTE] Regen: player ' .. iPlayer .. ' unit ' .. pLead:GetID()
                    .. ' damage ' .. iDamage .. ' -> ' .. iNew)
            end
        end
    end
end

local function OnTsoDTEBattleMageTurnActivated(iPlayer, bIsFirstTime)
    ReconcilePlayer(iPlayer)
    HealFormations(iPlayer)
end

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

-- 自定义类型的通知实机不出现，用官方剧本的 USER_DEFINED_1..3。
    if NotificationTypes ~= nil then
        NotifyReady = NotificationTypes.USER_DEFINED_1
        NotifySacrifice = NotificationTypes.USER_DEFINED_2
        NotifyRegen = NotificationTypes.USER_DEFINED_3
    end

    Events.UnitFormCorps.Add(OnFormationEvent)
    Events.UnitFormArmy.Add(OnFormationEvent)
    Events.UnitOperationDeactivated.Add(OnUnitOperationDeactivated)
    Events.PlayerTurnActivated.Add(OnTsoDTEBattleMageTurnActivated)
    print('[TsoDTE] Battle mage module initialized (notification types '
        .. tostring(NotifyReady) .. ', ' .. tostring(NotifySacrifice) .. ', ' .. tostring(NotifyRegen) .. ')')
end

InitTsoDTEBattleMage()
