local lu = require('luaunit')

loadfile('wow_functions.lua')()
--loadfile('Util.lua')()
--loadfile('../libs/LibStub/LibStub.lua')()
_G['PetInfo'] = {}
loadfile('../scripts/build_utils/utils/load_toc.lua')('../LibHunterPetInfo.toc', { 'BeastLoreEvents.lua' })

--print(_G['PetInfo']['Pets']['Snow Leopard']['family'])

_G['test'] = {}
local test = _G['test']
local LibPet = _G['LibPet']

--print(_G['PetInfo']['Families'])

function test.testFamilyInfo()
	local info = LibPet.familyInfo(4)
	lu.assertEquals(info['name'], 'Bear')
end

function test.testPetSkills()
	local skills = LibPet.petSkills(2731)
	lu.assertEquals(skills, {ability_druid_cower=4, ability_druid_supriseattack=1})
end

function test.testPetNoSkills()
	local skills = LibPet.petSkills(686)
	lu.assertEquals(skills, nil)
end

function test.testZoneNoPets()
	local pets = LibPet.zonePets(722)
	lu.assertEquals(pets, nil)
end

function test.testGetDiet()
	local diet = LibPet.getDiet(26)
	lu.assertEquals({1}, diet)
end

function test.testGetDietStrings()
	lu.assertEquals({'Meat'}, LibPet.getDietStrings(26))
    _G['locale'] = 'deDE'
    lu.assertEquals({'Fleisch'}, LibPet.getDietStrings(26))
end

os.exit( lu.LuaUnit.run() )