-- =============================================================================
-- WP13 战斗法师纯 Lua 测试（LuaJIT，不进游戏）
-- 运行（仓库根目录）：luajit tests/battle_mage_test.lua
--
-- 桩对象只模拟 src/Scripts/TsoDTE_BattleMage.lua 用到的引擎接口，通过事件处理函数驱动模块。
-- 引擎实际行为（N1 Kill 是否立即生效、N3 扣库存的时机、N6 编队 ID 是否在成员间共享）
-- 未经游戏实测。这里用开关（killMode、deductAt）覆盖几种可能，测的是模块在这些假设下的逻辑。
-- 退出码：全部通过为 0，否则为 1。
-- =============================================================================

local SCRIPT_DIR = ((arg and arg[0]) or ''):match('^(.*)[/\\]') or '.'
local MODULE_PATH = SCRIPT_DIR .. '/../src/Scripts/TsoDTE_BattleMage.lua'

-- 桩里的 ID 只需彼此不同，不必与游戏一致
local MFT = { STANDARD_FORMATION = 0, CORPS_FORMATION = 1, ARMY_FORMATION = 2 }
local OP = { WMD_STRIKE = 9001, PARAM_WMD_TYPE = 1, PARAM_X = 2, PARAM_Y = 3 }
local UNIT_BATTLE_MAGE = 3
local UNIT_OTHER = 4            -- 轰炸机等非战斗法师
local WEAPON_SCAR = 7
local WEAPON_OFFICIAL = 8       -- 官方核弹等

local ABIL_SCAR = 'ABILITY_TSOD_ANNIHILATION_SCAR'
local ABIL_REGEN = 'ABILITY_TSOD_ARMY_REGENERATION'
local NOTIF_READY = 'NOTIFICATION_TSOD_ANNIHILATION_READY'
local NOTIF_SACRIFICE = 'NOTIFICATION_TSOD_ANNIHILATION_SACRIFICE'
local NOTIF_REGEN = 'NOTIFICATION_TSOD_ARMY_REGENERATION'
local EVENT_NAMES = {
    'UnitFormCorps', 'UnitFormArmy', 'UnitOperationStarted',
    'UnitOperationDeactivated', 'PlayerTurnActivated',
}

local W           -- 当前测试的世界，每个用例重建
local RESULT = { pass = 0, fail = 0 }

local function Out(s)
    io.write(s, '\n')
end

local function Check(sName, bCond, sDetail)
    if bCond then
        RESULT.pass = RESULT.pass + 1
        Out('PASS  ' .. sName)
    else
        RESULT.fail = RESULT.fail + 1
        Out('FAIL  ' .. sName .. (sDetail and ('  -- ' .. sDetail) or ''))
    end
end

-- -----------------------------------------------------------------------------
-- 单位与玩家桩
-- -----------------------------------------------------------------------------
local UnitMT = {}
UnitMT.__index = UnitMT

function UnitMT:GetID() return self.id end
function UnitMT:GetType() return self.unitType end
function UnitMT:GetX() return self.x end
function UnitMT:GetY() return self.y end
function UnitMT:GetDamage() return self.damage end
function UnitMT:SetDamage(v) self.damage = v end
function UnitMT:GetMilitaryFormation() return self.formation end
function UnitMT:GetFormationID() return self.formationId end
function UnitMT:IsDead() return self.dead end
function UnitMT:IsDelayedDeath() return self.delayedDeath end
function UnitMT:GetAbility() return self.ability end

-- 编队人数：同一编队 ID 的、仍在编队中的单位数（引擎按编队算，桩按列表算）
function UnitMT:GetFormationUnitCount()
    if self.formation == MFT.STANDARD_FORMATION then
        return 1
    end
    local n = 0
    for _, v in ipairs(W.players[self.owner].units) do
        if v.formationId == self.formationId and v.formation ~= MFT.STANDARD_FORMATION then
            n = n + 1
        end
    end
    return n
end

function UnitMT:GetOperationParameter(iParam)
    if self.weaponError and iParam == OP.PARAM_WMD_TYPE then
        error('GetOperationParameter: simulated read failure')
    end
    return self.op[iParam]
end

local function AddUnit(t)
    local u = setmetatable({
        id = t.id,
        owner = t.owner or 0,
        x = t.x or 5,
        y = t.y or 5,
        unitType = t.type or UNIT_BATTLE_MAGE,
        formation = t.formation or MFT.STANDARD_FORMATION,
        formationId = t.formationId or -1,
        damage = t.damage or 0,
        dead = false,
        delayedDeath = false,
        weaponError = false,
        abilities = {},
        op = {},
    }, UnitMT)
    u.ability = {
        GetAbilityCount = function(_, sName) return u.abilities[sName] or 0 end,
        ChangeAbilityCount = function(_, sName, iDelta)
            u.abilities[sName] = (u.abilities[sName] or 0) + iDelta
        end,
    }
    table.insert(W.players[u.owner].units, u)
    return u
