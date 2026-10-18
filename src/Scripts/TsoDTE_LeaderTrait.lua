-- =============================================================================
-- WP3 领袖能力「凡人的韧性」之「何不用之」
-- 环境：Gameplay（InGame AddGameplayScripts）
--
-- 战斗中击杀敌方单位后，若尚未研究该单位的前置科技（Units.PrereqTech），
-- 立即获得该科技的尤里卡。每项科技最多由本能力触发一次。
-- 只对领袖为 LEADER_TSOD_ROSETTA_AUGUSTUS（或其 LeaderTraits 带本特性）的玩家生效。
--
-- 联机：只读写游戏状态，不用 Game.GetLocalPlayer、不用 math.random、不用 ExposedMembers。
-- 存档：「已由本能力触发」的标记存在玩家属性里（SetProperty），读档不丢。
--
-- 被杀单位的类型：Events 是事后派发的，派发时被杀单位可能已从 PlayerUnits 里移除
-- （官方 NotificationPanel 的 OnUnitKilledInCombat 也按「FindID 可能为 nil」处理）。
-- 所以先 FindID，取不到再查本脚本维护的单位类型缓存。缓存不进存档，每次加载重建。
-- =============================================================================

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROPERTY_PREFIX = 'TSOD_TYPHON_KILL_BOOST_'   -- + TechnologyType

-- [playerID] = pPlayer，拥有本能力的玩家
local TyphonPlayers = {}
local TyphonPlayerCount = 0

-- [techIndex] = true，在 Boosts 表里有尤里卡的科技
local TechHasBoost = {}

-- [playerID] = { [unitID] = unitTypeIndex }
local UnitTypeCache = {}

-- -----------------------------------------------------------------------------
local function CollectTyphonPlayers()
    local tLeaders = { [LEADER_TYPHON] = true }
    for row in GameInfo.LeaderTraits() do
        if row.TraitType == TRAIT_TYPHON then
            tLeaders[row.LeaderType] = true
        end
    end

    local tPlayers = {}
    local iCount = 0
    for _, iPlayer in ipairs(PlayerManager.GetWasEverAliveIDs()) do
        local pConfig = PlayerConfigurations[iPlayer]
        local pPlayer = Players[iPlayer]
        if pConfig ~= nil and pPlayer ~= nil and tLeaders[pConfig:GetLeaderTypeName()] then
            tPlayers[iPlayer] = pPlayer
            iCount = iCount + 1
        end
    end
    return tPlayers, iCount
end

local function CollectBoostedTechs()
    local tTechs = {}
    for row in GameInfo.Boosts() do
        if row.TechnologyType ~= nil then
            local tTech = GameInfo.Technologies[row.TechnologyType]
            if tTech ~= nil then
                tTechs[tTech.Index] = true
            end
        end
    end
    return tTechs
end

-- -----------------------------------------------------------------------------
-- 单位类型缓存
-- -----------------------------------------------------------------------------
local function CacheUnitType(playerID, unitID, unitTypeIndex)
    if unitTypeIndex == nil or unitTypeIndex < 0 then
        return
    end
    local tUnits = UnitTypeCache[playerID]
    if tUnits == nil then
        tUnits = {}
        UnitTypeCache[playerID] = tUnits
    end
    tUnits[unitID] = unitTypeIndex
end

local function FindUnit(playerID, unitID)
    local pPlayer = Players[playerID]
    if pPlayer == nil then
        return nil
    end
    return pPlayer:GetUnits():FindID(unitID)
end

local function SeedUnitTypeCache()
    UnitTypeCache = {}
    for _, iPlayer in ipairs(PlayerManager.GetWasEverAliveIDs()) do
        local pPlayer = Players[iPlayer]
        if pPlayer ~= nil then
            for _, pUnit in pPlayer:GetUnits():Members() do
                CacheUnitType(iPlayer, pUnit:GetID(), pUnit:GetType())
            end
        end
    end
end

-- 返回被杀单位的类型索引，并清掉它的缓存项
local function TakeKilledUnitType(playerID, unitID)
    local unitTypeIndex = nil
    local pUnit = FindUnit(playerID, unitID)
    if pUnit ~= nil then
        unitTypeIndex = pUnit:GetType()
    end

    local tUnits = UnitTypeCache[playerID]
    if tUnits ~= nil then
        if unitTypeIndex == nil then
            unitTypeIndex = tUnits[unitID]
        end
        tUnits[unitID] = nil
    end
    return unitTypeIndex
end

function OnTsoDTEUnitAddedToMap(playerID, unitID)
    local pUnit = FindUnit(playerID, unitID)
    if pUnit ~= nil then
        CacheUnitType(playerID, unitID, pUnit:GetType())
    end
end

function OnTsoDTEUnitUpgraded(playerID, unitID, upgradeUnitType)
    local pUnit = FindUnit(playerID, unitID)
    if pUnit ~= nil then
        CacheUnitType(playerID, unitID, pUnit:GetType())
    elseif upgradeUnitType ~= nil and GameInfo.Units[upgradeUnitType] ~= nil then
        CacheUnitType(playerID, unitID, GameInfo.Units[upgradeUnitType].Index)
    end
end

-- -----------------------------------------------------------------------------
-- 何不用之
-- -----------------------------------------------------------------------------
function OnTsoDTEUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    -- 不论凶手是谁都先取出并清掉缓存项，避免缓存只增不减
    local unitTypeIndex = TakeKilledUnitType(killedPlayerID, killedUnitID)

    local pPlayer = TyphonPlayers[playerID]
    if pPlayer == nil or killedPlayerID == playerID then
        return
    end
    if unitTypeIndex == nil then
        print('[TsoDTE] Kill boost: killed unit type unknown, player ' .. tostring(killedPlayerID) .. ' unit ' .. tostring(killedUnitID))
        return
    end

    local tUnit = GameInfo.Units[unitTypeIndex]
    if tUnit == nil or tUnit.PrereqTech == nil then
        return
    end
    local tTech = GameInfo.Technologies[tUnit.PrereqTech]
    if tTech == nil or not TechHasBoost[tTech.Index] then
        return
    end

    local sProperty = PROPERTY_PREFIX .. tTech.TechnologyType
    if pPlayer:GetProperty(sProperty) ~= nil then
        return
    end

    local pTechs = pPlayer:GetTechs()
    if pTechs:HasTech(tTech.Index) or pTechs:HasBoostBeenTriggered(tTech.Index) then
        return
    end

    pTechs:TriggerBoost(tTech.Index)
    pPlayer:SetProperty(sProperty, 1)
    print('[TsoDTE] Kill boost: player ' .. playerID .. ' killed ' .. tUnit.UnitType .. ', boosted ' .. tTech.TechnologyType)
end

-- -----------------------------------------------------------------------------
function InitTsoDTELeaderTrait()
    TyphonPlayers, TyphonPlayerCount = CollectTyphonPlayers()
    if TyphonPlayerCount < 1 then
        return
    end

    TechHasBoost = CollectBoostedTechs()
    SeedUnitTypeCache()

    Events.UnitAddedToMap.Add(OnTsoDTEUnitAddedToMap)
    Events.UnitUpgraded.Add(OnTsoDTEUnitUpgraded)
    Events.UnitKilledInCombat.Add(OnTsoDTEUnitKilledInCombat)
    print('[TsoDTE] Leader trait initialized for ' .. TyphonPlayerCount .. ' player(s)')
end

InitTsoDTELeaderTrait()
