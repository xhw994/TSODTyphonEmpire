-- WP3 Resilience of Mortals leader ability (Gameplay; InGame AddGameplayScripts): kills give Eureka; new eras give Eureka and Inspiration (2 of each in a Dark Age).
-- The only ability name is "Resilience of Mortals"; no other sub-names appear in notifications or UI text (user decision).

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROPERTY_PREFIX = 'TSOD_TYPHON_KILL_BOOST_'   -- + TechnologyType
local PROPERTY_LAST_ERA = 'TSOD_TYPHON_TWILIGHT_PALACE_ERA'   -- last game era processed (Eras table Index; the key name is kept for old-save compatibility)
local PROPERTY_DARK_ERA = 'TSOD_TYPHON_DARK_AGE_BONUS_ERA'   -- era for which the extra Dark Age +1+1 has already been granted
local PROPERTY_DARK_AGE = 'TSOD_TYPHON_DARK_AGE'             -- written by the modifier: > 0 during a Dark Age

-- Notifications: the official scenario uses NotificationTypes.USER_DEFINED_* (custom types do not appear in-game).
-- Battle Mage uses 1..3 and Desanctification uses 5, so this uses 4. The summary uses the leader ability name.
local NotifyBoost = nil
local TXT_SUMMARY    = 'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME'
local TXT_ERA_MSG    = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_ERA'
local TXT_DARK_MSG   = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_DARK_AGE'
local TXT_KILL_MSG   = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_KILL'
local TXT_EUREKA     = 'LOC_TSOD_TYPHON_BOOST_ITEM_EUREKA'
local TXT_INSPIRE    = 'LOC_TSOD_TYPHON_BOOST_ITEM_INSPIRATION'
local TXT_SEPARATOR  = 'LOC_TSOD_TYPHON_BOOST_ITEM_SEPARATOR'

-- [playerID] = pPlayer, the players who own this ability
local TyphonPlayers = {}
local TyphonPlayerCount = 0

-- [techIndex] = true, for techs that have Eureka in the Boosts table
local TechHasBoost = {}

-- [playerID] = { [unitID] = unitTypeIndex }
local UnitTypeCache = {}

-- For the new-era bonus: era list sorted chronologically, plus for each era the techs and civics with Eureka / Inspiration
local EraOrder = {}            -- [1..n] = eraIndex, sorted by ChronologyIndex
local EraPosition = {}         -- [eraIndex] = position in EraOrder
local BoostTechsByEra = {}     -- [eraIndex] = { techIndex, ... }
local BoostCivicsByEra = {}    -- [eraIndex] = { civicIndex, ... }

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

-- Unit type cache
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

-- Events are dispatched after the fact, so the killed unit may already be removed from PlayerUnits (the official NotificationPanel handles it the same way),
-- so FindID is tried first and the cache is checked if that fails. The cache is not saved (rebuilt on every load). Returns the unit type index and clears the cache entry.
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

