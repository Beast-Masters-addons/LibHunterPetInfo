---Most map related functions in WoW work with uiMapId which is different from the zone id used on Wowhead
---This is a library to help with that

_G['ZoneInfo'] = {}
local ZoneInfo = _G['ZoneInfo']
local LibPet = _G['LibPet']

function ZoneInfo.getZoneInfo(zoneId)
    return LibPet.getInfo('Zones', zoneId)
end

function ZoneInfo.getZoneId(mapId)
    return LibPet.getInfo('MapToZone', mapId)
end

function ZoneInfo.getCurrentZoneId()
    local mapId = _G.C_Map.GetBestMapForUnit("player")
    return ZoneInfo.getZoneId(mapId)
end

function ZoneInfo.getZoneName(zoneId)
    return _G.C_Map.GetAreaInfo(zoneId)
end