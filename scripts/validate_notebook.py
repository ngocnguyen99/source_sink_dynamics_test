"""Validate notebook JSON and compile every Python code cell."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python scripts/validate_notebook.py NOTEBOOK.ipynb")

    notebook_path = Path(sys.argv[1]).resolve()
    notebook = json.loads(notebook_path.read_text(encoding="utf-8"))

    code_cells = 0
    for cell_number, cell in enumerate(notebook["cells"], start=1):
        if cell.get("cell_type") != "code":
            continue
        code_cells += 1
        source = "".join(cell.get("source", []))
        compile(source, f"{notebook_path}#cell-{cell_number}", "exec")

    print(f"Validated {code_cells} Python code cells in {notebook_path.name}.")


if __name__ == "__main__":
    main()
