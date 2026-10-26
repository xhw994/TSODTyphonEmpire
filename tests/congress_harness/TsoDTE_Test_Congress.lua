-- 测试开关：世界议会的候选只留神权理事会和一个别的决议（议会每次抽两个），有已创立的宗教就必出现神权理事会；只在测试时启用。
-- 没有宗教时主 mod 的 Scripts/TsoDTE_Congress.lua 会把神权理事会拿掉，这里只剩一个别的决议。

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
