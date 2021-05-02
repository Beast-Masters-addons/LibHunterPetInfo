_G['PetSpells'] = {}
local PetSpells = _G['PetSpells']
local LibPet = _G['LibPet']
local utils = _G.LibStub('BM-utils-1', 5)

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
    return LibPet.getInfo('SpellRanks', spellIcon)
end

function PetSpells.getSpellProperties(spellId)
    local properties = LibPet.getInfo('SpellProperties', spellId)
    properties['name'] = _G.GetSpellInfo(properties['id'])
    return properties
end

function PetSpells.getSpellPropertiesByIcon(spellIcon, rank)
    assert(_G['PetSpellRanks'][spellIcon], 'Unknown spell icon: ' .. spellIcon)
    assert(_G['PetSpellRanks'][spellIcon][rank], 'Invalid rank: ' .. rank)
    local spellId = _G['PetSpellRanks'][spellIcon][rank]
    return _G['PetSpellProperties'][spellId]
end

---Get spell from icon and rank
---@param icon string
---@param rank string
---@return string spellId, spellName, GetSpellInfo
function PetSpells.getSpellFromIcon(icon, rank)
    local ranks = PetSpells.getSpellRanks(icon)
    assert(ranks[rank], utils:sprintf('Invalid rank %d', rank))
    local spellName, iconTexture = _G.GetSpellInfo(ranks[rank])
    return ranks[rank], spellName, iconTexture
end

function PetSpells.getSpellIconFromTexture(texture)
    return LibPet.getInfo('SpellIconTextures', texture)
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
            if name~=nil and not iconNames[name] then
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

function PetSpells.learnableByFamily(spellIcon, family)
    local familyInfo = LibPet.familyInfo(family)
    for _, spellId in ipairs(familyInfo['spells']) do
        local icon = PetSpells.getSpellProperties(spellId)['icon']
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

