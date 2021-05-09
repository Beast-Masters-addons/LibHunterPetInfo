import os

from build_utils.utils.Wowhead import Wowhead


class BuildLocale(Wowhead):
    locales = ['enUS', 'itIT', 'ptBR', 'frFR', 'deDE', 'esES', 'ruRU', 'koKR', 'zhTW', 'zhCN']

    def __init__(self):
        data_folder = os.path.join(os.path.dirname(__file__), '..', 'locale')
        super().__init__(data_folder)

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
    for locale in build.locales:
        diets[locale] = build.pet_foods(locale)
    build.save(diets, 'PetDietLocale')
