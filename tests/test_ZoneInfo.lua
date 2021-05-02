local lu = require('luaunit')
loadfile('wow_functions.lua')()
loadfile('../scripts/build_utils/utils/load_toc.lua')('../LibHunterPetInfo.toc', { 'BeastLoreEvents.lua' })

_G['test'] = {}
local test = _G['test']
local ZoneInfo = _G['ZoneInfo']

function test.testGetZoneInfo()
    local info = ZoneInfo.getZoneInfo(33)
    lu.assertEquals(info['name'], 'Stranglethorn Vale')
    local info2 = ZoneInfo.getZoneInfo(1)
    lu.assertEquals(info2['name'], 'Dun Morogh')
end

function test.testGetZoneId()
    local zoneId = ZoneInfo.getZoneId(1433)
    lu.assertEquals(zoneId, 44)
end

function test.testGetCurrentZoneId()
    local zoneId = ZoneInfo.getCurrentZoneId()
    lu.assertEquals(zoneId, 33)
end

function test.testGetZoneName()
    local name = ZoneInfo.getZoneName(33)
    lu.assertEquals(name, 'Stranglethorn Vale')
end

os.exit(lu.LuaUnit.run())