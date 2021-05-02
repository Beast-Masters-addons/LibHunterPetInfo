import os

from build_utils import WoWBuildUtils
import csv


class BuildMapData(WoWBuildUtils):
    def __init__(self):
        data_folder = os.path.join(os.path.dirname(__file__), '..', 'data')
        super().__init__(data_folder)

    def get_db_table(self, table, build_number='2.5.1.38537'):
        url = 'https://wow.tools/dbc/api/export/?name=%s&build=%s' % (table, build_number)
        response = self.get(url)
        return csv.DictReader(response.text.splitlines())

    def map_to_area(self):
        table = self.get_db_table('uimapassignment')
        maps = {}
        for row in table:
            # print(row['AreaID'], row['AreaID'] == 0)
            area = int(row['AreaID'])
            if area == 0:
                continue
            maps[int(row['UiMapID'])] = area
        return maps


if __name__ == "__main__":
    build = BuildMapData()
    build.map_to_area()
    build.save(build.map_to_area(), 'MapToZone')
