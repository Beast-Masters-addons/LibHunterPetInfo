_G['CurrentPet'] = {}
local CurrentPet = _G['CurrentPet']
local PetSpells = _G['PetSpells']
local LibPet = _G['LibPet']

---Bitwise AND for Lua 5.1
---https://stackoverflow.com/a/32387452/2630074
---@param a number
---@param b number
local function bitand(a, b)
    local result = 0
    local bitval = 1
    while a > 0 and b > 0 do
        if a % 2 == 1 and b % 2 == 1 then
            -- test the rightmost bits
            result = result + bitval      -- set the current bit
        end
        bitval = bitval * 2 -- shift left
        a = math.floor(a / 2) -- shift right
        b = math.floor(b / 2)
    end
    return result
end

function CurrentPet.info()
    return LibPet.getFamilyInfoFromTexture(_G.GetPetIcon())
end

function CurrentPet.spells()
    local slot = 1
    local petSkills = {}

    while true do
        --local spellIcon = _G.GetSpellBookItemTexture(slot, _G.BOOKTYPE_PET);
        --spellName = _G.GetSpellBookItemName(slot, _G.BOOKTYPE_PET);
        local _, petActionID = _G.GetSpellBookItemInfo(slot, _G.BOOKTYPE_PET)

        if petActionID == nil then
            return petSkills
        end

        local spellId = bitand(petActionID, 0xFFFFFF)
        petSkills[spellId] = PetSpells.getSpellProperties(spellId)

        --petSkills[spellId] = { id = spellId, name = spellName, icon = spellIcon }

        slot = slot + 1
    end
    return petSkills
end