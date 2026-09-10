#!/bin/bash
echo "=== TOOLS FOLDER AUDIT ==="
echo ""
for dir in tools/*/; do
  name=$(basename "$dir")
  if [ -d "${dir}.git" ] || [ -f "${dir}.git" ]; then
    url=$(git -C "$dir" remote get-url origin 2>/dev/null)
    if [ -n "$url" ]; then
      registered="NO"
      grep -q "path = tools/$name" .gitmodules 2>/dev/null && registered="YES"
      echo "[GIT REPO] $name"
      echo "   URL: $url"
      echo "   Registered in .gitmodules: $registered"
    else
      echo "[GIT REPO - NO REMOTE] $name (has .git but no origin)"
    fi
  else
    echo "[PLAIN FOLDER] $name (not a git repo)"
  fi
  echo ""
done
