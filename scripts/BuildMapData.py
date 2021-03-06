import os

from build_utils import BuildMapData

data_folder = os.path.join(os.path.dirname(__file__), '..', 'data')
build = BuildMapData(data_folder=data_folder)
build.save(build.map_to_area(), 'MapToZone')