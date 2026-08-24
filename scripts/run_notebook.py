"""Execute a notebook's Python code cells sequentially without a Jupyter server."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> None:
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python scripts/run_notebook.py NOTEBOOK.ipynb")

    notebook_path = Path(sys.argv[1]).resolve()
    notebook = json.loads(notebook_path.read_text(encoding="utf-8"))
    namespace = {"__name__": "__main__"}

    for cell_number, cell in enumerate(notebook["cells"], start=1):
        if cell.get("cell_type") != "code":
            continue
        source = "".join(cell.get("source", []))
        print(f"Executing code cell {cell_number}", flush=True)
        exec(compile(source, f"{notebook_path}#cell-{cell_number}", "exec"), namespace)


if __name__ == "__main__":
    main()
