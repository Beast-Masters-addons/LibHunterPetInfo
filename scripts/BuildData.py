import json
import os

from build_utils import build_lua_table


def file_name(name, extension):
    path = os.path.dirname(__file__)
    return '%s/../data/%s.%s' % (path, name, extension)


def save(data, name):
    with open(file_name(name, 'lua'), 'w') as fp:
        fp.write(build_lua_table(data, "_G['%s']" % name))

    with open(file_name(name, 'json'), 'w') as fp:
        json.dump(data, fp)
