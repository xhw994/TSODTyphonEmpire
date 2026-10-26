-- WP16 去神圣化（城市项目；Gameplay）：完成时把一半信仰值（向下取整）转为等量当前研究进度，只对提丰玩家，通知只发人类玩家。
-- 外交支持 +25 与「对提丰可见」不在这里：分别见 Core/TsoDTE_Project.sql 的完成修正与解锁修正。

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROJECT_DESANC = 'PROJECT_TSOD_DESANCTIFICATION'
local TXT_DESANC_MSG = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE'
local TXT_DESANC_SUM = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY'

-- 启动时填入
local ProjectIndex = -1
local NotifyType = nil         -- NotificationTypes.USER_DEFINED_5
local TyphonLeaders = {}      -- [LeaderType] = true

-- 判断玩家是不是提丰（领袖判断，口径与 TsoDTE_LeaderTrait.lua 的 CollectTyphonPlayers 相同）
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

local function NotifyHuman(iPlayer, iX, iY)
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
            Locale.Lookup(TXT_DESANC_MSG), Locale.Lookup(TXT_DESANC_SUM), iX, iY)
    end)
    if not bOk then
        print('[TsoDTE] Desanctification: notification failed: ' .. tostring(sErr))
    end
end

local function ConvertFaithToResearch(iPlayer, iCity)
    local pPlayer = Players[iPlayer]
    local pReligion = pPlayer:GetReligion()
    local pTechs = pPlayer:GetTechs()

    -- P5：没有当前研究时不转换，信仰原样保留（退路见 test-plan §9.5）。
    local iTech = pTechs:GetResearchingTech()
    if iTech == nil or iTech < 0 then
        print('[TsoDTE] Desanctification: player ' .. iPlayer .. ' has no current research, nothing converted (P5)')
        return
    end

    local iFaith = pReligion:GetFaithBalance()
    -- P3：一半，向下取整（Lua 5.1 没有整除运算符，用 math.floor）
    local iAmount = math.floor(iFaith / 2)
    if iAmount <= 0 then
        print('[TsoDTE] Desanctification: player ' .. iPlayer .. ' faith ' .. tostring(iFaith) .. ', too little to convert')
        return
    end

    -- P6：SetResearchProgress 的第二个参数是绝对值（官方只有 NapoleonScenario_StartScript.lua 一例），先读再写、读回核对。
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
end

-- 参数：playerID, cityID, projectID（即 GameInfo.Projects 的 Index）, buildingIndex, iX, iY, bCancelled
local function OnTsoDTECityProjectCompleted(iPlayer, iCity, iProject, iBuilding, iX, iY, bCancelled)
    if iProject ~= ProjectIndex then
        return
    end
    print('[TsoDTE] Desanctification: completion event player ' .. tostring(iPlayer) .. ' city ' .. tostring(iCity)
        .. ' cancelled ' .. tostring(bCancelled) .. ' (P1)')

    -- P2：bCancelled 为真时跳过并留日志，便于实测对照。
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

    -- P1：城市取不到只记日志，不影响转换（转换只依赖玩家）；退路见 test-plan §9.5。
    local pCity = pPlayer:GetCities():FindID(iCity)
    if pCity == nil then
        print('[TsoDTE] Desanctification: city ' .. tostring(iCity) .. ' not found under player ' .. tostring(iPlayer) .. ' (P1)')
    end

    ConvertFaithToResearch(iPlayer, iCity)
    NotifyHuman(iPlayer, iX, iY)
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
