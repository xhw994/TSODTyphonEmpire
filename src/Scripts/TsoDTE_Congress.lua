-- =============================================================================
-- WP17 神权理事会：决议的目标列表与可用性
-- 环境：Gameplay（InGame AddGameplayScripts）
--
-- 官方决议的目标都由 DLC/Expansion2/Scripts/WorldCongress.lua 里的 GameEvents.WC_Validate_* 填写
-- （options.ResolutionOptions = 一组 Hash）。本决议的 ValidationLua 是 WC_Validate_TsoDTE_TheocraticCouncil，
-- 在这里填「已创立的宗教」（不含万神殿），写法照官方 ReligionScreen.lua 的遍历。
-- 10-22 实测：沿用官方的 WC_Validate_RegliousBan（没有 Lua 处理函数）时，目标列表是上一个决议留下的地貌，游戏崩溃。
--
-- 没有已创立的宗教时，同官方「世界宗教」的做法，在 CanUseResolutions 里把本决议从候选里拿掉，
-- 避免出现空目标列表（官方 WorldCongressPopup.lua 遇到空列表会中止世界议会）。
--
-- 需实证：目标值用宗教行的 Hash（同官方其他验证函数用各自表行的 Hash）；投票后的目标是否传给选项 1 的修正。
-- 联机：只读游戏状态。
-- =============================================================================

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

local function OnValidateTheocraticCouncil(resolutionType, playerId, options)
    local tHashes = FoundedReligionHashes()
    options.ResolutionOptions = tHashes
    print('[TsoDTE] Theocratic council: ' .. #tHashes .. ' religion target(s) for player ' .. tostring(playerId))
end

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
