_G['FHH_compat'] = {}

local FHH_compat = _G['FHH_compat']
local LibPet = _G['LibPet']

function FHH_compat.GetPetInfo(_, petName)
	local pet = LibPet:petInfo(petName)
	local family = LibPet:familyName(pet['family'])
	local zone = LibPet:zoneNameFromId(pet['location'])
	local skills = LibPet:petSkills(pet['npc'])

	local info = {f=family, z=zone, min=pet['min'], max=pet['max']}
	for skill, rank in pairs(skills) do
		info[skill] = rank
	end
	if pet['classification'] == 1 then --Elite
		info['t'] = 1
	elseif pet['classification'] == 4 then --Rare
		info['t'] = 2
	elseif pet['classification'] == 2 then --Rare Elite
		info['t'] = 3
	end

	return info
end

function FHH_compat:BuildBeastInfo()
	local pets = {}
	for petName, _ in pairs(_G['PetInfo']['Pets']) do
		pets[petName] = self:GetPetInfo(petName)
	end
	return pets
end