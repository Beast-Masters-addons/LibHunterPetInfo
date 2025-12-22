from pathlib import Path

from build_utils.utils.BuildMapData import BuildMapData

build = BuildMapData()
data_folder = Path(__file__).parent.parent.joinpath('data', build.game_version)
data_folder.mkdir(parents=True, exist_ok=True)
build.data_folder = str(data_folder)

build.save(build.map_to_area(), 'MapToZone', save_json=False)
