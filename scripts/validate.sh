#!/bin/bash
# validate.sh - يتأكد إن الهدف ضمن النطاق المصرح به قبل أي فحص
# Usage: ./validate.sh <target>

set -uo pipefail

TARGET="${1:-}"
SCOPE_FILE="config/h1_scopes.txt"
BLACKLIST_FILE="config/blacklist.txt"   # نطاقات ممنوعة صراحة (out-of-scope) إن وجدت

if [ -z "$TARGET" ]; then
  echo "❌ Usage: $0 <target>"
  exit 1
fi

if [ ! -f "$SCOPE_FILE" ]; then
  echo "❌ Scope file not found: $SCOPE_FILE — refusing to scan without a scope list"
  exit 1
fi

# ===== 1. تحقق: الهدف موجود حرفياً بقائمة النطاق =====
if grep -qxF "$TARGET" "$SCOPE_FILE"; then
  IN_SCOPE=true
else
  # تحقق إضافي: هل الهدف هو subdomain لنطاق مسموح (مثال: api.example.com تحت *.example.com)
  IN_SCOPE=false
  while read -r allowed; do
    [ -z "$allowed" ] && continue
    # يدعم wildcard بصيغة *.example.com
    clean_allowed="${allowed#\*.}"
    if [[ "$TARGET" == "$clean_allowed" || "$TARGET" == *".$clean_allowed" ]]; then
      IN_SCOPE=true
      break
    fi
  done < "$SCOPE_FILE"
fi

# ===== 2. تحقق: الهدف مو موجود بقائمة سوداء (لو موجودة) =====
if [ -f "$BLACKLIST_FILE" ] && grep -qxF "$TARGET" "$BLACKLIST_FILE"; then
  echo "🚫 BLOCKED: $TARGET is explicitly out-of-scope (blacklist)"
  exit 2
fi

# ===== 3. النتيجة =====
if [ "$IN_SCOPE" = true ]; then
  echo "✅ IN-SCOPE: $TARGET"
  exit 0
else
  echo "🚫 OUT-OF-SCOPE: $TARGET — skipping (not found in $SCOPE_FILE)"
  exit 2
fi
