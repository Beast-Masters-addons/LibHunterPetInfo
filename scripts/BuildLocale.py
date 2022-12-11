import os

from BuildMapData import BuildMapData
from build_utils.utils.tables import WoWTablesCustom as WoWTables
from build_utils.utils.Wowhead import Wowhead


class BuildLocale(Wowhead):
    locales = ['enUS', 'itIT', 'ptBR', 'frFR', 'deDE', 'esES', 'ruRU', 'koKR', 'zhTW', 'zhCN']

    def __init__(self):
        data_folder = os.path.join(os.path.dirname(__file__), '..', 'locale')
        super().__init__(data_folder)

    def pet_families(self, locale):
        families = {}
        tables = WoWTables(locale=locale)
        if locale == 'enUS':
            locale = None
        try:
            table = tables.get_db_table('creaturefamily')
        except RuntimeError as e:
            print('Error %s for locale %s' % (e, locale))
            return
        for row in table:
            families[int(row['ID'])] = row['Name_lang']
        return families

    def pet_foods(self, locale='enUS'):
        url = 'https://wow.zamimg.com/js/locale/live.%s.js' % locale.lower()
        response = self.get(url)
        if response.status_code == 404:
            return
        data_js = self.get_js_variable(response.text, 'g_pet_foods')
        data = self.js_array_to_json('const data = ' + data_js, 'data')
        diet_names = {}
        for key, name in data.items():
            diet_names[int(key)] = name

        return diet_names


if __name__ == '__main__':
    build = BuildLocale()
    diets = {}
    pet_families = {}
    for locale in build.locales:
        pet_families[locale] = build.pet_families(locale)
        diets[locale] = build.pet_foods(locale)
    build.save(diets, 'PetDietLocale')
    build.save(pet_families, 'PetFamilyNames')
