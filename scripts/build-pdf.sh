#!/usr/bin/env bash
set -euo pipefail

# Build EMAM PDF from docs/EMAM-Resilient-SADAD.md using Pandoc
# Requires: pandoc installed on your system

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INPUT_MD="$ROOT_DIR/docs/EMAM-Resilient-SADAD.md"
OUTPUT_PDF="$ROOT_DIR/docs/EMAM-Resilient-SADAD.pdf"
HEADER_TEX="$ROOT_DIR/docs/latex-preamble.tex"

if ! command -v pandoc >/dev/null 2>&1; then
  echo "[error] pandoc not found. Install via: brew install pandoc" >&2
  exit 1
fi

if [[ -f "$HEADER_TEX" ]]; then
  pandoc "$INPUT_MD" -o "$OUTPUT_PDF" --from markdown --pdf-engine=xelatex -H "$HEADER_TEX" \
    || pandoc "$INPUT_MD" -o "$OUTPUT_PDF" -H "$HEADER_TEX"
else
  pandoc "$INPUT_MD" -o "$OUTPUT_PDF" --from markdown --pdf-engine=xelatex \
    || pandoc "$INPUT_MD" -o "$OUTPUT_PDF"
fi
echo "[ok] PDF generated at $OUTPUT_PDF"
