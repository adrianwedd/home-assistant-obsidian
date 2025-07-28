# Repository Registration Debug

## Issue
The Home Assistant repository `https://github.com/adrianwedd/home-assistant-obsidian` doesn't register as a valid repository in Home Assistant.

## Common Causes & Solutions

### 1. Repository Structure Issues
**Check**: Repository must have this exact structure:
```
/
├── repository.yaml          ← Must exist at root
└── obsidian/               ← Add-on folder
    ├── config.yaml         ← Must exist
    ├── run.sh             ← Optional but recommended
    └── icon.png           ← Must exist
```

**Status**: ✅ Structure is correct

### 2. repository.yaml Format Issues
**Current content**:
```yaml
name: "Obsidian Home Assistant Addon"
url: "https://github.com/adrianwedd/home-assistant-obsidian"
maintainer: "Adrian Wedd <adrian@adrianwedd.com>"
icon: "https://github.com/adrianwedd/home-assistant-obsidian/blob/main/obsidian/icon.png?raw=true"
logo: "https://github.com/adrianwedd/home-assistant-obsidian/blob/main/obsidian/logo.png?raw=true"
```

**Potential Issues**:
- Missing trailing newline
- URLs might need to be accessible
- Format should be valid YAML

### 3. GitHub Repository Issues
**Check these**:
- [ ] Repository is public (not private)
- [ ] Files are actually committed and pushed
- [ ] Branch is `main` (not `master`)
- [ ] No special characters in repository name

### 4. Home Assistant Cache Issues
**Try these steps**:
1. Remove repository completely from HA
2. Wait 5 minutes
3. Add repository URL again: `https://github.com/adrianwedd/home-assistant-obsidian`
4. Check HA logs for specific error messages

### 5. Validation Tools

**Test repository validity**:
```bash
# Check YAML syntax
python -c "import yaml; yaml.safe_load(open('repository.yaml'))"

# Check config.yaml syntax
python -c "import yaml; yaml.safe_load(open('obsidian/config.yaml'))"

# Check URLs are accessible
curl -I "https://github.com/adrianwedd/home-assistant-obsidian/blob/main/obsidian/icon.png?raw=true"
```

## Debugging Steps

### Step 1: Verify Repository Accessibility
- Visit: https://github.com/adrianwedd/home-assistant-obsidian
- Check files are visible
- Verify repository is public

### Step 2: Check Home Assistant Logs
- Settings → System → Logs
- Look for repository parsing errors
- Search for "repository" or "addon" errors

### Step 3: Manual Validation
Run these commands to validate:
```bash
# Test YAML parsing
python3 -c "
import yaml
try:
    with open('repository.yaml') as f:
        repo = yaml.safe_load(f)
    print('repository.yaml: ✅ Valid')
    print(f'Name: {repo.get(\"name\")}')
except Exception as e:
    print(f'repository.yaml: ❌ Error: {e}')

try:
    with open('obsidian/config.yaml') as f:
        config = yaml.safe_load(f)
    print('config.yaml: ✅ Valid')
    print(f'Add-on: {config.get(\"name\")} v{config.get(\"version\")}')
except Exception as e:
    print(f'config.yaml: ❌ Error: {e}')
"
```

### Step 4: Test Icon/Logo URLs
```bash
curl -I "https://github.com/adrianwedd/home-assistant-obsidian/blob/main/obsidian/icon.png?raw=true"
curl -I "https://github.com/adrianwedd/home-assistant-obsidian/blob/main/obsidian/logo.png?raw=true"
```

## Common Fixes

### Fix 1: Add Proper Newlines
Ensure files end with newlines:
```bash
echo "" >> repository.yaml
echo "" >> obsidian/config.yaml
```

### Fix 2: Simplify repository.yaml
Try minimal version:
```yaml
name: "Obsidian Home Assistant Addon"
url: "https://github.com/adrianwedd/home-assistant-obsidian"
maintainer: "Adrian Wedd <adrian@adrianwedd.com>"
```

### Fix 3: Check Branch Names
Ensure using `main` branch, not `master`:
```bash
git branch -M main
git push origin main
```

### Fix 4: Force Repository Refresh
In Home Assistant:
1. Remove repository
2. Restart Home Assistant completely
3. Re-add repository
4. Check logs immediately after adding

## Next Steps
1. Run validation commands above
2. Check Home Assistant logs for specific errors
3. Try simplified repository.yaml
4. Test with fresh Home Assistant restart
