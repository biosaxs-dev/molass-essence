# molass-essence Migration Plan

**Date:** 2026-07-02  
**Status:** Ready to begin

---

## 📊 Current State

### Notebook Output Status (30 notebooks total)

| File | Status | Code Cells | With Output |
|------|--------|------------|-------------|
| **Chapter 20: Fundamentals** |
| amino-acid.ipynb | ✅ OK | 0 | 0 |
| egh.ipynb | EMPTY | 5 | 0 |
| gaussian.ipynb | EMPTY | 5 | 0 |
| hammouda.ipynb | EMPTY | 1 | 0 |
| sphere-scattering.ipynb | EMPTY | 1 | 0 |
| **Chapter 30: Linear Algebra** |
| linear-transform.ipynb | EMPTY | 2 | 0 |
| mp-inverse.ipynb | PARTIAL | 6 | 4 |
| multiplication.ipynb | EMPTY | 4 | 0 |
| svd-denoise.ipynb | EMPTY | 2 | 0 |
| **Chapter 40: Matrix Factorization** |
| dim-solution-space.ipynb | EMPTY | 2 | 0 |
| matrix-rank.ipynb | ✅ OK | 0 | 0 |
| proportional.ipynb | EMPTY | 9 | 0 |
| relation-lrf-svd.ipynb | EMPTY | 5 | 0 |
| solving-strategies.ipynb | ✅ OK | 0 | 0 |
| underdetermined.ipynb | EMPTY | 7 | 0 |
| **Chapter 45: Statistical Measures** |
| characteristic-function.ipynb | PARTIAL | 11 | 7 |
| moments.ipynb | ✅ OK | 5 | 5 |
| radius-of-gyration.ipynb | EMPTY | 5 | 0 |
| **Chapter 50: SAXS Theory** |
| bounded-lrf.ipynb | EMPTY | 2 | 0 |
| fourier.ipynb | PARTIAL | 5 | 4 |
| guinier.ipynb | EMPTY | 2 | 0 |
| interparticle.ipynb | ✅ OK | 0 | 0 |
| scattering-factors.ipynb | EMPTY | 3 | 0 |
| worsened-errors.ipynb | EMPTY | 5 | 0 |
| **Chapter 60: Column Theory** |
| kinetic-theory.ipynb | ✅ OK | 0 | 0 |
| plate-theory.ipynb | EMPTY | 1 | 0 |
| sdm-lkm-equivalence.ipynb | PARTIAL | 9 | 7 |
| stochastic-theory.ipynb | ✅ OK | 0 | 0 |
| **Chapter 70: Complementary Functions** |
| cf-concept.ipynb | EMPTY | 5 | 0 |
| gec-monopore-cf.ipynb | EMPTY | 13 | 0 |

**Summary:**
- ✅ **OK (7)**: Pure markdown or fully executed
- ⚠️ **PARTIAL (4)**: Need to complete execution
- 🔴 **EMPTY (19)**: Need full execution

---

## 🎯 Migration Strategy

### Phase 1: Complete PARTIAL notebooks (Priority)
These are partially executed and should be completed first:

1. **mp-inverse.ipynb** (4/6 cells) — Chapter 30
2. **characteristic-function.ipynb** (7/11 cells) — Chapter 45
3. **fourier.ipynb** (4/5 cells) — Chapter 50
4. **sdm-lkm-equivalence.ipynb** (7/9 cells) — Chapter 60

### Phase 2: Execute EMPTY notebooks by chapter

**Chapter 20 (Fundamentals):** 4 notebooks
- egh.ipynb
- gaussian.ipynb
- hammouda.ipynb
- sphere-scattering.ipynb

**Chapter 30 (Linear Algebra):** 3 notebooks
- linear-transform.ipynb
- multiplication.ipynb
- svd-denoise.ipynb

**Chapter 40 (Matrix Factorization):** 4 notebooks
- dim-solution-space.ipynb
- proportional.ipynb
- relation-lrf-svd.ipynb
- underdetermined.ipynb

**Chapter 45 (Statistical):** 1 notebook
- radius-of-gyration.ipynb

**Chapter 50 (SAXS):** 4 notebooks
- bounded-lrf.ipynb
- guinier.ipynb
- scattering-factors.ipynb
- worsened-errors.ipynb

**Chapter 60 (Column):** 1 notebook
- plate-theory.ipynb

**Chapter 70 (CF):** 2 notebooks
- cf-concept.ipynb
- gec-monopore-cf.ipynb

---

## 🔧 Execution Commands