end

-- 军队 / 军团：ids 里第一个为主体（与编队 ID 相同），其余为成员
local function MakeFormation(aIds, iFormation, sState, t)
    for _, iId in ipairs(aIds) do
        AddUnit({
            id = iId,
            owner = t.owner,
            x = t.x,
            y = t.y,
            damage = t.damage,
            formation = sState == 'army' and MFT.ARMY_FORMATION or MFT.CORPS_FORMATION,
            formationId = iFormation,
        })
    end
end

local function Army(aIds, iFormation, t)
    MakeFormation(aIds, iFormation, 'army', t or {})
end

local function Corps(aIds, iFormation, t)
    MakeFormation(aIds, iFormation, 'corps', t or {})
end

-- 在列表里找单位（不含已移除的）
local function RawFind(iOwner, iId)
    for _, u in ipairs(W.players[iOwner].units) do
        if u.id == iId then
            return u
        end
    end
    return nil
end

-- 找任意玩家的单位（测试断言用）
local function Get(iId)
    for iPlayer = 0, 1 do
        local u = RawFind(iPlayer, iId)
        if u ~= nil then
            return u
        end
    end
    return nil
end

local function Present(iId)
    return Get(iId) ~= nil
end

local function Ab(iId, sName)
    local u = Get(iId)
    return u and u.abilities[sName] or 0
end

local function Dmg(iId)
    local u = Get(iId)
    return u and u.damage or -1
end

local function Stock(iPlayer)
    return W.players[iPlayer].weapons[WEAPON_SCAR] or 0
end

local function CountNotes(iPlayer, sType)
    local n = 0
    for _, t in ipairs(W.notes) do
        if t.player == iPlayer and t.type == sType then
            n = n + 1
        end
    end
    return n
end

local function LogHas(sNeedle)
    for _, s in ipairs(W.log) do
        if string.find(s, sNeedle, 1, true) then
            return true
        end
    end
    return false
end

-- -----------------------------------------------------------------------------
-- 引擎与事件
-- -----------------------------------------------------------------------------
local function Fire(sName, ...)
    for _, f in ipairs(W.handlers[sName]) do
        f(...)
    end
end

local function KillUnit(u)
    if W.killMode == 'immediate' then
        local aList = W.players[u.owner].units
        for i, v in ipairs(aList) do
            if v == u then
                table.remove(aList, i)
                break
            end
        end
        u.dead = true
    elseif W.killMode == 'delayed' then
        u.delayedDeath = true
    end
end

-- 引擎扣库存（假设：施放的是湮灭之创，或读不到武器类型时按湮灭之创算）
local function EngineDeduct(iOwner, u)
    if u.op[OP.PARAM_WMD_TYPE] == WEAPON_SCAR or u.weaponError then
        local p = W.players[iOwner]
        if (p.weapons[WEAPON_SCAR] or 0) > 0 then
            p.weapons[WEAPON_SCAR] = p.weapons[WEAPON_SCAR] - 1
        end
    end
end

local function StartStrike(iOwner, iUnit, iWeapon, iTargetX, iTargetY)
    local u = RawFind(iOwner, iUnit)
    W.strikeUnit = u
    u.op[OP.PARAM_WMD_TYPE] = iWeapon
    u.op[OP.PARAM_X] = iTargetX or u.x
    u.op[OP.PARAM_Y] = iTargetY or u.y
    if W.deductAt == 'start' then
        EngineDeduct(iOwner, u)
    end
    Fire('UnitOperationStarted', iOwner, iUnit, OP.WMD_STRIKE)
end

local function EndStrike(iOwner, iUnit)
    local u = W.strikeUnit
    if W.deductAt == 'end' then
        EngineDeduct(iOwner, u)
    end
    Fire('UnitOperationDeactivated', iOwner, iUnit, OP.WMD_STRIKE, 0)
end

local function StrikeWith(iOwner, iUnit, iWeapon, iTargetX, iTargetY)
    StartStrike(iOwner, iUnit, iWeapon, iTargetX, iTargetY)
    EndStrike(iOwner, iUnit)
end

local function TurnStart(iPlayer)
    Fire('PlayerTurnActivated', iPlayer, false)
