-- Test switch: the World Congress candidates keep only Theocratic Council and one other resolution (Congress draws two each time), so Theocratic Council always appears once a religion is founded; enable only for testing.
-- With no religion, the main mod's Scripts/TsoDTE_Congress.lua removes Theocratic Council, leaving only the other resolution here.

local RESOLUTION_TYPE = 'WC_RES_TSOD_THEOCRATIC_COUNCIL'

local function OnCanUseResolutions(resolutions)
    local tRow = GameInfo.Resolutions[RESOLUTION_TYPE]
    if tRow == nil then
        return
    end
    local bHasOurs = false
    local hOther = nil
    for _, hResolution in ipairs(resolutions.Resolutions) do
        if hResolution == tRow.Hash then
            bHasOurs = true
        elseif hOther == nil then
            hOther = hResolution
        end
    end
    local tKeep = {}
    if bHasOurs then
        table.insert(tKeep, tRow.Hash)
    end
    if hOther ~= nil then
        table.insert(tKeep, hOther)
    end
    resolutions.Resolutions = tKeep
    print('[TsoDTE test] congress pool narrowed to ' .. #tKeep .. ' resolution(s), theocratic council ' .. tostring(bHasOurs))
end

GameEvents.CanUseResolutions.Add(OnCanUseResolutions)
print('[TsoDTE test] congress harness loaded')
