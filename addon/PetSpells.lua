_G['PetSpells'] = {}
local PetSpells = _G['PetSpells']
local LibPet = _G['LibPet']
local utils = _G.LibStub('BM-utils-1', 5)

--/dump PetSkills.getSpellRank(16829)
---Get spell rank and icon
---@param spellId number
function PetSpells.getSpellRank(spellId)
    for icon, ranks in pairs(LibPet.tables['SpellRanks']) do
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
    local localizedName = _G.GetSpellInfo(properties['id'])
    if localizedName ~= nil then
        properties['name'] = localizedName
    end
    return properties
end

function PetSpells.getSpellPropertiesByIcon(spellIcon, rank)
    local ranks = LibPet.tables['SpellRanks']
    assert(ranks[spellIcon], 'Unknown spell icon: ' .. spellIcon)
    assert(ranks[spellIcon][rank], ('Invalid rank %d for spell %s'):format(rank or 0, spellIcon))
    local spellId = ranks[spellIcon][rank]
    return PetSpells.getSpellProperties(spellId)
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
    if LibPet.tables['AbilitySource'][icon] == nil then
        --@debug@
        print('No source information for ' .. icon)
        --@end-debug@
        return
    end
    return LibPet.tables['AbilitySource'][icon][rank]
end

function PetSpells.generateNamesToIcons()
    local iconNames = {}
    for icon, ranks in pairs(LibPet.getTable('SpellRanks')) do
        for _, spellId in pairs(ranks) do
            local name = _G.GetSpellInfo(spellId);
            if name ~= nil and not iconNames[name] then
                iconNames[name] = icon
            end
        end
    end
    return iconNames
end

function PetSpells.idToName(localize)
    local idNames = {}
    for id, spell in pairs(LibPet.getTable('SpellProperties')) do
        if spell['rank'] == 1 or spell['rank'] == nil then
            if localize then
                local name = _G.GetSpellInfo(id)
                if name == nil then
                    LibPet.utils:error('Name not found for spell with id ' .. id)
                    idNames[spell['name']] = id
                else
                    idNames[name] = id
                end
            else
                idNames[spell['name']] = id
            end
        end
    end
    return idNames
end

---Check if the given spell is learnable by the given family
---@param spellIcon string
---@param family number
function PetSpells.learnableByFamily(spellIcon, family)
    local familyInfo = LibPet.familyInfo(family)
    for _, icon in ipairs(familyInfo['spells']) do
        if icon == spellIcon then
            return true
        end
    end
    return false
end

function PetSpells.learnableByFamilies(spellIcon)
    local families = {}
    for familyIcon, familySpells in pairs(LibPet.tables['FamilySpells']) do
        local familyInfo = LibPet.getFamilyInfoFromIcon(familyIcon)
        for _, spellIcon_check in ipairs(familySpells) do
            local spellInfo = PetSpells.getSpellPropertiesByIcon(spellIcon_check, 1)
            if spellInfo['icon'] == spellIcon then
                table.insert(families, familyInfo['id'])
                break
            end
        end
    end
    return families
end

function PetSpells.getFamilySpells(familyId)
    local familyInfo = LibPet.familyInfo(familyId)
    local spells = {}
    for _, spell in ipairs(familyInfo['spells']) do
        table.insert(spells, PetSpells.getSpellPropertiesByIcon(spell, 1))
    end
    return spells
end

--/dump PetSpells.getPetsWithSpell(1754, 33)
function PetSpells.getPetsWithSpell(spellId, zone)
    assert(spellId>0, 'spellId is zero')
    assert(zone>0, 'zone is zero')
    --utils:printf('Get pets with spell %d in zone %d', spellId, zone)
    local spell = PetSpells.getSpellProperties(spellId)
    if spell['source'] == nil then
        print('No source for spellId ' .. spellId)
        return {}
    end
    if type(spell['source']) ~= 'table' then
        utils:printf('%s source is %s', spellId, spell['source'])
        --return spell['source']
        return {}
    end

    assert(spell, 'No info found for spellId ' .. spellId)
    local pets = {}
    if zone == nil then
        for _, petId in ipairs(spell['source']) do
            table.insert(pets, LibPet.petProperties(petId))
        end
    else
        for _, petId in ipairs(spell['source']) do
            local petInfo = LibPet.petProperties(petId)
            if petInfo ~= nil then
                for _, zone_check in ipairs(petInfo['location']) do
                    if zone_check == zone then
                        table.insert(pets, petInfo)
                    end
                end
            end
        end
    end
    return pets
end

--/dump PetSpells.getKnownSpells()
function PetSpells.getKnownSpells()
    if (not _G.CraftFrame or not _G.CraftFrame:IsVisible()) then
        --@debug@
        print('CraftFrame is not active')
        --@end-debug@
        return
    end
    local numCrafts = _G.GetNumCrafts();

    local spells = {}

    for craftIndex = 1, numCrafts do
        local craftName, rankText, craftType, _, _, trainingPointCost, requiredLevel = _G.GetCraftInfo(craftIndex);
        local rankNum
        if rankText then
            _, _, rankNum = string.find(rankText, "(%d+)");
            if (rankNum and tonumber(rankNum)) then
                rankNum = tonumber(rankNum)
            else
                --@debug@
                print(('Unable to parse rank text %s for %s'):format(rankText, craftName))
                --@end-debug@
                rankNum = 1
            end
        else
            --@debug@
            print(('%s has no rank'):format(craftName))
            --@end-debug@
            rankNum = 1
        end

        local spellIcon = PetSpells.getSpellIconFromTexture(_G.GetCraftIcon(craftIndex))
        if spells[spellIcon] == nil then
            spells[spellIcon] = {}
        end

        spells[spellIcon][rankNum] = {
            ['spellIcon'] = spellIcon,
            ['rankNum'] = rankNum,
            ['spellname'] = craftName,
            ['petKnows'] = craftType == 'used',
            ['requiredLevel'] = requiredLevel,
            ['trainingPointCost'] = trainingPointCost,
            ['craftIndex'] = craftIndex
        }
    end
    return spells
end