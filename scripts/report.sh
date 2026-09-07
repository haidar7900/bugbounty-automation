#!/bin/bash
# report.sh - يبني تقرير موحد من نتائج recon.sh و scan.sh
# Usage: ./report.sh <target>          → تقرير لهدف واحد
#        ./report.sh --all             → يجمع كل الأهداف الموجودة بـ config/h1_scopes.txt

set -uo pipefail

OUT_DIR="reports"
MODE="${1:-}"

build_target_report() {
  local target="$1"
  local detail="$OUT_DIR/detail_${target}.md"

  echo "# 🎯 Target: $target" > "$detail"
  echo "**Generated:** $(date)" >> "$detail"
  echo "" >> "$detail"

  local sub_count alive_count nuclei_count
  sub_count=$(wc -l < "$OUT_DIR/all_${target}.txt" 2>/dev/null || echo 0)
  alive_count=$(wc -l < "$OUT_DIR/alive_${target}.txt" 2>/dev/null || echo 0)
  nuclei_count=$(wc -l < "$OUT_DIR/nuclei_${target}.txt" 2>/dev/null || echo 0)

  echo "## 📊 Overview" >> "$detail"
  echo "- Subdomains found: **$sub_count**" >> "$detail"
  echo "- Alive hosts: **$alive_count**" >> "$detail"
  echo "- Nuclei findings: **$nuclei_count**" >> "$detail"
  echo "" >> "$detail"

  # ملفات نصية
  for f in all alive nuclei xsshunt dalfox kxss; do
    file="$OUT_DIR/${f}_${target}.txt"
    if [ -s "$file" ]; then
      echo "## 📄 $f" >> "$detail"
      echo '```' >> "$detail"
      cat "$file" >> "$detail"
      echo '```' >> "$detail"
      echo "" >> "$detail"
    fi
  done

  # ملفات JSON (نتايج الوكلاء)
  for f in onus noseyparker bugtrace darkwxlf pinakastra metatron strix reaper; do
    file="$OUT_DIR/${f}_${target}.json"
    if [ -s "$file" ]; then
      echo "## 🤖 $f" >> "$detail"
      echo '```json' >> "$detail"
      cat "$file" >> "$detail"
      echo '```' >> "$detail"
      echo "" >> "$detail"
    fi
  done

  echo "$target|$sub_count|$alive_count|$nuclei_count"
}

echo "📝 Building reports..."

if [ "$MODE" = "--all" ]; then
  SUMMARY="$OUT_DIR/SUMMARY.md"
  echo "# 🛡️ ULTIMATE BUG BOUNTY — SUMMARY" > "$SUMMARY"
  echo "**Date:** $(date)" >> "$SUMMARY"
  echo "" >> "$SUMMARY"
  echo "| Target | Subdomains | Alive | Nuclei Findings |" >> "$SUMMARY"
  echo "|---|---|---|---|" >> "$SUMMARY"

  while read -r target; do
    [ -z "$target" ] && continue
    line=$(build_target_report "$target")
    IFS='|' read -r t s a n <<< "$line"
    echo "| $t | $s | $a | $n |" >> "$SUMMARY"
  done < config/h1_scopes.txt

  echo "✅ Summary written to $SUMMARY"

elif [ -n "$MODE" ]; then
  build_target_report "$MODE" > /dev/null
  echo "✅ Report written to $OUT_DIR/detail_${MODE}.md"

else
  echo "❌ Usage: $0 <target>  |  $0 --all"
  exit 1
fi
