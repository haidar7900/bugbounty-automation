#!/bin/bash
# scan.sh - يشغل السكانرز والوكلاء الذكيين على نتائج recon.sh
# Usage: ./scan.sh <target>

set -uo pipefail

TARGET="${1:-}"
OUT_DIR="reports"
LOG_DIR="logs"

if [ -z "$TARGET" ]; then
  echo "❌ Usage: $0 <target>"
  exit 1
fi

ALIVE_FILE="$OUT_DIR/alive_${TARGET}.txt"
URLS_FILE="$OUT_DIR/urls_${TARGET}.txt"

if [ ! -f "$ALIVE_FILE" ]; then
  echo "❌ $ALIVE_FILE not found — run recon.sh first for $TARGET"
  exit 1
fi

run_safe() {
  echo "[*] $1"
  timeout 300 bash -c "$1" 2>&1 | tee -a "$LOG_DIR/scan_errors.log" || \
    echo "⚠️  Failed (continuing): $1" | tee -a "$LOG_DIR/failed_commands.txt"
}

echo "========================================"
echo "🛡️ SCAN: $TARGET"
echo "========================================"

run_safe "onus scan $TARGET --output $OUT_DIR/onus_${TARGET}.json"
run_safe "noseyparker scan $TARGET --output $OUT_DIR/noseyparker_${TARGET}.json"

if [ -f "tools/bugtrace/main.py" ]; then
  run_safe "python3 tools/bugtrace/main.py --target $TARGET --output $OUT_DIR/bugtrace_${TARGET}.json"
fi

for tool in dark_wxlf:darkwxlf pinakastra:pinakastra metatron:metatron; do
  dir="${tool%%:*}"
  tag="${tool##*:}"
  script="tools/$dir/main.py"
  [ "$dir" = "pinakastra" ] && script="tools/$dir/pinakastra.py"
  [ "$dir" = "metatron" ] && script="tools/$dir/metatron.py"
  if [ -f "$script" ]; then
    run_safe "python3 $script -d $TARGET -o $OUT_DIR/${tag}_${TARGET}.json"
  fi
done

run_safe "strix --target $TARGET --output $OUT_DIR/strix_${TARGET}.json"
if [ -f "tools/reaper/reaper.py" ]; then
  run_safe "python3 tools/reaper/reaper.py -d $TARGET -o $OUT_DIR/reaper_${TARGET}.json"
fi

if [ -f "$URLS_FILE" ]; then
  run_safe "xsshunt -u https://$TARGET -o $OUT_DIR/xsshunt_${TARGET}.txt"
  run_safe "dalfox file $URLS_FILE -o $OUT_DIR/dalfox_${TARGET}.txt"
  run_safe "kxss < $URLS_FILE > $OUT_DIR/kxss_${TARGET}.txt"
else
  echo "⚠️  $URLS_FILE not found — skipping dalfox/kxss (run recon.sh first)"
fi

run_safe "nuclei -l $ALIVE_FILE -severity low,medium,high,critical -o $OUT_DIR/nuclei_${TARGET}.txt"
NUCLEI_COUNT=$(wc -l < "$OUT_DIR/nuclei_${TARGET}.txt" 2>/dev/null || echo 0)
echo "📊 Nuclei findings: $NUCLEI_COUNT"

echo "✅ Scan done for $TARGET"
