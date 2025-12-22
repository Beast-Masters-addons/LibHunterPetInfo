from pathlib import Path

from build_utils.utils import WowXML

project_root = Path(__file__).parent.parent

game_folder: Path
for game_folder in project_root.joinpath('data').iterdir():
    if not game_folder.is_dir():
        continue
    file: Path
    xml = WowXML()
    for file in game_folder.iterdir():
        if file.suffix != '.lua':
            continue

        rel = file.relative_to(project_root)
        xml.script(str(rel))
    xml.save(project_root.joinpath('data', '%s.xml' % game_folder.name))
