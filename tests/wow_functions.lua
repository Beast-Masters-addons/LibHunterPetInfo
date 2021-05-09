_G.BOOKTYPE_PET = "pet"

function _G.GetSpellInfo(spellId)
    if spellId == 17257 then
        return 'Bite', 132278, 0, 0, 0, 17257
    elseif spellId == 24497 then
        return 'Arcane Resistance', 136096, 0, 0, 0, 24497
    end
end

function _G.GetSpellBookItemInfo(index, bookType)
    if bookType == _G.BOOKTYPE_PET then
        if index == 1 then
            return 'PETACTION', 16801709
        elseif index == 2 then
            return 'PETACTION', 2164278121
        end
    end
end

function _G.GetPetIcon()
    return 132184
end

_G.C_Map = {}
function _G.C_Map.GetAreaInfo(areaID)
    if areaID == 1 then
        return 'Dun Morogh'
    elseif areaID == 33 then
        return 'Stranglethorn Vale'
    end
end

function _G.C_Map.GetBestMapForUnit(unit)
    if unit == 'player' then
        return 1434
    end
end
function _G.C_Map.GetMapChildrenInfo() end

function _G.C_Map.GetMapInfo() end

function _G.GetLocale()
    return _G['locale'] or 'enUS'
end

function _G.UnitLevel(unit)
    return _G['playerLevel'] or 34
end