from pathlib import Path

from build_utils.utils.Wowhead import Wowhead
from build_utils.utils.tables import WoWTables


class BuildLocale(Wowhead):
    locales = ['enUS', 'itIT', 'ptBR', 'frFR', 'deDE', 'esES', 'ruRU', 'koKR', 'zhTW', 'zhCN']

    def __init__(self):
        super().__init__()
        self.tables = WoWTables()

    def pet_families(self, locale_arg: str):
        table = self.tables.get_db_table('creaturefamily', locale_arg)
        families = {int(row['ID']): row['Name_lang'] for row in table}

        return families

    def pet_foods(self, locale_arg: str):
        table = self.tables.get_db_table('ItemPetFood', locale_arg)
        diet_names = {int(row['ID']): row['Name_lang'] for row in table}

        return diet_names


if __name__ == '__main__':
    build = BuildLocale()
    diets = {}
    pet_families = {}
    data_path = Path(__file__).parent.parent.joinpath('data', build.game_version)
    data_path.mkdir(parents=True, exist_ok=True)
    build.data_folder = str(data_path)

    for locale in build.locales:
        pet_families[locale] = build.pet_families(locale)
        diets[locale] = build.pet_foods(locale)
    build.save(diets, 'PetDietLocale')
    build.save(pet_families, 'PetFamilyNames')
