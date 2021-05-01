_G['PetSpells'] = {}
local PetSpells = _G['PetSpells']
local utils = _G.LibStub('BM-utils-1', 5)

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

--/dump PetSkills.getSpellRank(16829)
---Get spell rank and icon
---@param spellId number
function PetSpells.getSpellRank(spellId)
    for icon, ranks in pairs(_G['PetSpellRanks']) do
        print('icon', icon)
        for rank, spellId_check in pairs(ranks) do
            if spellId == spellId_check then
                return rank, icon
            end
        end
    end
end

function PetSpells.getSpellRanks(spellIcon)
    assert(_G['PetSpellRanks'][spellIcon], utils:sprintf('No ranks found for %s', spellIcon))
    return _G['PetSpellRanks'][spellIcon]
end


--/dump LibPet:CurrentPetSpells()
function PetSpells.CurrentPetSpells()
    local slot = 1
    local spellName = ''
    local petSkills = {}

    while spellName do
        local spellIcon = _G.GetSpellBookItemTexture(slot, _G.BOOKTYPE_PET);
        spellName = _G.GetSpellBookItemName(slot, _G.BOOKTYPE_PET);
        local _, petActionID = _G.GetSpellBookItemInfo(slot, _G.BOOKTYPE_PET)
        if petActionID == nil then
            return petSkills
        end

        local spellId = bitand(petActionID, 0xFFFFFF)
        --print('spellName', spellName, 'spellId', spellId)

        petSkills[spellId] = { id = spellId, name = spellName, icon = spellIcon }
        --TODO: Add rank

        slot = slot + 1
    end
    return petSkills
end

--/dump LibPet.petSkillFromIcon('spell_nature_starfall', 2)
function PetSpells.petSkillFromIcon(icon, rank)
    local spellId = _G['PetSpellRanks'][icon][rank]
    return spellId, _G.GetSpellInfo(spellId)
end

function PetSpells.getPetSkillIcon(spellId)
    assert(_G['PetSpellProperties'][spellId], 'No info for spell ' .. spellId)
    return _G['PetSpellProperties'][spellId]['icon']
end

--/dump LibPet.petSkillFromIcon('spell_nature_starfall', 2)
function PetSpells.petSkillFromIcon(icon, rank)
    assert(_G['PetSpellRanks'][icon], 'No spell with icon ' .. icon)
    assert(_G['PetSpellRanks'][icon][rank], 'Invalid rank ' .. rank)
    local spellId = _G['PetSpellRanks'][icon][rank]
    return spellId, _G.GetSpellInfo(spellId)
end

function PetSpells.petSkillFromTexture(texture)
    return _G['PetSpellIconTextures'][texture]
end

function PetSpells.petFamilyFromTexture(texture)
    assert(texture, 'Texture is empty')
    for _, family in pairs(_G['PetFamilies']) do
        if family['icon_texture'] == texture then
            return family
        end
    end
    error('No pet family found with icon texture ' .. texture)
end

--/dump PetSkills.getSkillSource('ability_druid_supriseattack', 1)
function PetSpells.getSkillSource(icon, rank)
    if rank == nil then
        rank = 1
    end
    if _G['PetAbilitySource'][icon] == nil then
        --@debug@
        print('No source information for ' .. icon)
        --@end-debug@
        return
    end
    return _G['PetAbilitySource'][icon][rank]
end

function PetSpells.generateNamesToIcons()
    local iconNames = {}
    for icon, ranks in pairs(_G['PetSpellRanks']) do
        for _, spellId in pairs(ranks) do
            local name = _G.GetSpellInfo(spellId);
            if not iconNames[name] then
                iconNames[name] = icon
            end
        end
    end
    return iconNames
end

function PetSpells.idToName()
    local idNames = {}
    for id, spell in pairs(_G['PetSpellProperties']) do
        if spell['rank'] == 1 or spell['rank'] == nil then
            idNames[spell['name']] = id
        end
    end
    return idNames
end

function PetSpells.spellProperties(spellIcon, rank)
    assert(_G['PetSpellRanks'][spellIcon], 'Unknown spell icon: ' .. spellIcon)
    assert(_G['PetSpellRanks'][spellIcon][rank], 'Invalid rank: ' .. rank)
    local spellId = _G['PetSpellRanks'][spellIcon][rank]
    return _G['PetSpellProperties'][spellId]
end

function PetSpells.spellPropertiesById(spellId)
    return _G['PetSpellProperties'][spellId]
end

function PetSpells.learnableByFamily(spellIcon, family)
    assert(_G['PetFamilies'][family], 'Invalid family ' .. family)
    local familyInfo = _G['PetFamilies'][family]
    for _, spellId in ipairs(familyInfo['spells']) do
        local icon = PetSpells.getPetSkillIcon(spellId)
        if icon == spellIcon then
            return true
        end
    end
    return false
end

function PetSpells.familySkills(family_key)
    assert(_G['PetFamilies'][family_key], 'Invalid family id ' .. family_key)
    local family = _G['PetFamilies'][family_key]
    local spells = {}
    for _, spell in ipairs(family['spells']) do
        --spells:insert(PetSkills.getPetSkillIcon(spell))
        table.insert(spells, PetSpells.getPetSkillIcon(spell))
    end
    return spells
end

