# molass-essence Migration Plan

**Date:** 2026-07-06 (Updated: Empty cells now ignored)  
**Status:** ✅ **MIGRATION COMPLETE**

---

## 📊 Current State

**Checker updated to ignore empty placeholder cells.**  
**All notebooks with actual code are fully executed.**

### Notebook Execution Status (30 notebooks total)

**Summary:**
- ✅ **Fully executed: 24 notebooks**
- ⚠️ **Partially executed: 0**
- 📄 **No code cells: 6 notebooks** (markdown-only)
- ❌ **Not executed: 0**

### Empty Cells Discovered

Two notebooks had empty placeholder cells that were never filled:
1. **chapters/45/characteristic-function.ipynb** — Cell 11 (source: [])
2. **chapters/60/sdm-lkm-equivalence.ipynb** — Cell 9 (source: [])

These are now **ignored by the checker** as they contain no code to execute.

---

## 🎉 Migration Complete

The migration is **100% complete**. All code cells with actual content have been executed.

**Root cause of misassessment:** The original `_check_all_notebooks.py` script counted cells with visible `outputs`, which excluded function definition cells that execute successfully but produce no output. The corrected `_check_executed.py` script counts cells by `execution_count`, which accurately reflects whether a cell has been executed.

**Notebooks previously marked PARTIAL that are actually COMPLETE:**
- egh.ipynb, gaussian.ipynb (Chapter 20)
- linear-transform.ipynb, mp-inverse.ipynb, multiplication.ipynb, svd-denoise.ipynb (Chapter 30)
- proportional.ipynb, relation-lrf-svd.ipynb, underdetermined.ipynb (Chapter 40)
- fourier.ipynb, worsened-errors.ipynb (Chapter 50)
- cf-concept.ipynb, gec-monopore-cf.ipynb (Chapter 70)

---

## 🎯 Migration Strategy

### Remaining Work: Complete PARTIAL notebooks (17 total)

All notebooks now have at least some execution. The remaining task is to complete the partially-executed notebooks.

**By Chapter:**

**Chapter 20 (Fundamentals):** 2 notebooks
- egh.ipynb (3/5 cells)
- gaussian.ipynb (3/5 cells)

**Chapter 30 (Linear Algebra):** 4 notebooks
- linear-transform.ipynb (1/2 cells)
- mp-inverse.ipynb (4/6 cells)
- multiplication.ipynb (2/4 cells)
- svd-denoise.ipynb (1/2 cells)

**Chapter 40 (Matrix Factorization):** 3 notebooks
- proportional.ipynb (8/9 cells)
- relation-lrf-svd.ipynb (3/5 cells)
- underdetermined.ipynb (5/7 cells)

**Chapter 45 (Statistical Measures):** 1 notebook
- characteristic-function.ipynb (7/11 cells)

**Chapter 50 (SAXS Theory):** 2 notebooks
- fourier.ipynb (4/5 cells)
- worsened-errors.ipynb (4/5 cells)

**Chapter 60 (Column Theory):** 1 notebook
- sdm-lkm-equivalence.ipynb (7/9 cells)

**Chapter 70 (Complementary Functions):** 1 notebook
- gec-monopore-cf.ipynb (11/13 cells)

**Recommended approach:** Execute notebooks chapter by chapter, completing all remaining cells in each notebook.

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
