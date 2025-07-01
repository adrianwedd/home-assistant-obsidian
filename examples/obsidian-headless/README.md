# Obsidian Headless Example

This example container runs Obsidian in a headless environment using Xvfb and KasmVNC.

## Build and run

```bash
docker build -t obsidian-headless .
docker run --rm -it -p 6901:6901 obsidian-headless
```

Open `http://localhost:6901` in your browser to access the UI. Use `-v ~/myvault:/root/Obsidian` to persist data.
