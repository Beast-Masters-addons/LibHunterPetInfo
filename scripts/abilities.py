import wowhead
from petopia import parse_petopia, parse_skill_names

ranks = parse_petopia()

# pprint(ranks['scorpidpoison'])

file = wowhead.file('AbilityNPC')

table = "_G['PetInfo']['AbilityNPC'] = \n"
table += wowhead.build_lua_table(ranks)
# table += '\n}'
file.write(table)

file.write('\n')

table = "_G['PetInfo']['AbilityInfo'] = \n"
table += wowhead.build_lua_table(parse_skill_names())
file.write(table)

file.close()
