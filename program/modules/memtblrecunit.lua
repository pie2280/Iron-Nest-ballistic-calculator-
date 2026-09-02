local ram = require('ram')
local posdatamanager = require('posdatamanager')
local function ramoverride()
    local err = ram.cleardata()
    if err==0 then
        posdatamanager.reinit()
        return "ramoverride",0
    end
end

return {ramoverride=ramoverride}