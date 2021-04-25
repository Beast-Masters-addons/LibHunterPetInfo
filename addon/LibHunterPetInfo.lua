_G['PetInfo'] = {}
--PetInfo = {}
_G['LibPet'] = {}
local LibPet = _G['LibPet']

function LibPet.getInfo(_, tableName, key)
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

function LibPet:familyInfo(familyId)
	return self:getInfo('Families', familyId)
end

function LibPet:familyName(familyId)
	return self:familyInfo(familyId)['name']
end

function LibPet:petInfo(beastName)
	return self:getInfo('Pets', beastName)
end

function LibPet:zoneInfo(zoneId)
	return self:getInfo('Zones', zoneId)
end

function LibPet:zoneNameFromId(zoneId)
	return self:zoneInfo(zoneId)['name']
end

function LibPet.petSkills(npcId)
	assert(npcId, 'Missing NPC id')
	local skills = {}
	for skillKey, skill in pairs(_G['PetInfo']['AbilityNPC']) do
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
	return skills
end