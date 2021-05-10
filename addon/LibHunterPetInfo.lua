_G['LibPet'] = {}
local LibPet = _G['LibPet']
LibPet.version = '@project-version@'
LibPet.utils = _G['BMUtils']
LibPet.utils = _G.LibStub("BM-utils-1")
LibPet.tables = _G['PetInfo']

function LibPet.getInfo(tableName, key, allow_missing)
	assert(type(key) ~= 'table', 'Key is table')
	if not key then
        error('Empty key, table ' .. tableName)
	end
	local table = LibPet.tables[tableName]
	if not table then
		error(tableName..' is not a valid table name')
	end
	local info = table[key]
	if not info and not allow_missing then
		error(key..' is not a valid key in table '..tableName)
	end
	return info
end

function LibPet.getFamilyNames()
    return _G.LocalizedTables.getTable('PetFamilyNames')
end

function LibPet.familyInfo(familyId)
	return LibPet.getInfo('Families', familyId)
end

function LibPet.familyName(familyId)
	return LibPet.familyInfo(familyId)['name']
end

function LibPet.getLocalizedFamilyName(familyId)
    return _G.LocalizedTables.getValue('PetFamilyNames', familyId)
end

function LibPet.getDiet(familyId)
    return LibPet.familyInfo(familyId)['diet']
end

function LibPet.getDietStrings(familyId)
    local locale = _G.GetLocale()
    local strings
    if _G.PetDietLocale[locale] == nil then
        --@debug@
        print(('No strings for %s found, falling back to enUS'):format(locale))
        --@end-debug@
        strings = _G.PetDietLocale['enUS']
    else
        strings = _G.PetDietLocale[locale]
    end

    local diets = LibPet.getDiet(familyId)
    local dietStrings = {}
    for _, diet_id in ipairs(diets) do
        table.insert(dietStrings, strings[diet_id])
    end
    return dietStrings
end

function LibPet.getFamilyInfoFromTexture(texture)
	assert(texture, 'Texture is empty')
	for _, family in pairs(_G['PetFamilies']) do
		if family['icon_texture'] == texture then
			return family
		end
	end
	error('No pet family found with icon texture ' .. texture)
end

function LibPet.petProperties(id)
    return LibPet.getInfo('PetProperties', id, true)
end

function LibPet.zonePets(zoneId)
    local pets = {}
    for petId, petInfo in pairs(_G['PetProperties']) do
        for _, location in ipairs(petInfo['location']) do
            if location == zoneId then
                table.insert(pets, petId, petInfo)
            end
        end
    end
    if next(pets) ~= nil then
        return pets
    end
end

--/dump _G['LibPet'].petSkills(683)
function LibPet.petSkills(npcId)
	assert(npcId, 'Missing NPC id')
	local skills = {}
	for spellIcon, skill in pairs(LibPet.tables['AbilitySource']) do
		for rankKey, npcList in ipairs(skill) do
			if type(npcList) == 'table' then
				for _, npc in ipairs(npcList) do
					if npc==npcId then
						--print('Skill: '..skillKey, 'Rank: '..rankKey)
						skills[spellIcon] = rankKey
					end
				end
			end
		end
	end
    if next(skills) ~= nil then
        return skills
    end
end

function LibPet.levelRange(low, high, check)
    if check and low > check then
        low = LibPet.utils:colorize(low, 0xff, 0x20, 0x20)
    end
    if high and high~=low then
        if check and high > check then
            high = LibPet.utils:colorize(high, 0xff, 0x20, 0x20)
        end
        return LibPet.utils:sprintf('%s-%s', low, high)
    else
        return low
    end
end

function LibPet.getClassificationString(classification)
    if (classification == 1) then
        -- Elite
        return _G.ELITE
    elseif (classification == 4) then
        -- Rare
        return _G.ITEM_QUALITY3_DESC
    elseif (classification == 2) then
        -- Rare Elite
        return _G.ITEM_QUALITY3_DESC .. ' ' .. _G.ELITE
    end
end

function LibPet.getClassificationDecoration(classification)
    if (classification == 1) then
        -- Elite
        return "Interface\\DialogFrame\\UI-DialogBox-Gold-Dragon"
    elseif (classification == 4) then
        -- Rare
        return "Interface\\AddOns\\GFW_HuntersHelperUI\\Rare"
    elseif (classification == 2) then
        -- Rare Elite
        return "Interface\\AddOns\\GFW_HuntersHelperUI\\Rare-Elite"
    end
end

function LibPet.petLevelString(petInfo)
	local range = ''
	if petInfo['minlevel'] ~= nil then
		range = LibPet.levelRange(petInfo['minlevel'], petInfo['maxlevel'], _G.UnitLevel("player"))
	end

	local classification = ''
    if petInfo['classification'] > 0 then
        classification = LibPet.getClassificationString(petInfo['classification'])
    end

	if classification ~= '' and range ~= '' then
		return LibPet.utils:sprintf('%s (%s %s)', petInfo['name'], range, classification)
	elseif (range or classification) ~= '' then
		return LibPet.utils:sprintf('%s (%s)', petInfo['name'], range or classification)
	else
		return petInfo['name']
	end
end