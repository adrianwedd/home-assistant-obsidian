import pytest
import subprocess

def test_container_build():
    """Verify that the Docker image can be built successfully."""
    try:
        subprocess.run(["docker", "build", "-f", "container/Dockerfile", ".", "-t", "home-assistant-obsidian-test-build"], check=True, capture_output=True)
    except subprocess.CalledProcessError as e:
        pytest.fail(f"Container build failed: {e.stderr.decode()}")
