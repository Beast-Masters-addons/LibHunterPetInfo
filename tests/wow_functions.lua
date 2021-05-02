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