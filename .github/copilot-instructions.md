<!-- AI Context Standard v0.8 - Adopted: 2026-03-25 -->
# AI Assistant Initialization Guide — molass-essence

**Purpose**: Initialize AI context for working in this repository  
**Created**: March 25, 2026

---

## What this repository is about

This repository holds the Jupyter Book source for the [Molass Library Essence](https://biosaxs-dev.github.io/molass-essence/) web book — a theory-focused companion to the molass library.

---

## Repository-specific conventions

- **Format**: [MyST Markdown syntax](https://jupyterbook.org/en/stable/reference/cheatsheet.html) is used throughout unless otherwise stated
- **Build tool**: Jupyter Book
- **Audience**: Users who want to understand the mathematical and physical foundations of SEC-SAXS data analysis

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

## 🔄 Updates

**Latest**: March 25, 2026 — Created `.github/copilot-instructions.md` (AI Context Standard v0.8)
