_G['LibPet'] = {}
local LibPet = _G['LibPet']

function LibPet.getInfo(tableName, key)
	if not key then
		error('Invalid key')
	end
	local table = _G['PetInfo'][tableName]
	if not table then
		error(tableName..' is not a valid table name')
	end
	local info = table[key]
	if not info then
		error(key..' is not a valid key in table '..tableName)
	end
	return info
end

function LibPet.familyInfo(familyId)
	return LibPet.getInfo('Families', familyId)
end

function LibPet.familyName(familyId)
	return LibPet.familyInfo(familyId)['name']
end

---petInfo
---@param beastName string
---@deprecated
function LibPet.petInfo(beastName)
	return LibPet.getInfo('Pets', beastName)
end

function LibPet.petProperties(id)
    return LibPet.getInfo('PetProperties', id)
end

function LibPet.getZoneInfo(zoneId)
	return LibPet.getInfo('Zones', zoneId)
end

function LibPet.zoneNameFromId(zoneId)
	--C_Map.GetAreaInfo(areaID)
	return LibPet.zoneInfo(zoneId)['name']
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

function LibPet.getZoneByName(zoneName)
    return LibPet.getInfo('ZonesNameToId', zoneName)
end

function LibPet.petSkills(npcId)
	assert(npcId, 'Missing NPC id')
	local skills = {}
	for skillKey, skill in pairs(_G['PetAbilitySource']) do
		for rankKey, npcList in ipairs(skill) do
			if type(npcList) == 'table' then
				for _, npc in ipairs(npcList) do
					if npc==npcId then
						--print('Skill: '..skillKey, 'Rank: '..rankKey)
						skills[skillKey] = rankKey
					end
				end
			end
		end
	end
    if next(skills) ~= nil then
        return skills
    end
end
