# Notebook Execution Guide

This document explains how to execute Jupyter notebooks for MyST documentation builds.

## Overview

MyST requires notebooks to have cell outputs pre-populated in the repository. The CI/CD workflow validates but does **not execute** notebooks — outputs must be generated locally before committing.

## Quick Start

```powershell
# Execute only changed notebooks (default, recommended)
.\execute_notebooks.ps1

# Execute all notebooks (use after molass version upgrade)
.\execute_notebooks.ps1 -All

# Execute specific notebook
.\execute_notebooks.ps1 -Path "chapters\20\gaussian.ipynb"

# Execute entire chapter
.\execute_notebooks.ps1 -Chapter 20
```

## Workflow

### 1. Make changes to a notebook
Edit the notebook in VS Code as usual.

### 2. Execute changed notebooks
```powershell
.\execute_notebooks.ps1
```

This automatically detects modified notebooks via `git diff` and `git status`.

### 3. Verify outputs
Check that plots appear correctly:
```powershell
myst clean --all
myst start
```

Visit http://localhost:3000 to verify.

### 4. Commit and push
```powershell
git add chapters/
git commit -m "docs: execute updated notebooks"
git push
```

The CI workflow validates that all notebooks have outputs before deploying.

## Command Reference

### Parameter Sets

| Command | Behavior |
|---------|----------|
| `.\execute_notebooks.ps1` | Default: execute only changed notebooks |
| `-All` | Execute all notebooks in `chapters/` |
| `-Path <file>` | Execute specific notebook(s) |
| `-Chapter <num>` | Execute all notebooks in a chapter |

### Change Detection

The script detects changes via:
- `git diff --name-only HEAD` — staged changes
- `git status --porcelain` — unstaged/untracked files

Only `.ipynb` files are considered.

### When to Use `-All`

Use `-All` in these situations:
- After upgrading molass library version
- After adding new dependencies
- When unsure if all notebooks are up to date
- After cloning the repository fresh

Otherwise, the default `-Changed` mode is faster and safer.

## CI/CD Integration

The GitHub Actions workflow includes a validation step:

```yaml
- name: Validate notebooks have outputs
  run: |
    python3 << 'EOF'
    import sys, json, pathlib
    failed = []
    for nb_path in pathlib.Path('chapters').rglob('*.ipynb'):
        data = json.loads(nb_path.read_text(encoding='utf-8'))
        code_cells = [c for c in data['cells'] if c['cell_type'] == 'code']
        if code_cells and not any(c.get('outputs') for c in code_cells):
            failed.append(str(nb_path))
    
    if failed:
        print("\n❌ ERROR: Notebooks without outputs (run ./execute_notebooks.ps1 locally):")
        for f in failed:
            print(f"  - {f}")
        sys.exit(1)
    else:
        print("✅ All notebooks have outputs")
    EOF
```

This ensures deploys fail fast if notebooks lack outputs.

## Multi-Repo Status

This script is deployed to all 4 documentation repositories:

- ✅ molass-essence
- ✅ molass-tutorial  
- ✅ molass-technical
- ✅ molass-develop

All repos share the same script and CI validation.

## Troubleshooting

### Script parse error
If you see `TerminatorExpectedAtEndOfString`, ensure PowerShell 5.1 or later is installed.

### No notebooks detected
- Check you're in the correct repository directory
- Run `git status` to verify there are modified `.ipynb` files

### Execution fails
- Ensure `jupyter nbconvert` is installed: `pip install jupyter nbconvert`
- Check Python environment has required dependencies (numpy, matplotlib, molass, etc.)
- Try executing one notebook manually to see detailed error message

### CI validation fails after push
Run `.\execute_notebooks.ps1 -All` locally and commit the outputs.

## Dependencies

Required Python packages:
- `jupyter` — for nbconvert
- `nbconvert` — notebook execution
- `molass` — primary library
- `molass_data` — sample datasets
- `numpy`, `matplotlib`, `sympy` — computation/visualization

Install with:
```powershell
pip install jupyter nbconvert molass molass_data numpy matplotlib sympy
```

## See Also

- [_UPDATE_PLAN.md](_UPDATE_PLAN.md) — Tracking document for migration status
- [myst.yml](myst.yml) — MyST configuration
- [.github/workflows/deploy.yml](.github/workflows/deploy.yml) — CI/CD workflow
