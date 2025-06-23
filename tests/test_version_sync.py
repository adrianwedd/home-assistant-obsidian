import yaml

def test_version_matches_image_tag():
    with open('obsidian/config.yaml') as f:
        cfg = yaml.safe_load(f)
    version = str(cfg['version'])
    image_tag = str(cfg['image']).split(':')[-1]
    assert version == image_tag, f"version {version} does not match image tag {image_tag}"
