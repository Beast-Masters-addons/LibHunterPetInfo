from pathlib import Path

from build_utils.utils import WowXML

data_folder = Path(__file__).parent.parent.joinpath('data')

game_folder: Path
for game_folder in data_folder.iterdir():
    if not game_folder.is_dir():
        continue
    file: Path
    xml = WowXML()
    for file in game_folder.iterdir():
        if file.suffix != '.lua':
            continue

        rel = file.relative_to(data_folder)
        xml.script(str(rel))
    xml.save(data_folder.joinpath('%s.xml' % game_folder.name))
