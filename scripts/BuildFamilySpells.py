import os

from Petopia import Petopia

build = Petopia(os.getenv('GAME_VERSION') == 'bcc')

families = build.families()
family_spells = {}

for family in families:
    family_icon, spell_list = build.family_spells(family)
    family_spells[family_icon] = spell_list

build.save(family_spells, 'PetFamilySpells')
