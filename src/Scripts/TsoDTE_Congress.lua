-- WP17 Theocratic Council: resolution target list (founded religions, excluding the Pantheon) and availability (Gameplay; InGame AddGameplayScripts).
-- Official resolution targets are filled by GameEvents.WC_Validate_* in Expansion2/Scripts/WorldCongress.lua; this resolution's ValidationLua works the same way.

local RESOLUTION_TYPE = 'WC_RES_TSOD_THEOCRATIC_COUNCIL'

local function FoundedReligionHashes()
    local tHashes = {}
    local pGameReligion = Game.GetReligion()
    if pGameReligion == nil then
        return tHashes
    end
    for _, tInfo in ipairs(pGameReligion:GetReligions()) do
        local iReligion = tInfo.Religion
        local tRow = (iReligion ~= nil and iReligion >= 0) and GameInfo.Religions[iReligion] or nil
        if tRow ~= nil and not tRow.Pantheon and pGameReligion:HasBeenFounded(iReligion) then
            table.insert(tHashes, tRow.Hash)
        end
    end
    return tHashes
end

-- Reusing the official WC_Validate_RegliousBan (which has no Lua handler), the target list keeps the terrain left by the previous resolution, and the game crashes (in-game test 10-22).
local function OnValidateTheocraticCouncil(resolutionType, playerId, options)
    local tHashes = FoundedReligionHashes()
    options.ResolutionOptions = tHashes
    print('[TsoDTE] Theocratic council: ' .. #tHashes .. ' religion target(s) for player ' .. tostring(playerId))
end

-- With no founded religion, this resolution is removed from the candidates to avoid an empty target list (the official WorldCongressPopup.lua aborts the World Congress on an empty list).
local function OnCanUseResolutions(resolutions)
    local tRow = GameInfo.Resolutions[RESOLUTION_TYPE]
    if tRow == nil or #FoundedReligionHashes() > 0 then
        return
    end
    local tAllowed = {}
    for _, hResolution in ipairs(resolutions.Resolutions) do
        if hResolution ~= tRow.Hash then
            table.insert(tAllowed, hResolution)
        end
    end
    resolutions.Resolutions = tAllowed
end

local function InitTsoDTECongress()
    if GameInfo.Resolutions == nil or GameInfo.Resolutions[RESOLUTION_TYPE] == nil then
        print('[TsoDTE] Theocratic council: resolution row missing, module disabled')
        return
    end
    GameEvents.WC_Validate_TsoDTE_TheocraticCouncil.Add(OnValidateTheocraticCouncil)
    GameEvents.CanUseResolutions.Add(OnCanUseResolutions)
    print('[TsoDTE] Theocratic council module initialized')
end

InitTsoDTECongress()
