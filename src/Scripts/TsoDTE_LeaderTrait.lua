-- =============================================================================
-- WP3 领袖能力「凡人的韧性」
-- 环境：Gameplay（InGame AddGameplayScripts）
-- 两部分都在这里：何不用之（击杀给尤里卡）、黄昏宫殿（新时代给尤里卡与鼓舞）。
--
-- 【何不用之】
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
--
-- 【黄昏宫殿】
-- 每进入一个新时代：1 个随机尤里卡 + 1 个随机鼓舞；新时代是黑暗时代时各 2 个。
-- 原先用 SQL 的 MODIFIER_PLAYER_GRANT_RANDOM_TECHNOLOGY_BOOST_ON_NEW_ERA（首尔）与市政版（维尔纽斯），
-- I1 实测过了两个时代都没给，确认在风云变幻里不生效，改到这里。
--   时机：不挂 GameEraChanged，而是在提丰玩家每回合开始（PlayerTurnActivated）时比较
--         「当前游戏时代」和玩家属性里记的「上次处理到的时代」。时代切换发生在回合交替时，
--         到玩家回合开始时黑暗 / 黄金时代已经判定完，所以 HasDarkAge 读到的是新时代的结果。
--         记录存在玩家属性里，读档不会重复给。开局（属性为空）只记录、不发放。
--   英雄时代（黑暗时代之后进入的黄金时代）属于黄金时代，不算黑暗时代，给 1 + 1。
--   抽取范围：优先新时代的科技 / 市政；新时代里已经没有可用的（都研究过或已触发），
--         顺延到之后的时代，再没有就往前找更早的时代。只抽在 Boosts 表里有尤里卡 / 鼓舞、
--         尚未研究、尚未触发的项。
--   随机数：联机要同步，不用 math.random；用回合数、玩家 ID、时代算一个确定的伪随机下标。
--
-- 【通知】
-- 授予后对人类玩家各发一条 NotificationManager 通知（类型与文本见 src/Core/TsoDTE_Boost.sql、
-- src/Texts/TsoDTE_Text_Boost.sql）：
--   黄昏宫殿：列出实际授予的尤里卡（科技名）与鼓舞（市政名），摘要「黄昏宫殿」，点击跳到首都。
--   何不用之：列出被杀单位名与授予的尤里卡，摘要「何不用之」，点击跳到凶手单位所在格。
-- 没有授予任何项时不发；AI 玩家不发；通知出错只写日志，不影响已完成的授予。
-- =============================================================================

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROPERTY_PREFIX = 'TSOD_TYPHON_KILL_BOOST_'   -- + TechnologyType
local PROPERTY_LAST_ERA = 'TSOD_TYPHON_TWILIGHT_PALACE_ERA'   -- 上次处理到的游戏时代（Eras 表的 Index）

-- 通知类型与文本的 tag（登记在 src/Core/TsoDTE_Boost.sql、src/Texts/TsoDTE_Text_Boost.sql）
local NOTIF_TWILIGHT   = 'NOTIFICATION_TSOD_TWILIGHT_BOOST'
local NOTIF_KILL       = 'NOTIFICATION_TSOD_KILL_BOOST'
local TXT_TWILIGHT_MSG = 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_MESSAGE'
local TXT_TWILIGHT_SUM = 'LOC_NOTIFICATION_TSOD_TWILIGHT_BOOST_SUMMARY'
local TXT_KILL_MSG     = 'LOC_NOTIFICATION_TSOD_KILL_BOOST_MESSAGE'
local TXT_KILL_SUM     = 'LOC_NOTIFICATION_TSOD_KILL_BOOST_SUMMARY'
local TXT_EUREKA       = 'LOC_NOTIFICATION_TSOD_BOOST_EUREKA'
local TXT_INSPIRATION  = 'LOC_NOTIFICATION_TSOD_BOOST_INSPIRATION'
local TXT_SEPARATOR    = 'LOC_NOTIFICATION_TSOD_BOOST_SEPARATOR'

-- [通知类型名] = DB.MakeHash 的哈希，InitTsoDTELeaderTrait 里填
local NotifyHash = {}

-- [playerID] = pPlayer，拥有本能力的玩家
local TyphonPlayers = {}
local TyphonPlayerCount = 0

-- [techIndex] = true，在 Boosts 表里有尤里卡的科技
local TechHasBoost = {}

-- [playerID] = { [unitID] = unitTypeIndex }
local UnitTypeCache = {}

