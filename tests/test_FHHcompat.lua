local lu = require('luaunit')

_G['PetInfo'] = {}
loadfile('../scripts/build_utils/utils/load_toc.lua')('../LibHunterPetInfo.toc', { 'BeastLoreEvents.lua' })

_G['test'] = {}
local test = _G['test']
local compat = _G['FHH_compat']

function test.testPetInfo()
    local fhh_info = { f = "Wolf",
                       z = "Duskwood",
                       min = 24,
                       max = 25,
                       bite = 4,
    }

    local info = compat:GetPetInfo("Black Ravager")
    lu.assertEquals(info, fhh_info)
end

function test.testBuildBeastInfo()
    local pets = compat:BuildBeastInfo()
    lu.assertEquals(pets["Agam'ar"], { f = "Boar", z = "Razorfen Kraul", min = 24, max = 25, t = 1, charge = 3, })
    lu.assertEquals(pets["Crag Coyote"], { f = "Wolf", z = "Badlands", min = 35, max = 36, bite = 5, dash = 1, })
    lu.assertEquals(pets["Blisterpaw Hyena"], { f = "Hyena", z = "Tanaris", min = 44, max = 45, dash = 2, })
end

os.exit(lu.LuaUnit.run())