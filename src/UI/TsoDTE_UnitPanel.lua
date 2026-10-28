-- Unit panel: Annihilation Scar appears only in the Battle Mage army state (it filters only the WMD_STRIKE button). Chaining and compatibility approach: see docs/impl-plan.md, WP13 revision.
-- Does not override IsActionLimited (the other mod's UnitPanel does its own filtering there).

local BASE_FILES_IN_ORDER = {
    "UnitPanel_Expansion2.lua",
    "UnitPanel_Expansion1.lua",
    "UnitPanel.lua",
}

-- If the file is missing or errors internally, only one log line is written; the whole panel is not disabled.
local function TryInclude(sFile)
    local bOk, sErr = pcall(include, sFile)
    if not bOk then
        print("[TsoDTE] UnitPanel include failed: " .. sFile .. " : " .. tostring(sErr))
    end
end

-- a. Another mod's UnitPanel replacement, if present (it includes the base panel itself)
TryInclude("UnitPanel_Klee.lua")

-- b. If no such replacement is present, add the base panel, trying the highest expansion version first
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

-- c. BuilderLagFix: replaces GetUnitActionsTable as a whole
TryInclude("BuilderLagFix.lua")

-- d. Our layer. Limit: only one replacement of the same panel script can take effect; if another mod later replaces the unit panel with a higher LoadOrder than this file,
-- our filter is overridden, and only this filter layer is lost (the other weapon buttons reappear); game logic is not affected.

local TSOD_BASE_GetUnitActionsTable = GetUnitActionsTable
local TSOD_BATTLE_MAGE_TYPE = "UNIT_TSOD_BATTLE_MAGE"
local TSOD_SCAR_NAME_LOC = "LOC_WMD_TSOD_ANNIHILATION_SCAR_NAME"

-- Only the army (3 units combined) can fire; a unit that has already fired (while Kill has not taken effect yet) is no longer shown
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
    -- Matches by substring of the localized weapon name, not by suffix matching: when it cannot fire, the reason is appended after the name.
    local sScarName = Locale.Lookup(TSOD_SCAR_NAME_LOC)

    for sCategory, tEntries in pairs(tActions) do
        if sCategory ~= "displayOrder" and type(tEntries) == "table" then
            -- Delete in reverse order so the indices do not shift
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
