-- =============================================================================
-- 纯 Lua 测试：用桩对象模拟游戏接口，跑 src/Scripts 下的两个 Gameplay 脚本。
-- 运行（仓库根目录）：
--   luajit tests/run_tests.lua
-- 能抓到的：语法错误、调用了不存在的方法、空值、对账与阵亡的逻辑错误。
-- 抓不到的：引擎事件在 Gameplay 环境是否派发、修正是否生效、通知是否显示——这些只能进游戏看 Lua.log。
-- =============================================================================

local ROOT = (arg and arg[0] and arg[0]:match('^(.*)[/\\]tests[/\\]')) or '.'
local failures, passes = 0, 0

local function check(bCond, sName)
    if bCond then
        passes = passes + 1
    else
        failures = failures + 1
        print('FAIL: ' .. sName)
    end
end

-- -----------------------------------------------------------------------------
-- 桩：GameInfo 表（按名字和下标都能取，并且能当迭代器调用）
-- -----------------------------------------------------------------------------
local function MakeInfoTable(aRows, sKey)
    local t = {}
    for i, row in ipairs(aRows) do
        row.Index = i - 1
        t[row[sKey]] = row
        t[row.Index] = row
    end
    return setmetatable(t, { __call = function()
        local i = 0
        return function()
            i = i + 1
            return aRows[i]
        end
    end })
end

-- 每个测试重建整套环境
local World

local function NewUnit(iPlayer, iID, iType, x, y, iFormation)
    local tAbilities = {}
    local tProps = {}
    local u = { player = iPlayer, id = iID, type = iType, x = x, y = y, formation = iFormation or 0, damage = 0 }
    function u:GetID() return self.id end
    function u:GetType() return self.type end
    function u:GetX() return self.x end
    function u:GetY() return self.y end
    function u:GetMilitaryFormation() return self.formation end
    function u:GetDamage() return self.damage end
    function u:SetDamage(v) self.damage = v end
    function u:GetProperty(k) return tProps[k] end
    function u:SetProperty(k, v) tProps[k] = v end
    function u:GetAbility()
        return {
            GetAbilityCount = function(_, s) return tAbilities[s] or 0 end,
            ChangeAbilityCount = function(_, s, n) tAbilities[s] = (tAbilities[s] or 0) + n end,
        }
    end
    u.abilities = tAbilities
    return u
end

local function NewPlayer(iID, bHuman)
    local p = { id = iID, human = bHuman, units = {}, props = {}, wmd = {}, boostedTech = {}, boostedCivic = {} }
    function p:IsHuman() return self.human end
    function p:GetProperty(k) return self.props[k] end
    function p:SetProperty(k, v) self.props[k] = v end
    function p:GetUnits()
        local pl = self
        return {
            Members = function()
                local aList = {}
                for _, u in pairs(pl.units) do table.insert(aList, u) end
                table.sort(aList, function(a, b) return a.id < b.id end)
                local i = 0
                return function()
                    i = i + 1
                    if aList[i] then return i, aList[i] end
                end
            end,
            FindID = function(_, iUnit) return pl.units[iUnit] end,
        }
    end
    function p:GetWMDs()
        local pl = self
        return {
            GetWeaponCount = function(_, w) return pl.wmd[w] or 0 end,
            ChangeWeaponCount = function(_, w, n) pl.wmd[w] = (pl.wmd[w] or 0) + n end,
        }
    end
    function p:GetTechs()
        local pl = self
        return {
            HasTech = function() return false end,
            HasBoostBeenTriggered = function(_, i) return pl.boostedTech[i] == true end,
            TriggerBoost = function(_, i) pl.boostedTech[i] = true end,
        }
    end
    function p:GetCulture()
        local pl = self
        return {
            HasCivic = function() return false end,
            HasBoostBeenTriggered = function(_, i) return pl.boostedCivic[i] == true end,
            TriggerBoost = function(_, i) pl.boostedCivic[i] = true end,
        }
    end
    function p:GetCities()
        return { GetCapitalCity = function() return { GetX = function() return 5 end, GetY = function() return 6 end } end }
    end
    return p
end

