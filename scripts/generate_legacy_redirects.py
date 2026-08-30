#!/usr/bin/env python3
"""Recreate chapters/intro.html as a redirect stub to the new site root.

Before the MyST v2 migration, the book root was served at chapters/intro.html.
MyST v2 serves it at /. The JOSS paper (published, cannot be edited) links to
the old path, so this stub keeps it resolving. Run after `myst build --html`
and before uploading the site artifact.
"""
import os
import sys
from pathlib import Path

BUILD_DIR = Path("_build/html")
BASE_URL = os.environ.get("BASE_URL", "").rstrip("/")
TARGET = f"{BASE_URL}/"

REDIRECT_HTML = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Redirecting...</title>
<meta http-equiv="refresh" content="0; url={TARGET}">
<link rel="canonical" href="{TARGET}">
<script>
  location.replace("{TARGET}" + location.hash + location.search);
</script>
</head>
<body>
<p>This page has moved. Redirecting to <a href="{TARGET}">{TARGET}</a>.</p>
</body>
</html>
"""


def main():
    if not BUILD_DIR.exists():
        print(f"Build directory {BUILD_DIR} not found; run `myst build --html` first.", file=sys.stderr)
        sys.exit(1)

    stub_path = BUILD_DIR / "chapters" / "intro.html"
    stub_path.parent.mkdir(parents=True, exist_ok=True)
    stub_path.write_text(REDIRECT_HTML, encoding="utf-8")
    print(f"Generated legacy redirect stub at {stub_path}")


if __name__ == "__main__":
    main()
