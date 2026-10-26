-- WP17 神权理事会：决议的目标列表（已创立的宗教，不含万神殿）与可用性（Gameplay；InGame AddGameplayScripts）。
-- 官方决议的目标都由 Expansion2/Scripts/WorldCongress.lua 的 GameEvents.WC_Validate_* 填写，本决议的 ValidationLua 同理。

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

-- 沿用官方 WC_Validate_RegliousBan（没有 Lua 处理函数）时，目标列表是上一个决议留下的地貌，游戏崩溃（10-22 实测）。
local function OnValidateTheocraticCouncil(resolutionType, playerId, options)
    local tHashes = FoundedReligionHashes()
    options.ResolutionOptions = tHashes
    print('[TsoDTE] Theocratic council: ' .. #tHashes .. ' religion target(s) for player ' .. tostring(playerId))
end

-- 没有已创立的宗教时从候选里拿掉本决议，避免空目标列表（官方 WorldCongressPopup.lua 遇到空列表会中止世界议会）。
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