local function NotifyBoostHuman(iPlayer, sMessage, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() or NotifyBoost == nil then
        return
    end
    local bOk, sErr = pcall(function()
        NotificationManager.SendNotification(iPlayer, NotifyBoost, sMessage, Locale.Lookup(TXT_SUMMARY), iX, iY)
    end)
    if not bOk then
        print('[TsoDTE] Leader trait: notification failed: ' .. tostring(sErr))
    end
end

local function JoinItems(tItems)
    return table.concat(tItems, Locale.Lookup(TXT_SEPARATOR))
end

-- Kill Eureka
function OnTsoDTEUnitKilledInCombat(killedPlayerID, killedUnitID, playerID, unitID)
    -- Take the entry out and clear it whatever the killer, so the cache does not only grow
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

    local sMsg = Locale.Lookup(TXT_KILL_MSG, Locale.Lookup(tUnit.Name), Locale.Lookup(TXT_EUREKA, Locale.Lookup(tTech.Name)))
    local pKiller = FindUnit(playerID, unitID)
    if pKiller ~= nil then
        NotifyBoostHuman(playerID, sMsg, pKiller:GetX(), pKiller:GetY())
    else
        NotifyBoostHuman(playerID, sMsg)
    end
end

-- New-era bonus (the SQL ..._ON_NEW_ERA modifiers do not work under Gathering Storm, confirmed in-game, I1; so it is done in Lua)
local function CollectEraTables()
    local tOrder = {}
    for row in GameInfo.Eras() do
        table.insert(tOrder, row)
    end
    table.sort(tOrder, function(a, b)
        local ca = a.ChronologyIndex or a.Index
        local cb = b.ChronologyIndex or b.Index
        return ca < cb
    end)

    EraOrder = {}
    EraPosition = {}
    BoostTechsByEra = {}
    BoostCivicsByEra = {}
    for i, row in ipairs(tOrder) do
        EraOrder[i] = row.Index
        EraPosition[row.Index] = i
        BoostTechsByEra[row.Index] = {}
        BoostCivicsByEra[row.Index] = {}
    end

    -- The same item may have several rows in Boosts; de-duplicate first
    local tSeenTech = {}
    local tSeenCivic = {}
    for row in GameInfo.Boosts() do
        if row.TechnologyType ~= nil then
            local tTech = GameInfo.Technologies[row.TechnologyType]
            if tTech ~= nil and not tSeenTech[tTech.Index] then
                tSeenTech[tTech.Index] = true
                local tEra = GameInfo.Eras[tTech.EraType]
                if tEra ~= nil and BoostTechsByEra[tEra.Index] ~= nil then
                    table.insert(BoostTechsByEra[tEra.Index], tTech.Index)
                end
            end
        end
        if row.CivicType ~= nil then
            local tCivic = GameInfo.Civics[row.CivicType]
            if tCivic ~= nil and not tSeenCivic[tCivic.Index] then
                tSeenCivic[tCivic.Index] = true
                local tEra = GameInfo.Eras[tCivic.EraType]
                if tEra ~= nil and BoostCivicsByEra[tEra.Index] ~= nil then
                    table.insert(BoostCivicsByEra[tEra.Index], tCivic.Index)
                end
            end
        end
    end
    -- GameInfo iteration order is fixed, but sorting is safer (every multiplayer client must match)
    for _, tList in pairs(BoostTechsByEra) do table.sort(tList) end
    for _, tList in pairs(BoostCivicsByEra) do table.sort(tList) end
end

-- Draw order: the new era, then later eras (nearest first), then earlier eras (nearest first)
local function EraSearchOrder(eraIndex)
    local tResult = {}
    local iPos = EraPosition[eraIndex]
    if iPos == nil then
        return tResult
    end
    for i = iPos, #EraOrder do
        table.insert(tResult, EraOrder[i])
    end
    for i = iPos - 1, 1, -1 do
        table.insert(tResult, EraOrder[i])
    end
    return tResult
end

-- Deterministic pseudo-random index 1..n (must sync in multiplayer, so math.random is not used)
local function PickIndex(n, iPlayer, eraIndex, iSalt)
    local iSeed = Game.GetCurrentGameTurn() * 7919 + iPlayer * 104729 + eraIndex * 1299709 + iSalt * 15485863
    -- One step of Park-Miller: the product stays under 2^46, which Lua 5.1 doubles represent exactly
    iSeed = (iSeed % 2147483647) * 16807 % 2147483647
    return (iSeed % n) + 1
end

-- Walks tByEra in order and triggers one candidate at random from the first era that still has candidates; returns the triggered index or nil
local function GrantOneBoost(iPlayer, eraIndex, tByEra, fnAvailable, fnTrigger, iSalt)
    for _, iEra in ipairs(EraSearchOrder(eraIndex)) do
        local tCandidates = {}
        for _, idx in ipairs(tByEra[iEra] or {}) do
            if fnAvailable(idx) then
                table.insert(tCandidates, idx)
            end
        end
        if #tCandidates > 0 then
            local idx = tCandidates[PickIndex(#tCandidates, iPlayer, eraIndex, iSalt)]
            fnTrigger(idx)
            return idx
        end
    end
    return nil
end

-- Returns (is Dark Age, source note). GameEras:HasDarkAge is nil in the Gameplay context (confirmed in-game),
-- so the player attribute written by the modifier TSOD_TYPHON_DARK_AGE_PROBE is read first; if that is unreadable, HasDarkAge is tried; if neither works, it is treated as not a Dark Age.
local function PlayerHasDarkAge(iPlayer, pPlayer)
    local vProp = pPlayer:GetProperty(PROPERTY_DARK_AGE)
    if vProp ~= nil then
        return (tonumber(vProp) or 0) > 0, 'property ' .. tostring(vProp)
    end
    local pEras = Game.GetEras()
    if pEras ~= nil and pEras.HasDarkAge ~= nil then
        local bOk, vResult = pcall(pEras.HasDarkAge, pEras, iPlayer)
        if bOk then
            return vResult == true, 'HasDarkAge'
        end
        return false, 'property unset, HasDarkAge raised: ' .. tostring(vResult)
    end
    return false, 'property unset, HasDarkAge unavailable'
end

-- Grants iCount sets (1 Eureka + 1 Inspiration); returns the item text list for the notification and the type name list for the log
local function GrantBoostPairs(iPlayer, pPlayer, eraIndex, iCount, iSaltBase)
    local pTechs = pPlayer:GetTechs()
    local pCulture = pPlayer:GetCulture()

    local function TechAvailable(idx)
        return not pTechs:HasTech(idx) and not pTechs:HasBoostBeenTriggered(idx)
    end
    local function CivicAvailable(idx)
        return not pCulture:HasCivic(idx) and not pCulture:HasBoostBeenTriggered(idx)
    end

    local tItems = {}
    local tTypes = {}
    for i = 1, iCount do
        local iTech = GrantOneBoost(iPlayer, eraIndex, BoostTechsByEra, TechAvailable,
            function(idx) pTechs:TriggerBoost(idx) end, iSaltBase + i)
        if iTech ~= nil then
            local tTech = GameInfo.Technologies[iTech]
            table.insert(tTypes, tTech.TechnologyType)
            table.insert(tItems, Locale.Lookup(TXT_EUREKA, Locale.Lookup(tTech.Name)))
        end
        local iCivic = GrantOneBoost(iPlayer, eraIndex, BoostCivicsByEra, CivicAvailable,
            function(idx) pCulture:TriggerBoost(idx) end, iSaltBase + i + 100)
        if iCivic ~= nil then
            local tCivic = GameInfo.Civics[iCivic]
            table.insert(tTypes, tCivic.CivicType)
            table.insert(tItems, Locale.Lookup(TXT_INSPIRE, Locale.Lookup(tCivic.Name)))
        end
    end
    return tItems, tTypes
end

local function NotifyAtCapital(iPlayer, pPlayer, sMsg)
    local pCapital = pPlayer:GetCities():GetCapitalCity()
    if pCapital ~= nil then
        NotifyBoostHuman(iPlayer, sMsg, pCapital:GetX(), pCapital:GetY())
    else
        NotifyBoostHuman(iPlayer, sMsg)
    end
end

local function EraName(eraIndex)
    local tEra = GameInfo.Eras[eraIndex]
    return tEra and tEra.EraType or tostring(eraIndex)
end

-- Entering a new era: grants 1+1 (the extra 1+1 for a Dark Age is added by CheckDarkAgeBonus)
local function GrantNewEra(iPlayer, pPlayer, eraIndex)
    local tItems, tTypes = GrantBoostPairs(iPlayer, pPlayer, eraIndex, 1, 0)
    print('[TsoDTE] New era boost: player ' .. iPlayer .. ' entered ' .. EraName(eraIndex)
        .. ', boosted ' .. (#tTypes > 0 and table.concat(tTypes, ', ') or 'nothing'))
    if #tItems > 0 then
        NotifyAtCapital(iPlayer, pPlayer, Locale.Lookup(TXT_ERA_MSG, JoinItems(tItems)))
    end
end

-- Requirement re-evaluation may come later than turn start, so on entering a new era 1+1 is granted first; if a Dark Age is then read within that era, the extra 1+1 is added (once per era)
local function CheckDarkAgeBonus(iPlayer, pPlayer, eraIndex)
    if pPlayer:GetProperty(PROPERTY_DARK_ERA) == eraIndex then
        return
    end
    local bDark, sSource = PlayerHasDarkAge(iPlayer, pPlayer)
    if not bDark then
        return
    end
    pPlayer:SetProperty(PROPERTY_DARK_ERA, eraIndex)
    local tItems, tTypes = GrantBoostPairs(iPlayer, pPlayer, eraIndex, 1, 10)
    print('[TsoDTE] Dark age bonus: player ' .. iPlayer .. ' in ' .. EraName(eraIndex)
        .. ' [' .. sSource .. '], boosted ' .. (#tTypes > 0 and table.concat(tTypes, ', ') or 'nothing'))
    if #tItems > 0 then
        NotifyAtCapital(iPlayer, pPlayer, Locale.Lookup(TXT_DARK_MSG, JoinItems(tItems)))
    end
end

-- GameEraChanged is not attached: each turn start compares the current era with the last era recorded in the player attribute (eras change during turn transition)
function OnTsoDTEPlayerTurnActivated(iPlayer, bIsFirstTime)
    local pPlayer = TyphonPlayers[iPlayer]
    if pPlayer == nil then
        return
    end
    local pEras = Game.GetEras()
    if pEras == nil then
        return
    end
    local iEra = pEras:GetCurrentEra()
    if iEra == nil or iEra < 0 then
        return
    end

    local iLast = pPlayer:GetProperty(PROPERTY_LAST_ERA)
    if iLast == nil then
        -- First turn, or first time this script sees this save: record only, do not grant (no Dark Age bonus for this era either)
        pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
        pPlayer:SetProperty(PROPERTY_DARK_ERA, iEra)
        return
    end
    if iEra ~= iLast then
        -- Write the marker first, then grant: an error midway through granting will not cause a repeat next turn
        pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
        if (EraPosition[iEra] or 0) > (EraPosition[iLast] or 0) then
            GrantNewEra(iPlayer, pPlayer, iEra)
        else
            -- Era went backwards (should not happen): no Dark Age bonus
            pPlayer:SetProperty(PROPERTY_DARK_ERA, iEra)
            return
        end
    end
    CheckDarkAgeBonus(iPlayer, pPlayer, iEra)
end

function InitTsoDTELeaderTrait()
    TyphonPlayers, TyphonPlayerCount = CollectTyphonPlayers()
    if TyphonPlayerCount < 1 then
        return
    end

    TechHasBoost = CollectBoostedTechs()
    CollectEraTables()
    SeedUnitTypeCache()
    if NotificationTypes ~= nil then
        NotifyBoost = NotificationTypes.USER_DEFINED_4
    end

    Events.UnitAddedToMap.Add(OnTsoDTEUnitAddedToMap)
    Events.UnitUpgraded.Add(OnTsoDTEUnitUpgraded)
    Events.UnitKilledInCombat.Add(OnTsoDTEUnitKilledInCombat)
    Events.PlayerTurnActivated.Add(OnTsoDTEPlayerTurnActivated)
    local pEras = Game.GetEras()
    for iPlayer, pPlayer in pairs(TyphonPlayers) do
        -- Store in a local first: GetProperty returns nil when nothing is stored, and passing that straight to tostring raises an error (confirmed in-game, 10-22)
        local vDark = pPlayer:GetProperty(PROPERTY_DARK_AGE)
        print('[TsoDTE] Dark age sources for player ' .. iPlayer .. ': property ' .. tostring(vDark)
            .. ', HasDarkAge callable ' .. tostring(pEras ~= nil and pEras.HasDarkAge ~= nil)
            .. ', notification type ' .. tostring(NotifyBoost))
    end
    print('[TsoDTE] Leader trait initialized for ' .. TyphonPlayerCount .. ' player(s)')
end

InitTsoDTELeaderTrait()
