import yaml

def test_image_is_untagged_and_version_set():
    with open('obsidian/config.yaml') as f:
        cfg = yaml.safe_load(f)
    image = str(cfg['image'])
    version = str(cfg['version'])
    assert ':' not in image, 'image must not include a tag'
    assert version, 'version must be specified'
