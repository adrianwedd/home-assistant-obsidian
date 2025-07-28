import time
import sys
import docker
import requests

client = docker.from_env()
print('Starting container...')
container = client.containers.run(
    'ghcr.io/sytone/obsidian-remote:latest',
    detach=True,
    ports={'3000/tcp': 3000},
)
try:
    for _ in range(30):
        time.sleep(1)
        try:
            r = requests.get('http://localhost:3000', timeout=2)
            if r.status_code == 200:
                print('Add-on responded successfully')
                break
        except requests.exceptions.ConnectionError:
            continue
    else:
        print('Timed out waiting for response')
        sys.exit(1)
finally:
    container.remove(force=True)
