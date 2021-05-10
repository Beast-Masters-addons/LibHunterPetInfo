local lu = require('luaunit')
loadfile('wow_functions.lua')()
loadfile('../scripts/build_utils/utils/load_toc.lua')('../LibHunterPetInfo.toc', { 'BeastLoreEvents.lua' })

_G['test'] = {}
local test = _G['test']
local PetSpells = _G['PetSpells']

function test.testGetSpellRank()
    local rank, icon = PetSpells.getSpellRank(16829)
    lu.assertEquals(rank, 3)
    lu.assertEquals(icon, 'ability_druid_rake')
end

function test.testGetSpellRanks()
    local ranks = PetSpells.getSpellRanks('ability_druid_rake')
    lu.assertEquals(ranks[2], 16828)
end

function test.testGetSpellProperties()
    local spell = PetSpells.getSpellProperties(24497)
    lu.assertEquals(spell['icon'], 'spell_nature_starfall')
    lu.assertEquals(spell['rank'], 2)
end

function test.testGetSpellPropertiesByIcon()
    local spell = PetSpells.getSpellPropertiesByIcon('spell_nature_starfall', 2)
    lu.assertEquals(spell['icon'], 'spell_nature_starfall')
    lu.assertEquals(spell['rank'], 2)
    lu.assertEquals(spell['id'], 24497)
end

function test.testGetSpellFromIcon()
    local spellId, spellName, iconTexture = PetSpells.getSpellFromIcon('spell_nature_starfall', 2)
    lu.assertEquals(spellId, 24497)
    lu.assertEquals(spellName, 'Arcane Resistance')
    lu.assertEquals(iconTexture, 136096)
end

function test.testGetSpellIconFromTexture()
    local spellIcon = PetSpells.getSpellIconFromTexture(136096)
    lu.assertEquals(spellIcon, 'spell_nature_starfall')
end

function test.testGetSkillSource()
    local source = PetSpells.getSkillSource('ability_druid_supriseattack', 1)
    lu.assertEquals(source, { 2406, 2731, 684, 768 })
end

function test.testGenerateNamesToIcons()
    local iconNames = PetSpells.generateNamesToIcons()
    lu.assertEquals(iconNames['Bite'], 'ability_racial_cannibalize')
end

function test.testIdToName()
    local idNames = PetSpells.idToName()
    lu.assertEquals(idNames['Bite'], 17253)
end

function test.testLearnableByFamily()
    local status = PetSpells.learnableByFamily('ability_druid_rake', 4)
    lu.assertEquals(status, true)
    local status2 = PetSpells.learnableByFamily('ability_druid_rake', 3)
    lu.assertEquals(status2, false)
end

function test.testLearnableByFamilies()
    local families = PetSpells.learnableByFamilies('inv_weapon_shortblade_28')
    lu.assertEquals(families, { 31, 5 })
end

function test.testGetFamilySpells()
    local spells = PetSpells.getFamilySpells(5)
    lu.assertEquals(spells[2]['id'], 23110)
    lu.assertEquals(spells[2]['icon'], 'ability_druid_dash')

--[[    local spells2 = PetSpells.getFamilySpells(4)
    lu.assertEquals(spells2[2]['id'], 27049)
    lu.assertEquals(spells2[2]['icon'], 'ability_druid_rake')]]
end

os.exit(lu.LuaUnit.run())