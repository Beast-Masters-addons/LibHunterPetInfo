import sys

import BuildData
import wowhead

try:
    response = wowhead.get('https://%s.wowhead.com/hunter-pets' % sys.argv[1])
except IndexError:
    response = wowhead.get('https://classic.wowhead.com/hunter-pets')
families = wowhead.get_list_view(response, 'pets')

family_ids = []
pet_spells = []

data_dict = {}
for family in families:
    del family['popularity']
    pet_spells.append(family['spells'])
    family_ids.append(family['id'])
    data_dict[family['id']] = family

BuildData.save(data_dict, 'PetFamilies')
