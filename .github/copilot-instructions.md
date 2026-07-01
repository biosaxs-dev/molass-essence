<!-- AI Context Standard v0.9.2 - Adopted: 2026-05-07 -->
# AI Assistant Initialization Guide — molass-essence

**Purpose**: Initialize AI context for working in this repository  
**Created**: March 25, 2026

---

## What this repository is about

This repository holds the Jupyter Book source for the [Molass Library Essence](https://biosaxs-dev.github.io/molass-essence/) web book — a theory-focused companion to the molass library.

---

## Repository-specific conventions

- **Format**: [MyST Markdown syntax](https://jupyterbook.org/en/stable/reference/cheatsheet.html) is used throughout unless otherwise stated
- **Build tool**: Jupyter Book v2 (MyST)
- **Audience**: Users who want to understand the mathematical and physical foundations of SEC-SAXS data analysis

---

## MyST Configuration Notes

**Important**: When authoring notebooks for this documentation book, follow the conventions in [molass-develop § Writing Notebooks for Documentation](https://biosaxs-dev.github.io/molass-develop/chapters/07/documentation.html#writing-notebooks-for-documentation). This covers:
- MyST development workflow and auto-rebuild behavior
- Suppressing long outputs (%%capture, %%script false, etc.)
- Notebook frontmatter requirements
- Common cell magics reference
- Tool choice for notebook editing

For other MyST troubleshooting (duplicate titles, build issues), see the full [Documentation chapter in molass-develop](https://biosaxs-dev.github.io/molass-develop/chapters/07/documentation.html).

**Quick reference**: Notebooks must have frontmatter in the first markdown cell to avoid title duplication:

````markdown
---
title: Page Title
---

# Page Title
## Section
...
````

**Local testing**: `myst start` → http://localhost:3000  
**Clean rebuild**: `myst clean --all` then `myst start`

---

## Multi-root workspace context

| Repository | Role | Tool |
|------------|------|------|
| `molass-library` | Main library (Python source) | Python / Sphinx |
| `molass-legacy` | Legacy GUI predecessor; required runtime dep | Python / Sphinx |
| `modeling-vs-model_free` | Research: decomposition criteria | Markdown / Notebooks |
| `molass-tutorial` | Usage documentation | Jupyter Book / MyST |
| `molass-essence` | **This repo**: theory documentation | Jupyter Book / MyST |
| `molass-technical` | Technical report | Jupyter Book / MyST |
| `molass-develop` | Developer handbook | Jupyter Book / MyST |
| `molass-beginner` | Beginner onboarding (Agent mode) | Markdown |

---

## Building the book

```bash
jupyter-book build .
```

Output goes to `_build/html/`.

---

## Notebook workflow

Read [NOTEBOOK_CONVENTIONS.md v0.2.6](https://github.com/freesemt/ai-context-standard/blob/main/NOTEBOOK_CONVENTIONS.md) before working with any notebook in this repo.  
Kernel preference: global Python (`py`). Do not create venvs.

---

## Response language

**Response language**: English

---

## 🔄 Updates

**Latest**: March 25, 2026 — Created `.github/copilot-instructions.md` (AI Context Standard v0.8)