local function Count(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

local function SetupWorld()
    World = { handlers = {}, notifications = {}, killed = {}, killRemoves = true, era = 0, turn = 10 }
    local function Event(sName)
        return { Add = function(f) World.handlers[sName] = World.handlers[sName] or {}; table.insert(World.handlers[sName], f) end }
    end
    Events = setmetatable({}, { __index = function(t, k) local e = Event(k); rawset(t, k, e); return e end })
    MilitaryFormationTypes = { STANDARD_FORMATION = 0, CORPS_FORMATION = 1, ARMY_FORMATION = 2 }
    NotificationTypes = { USER_DEFINED_1 = 101, USER_DEFINED_2 = 102, USER_DEFINED_3 = 103, USER_DEFINED_4 = 104, USER_DEFINED_5 = 105 }
    UnitOperationTypes = { WMD_STRIKE = 777 }
    NotificationManager = { SendNotification = function(iPlayer, hType, sMsg, sSum, x, y)
        table.insert(World.notifications, { player = iPlayer, type = hType, msg = sMsg, sum = sSum, x = x, y = y })
    end }
    UnitManager = { Kill = function(u)
        table.insert(World.killed, u.id)
        if World.killRemoves then Players[u.player].units[u.id] = nil end
    end }
    Locale = { Lookup = function(s, ...)
        local a = { ... }
        if #a == 0 then return s end
        local parts = {}
        for i, v in ipairs(a) do parts[i] = tostring(v) end
        return s .. '(' .. table.concat(parts, '|') .. ')'
    end }
    Game = {
        GetEras = function() return { GetCurrentEra = function() return World.era end } end,
        GetCurrentGameTurn = function() return World.turn end,
        AddWorldViewText = function() end,
    }
    PlayerManager = { GetWasEverAliveIDs = function() return { 0, 1 } end }
    PlayerConfigurations = {
        [0] = { GetLeaderTypeName = function() return 'LEADER_TSOD_ROSETTA_AUGUSTUS' end },
        [1] = { GetLeaderTypeName = function() return 'LEADER_OTHER' end },
    }
    Players = { [0] = NewPlayer(0, true), [1] = NewPlayer(1, false) }
    GameInfo = {
        Units = MakeInfoTable({
            { UnitType = 'UNIT_WARRIOR', Name = 'LOC_UNIT_WARRIOR_NAME' },
            { UnitType = 'UNIT_TSOD_BATTLE_MAGE', Name = 'LOC_UNIT_TSOD_BATTLE_MAGE_NAME' },
            { UnitType = 'UNIT_KNIGHT', Name = 'LOC_UNIT_KNIGHT_NAME', PrereqTech = 'TECH_STIRRUPS' },
        }, 'UnitType'),
        WMDs = MakeInfoTable({ { WeaponType = 'WMD_NUCLEAR_DEVICE' }, { WeaponType = 'WMD_TSOD_ANNIHILATION_SCAR' } }, 'WeaponType'),
        LeaderTraits = MakeInfoTable({ { LeaderType = 'LEADER_TSOD_ROSETTA_AUGUSTUS', TraitType = 'TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS' } }, 'LeaderType'),
        Eras = MakeInfoTable({ { EraType = 'ERA_ANCIENT', ChronologyIndex = 1 }, { EraType = 'ERA_CLASSICAL', ChronologyIndex = 2 } }, 'EraType'),
        Technologies = MakeInfoTable({
            { TechnologyType = 'TECH_STIRRUPS', Name = 'LOC_TECH_STIRRUPS_NAME', EraType = 'ERA_CLASSICAL' },
            { TechnologyType = 'TECH_A', Name = 'LOC_TECH_A_NAME', EraType = 'ERA_CLASSICAL' },
            { TechnologyType = 'TECH_B', Name = 'LOC_TECH_B_NAME', EraType = 'ERA_CLASSICAL' },
        }, 'TechnologyType'),
        Civics = MakeInfoTable({
            { CivicType = 'CIVIC_A', Name = 'LOC_CIVIC_A_NAME', EraType = 'ERA_CLASSICAL' },
            { CivicType = 'CIVIC_B', Name = 'LOC_CIVIC_B_NAME', EraType = 'ERA_CLASSICAL' },
        }, 'CivicType'),
        Boosts = MakeInfoTable({
            { BoostID = 1, TechnologyType = 'TECH_STIRRUPS' }, { BoostID = 2, TechnologyType = 'TECH_A' },
            { BoostID = 3, TechnologyType = 'TECH_B' }, { BoostID = 4, CivicType = 'CIVIC_A' }, { BoostID = 5, CivicType = 'CIVIC_B' },
        }, 'BoostID'),
    }
end

local function Fire(sName, ...)
    for _, f in ipairs(World.handlers[sName] or {}) do f(...) end
end

local function LoadScript(sRel)
    local f, sErr = loadfile(ROOT .. '/src/Scripts/' .. sRel)
    assert(f, sErr)
    f()
end

local MAGE = 1        -- GameInfo.Units 下标
local SCAR = 1        -- GameInfo.WMDs 下标
local ABILITY_SCAR = 'ABILITY_TSOD_ANNIHILATION_SCAR'
local ABILITY_REGEN = 'ABILITY_TSOD_ARMY_REGENERATION'

local function NotesOfType(hType)
    local n = 0
    for _, t in ipairs(World.notifications) do if t.type == hType then n = n + 1 end end
    return n
end

-- -----------------------------------------------------------------------------
-- 战斗法师
-- -----------------------------------------------------------------------------
local function TestBattleMage()
    -- 1. 军团：只有战场再生，没有湮灭之创，库存 0
    SetupWorld(); LoadScript('TsoDTE_BattleMage.lua')
    local p = Players[0]
    local u = NewUnit(0, 10, MAGE, 3, 3, MilitaryFormationTypes.CORPS_FORMATION)
    p.units[10] = u
    Fire('UnitFormCorps', 0, 10)
    check(u.abilities[ABILITY_REGEN] == 1, 'corps gets regeneration')
    check((u.abilities[ABILITY_SCAR] or 0) == 0, 'corps has no scar')
    check((p.wmd[SCAR] or 0) == 0, 'corps adds no stock')
    check(NotesOfType(NotificationTypes.USER_DEFINED_3) == 1, 'corps regen notification sent once')

    -- 2. 升级成军队：湮灭之创 + 战场再生，库存 1，就绪通知
    u.formation = MilitaryFormationTypes.ARMY_FORMATION
    Fire('UnitFormArmy', 0, 10)
    check(u.abilities[ABILITY_SCAR] == 1 and u.abilities[ABILITY_REGEN] == 1, 'army gets scar and regen')
    check(p.wmd[SCAR] == 1, 'army stock is 1')
    check(NotesOfType(NotificationTypes.USER_DEFINED_1) == 1, 'army ready notification sent once')

    -- 3. 回合开始重复对账：不重复通知、库存不变
    Fire('PlayerTurnActivated', 0, true)
    check(p.wmd[SCAR] == 1, 'stock stays 1 after turn start')
    check(NotesOfType(NotificationTypes.USER_DEFINED_1) == 1, 'no duplicate ready notification')

    -- 4. 施放结束：引擎已扣成 0 → 整支军队阵亡，库存对回 0
    p.wmd[SCAR] = 0
    Fire('UnitOperationDeactivated', 0, 10, UnitOperationTypes.WMD_STRIKE, 0)
    check(#World.killed == 1 and World.killed[1] == 10, 'casting army is killed')
    check(p.units[10] == nil, 'army removed')
    check((p.wmd[SCAR] or 0) == 0, 'stock 0 after the army died')
    check(NotesOfType(NotificationTypes.USER_DEFINED_2) == 1, 'sacrifice notification sent')
    Fire('PlayerTurnActivated', 0, true)
    check((p.wmd[SCAR] or 0) == 0, 'no refill next turn')

    -- 5. 别的武器（库存没少）：不杀
    SetupWorld(); LoadScript('TsoDTE_BattleMage.lua')
    p = Players[0]
    u = NewUnit(0, 20, MAGE, 4, 4, MilitaryFormationTypes.ARMY_FORMATION)
    p.units[20] = u
    Fire('PlayerTurnActivated', 0, true)
    check(p.wmd[SCAR] == 1, 'army stock 1 at turn start')
    Fire('UnitOperationDeactivated', 0, 20, UnitOperationTypes.WMD_STRIKE, 0)
    check(#World.killed == 0, 'no kill when the scar stock did not drop')

    -- 6. Kill 没立刻生效：标记已施放，不再计入库存、不再有湮灭之创
    World.killRemoves = false
    p.wmd[SCAR] = 0
    Fire('UnitOperationDeactivated', 0, 20, UnitOperationTypes.WMD_STRIKE, 0)
    check(#World.killed == 1, 'kill attempted')
    check(u:GetProperty('TSOD_TYPHON_SCAR_SPENT') == 1, 'spent flag set')
    Fire('PlayerTurnActivated', 0, true)
    check((p.wmd[SCAR] or 0) == 0, 'spent army is not restocked')
    check((u.abilities[ABILITY_SCAR] or 0) == 0, 'spent army loses the scar')

    -- 7. 同格两个单位对象（编队成员）：只算一支军队，能力只给 ID 小的
    SetupWorld(); LoadScript('TsoDTE_BattleMage.lua')
    p = Players[0]
    local a = NewUnit(0, 31, MAGE, 7, 7, MilitaryFormationTypes.ARMY_FORMATION)
    local b = NewUnit(0, 30, MAGE, 7, 7, MilitaryFormationTypes.ARMY_FORMATION)
    p.units[31] = a; p.units[30] = b
    Fire('PlayerTurnActivated', 0, true)
    check(p.wmd[SCAR] == 1, 'one army per tile')
    check(b.abilities[ABILITY_SCAR] == 1 and (a.abilities[ABILITY_SCAR] or 0) == 0, 'scar only on the lead unit')
    p.wmd[SCAR] = 0
    Fire('UnitOperationDeactivated', 0, 31, UnitOperationTypes.WMD_STRIKE, 0)
    check(#World.killed == 2, 'both formation members killed')

    -- 8. 回血：每回合 10，只回主体
    SetupWorld(); LoadScript('TsoDTE_BattleMage.lua')
    p = Players[0]
    u = NewUnit(0, 40, MAGE, 1, 1, MilitaryFormationTypes.CORPS_FORMATION)
    u.damage = 30
    p.units[40] = u
    Fire('PlayerTurnActivated', 0, true)
    check(u.damage == 20, 'corps heals 10 at turn start')
    Fire('PlayerTurnActivated', 0, true)
    check(u.damage == 10, 'corps heals again next turn')

    -- 9. AI 不发通知
    SetupWorld(); LoadScript('TsoDTE_BattleMage.lua')
    local ai = Players[1]
    ai.units[50] = NewUnit(1, 50, MAGE, 2, 2, MilitaryFormationTypes.ARMY_FORMATION)
    Fire('PlayerTurnActivated', 1, true)
    check(ai.wmd[SCAR] == 1 and #World.notifications == 0, 'AI army stocked without notifications')
end

-- -----------------------------------------------------------------------------
-- 领袖能力
-- -----------------------------------------------------------------------------
local function TestLeaderTrait()
    SetupWorld(); LoadScript('TsoDTE_LeaderTrait.lua')
    local p = Players[0]
    -- 开局：只记录
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 0 and #World.notifications == 0, 'first turn only records the era')

    -- 进入新时代（非黑暗）：1+1 和一条通知
    World.era = 1
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 1 and Count(p.boostedCivic) == 1, 'normal era gives 1 + 1')
    check(NotesOfType(NotificationTypes.USER_DEFINED_4) == 1, 'era notification sent')
    check(World.notifications[1].sum == 'LOC_TRAIT_LEADER_TSOD_ROSETTA_AUGUSTUS_NAME', 'notification summary is the ability name')

    -- 黑暗时代属性晚一回合才出现：补 1+1，只补一次
    p.props['TSOD_TYPHON_DARK_AGE'] = 1
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 2 and Count(p.boostedCivic) == 2, 'dark age adds 1 + 1 once detected')
    check(NotesOfType(NotificationTypes.USER_DEFINED_4) == 2, 'dark age notification sent')
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 2, 'dark age bonus only once per era')

    -- 进入时就是黑暗时代：同一回合 2+2
    SetupWorld(); LoadScript('TsoDTE_LeaderTrait.lua')
    p = Players[0]
    Fire('PlayerTurnActivated', 0, true)
    World.era = 1
    p.props['TSOD_TYPHON_DARK_AGE'] = 1
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 2 and Count(p.boostedCivic) == 2, 'entering a dark age gives 2 + 2 at once')

    -- 开局就处于黑暗时代（读旧存档第一次见到）：不补
    SetupWorld(); LoadScript('TsoDTE_LeaderTrait.lua')
    p = Players[0]
    p.props['TSOD_TYPHON_DARK_AGE'] = 1
    Fire('PlayerTurnActivated', 0, true)
    Fire('PlayerTurnActivated', 0, true)
    check(Count(p.boostedTech) == 0, 'no bonus for the era the script first sees')

    -- 击杀尤里卡：触发并通知，位置是凶手
    SetupWorld(); LoadScript('TsoDTE_LeaderTrait.lua')
    p = Players[0]
    local enemy = Players[1]
    enemy.units[60] = NewUnit(1, 60, 2, 9, 9)      -- 骑士，前置马镫
    p.units[61] = NewUnit(0, 61, MAGE, 8, 9)
    Fire('UnitKilledInCombat', 1, 60, 0, 61)
    local iStirrups = GameInfo.Technologies['TECH_STIRRUPS'].Index
    check(p.boostedTech[iStirrups] == true, 'kill boost triggers the prerequisite eureka')
    local n = World.notifications[#World.notifications]
    check(n ~= nil and n.type == NotificationTypes.USER_DEFINED_4 and n.x == 8 and n.y == 9, 'kill notification at the killer')
    enemy.units[62] = NewUnit(1, 62, 2, 9, 8)
    Fire('UnitKilledInCombat', 1, 62, 0, 61)
    check(#World.notifications == 1, 'second kill of the same type does nothing')
end

local ok, err = pcall(TestBattleMage)
if not ok then failures = failures + 1; print('ERROR in battle mage tests: ' .. tostring(err)) end
ok, err = pcall(TestLeaderTrait)
if not ok then failures = failures + 1; print('ERROR in leader trait tests: ' .. tostring(err)) end

print(string.format('%d passed, %d failed', passes, failures))
os.exit(failures == 0 and 0 or 1)
