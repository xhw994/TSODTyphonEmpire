-- =============================================================================
-- WP16 去神圣化（城市项目）
-- 环境：Gameplay（InGame AddGameplayScripts）
--
-- 完成 PROJECT_TSOD_DESANCTIFICATION 时（只对提丰玩家，按领袖判断）：
--   1. 当前信仰值的一半（向下取整）转为等量的当前研究进度；
--   2. 从信仰值里扣掉同样的数量。
--   3. 只对人类玩家发一条通知（照 WP13）。AI 完成照样转换，不发通知。
-- 外交支持 +25 不在这里：由 Core/TsoDTE_Project.sql 的项目完成修正
--   TSOD_TYPHON_DESANCTIFICATION_FAVOR（MODIFIER_PLAYER_ADD_FAVOR，RunOnce）给。
-- 「对提丰可见」也不在这里：由文明能力挂的 MODIFIER_PLAYER_ALLOW_PROJECT_TSOD 决定。
--
-- 研究进度的写法：官方没有 ChangeCurrentResearchProgress 的参数记录，也没有官方用例；
-- 官方 NapoleonScenario_StartScript.lua 用的是 SetResearchProgress(techIndex, 绝对值)，
-- 所以这里用 GetResearchProgress + SetResearchProgress，并读回核对。
--
-- 联机：只读写游戏状态。不用 math.random、不用 ExposedMembers、不用 Game.GetLocalPlayer。
-- 存档：本脚本不存任何 Lua 状态。转换结果都落在引擎的信仰值与研究进度里，读档即一致。
--
-- 【需实证】每条的退路见代码对应位置的注释，也写在 docs/test-plan-I1.md 的 §9
--   P1  Events.CityProjectCompleted 在 Gameplay 环境是否派发，且 playerID / cityID / projectID 有效。
--       官方只在 UI 环境订阅过它（TutorialLoader_Expansion2.lua），Gameplay 里没有先例。
--   P2  bCancelled 的含义：目前只在它为真时跳过。若完成时它也为真，会漏转换。
--   P3  转换公式：信仰减半（向下取整），研究进度加等量。
--   P4  完成后信仰值是否被再次结算（回合结束时是否又按转换前的值变化）。
--   P5  GetResearchingTech 在没有当前研究时返回 -1，此时本脚本不转换。
--   P6  SetResearchProgress 的第二个参数是绝对值，读回值与预期一致。
--   P7  研究进度加到超过研究造价时，科技是否即时完成、进度是否被截断。
-- =============================================================================

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROJECT_DESANC = 'PROJECT_TSOD_DESANCTIFICATION'
local NOTIF_DESANC   = 'NOTIFICATION_TSOD_DESANCTIFICATION'
local TXT_DESANC_MSG = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_MESSAGE'
local TXT_DESANC_SUM = 'LOC_NOTIFICATION_TSOD_DESANCTIFICATION_SUMMARY'

-- 启动时填入
local ProjectIndex = -1
local NotifyHash = nil
local TyphonLeaders = {}      -- [LeaderType] = true

-- -----------------------------------------------------------------------------
-- 判断玩家是不是提丰（领袖判断，口径与 TsoDTE_LeaderTrait.lua 的 CollectTyphonPlayers 相同）
-- -----------------------------------------------------------------------------
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

-- -----------------------------------------------------------------------------
-- 通知只发给人类玩家（照 TsoDTE_BattleMage.lua 的 NotifyHuman）
-- -----------------------------------------------------------------------------
local function NotifyHuman(iPlayer, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() then
        return
    end
    if NotifyHash == nil then
        print('[TsoDTE] Desanctification: notification type hash missing, message not sent')
        return
    end
    NotificationManager.SendNotification(iPlayer, NotifyHash,
        Locale.Lookup(TXT_DESANC_MSG), Locale.Lookup(TXT_DESANC_SUM), iX, iY)
end

-- -----------------------------------------------------------------------------
-- 信仰转科技
-- -----------------------------------------------------------------------------
local function ConvertFaithToResearch(iPlayer, iCity)
    local pPlayer = Players[iPlayer]
    local pReligion = pPlayer:GetReligion()
    local pTechs = pPlayer:GetTechs()

    -- P5：没有当前研究时不转换，信仰原样保留。
    -- 退路：若实测这时也应该转，改为把数量记在玩家属性里（SetProperty），等玩家选定研究时再补入。
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

    -- P6：SetResearchProgress 的第二个参数是绝对值，先读再写，写完读回核对。
    -- 退路：读回值与预期不符时，记下 Lua.log 的 progress 两行，并检查 SetResearchProgress 是否被忽略。
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

-- -----------------------------------------------------------------------------
-- 项目完成事件
-- 参数：playerID, cityID, projectID（即 GameInfo.Projects 的 Index）, buildingIndex, iX, iY, bCancelled
-- -----------------------------------------------------------------------------
local function OnTsoDTECityProjectCompleted(iPlayer, iCity, iProject, iBuilding, iX, iY, bCancelled)
    if iProject ~= ProjectIndex then
        return
    end

    -- P2：bCancelled 为真时跳过。跳过时留日志，便于实测对照它到底在什么时候为真。
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

    -- P1：城市取不到只记日志，不影响转换（转换只依赖玩家）。
    -- 退路：若 P1 失败（派发时 playerID 或 cityID 无效），改为在 UI 环境订阅同一事件，
    -- 再用 UI.RequestPlayerOperation(PlayerOperations.EXECUTE_SCRIPT) 把转换请求交给本文件的函数（kb 的第 3 种通信办法）。
    local pCity = pPlayer:GetCities():FindID(iCity)
    if pCity == nil then
        print('[TsoDTE] Desanctification: city ' .. tostring(iCity) .. ' not found under player ' .. tostring(iPlayer) .. ' (P1)')
    end

    ConvertFaithToResearch(iPlayer, iCity)
    NotifyHuman(iPlayer, iX, iY)
end

-- -----------------------------------------------------------------------------
local function InitTsoDTEProject()
    local tProject = GameInfo.Projects[PROJECT_DESANC]
    if tProject == nil then
        print('[TsoDTE] Desanctification: project row missing, module disabled')
        return
    end
    ProjectIndex = tProject.Index
    TyphonLeaders = CollectTyphonLeaders()
    NotifyHash = DB.MakeHash(NOTIF_DESANC)

    Events.CityProjectCompleted.Add(OnTsoDTECityProjectCompleted)
    print('[TsoDTE] Desanctification module initialized')
end

InitTsoDTEProject()