-- 黄昏宫殿用：按时代先后排好的时代列表，以及每个时代里有尤里卡 / 鼓舞的科技、市政
local EraOrder = {}            -- [1..n] = eraIndex，按 ChronologyIndex 排序
local EraPosition = {}         -- [eraIndex] = 在 EraOrder 里的位置
local BoostTechsByEra = {}     -- [eraIndex] = { techIndex, ... }
local BoostCivicsByEra = {}    -- [eraIndex] = { civicIndex, ... }

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
-- 通知（只发给人类玩家，照 TsoDTE_BattleMage.lua 的 NotifyHuman）
-- 位置参数形式：SendNotification(玩家, 类型哈希, 消息, 摘要[, x, y])。
-- 文本由调用方用 Locale.Lookup 取好再传入；没有坐标时不传 x、y。
-- -----------------------------------------------------------------------------
local function NotifyHuman(iPlayer, sNotif, sMessage, sSummary, iX, iY)
    local pPlayer = Players[iPlayer]
    if pPlayer == nil or not pPlayer:IsHuman() then
        return
    end
    local hType = NotifyHash[sNotif]
    if hType == nil then
        print('[TsoDTE] Leader trait: notification type not registered: ' .. sNotif)
        return
    end
    if iX ~= nil and iY ~= nil then
        NotificationManager.SendNotification(iPlayer, hType, sMessage, sSummary, iX, iY)
    else
        NotificationManager.SendNotification(iPlayer, hType, sMessage, sSummary)
    end
end

-- 授予已经完成，通知出错只写日志，不回滚、不影响后续
local function TrySendBoostNotice(fnSend)
    local bOk, vErr = pcall(fnSend)
    if not bOk then
        print('[TsoDTE] Boost notification failed (the grant is kept): ' .. tostring(vErr))
    end
end

-- 多条文本用本地化分隔符拼接（中文顿号、英文逗号）
local function JoinTexts(tTexts)
    return table.concat(tTexts, Locale.Lookup(TXT_SEPARATOR))
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

    TrySendBoostNotice(function()
        local sMsg = Locale.Lookup(TXT_KILL_MSG, Locale.Lookup(tUnit.Name), Locale.Lookup(TXT_EUREKA, Locale.Lookup(tTech.Name)))
        local sSum = Locale.Lookup(TXT_KILL_SUM)
        -- 位置：凶手单位所在格（点击通知跳到交战处）；取不到凶手单位时不传坐标
        local pAttacker = FindUnit(playerID, unitID)
        if pAttacker ~= nil then
            NotifyHuman(playerID, NOTIF_KILL, sMsg, sSum, pAttacker:GetX(), pAttacker:GetY())
        else
            NotifyHuman(playerID, NOTIF_KILL, sMsg, sSum)
        end
    end)
end

-- -----------------------------------------------------------------------------
-- 黄昏宫殿
-- -----------------------------------------------------------------------------
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

    -- Boosts 里同一项可能有多行，先去重
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
    -- GameInfo 的遍历顺序固定，但排序一下更稳妥（联机各端必须一致）
    for _, tList in pairs(BoostTechsByEra) do table.sort(tList) end
    for _, tList in pairs(BoostCivicsByEra) do table.sort(tList) end
end

-- 抽取顺序：新时代 → 之后的时代（由近到远）→ 之前的时代（由近到远）
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

-- 确定的伪随机下标，1..n
local function PickIndex(n, iPlayer, eraIndex, iSalt)
    local iSeed = Game.GetCurrentGameTurn() * 7919 + iPlayer * 104729 + eraIndex * 1299709 + iSalt * 15485863
    -- Park-Miller 一步：乘积不超过 2^46，Lua 5.1 的双精度能精确表示
    iSeed = (iSeed % 2147483647) * 16807 % 2147483647
    return (iSeed % n) + 1
end

-- 从 tByEra 里按顺序找第一个还有候选项的时代，随机触发一个；返回触发的下标或 nil
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

-- 返回 (是否黑暗时代, 来源说明)。
-- 注意：官方文档与官方用法里 GameEras:HasDarkAge / HasGoldenAge / HasHeroicGoldenAge 都只在 UI 环境
-- （kb 里 script=false，官方脚本里也只有 UI 文件在用）。本脚本跑在 Gameplay，调不调得通要实测。
-- 所以这里用 pcall 包住，取不到或报错就记日志并按「非黑暗」处理（只给 1+1），
-- 不让它悄悄失败：Lua.log 里会写明原因。英雄时代 / 黄金时代一律按「非黑暗」。
local function PlayerHasDarkAge(iPlayer)
    local pEras = Game.GetEras()
    if pEras == nil or pEras.HasDarkAge == nil then
        return false, 'HasDarkAge is not available in Gameplay'
    end
    local bOk, vResult = pcall(pEras.HasDarkAge, pEras, iPlayer)
    if not bOk then
        return false, 'HasDarkAge raised an error: ' .. tostring(vResult)
    end
    return vResult == true, 'HasDarkAge'
end

