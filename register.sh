#!/bin/bash
set -u

declare -A TOOLS=(
  [BugTraceAI-CLI]="https://github.com/BugTraceAI/BugTraceAI-CLI.git"
  [Pentest-Agents]="https://github.com/H-mmer/pentest-agents.git"
  [all-in-one-recon]="https://github.com/PradyumnTiwareNexus/All-in-one-recon.git"
  [alnur]="https://github.com/Threads-Beams/ALNUR.git"
  [ars0n]="https://github.com/R-s0n/ars0n-framework-v2.git"
  [bb-toolkit]="https://github.com/0xpynge/bug-bounty-toolkit.git"
  [bugbounty-mcp]="https://github.com/gokulapap/bugbounty-mcp-server.git"
  [magicrecon]="https://github.com/robotshell/magicRecon.git"
  [reconaizer]="https://github.com/slehee/ReconAIzer.git"
  [reconbud]="https://github.com/tallaladnan/ReconBud.git"
  [ronin]="https://github.com/ronin-rb/ronin.git"
  [vulneramcp]="https://github.com/telmon95/vulneramcp.git"
  [vulscanner]="https://github.com/zeemscript/vulscanner.git"
  [webvulnscan]="https://github.com/ManishPanchal0199/Web-Application-Vulnerability-Scanner.git"
  [wp-hunter-mcp]="https://github.com/RaheesAhmed/wp-hunter-mcp.git"
)

echo "=== REGISTERING 15 EXISTING TOOLS AS SUBMODULES ==="
echo ""

SUCCESS=0
FAILED=0

for name in "${!TOOLS[@]}"; do
  url="${TOOLS[$name]}"
  path="tools/$name"
  echo "--- $name ---"
  if git submodule add "$url" "$path" 2>&1; then
    SUCCESS=$((SUCCESS+1))
  else
    FAILED=$((FAILED+1))
    echo "FAILED: $name"
  fi
  echo ""
done

echo "=== SUMMARY ==="
echo "Success: $SUCCESS"
echo "Failed: $FAILED"
echo ""
echo "=== git status ==="
git status