### Option 1: Execute one notebook at a time (recommended for inspection)
```powershell
cd C:\Users\takahashi\GitHub\molass-essence

# Phase 1: Complete PARTIAL notebooks
jupyter nbconvert --to notebook --execute --inplace chapters/30/mp-inverse.ipynb
jupyter nbconvert --to notebook --execute --inplace chapters/45/characteristic-function.ipynb
jupyter nbconvert --to notebook --execute --inplace chapters/50/fourier.ipynb
jupyter nbconvert --to notebook --execute --inplace chapters/60/sdm-lkm-equivalence.ipynb

# Phase 2: Execute by chapter (example)
jupyter nbconvert --to notebook --execute --inplace chapters/20/egh.ipynb
jupyter nbconvert --to notebook --execute --inplace chapters/20/gaussian.ipynb
# ... continue with remaining notebooks
```

### Option 2: Batch execute all EMPTY notebooks (faster but less control)
```powershell
cd C:\Users\takahashi\GitHub\molass-essence

# Get list of EMPTY notebooks and execute
$script = @"
import json
from pathlib import Path
nbs = sorted(Path('chapters').rglob('*.ipynb'))
for nb in nbs:
    cells = json.loads(nb.read_text(encoding='utf-8'))['cells']
    code = len([c for c in cells if c['cell_type']=='code'])
    output = len([c for c in cells if c['cell_type']=='code' and c.get('outputs',[])])
    if code > 0 and output == 0:
        print(nb)
"@
$script | py | ForEach-Object { jupyter nbconvert --to notebook --execute --inplace $_ }
```

---

## ⚠️ Known Issues & Workarounds

From molass-tutorial migration experience:

1. **VS Code Last-Cell Bug** (v1.127.0)
   - Symptom: Last cell doesn't render in editor
   - Workaround: Add marker cell at end with horizontal rule
   - Verification: Use `aicListNotebookCells` to confirm cell exists

2. **Verbose Output Suppression**
   - Pattern: Add `%%capture` magic at top of noisy cells
   - Keeps .ipynb files clean for git

3. **File Integrity Check**
   - Before assuming content is lost, verify with Python:
     ```python
     import json
     nb = json.load(open('path/to/notebook.ipynb', encoding='utf-8'))
     len(nb['cells'])  # Count cells
     ```

---

## 📋 Execution Checklist

### Before Starting
- [ ] Verify molass library version: `python -c "from molass import get_version; print(get_version())"`
- [ ] Check kernel is global Python (`py`) not a venv
- [ ] Ensure molass_data is installed: `python -c "import molass_data"`

### During Execution
- [ ] Monitor for import errors (missing dependencies)
- [ ] Watch for long-running cells (>5 min)
- [ ] Check for unexpected warnings/errors
- [ ] Note any cells that need `%%capture` magic

### After Execution
- [ ] Run status check script to verify outputs saved
- [ ] Test local build: `myst start` (port 3000)
- [ ] Check sample pages for rendering issues
- [ ] Look for missing plots or broken LaTeX

### Deployment
- [ ] Stage: `git add chapters/**/*.ipynb`
- [ ] Commit with descriptive message
- [ ] Push: `git push origin main`
- [ ] Monitor GitHub Actions: `gh run list -R biosaxs-dev/molass-essence --limit 3`
- [ ] Verify deployed site: https://biosaxs-dev.github.io/molass-essence/

---

## 🔗 Related Documentation

- **molass-tutorial migration**: [_UPDATE_PLAN.md](../molass-tutorial/_UPDATE_PLAN.md)
- **Notebook conventions**: [NOTEBOOK_CONVENTIONS.md v0.2.6](https://github.com/freesemt/ai-context-standard/blob/main/NOTEBOOK_CONVENTIONS.md)
- **VS Code rendering bug**: Documented in molass-tutorial/chapters/08/backward.ipynb (cell #11)
- **Workspace status**: [molass-review/WORKSPACE_STATUS.md](../molass-review/WORKSPACE_STATUS.md)

---

## 📝 Notes for Next Session

**Resume workflow:**
1. Say: "I want to resume molass-essence migration"
2. AI will read this file and current status
3. Pick Phase 1 (PARTIAL) or Phase 2 (EMPTY by chapter)
4. Execute → verify → commit → deploy

**Quick status check:**
```powershell
cd C:\Users\takahashi\GitHub\molass-essence
$script = @"
import json
from pathlib import Path
nbs = sorted(Path('chapters').rglob('*.ipynb'))
print(f'{'File':<40} Code  Out  Status')
print('-' * 60)
for nb in nbs:
    cells = json.loads(nb.read_text(encoding='utf-8'))['cells']
    code = len([c for c in cells if c['cell_type']=='code'])
    output = len([c for c in cells if c['cell_type']=='code' and c.get('outputs',[])])
    status = 'OK' if code==output else ('EMPTY' if output==0 else 'PARTIAL')
    print(f'{str(nb.relative_to('chapters')):<40} {code:>4} {output:>4}  {status}')
"@
$script | py
```

---

**Last updated:** 2026-07-02  
**Next milestone:** Complete Phase 1 (4 PARTIAL notebooks)
