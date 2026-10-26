-- WP3 领袖能力「凡人的韧性」（Gameplay；InGame AddGameplayScripts）：击杀给尤里卡；新时代给尤里卡与鼓舞（黑暗时代各 2 个）。
-- 只有一个能力名「凡人的韧性」，通知与界面文字里不出现别的子名称（用户定）。

local LEADER_TYPHON  = 'LEADER_TSOD_ROSETTA_AUGUSTUS'
local TRAIT_TYPHON   = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS'
local PROPERTY_PREFIX = 'TSOD_TYPHON_KILL_BOOST_'   -- + TechnologyType
local PROPERTY_LAST_ERA = 'TSOD_TYPHON_TWILIGHT_PALACE_ERA'   -- 上次处理到的游戏时代（Eras 表的 Index；键名保留，旧存档兼容）
local PROPERTY_DARK_ERA = 'TSOD_TYPHON_DARK_AGE_BONUS_ERA'   -- 已补过黑暗时代额外 1+1 的时代
local PROPERTY_DARK_AGE = 'TSOD_TYPHON_DARK_AGE'             -- 修正写入：黑暗时代时 > 0

-- 通知：官方剧本用 NotificationTypes.USER_DEFINED_*（自定义类型实机不出现）。
-- 战斗法师用 1..3，去神圣化用 5，这里用 4。摘要用领袖能力名。
local NotifyBoost = nil
local TXT_SUMMARY    = 'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME'
local TXT_ERA_MSG    = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_ERA'
local TXT_DARK_MSG   = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_DARK_AGE'
local TXT_KILL_MSG   = 'LOC_TSOD_TYPHON_BOOST_NOTIFY_KILL'
local TXT_EUREKA     = 'LOC_TSOD_TYPHON_BOOST_ITEM_EUREKA'
local TXT_INSPIRE    = 'LOC_TSOD_TYPHON_BOOST_ITEM_INSPIRATION'
local TXT_SEPARATOR  = 'LOC_TSOD_TYPHON_BOOST_ITEM_SEPARATOR'

-- [playerID] = pPlayer，拥有本能力的玩家
local TyphonPlayers = {}
local TyphonPlayerCount = 0

-- [techIndex] = true，在 Boosts 表里有尤里卡的科技
local TechHasBoost = {}

-- [playerID] = { [unitID] = unitTypeIndex }
local UnitTypeCache = {}

-- 新时代加成用：按时代先后排好的时代列表，以及每个时代里有尤里卡 / 鼓舞的科技、市政
local EraOrder = {}            -- [1..n] = eraIndex，按 ChronologyIndex 排序
local EraPosition = {}         -- [eraIndex] = 在 EraOrder 里的位置
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

-- 单位类型缓存
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

-- Events 是事后派发的，被杀单位可能已从 PlayerUnits 移除（官方 NotificationPanel 同样处理），
-- 故先 FindID，取不到再查缓存（缓存不进存档，每次加载重建）。返回类型索引并清掉缓存项。
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

-- 击杀尤里卡
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

    local sMsg = Locale.Lookup(TXT_KILL_MSG, Locale.Lookup(tUnit.Name), Locale.Lookup(TXT_EUREKA, Locale.Lookup(tTech.Name)))
    local pKiller = FindUnit(playerID, unitID)
    if pKiller ~= nil then
        NotifyBoostHuman(playerID, sMsg, pKiller:GetX(), pKiller:GetY())
    else
        NotifyBoostHuman(playerID, sMsg)
    end
end

-- 新时代加成（SQL 的 ..._ON_NEW_ERA 修正在风云变幻里不生效，I1 实测，故改在 Lua 里做）
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

-- 确定的伪随机下标 1..n（联机要同步，不用 math.random）
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

-- 返回 (是否黑暗时代, 来源说明)。GameEras:HasDarkAge 在 Gameplay 环境是 nil（实机证实），
-- 所以先读修正 TSOD_TYPHON_DARK_AGE_PROBE 写入的玩家属性，读不到再试 HasDarkAge，都不行按非黑暗。
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

-- 授予 iCount 组（1 尤里卡 + 1 鼓舞），返回通知用的项目文本列表与日志用的类型名列表
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

-- 进入新时代：给 1+1（黑暗时代的额外 1+1 由 CheckDarkAgeBonus 补）
local function GrantNewEra(iPlayer, pPlayer, eraIndex)
    local tItems, tTypes = GrantBoostPairs(iPlayer, pPlayer, eraIndex, 1, 0)
    print('[TsoDTE] New era boost: player ' .. iPlayer .. ' entered ' .. EraName(eraIndex)
        .. ', boosted ' .. (#tTypes > 0 and table.concat(tTypes, ', ') or 'nothing'))
    if #tItems > 0 then
        NotifyAtCapital(iPlayer, pPlayer, Locale.Lookup(TXT_ERA_MSG, JoinItems(tItems)))
    end
end

-- 需求重新评估可能晚于回合开始，所以进入新时代时先给 1+1，之后本时代内读到黑暗时代才补 1+1（每时代一次）
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

-- 不挂 GameEraChanged：每回合开始比较当前时代与玩家属性里记的上次时代（时代切换发生在回合交替时）
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
        -- 开局或本脚本第一次见到这个存档：只记录，不发放（本时代也不补黑暗时代）
        pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
        pPlayer:SetProperty(PROPERTY_DARK_ERA, iEra)
        return
    end
    if iEra ~= iLast then
        -- 先写标记再发放：发放中途出错也不会在下回合重复给
        pPlayer:SetProperty(PROPERTY_LAST_ERA, iEra)
        if (EraPosition[iEra] or 0) > (EraPosition[iLast] or 0) then
            GrantNewEra(iPlayer, pPlayer, iEra)
        else
            -- 时代倒退（不该发生）：不补黑暗时代
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
        -- 先存进局部变量：GetProperty 读不到时返回「无值」，直接传给 tostring 会报错（10-22 实测）
        local vDark = pPlayer:GetProperty(PROPERTY_DARK_AGE)
        print('[TsoDTE] Dark age sources for player ' .. iPlayer .. ': property ' .. tostring(vDark)
            .. ', HasDarkAge callable ' .. tostring(pEras ~= nil and pEras.HasDarkAge ~= nil)
            .. ', notification type ' .. tostring(NotifyBoost))
    end
    print('[TsoDTE] Leader trait initialized for ' .. TyphonPlayerCount .. ' player(s)')
end

InitTsoDTELeaderTrait()
