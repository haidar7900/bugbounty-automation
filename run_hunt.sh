#!/bin/bash
# ============================================================
#  run_hunt.sh — يشغّل خط أنابيب Bug Bounty كامل
#  Usage: ./run_hunt.sh [targets.txt]
# ============================================================
set -uo pipefail

TARGETS_FILE="${1:-targets.txt}"
OUTDIR="${OUTDIR:-output}"
THREADS="${THREADS:-50}"

# --- PATH أولاً ---
export PATH="$PATH:$(go env GOPATH 2>/dev/null)/bin:$HOME/go/bin:$HOME/.local/bin:$HOME/.cargo/bin"

mkdir -p "$OUTDIR"

# --- دوال مساعدة ---
log()  { echo "[$(date +%H:%M:%S)] $*"; }
have() { command -v "$1" >/dev/null 2>&1; }
skip() { echo "  ⏭️  skip $1: $2"; }

# --- تحقق من وجود ملف الأهداف ---
if [ ! -f "$TARGETS_FILE" ]; then
  echo "❌ $TARGETS_FILE غير موجود. اكتب دومين في كل سطر."
  exit 1
fi

log "Targets: $(wc -l < "$TARGETS_FILE") | Output: $OUTDIR"

# ============================================================
#  المرحلة 1: جمع النطاقات الفرعية
# ============================================================
log "=== [1/5] Subdomain Enumeration ==="

: > "$OUTDIR/all_subs.txt"

while read -r d; do
  [ -z "$d" ] && continue
  log "  → $d"

  if have subfinder; then
    subfinder -d "$d" -silent -all 2>/dev/null >> "$OUTDIR/all_subs.txt" || true
  fi

  if have assetfinder; then
    assetfinder --subs-only "$d" 2>/dev/null >> "$OUTDIR/all_subs.txt" || true
  fi

  if have amass; then
    timeout 120 amass enum -passive -d "$d" -silent 2>/dev/null >> "$OUTDIR/all_subs.txt" || true
  fi
done < "$TARGETS_FILE"

sort -u "$OUTDIR/all_subs.txt" -o "$OUTDIR/all_subs.txt"
log "  ✅ subdomains: $(wc -l < "$OUTDIR/all_subs.txt")"

# ============================================================
#  المرحلة 2: فحص الحيوية + التقاط تقني
# ============================================================
log "=== [2/5] HTTP Probing ==="

if have httpx; then
  httpx -l "$OUTDIR/all_subs.txt" \
    -silent -threads "$THREADS" \
    -status-code -title -tech-detect -web-server \
    -o "$OUTDIR/live.txt" 2>/dev/null || true
  log "  ✅ live hosts: $(wc -l < "$OUTDIR/live.txt" 2>/dev/null || echo 0)"
else
  skip "httpx" "غير مثبّت"
fi

# قائمة URLs نظيفة للـ nuclei
awk '{print $1}' "$OUTDIR/live.txt" 2>/dev/null | sort -u > "$OUTDIR/live_urls.txt" || true

# ============================================================
#  المرحلة 3: جمع URLs + Params
# ============================================================
log "=== [3/5] URL Harvesting ==="

: > "$OUTDIR/all_urls.txt"
while read -r d; do
  [ -z "$d" ] && continue
  if have gau; then
    echo "$d" | gau --threads 10 2>/dev/null >> "$OUTDIR/all_urls.txt" || true
  fi
  if have waybackurls; then
    echo "$d" | waybackurls 2>/dev/null >> "$OUTDIR/all_urls.txt" || true
  fi
done < "$TARGETS_FILE"

sort -u "$OUTDIR/all_urls.txt" -o "$OUTDIR/all_urls.txt" 2>/dev/null
grep '=' "$OUTDIR/all_urls.txt" > "$OUTDIR/urls_with_params.txt" 2>/dev/null || true
log "  ✅ urls: $(wc -l < "$OUTDIR/all_urls.txt") | with params: $(wc -l < "$OUTDIR/urls_with_params.txt")"

# ============================================================
#  المرحلة 4: Crawling (Katana)
# ============================================================
log "=== [4/5] Crawling ==="

if have katana && [ -s "$OUTDIR/live_urls.txt" ]; then
  katana -list "$OUTDIR/live_urls.txt" \
    -silent -d 3 -jc -kf all -c 20 \
    -o "$OUTDIR/katana_urls.txt" 2>/dev/null || true
  log "  ✅ crawled: $(wc -l < "$OUTDIR/katana_urls.txt" 2>/dev/null || echo 0)"
else
  skip "katana" "غير مثبّت أو لا يوجد live hosts"
fi

# ============================================================
#  المرحلة 5: Vulnerability Scanning
# ============================================================
log "=== [5/5] Vulnerability Scanning ==="

# Nuclei
if have nuclei && [ -s "$OUTDIR/live_urls.txt" ]; then
  nuclei -l "$OUTDIR/live_urls.txt" \
    -silent -severity critical,high,medium \
    -c 25 -rl 150 \
    -o "$OUTDIR/nuclei_findings.txt" 2>/dev/null || true
  log "  ✅ nuclei findings: $(wc -l < "$OUTDIR/nuclei_findings.txt" 2>/dev/null || echo 0)"
else
  skip "nuclei" "غير مثبّت أو لا يوجد live hosts"
fi

# XSS — dalfox
if have dalfox && [ -s "$OUTDIR/urls_with_params.txt" ]; then
  head -200 "$OUTDIR/urls_with_params.txt" | \
    dalfox pipe --silence --no-spinner 2>/dev/null > "$OUTDIR/dalfox_xss.txt" || true
  log "  ✅ dalfox XSS: $(wc -l < "$OUTDIR/dalfox_xss.txt" 2>/dev/null || echo 0)"
else
  skip "dalfox" "غير مثبّت أو لا يوجد urls with params"
fi

# Kxss — انعكاسات
if have kxss && [ -s "$OUTDIR/urls_with_params.txt" ]; then
  head -500 "$OUTDIR/urls_with_params.txt" | kxss 2>/dev/null | \
    grep -i "Unfiltered" > "$OUTDIR/kxss_reflections.txt" || true
  log "  ✅ kxss reflections: $(wc -l < "$OUTDIR/kxss_reflections.txt" 2>/dev/null || echo 0)"
else
  skip "kxss" "غير مثبّت"
fi

# TruffleHog — تسريبات secrets
if have trufflehog && [ -d .git ]; then
  trufflehog filesystem . --only-verified --json 2>/dev/null \
    > "$OUTDIR/trufflehog_secrets.json" || true
  log "  ✅ trufflehog: $(wc -l < "$OUTDIR/trufflehog_secrets.json" 2>/dev/null || echo 0) findings"
else
  skip "trufflehog" "غير مثبّت"
fi

# ============================================================
#  الملخص
# ============================================================
echo ""
echo "==========================================="
echo "          HUNT SUMMARY"
echo "==========================================="
for f in all_subs live_urls all_urls urls_with_params katana_urls \
         nuclei_findings dalfox_xss kxss_reflections trufflehog_secrets.json; do
  p="$OUTDIR/$f"
  if [ -f "$p" ]; then
    printf "  %-28s %s\n" "$f" "$(wc -l < "$p")"
  fi
done
echo "==========================================="
echo "Done. Results in $OUTDIR/"
