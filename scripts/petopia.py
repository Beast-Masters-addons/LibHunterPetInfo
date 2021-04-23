import re

from lxml import html as html


def parse_petopia():
    file = open('Petopia Classic_ Pet Family Abilities.html', 'r')
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
