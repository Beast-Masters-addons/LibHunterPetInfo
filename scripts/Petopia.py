import re

from lxml import html as html

from build_utils import WoWBuildUtils


class Petopia(WoWBuildUtils):
    def __init__(self, tbc=False):
        super().__init__()
        if tbc:
            print('Get Petopia TBC')
            self.abilities_url = 'https://www.wow-petopia.com/classic_bc/abilities.php'
        else:
            print('Get Petopia Classic')
            self.abilities_url = 'https://www.wow-petopia.com/classic/abilities.php'

    def spells(self):
        response = self.get(self.abilities_url)
        root = html.fromstring(response.text)

        ability_ranks = {}
        abilities = root.xpath('//ul[@class="abilityranklist classic"]')
        for ability in abilities:
            # header = ability.find('h3[@class="guide_heading classic"]')
            icon = None
            for rank in ability.findall('li'):
                rank_id = rank.get('id')
                matches = re.match(r'([a-z]+)([0-9]+)', rank_id)
                ability_key = matches[1]
                rank_num = int(matches[2])
                if not icon:
                    icon = root.xpath('//h3[@id="%s"]/img' % ability_key)[0].get('src')
                    icon = re.sub(r'.+/(.+)\.png', r'\1', icon)
                if icon == 'ability_druid_ferociousbite':
                    icon = 'ability_racial_cannibalize'

                # print('Rank key: %s Rank num: %d' % (ability_key, rank_num))
                if icon not in ability_ranks:
                    ability_ranks[icon] = {}
                ability_ranks[icon][rank_num] = []

                ul = rank.find('ul[@class="abilityranknpclist classic"]')
                if ul is None:  # Trainer?
                    header = rank.find('span[@class="abilitysourceheading classic"]')
                    if header.text == 'Can be learned from trainers.':
                        ability_ranks[icon][rank_num] = 'trainer'
                    elif header.text == 'No known training source.':
                        ability_ranks[icon][rank_num] = 'unknown'
                    else:
                        raise ValueError('Invalid status: ' + header.text)
                    continue

                for npc in ul.findall('li'):
                    npc_link = npc.find('a').get('href')
                    matches = re.search(r'npc=([0-9]+)', npc_link)
                    npc_id = int(matches[1])
                    ability_ranks[icon][rank_num].append(npc_id)
        return ability_ranks


def parse_petopia():
    file = open('Petopia BC Classic_ Pet Family Abilities.html', 'r')
    root = html.fromstring(file.read())

    ranks = {}
    abilities = root.xpath('//ul[@class="abilityranklist classic"]')
    for ability in abilities:
        for rank in ability.findall('li'):
            rank_id = rank.get('id')
            matches = re.match(r'([a-z]+)([0-9]+)', rank_id)
            rank_key = matches[1]
            rank_num = int(matches[2])
            # print('Rank key: %s Rank num: %d' % (rank_key, rank_num))
            if rank_key not in ranks:
                ranks[rank_key] = {}
            ranks[rank_key][rank_num] = []
            # ranks[rank_key].append([])

            ul = rank.find('ul[@class="abilityranknpclist classic"]')
            if ul is None:  # Trainer?
                header = rank.find('span[@class="abilitysourceheading classic"]')
                # if header.text == 'Can be learned from trainers.':
                ranks[rank_key][rank_num] = header.text
                # ranks[rank_key].append(header.text)
                # print(header.text)
                continue
            # else:
            #    ranks[rank_key].append([])

            for npc in ul.findall('li'):
                npc_link = npc.find('a').get('href')
                matches = re.search(r'npc=([0-9]+)', npc_link)
                npc_id = int(matches[1])
                # print(npc_id)
                ranks[rank_key][rank_num].append(npc_id)
                # ranks[rank_key].append(npc_id)

                # print('class', npc.get('class'))
    return ranks


def parse_skill_names(file_name='Petopia Classic_ Pet Family Abilities.html'):
    file = open(file_name, 'r')
    root = html.fromstring(file.read())
    headers = root.xpath('.//h4[@class="guide_index_heading classic"]')

    skills = {}
    for header in headers:
        header_text = header.text.strip()
        if header_text == 'Learned from wild creatures:':
            source = 'wild'
        else:
            source = 'trainer'

        for skill in header.find('ul').findall('li'):
            skill_key = skill.xpath('a/@href')[0]
            skill_key = skill_key[1:]
            skill_name = str(skill.xpath('a/text()')[0])
            print('Key: %s Name: %s' % (skill_key, skill_name))
            skills[skill_key] = {'key': skill_key, 'name': skill_name, 'source': source}

    return skills
