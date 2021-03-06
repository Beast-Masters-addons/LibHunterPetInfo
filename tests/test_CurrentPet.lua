local lu = require('luaunit')
loadfile('wow_functions.lua')()
loadfile('../scripts/build_utils/utils/load_toc.lua')('../LibHunterPetInfo.toc', { 'BeastLoreEvents.lua' })

_G['test'] = {}
local test = _G['test']
local CurrentPet = _G['CurrentPet']

function test.testInfo()
    local familyInfo = CurrentPet.info()
    lu.assertEquals(familyInfo['icon'], 'ability_hunter_pet_boar')
    lu.assertEquals(familyInfo['id'], 5)
end

function test.testSpells()
    local spells = CurrentPet.spells()
    local spell = spells[17257]
    lu.assertEquals(spell['name'], 'Bite')
    lu.assertEquals(spell['rank'], 4)
    lu.assertEquals(spell['id'], 17257)
end

os.exit(lu.LuaUnit.run())