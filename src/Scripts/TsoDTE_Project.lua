-- WP16 Desanctification (city project; Gameplay): on completion, converts half the faith (rounded down) into an equal amount of current research progress; only for Typhon players, and notifications go only to human players.
-- The +25 diplomatic support and "visible to Typhon" are not here: see the completion modifier and unlock modifier in Core/TsoDTE_Project.sql.

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROJECT_DESANC = 'PROJECT_TSOD_DESANCTIFICATION'
local TXT_DESANC_MSG = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE'
local TXT_DESANC_NONE = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE_NOTHING_CONVERTED'
local TXT_DESANC_SUM = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY'

-- Filled in at startup
local ProjectIndex = -1
local NotifyType = nil         -- NotificationTypes.USER_DEFINED_5
local TyphonLeaders = {}      -- [LeaderType] = true

-- Checks whether a player is Typhon (by leader; same criteria as CollectTyphonPlayers in TsoDTE_LeaderTrait.lua)
local function CollectTyphonLeaders()
    local tLeaders = { [LEADER_TYPHON] = true }
    for row in GameInfo.LeaderTraits() do
        if row.TraitType == TRAIT_TYPHON then
            tLeaders[row.LeaderType] = true
        end
    end
    return tLeaders
end

local function IsTyphonPlayer(iPlayer)
    local pConfig = PlayerConfigurations[iPlayer]
    return pConfig ~= nil and TyphonLeaders[pConfig:GetLeaderTypeName()] == true
end

local function NotifyHuman(iPlayer, iX, iY, sMessage)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() then
        return
    end
    if NotifyType == nil then
        print('[TsoDTE] Desanctification: NotificationTypes unavailable, message not sent')
        return
    end
    local bOk, sErr = pcall(function()
        NotificationManager.SendNotification(iPlayer, NotifyType,
            Locale.Lookup(sMessage), Locale.Lookup(TXT_DESANC_SUM), iX, iY)
    end)
    if not bOk then
        print('[TsoDTE] Desanctification: notification failed: ' .. tostring(sErr))
    end
end

local function ConvertFaithToResearch(iPlayer, iCity)
    local pPlayer = Players[iPlayer]
    local pReligion = pPlayer:GetReligion()
    local pTechs = pPlayer:GetTechs()

    -- P5: with no current research, nothing is converted and the faith is kept as is (fallback: see test-plan §9.5).
    local iTech = pTechs:GetResearchingTech()
    if iTech == nil or iTech < 0 then
        print('[TsoDTE] Desanctification: player ' .. iPlayer .. ' has no current research, nothing converted (P5)')
        return false
    end

    local iFaith = pReligion:GetFaithBalance()
    -- P3: half, rounded down (Lua 5.1 has no integer-division operator, so math.floor is used)
    local iAmount = math.floor(iFaith / 2)
    if iAmount <= 0 then
        print('[TsoDTE] Desanctification: player ' .. iPlayer .. ' faith ' .. tostring(iFaith) .. ', too little to convert')
        return false
    end

    -- P6: the second argument of SetResearchProgress is an absolute value (the official code has only one example, NapoleonScenario_StartScript.lua), so read first, write, then read back to verify.
    local iProgressBefore = pTechs:GetResearchProgress(iTech)
    pTechs:SetResearchProgress(iTech, iProgressBefore + iAmount)
    local iProgressAfter = pTechs:GetResearchProgress(iTech)

    pReligion:ChangeFaithBalance(-iAmount)
    local iFaithAfter = pReligion:GetFaithBalance()

    local tTech = GameInfo.Technologies[iTech]
    print('[TsoDTE] Desanctification: player ' .. iPlayer .. ' city ' .. tostring(iCity)
        .. ' faith ' .. tostring(iFaith) .. ' -> ' .. tostring(iFaithAfter)
        .. ', research ' .. (tTech and tTech.TechnologyType or tostring(iTech))
        .. ' progress ' .. tostring(iProgressBefore) .. ' -> ' .. tostring(iProgressAfter)
        .. ' (expected +' .. tostring(iAmount) .. ')')
    return true
end

-- Parameters: playerID, cityID, projectID (the GameInfo.Projects Index), buildingIndex, iX, iY, bCancelled
local function OnTsoDTECityProjectCompleted(iPlayer, iCity, iProject, iBuilding, iX, iY, bCancelled)
    if iProject ~= ProjectIndex then
        return
    end
    print('[TsoDTE] Desanctification: completion event player ' .. tostring(iPlayer) .. ' city ' .. tostring(iCity)
        .. ' cancelled ' .. tostring(bCancelled) .. ' (P1)')

    -- P2: when bCancelled is true, skip and leave a log entry for comparison in testing.
    if bCancelled then
        print('[TsoDTE] Desanctification: completion event with bCancelled=true, skipped (P2)')
        return
    end

    if not IsTyphonPlayer(iPlayer) then
        return
    end

    local pPlayer = Players[iPlayer]
    if pPlayer == nil then
        print('[TsoDTE] Desanctification: player ' .. tostring(iPlayer) .. ' not found (P1)')
        return
    end

    -- P1: if the city cannot be read, only log it; conversion is not affected (it depends only on the player); fallback: see test-plan §9.5.
    local pCity = pPlayer:GetCities():FindID(iCity)
    if pCity == nil then
        print('[TsoDTE] Desanctification: city ' .. tostring(iCity) .. ' not found under player ' .. tostring(iPlayer) .. ' (P1)')
    end

    local bConverted = ConvertFaithToResearch(iPlayer, iCity)
    NotifyHuman(iPlayer, iX, iY, bConverted and TXT_DESANC_MSG or TXT_DESANC_NONE)
end

local function InitTsoDTEProject()
    local tProject = GameInfo.Projects[PROJECT_DESANC]
    if tProject == nil then
        print('[TsoDTE] Desanctification: project row missing, module disabled')
        return
    end
    ProjectIndex = tProject.Index
    TyphonLeaders = CollectTyphonLeaders()
    if NotificationTypes ~= nil then
        NotifyType = NotificationTypes.USER_DEFINED_5
    end

    Events.CityProjectCompleted.Add(OnTsoDTECityProjectCompleted)
    print('[TsoDTE] Desanctification module initialized')
end

InitTsoDTEProject()
