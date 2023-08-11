import os

from build_utils.utils.BuildMapData import BuildMapData

data_folder = os.path.join(os.path.dirname(__file__), '..', 'data')
version = os.getenv('GAME_VERSION')
build = BuildMapData(data_folder=data_folder, game=version)
build.save(build.map_to_area(), 'MapToZone')
