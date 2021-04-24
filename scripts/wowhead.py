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
    json_string = re.sub(r',(\s*)([^"]+?):(\s?(?:\[.+?]|["a-zA-Z0-9]+))', r',\1"\2":\3', json_string)
    # Pattern matches too much when two keys missing quotes
    json_string = re.sub(r',(\s*)([^"]+?):(\s?(?:\[.+?]|["a-zA-Z0-9]+))', r',\1"\2":\3', json_string)
    # json = str_replace("'", '',json) # Remove single quotes
    json_string = re.sub(r'/"([0-9]+],)(pctstack":{)([0-9]+)/', '$1"$2"$3"', json_string)
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


