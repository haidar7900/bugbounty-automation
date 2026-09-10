#!/bin/bash
set -uo pipefail

echo "Installing ALL Advanced Bug Bounty Tools..."

run_step() {
  echo "RUNNING: $1"
  eval "$1" || echo "WARNING: step failed, continuing -> $1"
}

FAILED_TOOLS=()
OK_TOOLS=()

check_tool() {
  if command -v "$1" &> /dev/null; then
    OK_TOOLS+=("$1")
  else
    FAILED_TOOLS+=("$1")
  fi
}

export PATH=$PATH:$(go env GOPATH 2>/dev/null)/bin:$HOME/go/bin:/usr/local/bin:$HOME/.cargo/bin
mkdir -p "$(go env GOPATH 2>/dev/null || echo $HOME/go)/bin"

sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap masscan curl wget unzip ruby ruby-dev build-essential nodejs npm

echo ""
echo "=== [1/4] Installing Core Go Tools ==="
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/hahwul/dalfox/v2@latest
go install -v github.com/Emoe/kxss@latest

for t in subfinder httpx katana nuclei ffuf waybackurls assetfinder gf amass gau dalfox kxss; do
  check_tool "$t"
done

echo ""
echo "=== [2/4] Installing Python Base Tools ==="
pip install --upgrade pip --break-system-packages
run_step "pip install --break-system-packages bbot"
run_step "curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin"

echo ""
echo "=== [3/4] Auto-installing all tools/ submodules (generic detection) ==="

for dir in tools/*/; do
  name=$(basename "$dir")
  echo "--- $name ---"

  if [ -f "${dir}requirements.txt" ]; then
    run_step "pip install --break-system-packages -r '${dir}requirements.txt'"
  fi

  if [ -f "${dir}package.json" ]; then
    run_step "(cd '$dir' && npm install)"
  fi

  if [ -f "${dir}Gemfile" ]; then
    run_step "(cd '$dir' && bundle install)"
  elif [ "$name" = "ronin" ]; then
    run_step "gem install ronin-rb"
  fi

  if [ -f "${dir}install.sh" ]; then
    run_step "(cd '$dir' && chmod +x install.sh && ./install.sh)"
  fi

  if [ -f "${dir}setup.py" ]; then
    run_step "pip install --break-system-packages -e '$dir'"
  fi

  if [ -f "${dir}go.mod" ]; then
    echo "NOTE: $name is a Go module - build manually if needed: (cd $dir && go build ./...)"
  fi

  echo ""
done

echo ""
echo "=== [4/4] Updating Nuclei templates ==="
run_step "nuclei -update-templates -silent"

if ! grep -q "go env GOPATH" "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH=$PATH:$(go env GOPATH)/bin:$HOME/.cargo/bin' >> "$HOME/.bashrc"
fi
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "PATH=$PATH" >> "$GITHUB_ENV"
fi

echo ""
echo "=== INSTALL SUMMARY ==="
echo "OK: ${OK_TOOLS[*]:-none}"
echo "MISSING (check manually): ${FAILED_TOOLS[*]:-none}"
echo ""
echo "Setup finished."
