import json
import os
import re

from Petopia import Petopia
from build_utils.utils.Wowhead import Wowhead


class BuildPetData(Wowhead):
    def __init__(self):
        data_folder = os.path.join(os.path.dirname(__file__), '..', 'data', os.getenv('GAME_VERSION'))
        super(BuildPetData, self).__init__(data_folder)
        self.petopia = Petopia()

    def families(self):
        textures = self.art_textures()
        response = self.query(uri='/hunter-pets')
        families = self.get_list_view(response, 'pets')

        family_ids = []

        data_dict = {}
        for family in families:
            del family['popularity']
            del family['spells']
            family_ids.append(family['id'])
            try:
                family['icon_texture'] = textures[family['icon']]
            except KeyError:
                family['icon_texture'] = textures[family['icon'].replace('-', ' ')]
            data_dict[family['id']] = family
            diets = []
            for diet in [1, 2, 4, 8, 16, 32, 64, 128]:
                if family['diet'] & diet:
                    diets.append(diet)
            family['diet'] = diets

        return data_dict

    def passive_spells(self):
        response = self.query(uri='/spells/pet-abilities/hunter?filter=50;1;0')
        matches = re.search(r'WH\.Gatherer\.addData\(.+?({.+})\);', response.text)
        spells = json.loads(matches.group(1))
        spell_list = []
        for spell_id, spell in spells.items():
            if spell['icon'] not in spell_list:
                spell_list.append(spell['icon'])
        return spell_list

    def spell_properties(self):
        passive_spells = self.passive_spells()
        response = self.query(uri='/spells/pet-abilities/hunter')

        properties = {}
        spell_icon_textures = {}

        spells = self.get_gatherer_data(response)
        textures = self.art_textures()
        spell_sources = self.petopia.spells()

        for spell in self.get_list_data(response, 'listviewspells'):
            # if 'chrclass' in spell:
            #     if spell['chrclass'] != 4:
            #         continue
            #     del spell['chrclass']
            del spell['popularity']

            if 'rank' in spell:
                matches = re.match(r'\w+\s([0-9]+)', spell['rank'])
                if not matches:
                    # Wowhead has no rank data for avoidance, check id and add here
                    if spell['id'] == 35694:
                        spell['rank'] = 1
                    elif spell['id'] == 35698:
                        spell['rank'] = 2
                    else:
                        continue
                else:
                    spell['rank'] = int(matches.group(1))
            spell['icon'] = spells[str(spell['id'])]['icon']
            if spell['icon'] in textures:
                spell['icon_texture'] = textures[spell['icon']]
            else:
                print('Texture for icon %s not found' % spell['icon'])
                spell['icon_texture'] = None

            spell['passive'] = spell['icon'] in passive_spells
            try:
                spell['source'] = spell_sources[spell['icon']][spell['rank']]
            except KeyError as e:
                # print('Invalid key:', e)
                pass

            properties[spell['id']] = spell
            if spell['icon_texture']:
                spell_icon_textures[spell['icon_texture']] = spell['icon']

        return properties, spell_icon_textures, spell_sources

    def spell_ranks(self, valid_ids):
        response = self.query(uri='/spells/pet-abilities/hunter')
        spells = self.get_gatherer_data(response)
        ranks = {}

        for spell_id, spell in spells.items():
            spell_id = int(spell_id)
            if spell_id not in valid_ids:
                continue

            icon = spell['icon']
            rank_key = 'rank_enus'

            if spell[rank_key] == '':
                rank = 1
            else:
                matches = re.match(r'\w+\s([0-9]+)', spell[rank_key])
                if not matches:
                    # Wowhead has no rank data for avoidance, check id and add here
                    if spell_id == 35694:
                        rank = 1
                    elif spell_id == 35698:
                        rank = 2
                    else:
                        continue
                else:
                    rank = int(matches.group(1))

            if icon not in ranks:
                ranks[icon] = {}

            ranks[icon][rank] = spell_id
        return ranks

    def pet_properties(self):
        with open(self.file_name('PetFamilies', 'json')) as fp:
            families = json.load(fp)
        pets = {}
        family_members = {}
        for family in families.keys():
            family = int(family)
            response = self.query(uri='/pet=%d' % family)
            data = self.get_list_view(response, 'tameable')
            for npc in data:
                if 'location' not in npc:
                    continue
                pets[npc['id']] = npc
                if family not in family_members:
                    family_members[family] = []
                family_members[family].append(npc['id'])
        return pets, family_members

    def zones(self):
        response = self.query(uri='/zones')
        zones = self.get_json_listview(response, 'zones')
        zones_out = {}
        zones_name_to_id = {}
        for zone in zones:
            del zone['popularity']
            zones_out[zone['id']] = zone
            zones_name_to_id[zone['name']] = zone['id']
        return zones_out, zones_name_to_id


if __name__ == "__main__":
    build = BuildPetData()
    if not os.path.exists(build.data_folder):
        os.mkdir(build.data_folder)

    build.save(build.families(), 'PetFamilies')

    spell_properties, icon_textures, sources = build.spell_properties()
    build.save(spell_properties, 'PetSpellProperties')
    build.save(icon_textures, 'PetSpellIconTextures')

    build.save(sources, 'PetAbilitySource')
    build.save(build.spell_ranks(list(spell_properties.keys())), 'PetSpellRanks')

    pet_properties, pet_family_members = build.pet_properties()
    build.save(pet_properties, 'PetProperties')
    build.save(pet_family_members, 'PetFamilyMembers')

    zone_info, zone_name_to_id = build.zones()
    build.save(zone_info, 'ZoneData')
    build.save(zone_name_to_id, 'ZonesNameToId')
