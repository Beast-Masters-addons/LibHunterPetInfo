_G['CurrentPet'] = {}
local CurrentPet = _G['CurrentPet']

function CurrentPet.info()
    return _G['PetSkills'].petFamilyFromTexture(_G.GetPetIcon())
end