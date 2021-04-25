local lu = require('luaunit')

--loadfile('wow_functions.lua')()
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
	local info = LibPet:familyInfo(4)
	lu.assertEquals(info['name'], 'Bear')
end

function test.testPetInfo()
	local info = LibPet:petInfo('Snow Leopard')
	lu.assertEquals(info['npc'], 1201)
	lu.assertEquals(info['family'], 2)
end

function test.testZone()
	local zoneName = LibPet:zoneNameFromId(1)
	lu.assertEquals(zoneName, 'Dun Morogh')
end

function test.testPetSkills()
	local skills = LibPet.petSkills(2731)
	lu.assertEquals(skills, {cower=4, prowl=1})
end


os.exit( lu.LuaUnit.run() )