#!/bin/bash
# recon.sh - يجمع subdomains، يفحص الحيّة، ويجمع URLs
# Usage: ./recon.sh <target>

set -uo pipefail

TARGET="${1:-}"
OUT_DIR="reports"
LOG_DIR="logs"

if [ -z "$TARGET" ]; then
  echo "❌ Usage: $0 <target>"
  exit 1
fi

mkdir -p "$OUT_DIR" "$LOG_DIR"

run_safe() {
  echo "[*] $1"
  timeout 300 bash -c "$1" 2>&1 | tee -a "$LOG_DIR/recon_errors.log" || \
    echo "⚠️  Failed (continuing): $1" | tee -a "$LOG_DIR/failed_commands.txt"
}

echo "========================================"
echo "🔍 RECON: $TARGET"
echo "========================================"

# ===== 1. جمع Subdomains من عدة مصادر =====
run_safe "amass enum -d $TARGET -timeout 5 -o $OUT_DIR/amass_${TARGET}.txt"
run_safe "subfinder -d $TARGET -silent -o $OUT_DIR/sub_${TARGET}.txt"
run_safe "assetfinder -subs-only $TARGET > $OUT_DIR/asset_${TARGET}.txt"

if [ -f "tools/ott3rrhunt/ott3rrhunt.py" ]; then
  run_safe "python3 tools/ott3rrhunt/ott3rrhunt.py -d $TARGET -o $OUT_DIR/ott3rr_${TARGET}.txt"
fi
if [ -f "tools/theharvester/theHarvester.py" ]; then
  run_safe "python3 tools/theharvester/theHarvester.py -d $TARGET -b all -f $OUT_DIR/harvester_${TARGET}.html"
fi

# ===== 2. دمج وتنظيف (dedup) =====
cat "$OUT_DIR"/amass_${TARGET}.txt "$OUT_DIR"/sub_${TARGET}.txt "$OUT_DIR"/asset_${TARGET}.txt 2>/dev/null \
  | grep -v '^$' | sort -u > "$OUT_DIR/all_${TARGET}.txt"

SUB_COUNT=$(wc -l < "$OUT_DIR/all_${TARGET}.txt" 2>/dev/null || echo 0)
echo "📊 Total unique subdomains: $SUB_COUNT"

# ===== 3. فحص الحيّة =====
run_safe "httpx -l $OUT_DIR/all_${TARGET}.txt -silent -o $OUT_DIR/alive_${TARGET}.txt"
ALIVE_COUNT=$(wc -l < "$OUT_DIR/alive_${TARGET}.txt" 2>/dev/null || echo 0)
echo "📊 Alive hosts: $ALIVE_COUNT"

# ===== 4. جمع URLs (لازم لـ dalfox/kxss لاحقاً بمرحلة scan) =====
run_safe "cat $OUT_DIR/alive_${TARGET}.txt | gau --subs > $OUT_DIR/urls_${TARGET}.txt"
run_safe "cat $OUT_DIR/alive_${TARGET}.txt | waybackurls >> $OUT_DIR/urls_${TARGET}.txt"
sort -u "$OUT_DIR/urls_${TARGET}.txt" -o "$OUT_DIR/urls_${TARGET}.txt" 2>/dev/null
URL_COUNT=$(wc -l < "$OUT_DIR/urls_${TARGET}.txt" 2>/dev/null || echo 0)
echo "📊 Collected URLs: $URL_COUNT"

echo "✅ Recon done for $TARGET"
