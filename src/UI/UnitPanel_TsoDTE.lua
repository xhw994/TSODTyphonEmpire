-- ===========================================================================
--  单位面板：湮灭之创只在战斗法师的军队状态下出现
--
--  文件头写法照梦境之城（TSODDreamCity\UI\CityStates_TSODDreamCity.lua）：
--  ReplaceUIScript（LuaContext UnitPanel）配同 LoadOrder（200000）的 ImportFiles，
--  后来的 mod 才能 include 本文件接力，而不是把我们顶掉。
--
--  接力链（基础版只 include 一次，避免重复定义）：
--    a. include 可莉 mod（工坊 2882489805）的 UnitPanel_Klee.lua。它自己 include 基础版。
--    b. 若 a 之后 Initialize 仍未定义，依次 include 资料片版本与基础版，直到 Initialize 出现。
--    c. include BuilderLagFix（工坊 2024939221）的 BuilderLagFix.lua。它整体重写了 GetUnitActionsTable。
--    d. 本文件包一层 GetUnitActionsTable：先调原函数，再过滤 userTag 为 WMD_STRIKE 的条目。
--  不覆盖 IsActionLimited（可莉 mod 在那里做它自己的过滤）。
--
--  过滤规则（只动核武类按钮，其余按钮一概不碰）：
--    战斗法师：只保留湮灭之创，且只在军队状态下保留；官方核弹、热核、其他 mod 的武器全部去掉。
--    其他单位：去掉湮灭之创；其余武器按钮照常。
--  认武器：按武器的本地化名做子串匹配（AddActionToTable 的 helpString 里拼了 Locale.Lookup(entry.Name)）。
--    不用「末尾」匹配：不能发射时，失败原因会追加在名字后面。
--
--  限度（请保留这段）：
--    同一个面板脚本只能有一个替换生效，做不到对所有 mod 都兼容。
--    以后若有别的 mod 替换单位面板且 LoadOrder 比本文件大，我们的过滤会被顶掉，
--    损失的只是这一层过滤（湮灭之创之外的武器按钮会重新出现），游戏逻辑不受影响。
-- ===========================================================================

local BASE_FILES_IN_ORDER = {
    "UnitPanel_Expansion2.lua",
    "UnitPanel_Expansion1.lua",
    "UnitPanel.lua",
}

-- 文件不存在或内部出错时只记一行日志，不让整个面板失效。
local function TryInclude(sFile)
    local bOk, sErr = pcall(include, sFile)
    if not bOk then
        print("[TsoDTE] UnitPanel include failed: " .. sFile .. " : " .. tostring(sErr))
    end
end

-- a. 可莉（会自己 include 基础版）
TryInclude("UnitPanel_Klee.lua")

-- b. 没有可莉时，按资料片版本由高到低补上基础版
if Initialize == nil then
    for _, sFile in ipairs(BASE_FILES_IN_ORDER) do
        TryInclude(sFile)
        if Initialize ~= nil then
            break
        end
    end
end
if Initialize == nil then
    print("[TsoDTE] base UnitPanel not found; unit panel customisation skipped")
end

-- c. BuilderLagFix：整体替换 GetUnitActionsTable
TryInclude("BuilderLagFix.lua")

-- d. 我们这一层 ---------------------------------------------------------------

local TSOD_BASE_GetUnitActionsTable = GetUnitActionsTable
local TSOD_BATTLE_MAGE_TYPE = "UNIT_TSOD_BATTLE_MAGE"
local TSOD_SCAR_NAME_LOC = "LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME"

-- 只有军队（3 个合成）能施放；施放过的（Kill 未立刻生效时）不再显示
local function TsoDTE_CanCastScar(pUnit)
    return pUnit:GetMilitaryFormation() == MilitaryFormationTypes.ARMY_FORMATION
        and pUnit:GetProperty("TSOD_TYPHON_SCAR_SPENT") == nil
end

function GetUnitActionsTable(pUnit)
    local tActions = TSOD_BASE_GetUnitActionsTable(pUnit)
    if tActions == nil or pUnit == nil then
        return tActions
    end

    local tInfo = GameInfo.Units[pUnit:GetUnitType()]
    local bBattleMage = tInfo ~= nil and tInfo.UnitType == TSOD_BATTLE_MAGE_TYPE
    local bScarAllowed = bBattleMage and TsoDTE_CanCastScar(pUnit)
    local sScarName = Locale.Lookup(TSOD_SCAR_NAME_LOC)

    for sCategory, tEntries in pairs(tActions) do
        if sCategory ~= "displayOrder" and type(tEntries) == "table" then
            -- 倒序删除，索引不乱
            for i = #tEntries, 1, -1 do
                local tEntry = tEntries[i]
                if tEntry.userTag == UnitOperationTypes.WMD_STRIKE then
                    local bIsScar = sScarName ~= ""
                        and tEntry.helpString ~= nil
                        and string.find(tEntry.helpString, sScarName, 1, true) ~= nil
                    local bKeep
                    if bIsScar then
                        bKeep = bScarAllowed
                    else
                        -- 其他核武类武器：战斗法师一律去掉；别的单位不管
                        bKeep = not bBattleMage
                    end
                    if not bKeep then
                        table.remove(tEntries, i)
                    end
                end
            end
        end
    end

    return tActions
end