end

-- -----------------------------------------------------------------------------
-- 全局桩（模块在加载时与运行时都会访问这些全局名）
-- -----------------------------------------------------------------------------
local function InstallGlobals()
    Players = {}
    W.players[0] = { id = 0, human = true, units = {}, weapons = {} }
    W.players[1] = { id = 1, human = false, units = {}, weapons = {} }
    for iPlayer = 0, 1 do
        local p = W.players[iPlayer]
        Players[iPlayer] = setmetatable(p, {})
        p.IsHuman = function(self) return self.human end
        p.GetUnits = function(self)
            return {
                Members = function()
                    local aSnap = {}
                    for _, u in ipairs(self.units) do
                        aSnap[#aSnap + 1] = u
                    end
                    local i = 0
                    return function()
                        i = i + 1
                        local u = aSnap[i]
                        if u ~= nil then
                            return i, u
                        end
                    end
                end,
                FindID = function(_, iId)
                    return RawFind(self.id, iId)
                end,
            }
        end
        p.GetWMDs = function(self)
            return {
                GetWeaponCount = function(_, iIdx) return self.weapons[iIdx] or 0 end,
                ChangeWeaponCount = function(_, iIdx, iDelta)
                    self.weapons[iIdx] = (self.weapons[iIdx] or 0) + iDelta
                end,
            }
        end
    end

    Events = {}
    for _, sName in ipairs(EVENT_NAMES) do
        W.handlers[sName] = {}
        Events[sName] = {
            Add = function(f) table.insert(W.handlers[sName], f) end,
        }
    end

    GameInfo = {
        Units = { UNIT_TSOD_BATTLE_MAGE = { Index = UNIT_BATTLE_MAGE } },
        WMDs = { WMD_TSOD_ANNIHILATION_SCAR = { Index = WEAPON_SCAR } },
    }
    MilitaryFormationTypes = { CORPS_FORMATION = MFT.CORPS_FORMATION, ARMY_FORMATION = MFT.ARMY_FORMATION }
    UnitOperationTypes = { WMD_STRIKE = OP.WMD_STRIKE, PARAM_WMD_TYPE = OP.PARAM_WMD_TYPE,
        PARAM_X = OP.PARAM_X, PARAM_Y = OP.PARAM_Y }
    DB = { MakeHash = function(s) return s end }
    Locale = { Lookup = function(s) return s end }
    NotificationManager = {
        SendNotification = function(iPlayer, sType, sMsg, sSum, iX, iY)
            table.insert(W.notes, { player = iPlayer, type = sType, msg = sMsg, sum = sSum, x = iX, y = iY })
        end,
    }
    Game = {
        AddWorldViewText = function(iPlayer, sText, iX, iY)
            table.insert(W.texts, { player = iPlayer, text = sText, x = iX, y = iY })
        end,
    }
    Map = {
        GetPlotDistance = function(x1, y1, x2, y2)
            return math.max(math.abs(x1 - x2), math.abs(y1 - y2))
        end,
    }
    UnitManager = {
        Kill = function(u) KillUnit(u) end,
    }
    print = function(s)
        table.insert(W.log, tostring(s))
    end
end

-- 每个用例：重建世界 → 装全局桩 → 加载模块 → 布置 → 断言
local function Scenario(sName, tOpts, fn)
    W = {
        players = {}, handlers = {}, notes = {}, texts = {}, log = {},
        killMode = (tOpts and tOpts.killMode) or 'immediate',
        deductAt = (tOpts and tOpts.deductAt) or 'start',
    }
    InstallGlobals()
    local bLoadOk, sLoadErr = pcall(dofile, MODULE_PATH)
    if not bLoadOk then
        Check(sName .. '（模块加载）', false, tostring(sLoadErr))
        return
    end
    local bOk, sErr = pcall(fn)
    if not bOk then
        Check(sName .. '（用例异常）', false, tostring(sErr))
    end
end

-- =============================================================================
-- 用例
-- =============================================================================

Scenario('军团只给战场再生，不给湮灭之创，库存为 0', nil, function()
    Corps({ 1, 2 }, 1, { owner = 0 })
    Fire('UnitFormCorps', 0, 1)
    TurnStart(0)
    Check('军团主体有战场再生', Ab(1, ABIL_REGEN) == 1)
    Check('军团主体没有湮灭之创', Ab(1, ABIL_SCAR) == 0)
    Check('军团不计入库存（库存为 0）', Stock(0) == 0, 'stock=' .. Stock(0))
end)

Scenario('军队有湮灭之创与战场再生，三人一支库存为 1', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0 })
    Fire('UnitFormArmy', 0, 1)
    TurnStart(0)
    Check('军队主体有湮灭之创', Ab(1, ABIL_SCAR) == 1)
    Check('军队主体有战场再生', Ab(1, ABIL_REGEN) == 1)
    Check('一支军队（三人）库存为 1，不按人数计', Stock(0) == 1, 'stock=' .. Stock(0))
