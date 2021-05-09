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

function test.testPetLevelString()
	_G.ELITE = 'Elite'
	_G.ITEM_QUALITY3_DESC = 'Rare'

	lu.assertEquals('Highland Thrasher (34)', LibPet.petLevelString(LibPet.petProperties(2560)))
	lu.assertEquals('Roc (|cffff202041|r-|cffff202043|r)', LibPet.petLevelString(LibPet.petProperties(5428)))
	lu.assertEquals('Greater Firebird', LibPet.petLevelString(LibPet.petProperties(8207)))
	lu.assertEquals('Zaricotl (|cffff20209999|r-|cffff20209999|r Rare Elite)', LibPet.petLevelString(LibPet.petProperties(2931)))
end

os.exit( lu.LuaUnit.run() )