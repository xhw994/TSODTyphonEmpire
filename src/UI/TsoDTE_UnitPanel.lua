-- 单位面板：湮灭之创只在战斗法师的军队状态下出现（只过滤 WMD_STRIKE 按钮）。接力链与兼容写法见 docs/impl-plan.md WP13 修订。
-- 不覆盖 IsActionLimited（可莉 mod 在那里做它自己的过滤）。

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

-- d. 我们这一层。限度：同一个面板脚本只能有一个替换生效；以后若有别的 mod 替换单位面板且 LoadOrder 比本文件大，
-- 我们的过滤会被顶掉，损失的只是这层过滤（其他武器按钮重新出现），游戏逻辑不受影响。

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
    -- 按武器本地化名做子串匹配，不用「末尾」匹配：不能发射时，失败原因会追加在名字后面。
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