end)

Scenario('两支军队在同一格，库存为 2（同格不合并）', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Army({ 4, 5, 6 }, 4, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormArmy', 0, 4)
    TurnStart(0)
    Check('两支军队库存为 2', Stock(0) == 2, 'stock=' .. Stock(0))
    Check('两支军队的主体都有湮灭之创', Ab(1, ABIL_SCAR) == 1 and Ab(4, ABIL_SCAR) == 1)
end)

Scenario('被并入的成员不得获得能力', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0 })
    Corps({ 7, 8 }, 7, { owner = 0, x = 9, y = 9 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormCorps', 0, 7)
    TurnStart(0)
    Check('军队成员 2 没有湮灭之创', Ab(2, ABIL_SCAR) == 0, 'ability=' .. Ab(2, ABIL_SCAR))
    Check('军队成员 2 没有战场再生', Ab(2, ABIL_REGEN) == 0, 'ability=' .. Ab(2, ABIL_REGEN))
    Check('军队成员 3 没有湮灭之创', Ab(3, ABIL_SCAR) == 0)
    Check('军团成员 8 没有战场再生', Ab(8, ABIL_REGEN) == 0, 'ability=' .. Ab(8, ABIL_REGEN))
end)

Scenario('回血：每个编队每回合只回一次（主体回 10，成员不回）', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, damage = 30 })
    Corps({ 7, 8 }, 7, { owner = 0, x = 9, y = 9, damage = 30 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormCorps', 0, 7)
    TurnStart(0)
    Check('军队主体回 10 点', Dmg(1) == 20, 'damage=' .. Dmg(1))
    Check('军队成员不回血（避免双倍）', Dmg(2) == 30 and Dmg(3) == 30, 'damage2=' .. Dmg(2) .. ' damage3=' .. Dmg(3))
    Check('军团主体回 10 点', Dmg(7) == 20, 'damage=' .. Dmg(7))
    TurnStart(0)
    Check('下一回合军队主体仍回血', Dmg(1) == 10, 'damage=' .. Dmg(1))
end)

Scenario('普通状态的战斗法师：没有能力、不计库存、不回血', nil, function()
    AddUnit({ id = 1, owner = 0, damage = 30 })
    TurnStart(0)
    Check('普通状态没有湮灭之创', Ab(1, ABIL_SCAR) == 0)
    Check('普通状态没有战场再生', Ab(1, ABIL_REGEN) == 0)
    Check('普通状态库存为 0', Stock(0) == 0)
    Check('普通状态不回血', Dmg(1) == 30, 'damage=' .. Dmg(1))
end)

-- 军队施放：整支阵亡、库存 −1、另一支仍在。两种扣库存时机都要对。
for _, sDeduct in ipairs({ 'start', 'end' }) do
    Scenario('军队施放湮灭之创：整支阵亡，库存 −1（扣库存时机 ' .. sDeduct .. '）', { deductAt = sDeduct }, function()
        Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
        Army({ 4, 5, 6 }, 4, { owner = 0, x = 9, y = 9 })
        Fire('UnitFormArmy', 0, 1)
        Fire('UnitFormArmy', 0, 4)
        TurnStart(0)
        Check('施放前库存为 2', Stock(0) == 2, 'stock=' .. Stock(0))
        StrikeWith(0, 1, WEAPON_SCAR, 8, 8)
        Check('施放的军队三人全部阵亡', not Present(1) and not Present(2) and not Present(3))
        Check('另一支军队仍在', Present(4) and Present(5) and Present(6))
        Check('施放后库存为 1', Stock(0) == 1, 'stock=' .. Stock(0))
        Check('另一支军队仍有湮灭之创', Ab(4, ABIL_SCAR) == 1)
        Check('施放后发出阵亡通知', CountNotes(0, NOTIF_SACRIFICE) == 1, 'notes=' .. CountNotes(0, NOTIF_SACRIFICE))
        Check('施放位置浮出魔力枯竭', #W.texts == 1 and W.texts[1].x == 5 and W.texts[1].y == 5)
    end)
end

Scenario('轰炸机等非战斗法师施放：不处理（F6 已删）', nil, function()
    AddUnit({ id = 20, owner = 0, type = UNIT_OTHER, x = 5, y = 5 })
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormArmy', 0, 1)
    TurnStart(0)
    StrikeWith(0, 20, WEAPON_SCAR, 5, 5)
    Check('军队没有代为阵亡', Present(1) and Present(2) and Present(3))
    Check('施放后库存仍为 1（只由对账维护）', Stock(0) == 1, 'stock=' .. Stock(0))
end)

Scenario('军团施放湮灭之创：不处理（只有军队能施放）', nil, function()
    Corps({ 7, 8 }, 7, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormCorps', 0, 7)
    TurnStart(0)
    StrikeWith(0, 7, WEAPON_SCAR, 5, 5)
    Check('军团不阵亡', Present(7) and Present(8))
    Check('库存仍为 0', Stock(0) == 0, 'stock=' .. Stock(0))
end)

Scenario('武器类型读不到，施放者是军队：按后备规则判定，军队阵亡', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Army({ 4, 5, 6 }, 4, { owner = 0, x = 9, y = 9 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormArmy', 0, 4)
    TurnStart(0)
    Get(1).weaponError = true
    StrikeWith(0, 1, WEAPON_SCAR, 8, 8)
    Check('后备规则下军队阵亡', not Present(1) and not Present(2) and not Present(3))
    Check('日志写明按后备规则判定', LogHas('后备规则'))
end)

Scenario('武器类型读不到，施放者是军团：不处理', nil, function()
    Corps({ 7, 8 }, 7, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormCorps', 0, 7)
    TurnStart(0)
    Get(7).weaponError = true
    StrikeWith(0, 7, WEAPON_SCAR, 5, 5)
    Check('军团不阵亡', Present(7) and Present(8))
end)

Scenario('官方核弹（武器不是湮灭之创）：不处理', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormArmy', 0, 1)
    TurnStart(0)
    StrikeWith(0, 1, WEAPON_OFFICIAL, 5, 5)
    Check('军队不阵亡', Present(1) and Present(2) and Present(3))
    Check('湮灭之创库存不变', Stock(0) == 1, 'stock=' .. Stock(0))
end)

Scenario('延迟死亡的单位不计入库存', { killMode = 'delayed' }, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Army({ 4, 5, 6 }, 4, { owner = 0, x = 9, y = 9 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormArmy', 0, 4)
    TurnStart(0)
    StrikeWith(0, 1, WEAPON_SCAR, 8, 8)
    Check('延迟死亡的军队不计入库存（库存为 1）', Stock(0) == 1, 'stock=' .. Stock(0))
end)

Scenario('Started 里 Kill 没生效：Deactivated 时补杀', { killMode = 'ignore' }, function()
    Army({ 1, 2, 3 }, 1, { owner = 0, x = 5, y = 5 })
    Fire('UnitFormArmy', 0, 1)
    TurnStart(0)
    StartStrike(0, 1, WEAPON_SCAR, 8, 8)
    W.killMode = 'immediate'
    EndStrike(0, 1)
    Check('补杀后军队三人阵亡', not Present(1) and not Present(2) and not Present(3))
    Check('补杀后库存为 0', Stock(0) == 0, 'stock=' .. Stock(0))
end)

Scenario('通知只发给人类玩家：军队发 READY，军团发 REGEN', nil, function()
    Army({ 1, 2, 3 }, 1, { owner = 0 })
    Corps({ 7, 8 }, 7, { owner = 0, x = 9, y = 9 })
    Army({ 21, 22, 23 }, 21, { owner = 1, x = 13, y = 13 })
    Fire('UnitFormArmy', 0, 1)
    Fire('UnitFormCorps', 0, 7)
    Fire('UnitFormArmy', 1, 21)
    TurnStart(0)
    TurnStart(1)
    Check('人类军队发一条 READY', CountNotes(0, NOTIF_READY) == 1, 'n=' .. CountNotes(0, NOTIF_READY))
    Check('人类军团发一条 REGEN', CountNotes(0, NOTIF_REGEN) == 1, 'n=' .. CountNotes(0, NOTIF_REGEN))
    Check('AI 的组成不发通知', CountNotes(1, NOTIF_READY) == 0 and CountNotes(1, NOTIF_REGEN) == 0)
end)

-- -----------------------------------------------------------------------------
-- 汇总
-- -----------------------------------------------------------------------------
Out(string.format('\n共 %d 项：通过 %d，失败 %d', RESULT.pass + RESULT.fail, RESULT.pass, RESULT.fail))
os.exit(RESULT.fail == 0 and 0 or 1)