local function GrantTwilightPalace(iPlayer, pPlayer, eraIndex)
    local bDark, sDarkSource = PlayerHasDarkAge(iPlayer)
    local iCount = bDark and 2 or 1

    local pTechs = pPlayer:GetTechs()
    local pCulture = pPlayer:GetCulture()

    local function TechAvailable(idx)
        return not pTechs:HasTech(idx) and not pTechs:HasBoostBeenTriggered(idx)
    end
    local function CivicAvailable(idx)
        return not pCulture:HasCivic(idx) and not pCulture:HasBoostBeenTriggered(idx)
    end

    local tGranted = {}   -- 日志用：类型名
    local tItems = {}     -- 通知用：「X 的尤里卡」「Y 的鼓舞」的本地化文本
    for i = 1, iCount do
        local iTech = GrantOneBoost(iPlayer, eraIndex, BoostTechsByEra, TechAvailable,
            function(idx) pTechs:TriggerBoost(idx) end, i)
        if iTech ~= nil then
            local tTech = GameInfo.Technologies[iTech]
            table.insert(tGranted, tTech.TechnologyType)
            table.insert(tItems, Locale.Lookup(TXT_EUREKA, Locale.Lookup(tTech.Name)))
        end
        local iCivic = GrantOneBoost(iPlayer, eraIndex, BoostCivicsByEra, CivicAvailable,
            function(idx) pCulture:TriggerBoost(idx) end, i + 100)
        if iCivic ~= nil then
            local tCivic = GameInfo.Civics[iCivic]
            table.insert(tGranted, tCivic.CivicType)
            table.insert(tItems, Locale.Lookup(TXT_INSPIRATION, Locale.Lookup(tCivic.Name)))
        end
    end

    local tEra = GameInfo.Eras[eraIndex]
    print('[TsoDTE] Twilight Palace: player ' .. iPlayer .. ' entered ' .. (tEra and tEra.EraType or tostring(eraIndex))
        .. (bDark and ' (dark age)' or '') .. ' [dark age check: ' .. sDarkSource .. ']'
        .. ', boosted ' .. (#tGranted > 0 and table.concat(tGranted, ', ') or 'nothing'))

    -- 没有授予任何项就不发；通知只列实际授予的项（判定未生效时不写「黑暗时代 2+2」）
    if #tItems > 0 then
        TrySendBoostNotice(function()
            local sMsg = Locale.Lookup(TXT_TWILIGHT_MSG, JoinTexts(tItems))
            local sSum = Locale.Lookup(TXT_TWILIGHT_SUM)
            -- 位置：首都（点击通知跳到首都）；没有首都时不传坐标
            local pCapital = pPlayer:GetCities():GetCapitalCity()
            if pCapital ~= nil then
                NotifyHuman(iPlayer, NOTIF_TWILIGHT, sMsg, sSum, pCapital:GetX(), pCapital:GetY())
            else
                NotifyHuman(iPlayer, NOTIF_TWILIGHT, sMsg, sSum)
            end
        end)
    end
end

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
        -- 开局或本脚本第一次见到这个存档：只记录，不发放
        pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
        return
    end
    if iEra == iLast then
        return
    end

    -- 先写标记再发放：发放中途出错也不会在下回合重复给
    pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
    if (EraPosition[iEra] or 0) > (EraPosition[iLast] or 0) then
        GrantTwilightPalace(iPlayer, pPlayer, iEra)
    end
end

-- -----------------------------------------------------------------------------
function InitTsoDTELeaderTrait()
    TyphonPlayers, TyphonPlayerCount = CollectTyphonPlayers()
    if TyphonPlayerCount < 1 then
        return
    end

    TechHasBoost = CollectBoostedTechs()
    CollectEraTables()
    SeedUnitTypeCache()
    for _, sName in ipairs({ NOTIF_TWILIGHT, NOTIF_KILL }) do
        NotifyHash[sName] = DB.MakeHash(sName)
    end

    Events.UnitAddedToMap.Add(OnTsoDTEUnitAddedToMap)
    Events.UnitUpgraded.Add(OnTsoDTEUnitUpgraded)
    Events.UnitKilledInCombat.Add(OnTsoDTEUnitKilledInCombat)
    Events.PlayerTurnActivated.Add(OnTsoDTEPlayerTurnActivated)
    -- 加载时报告一次：Gameplay 环境里到底能不能调 HasDarkAge（官方只在 UI 环境用它）
    local pEras = Game.GetEras()
    print('[TsoDTE] Game.GetEras().HasDarkAge callable in Gameplay: ' .. tostring(pEras ~= nil and pEras.HasDarkAge ~= nil))
    print('[TsoDTE] Leader trait initialized for ' .. TyphonPlayerCount .. ' player(s)')
end

InitTsoDTELeaderTrait()
