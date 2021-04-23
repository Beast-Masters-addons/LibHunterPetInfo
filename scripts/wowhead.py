import json
import os
import re
import requests


def get(url):
    return requests.get(url)


def file(name):
    path = os.path.dirname(__file__)
    return open('%s/../data/%s.lua' % (path, name), 'w')


def clean_json(json_string):
    # Fix unquoted keys
    # json_string = re.sub(r',(\s*)([^"]+?):', r',\1"\2":', json_string)
    json_string = re.sub(r',(\s*)([^"]+?):(\s?(?:\[.+?\]|["a-zA-Z0-9]+))', r',\1"\2":\3', json_string)
    # json = str_replace("'", '',json) # Remove single quotes
    json_string = re.sub(r'/"([0-9]+\],)(pctstack":{)([0-9]+)/', '$1"$2"$3"', json_string)
    return json_string


def get_list_view(response, list_id):
    pattern = r"new Listview.+id: '%s'.+data:\s?(\[.+\])" % list_id
    match = re.search(pattern, response.text)
    if not match:
        raise Exception('No match for ', pattern)
    try:
        return json.loads(clean_json(match[1]))
    except json.decoder.JSONDecodeError as e:
        print(match[1])
        raise e


def build_lua_table(source):
    table = '{\n'
    for key, value in source.items():
        if type(key) == int:
            key = '[%d]' % key

        table += '\t'
        if type(value) == str:
            table += '%s="%s"' % (key, value)
        elif type(value) == int:
            table += '%s=%d' % (key, value)
        elif type(value) == list:
            table += '%s = {' % key
            for item in value:
                if type(item) == str:
                    table += '"%s",' % item
                elif type(item) == int:
                    table += '%d,' % item
                else:
                    raise Exception('Unhandled type: ' + type(item))
            table = table[:-1]
            table += '}'
        elif type(value) == dict:
            table += '%s =\n' % key
            table += build_lua_table(value)
        else:
            raise Exception('Unhandled type: %s' % type(value))

        table += ',\n'
    table += '}'
    return table
