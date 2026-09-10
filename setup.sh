#!/bin/bash
set +e
echo "🔥 Installing ALL Advanced Bug Bounty Tools..."

sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap masscan curl wget unzip

# ===== 1. الأدوات الأساسية (Go) =====
echo "[1/8] Installing Core Go Tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null
go install -v github.com/projectdiscovery/katana/cmd/katana@latest 2>/dev/null
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null
go install -v github.com/ffuf/ffuf/v2@latest 2>/dev/null
go install -v github.com/tomnomnom/waybackurls@latest 2>/dev/null
go install -v github.com/tomnomnom/assetfinder@latest 2>/dev/null
go install -v github.com/tomnomnom/gf@latest 2>/dev/null
go install -v github.com/OWASP/Amass/v3/...@master 2>/dev/null
go install -v github.com/lc/gau/v2/cmd/gau@latest 2>/dev/null
go install -v github.com/hahwul/dalfox/v2@latest 2>/dev/null
go install -v github.com/Emoe/kxss@latest 2>/dev/null
go install -v github.com/sw33tLie/bbscope@latest 2>/dev/null

# ===== 2. أدوات Python =====
echo "[2/8] Installing Python Tools..."
pip install --upgrade pip 2>/dev/null
pip install aiptx riftor bbot truffleHog dirsearch 2>/dev/null
pip install git+https://github.com/maverickaayush/ONUS.git 2>/dev/null
pip install git+https://github.com/ItAkIlA/recon_osint.git 2>/dev/null

# ===== 3. Pinakastra (AI Exploitation) =====
echo "[3/8] Installing Pinakastra..."
cd tools/Pinakastra && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 4. ParamSpecter-Crawler =====
echo "[4/8] Installing ParamSpecter-Crawler..."
cd tools/ParamSpecter-Crawler && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 5. AIRecon =====
echo "[5/8] Installing AIRecon..."
cd tools/AIRecon && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 6. BugHawk AI =====
echo "[6/8] Installing BugHawk AI..."
cd tools/BugHawk-AI && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 7. DetectiveJoe =====
echo "[7/8] Installing DetectiveJoe..."
cd tools/DetectiveJoe && chmod +x install.sh && ./install.sh 2>/dev/null
cd ../..

# ===== 8. ReconSuite-AI =====
echo "[8/8] Installing ReconSuite-AI..."
cd tools/ReconSuite-AI && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 9. NoSQLMap =====
echo "[9/9] Installing NoSQLMap..."
cd tools/NoSQLMap && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 10. HexStrike AI =====
echo "[10/10] Installing HexStrike AI..."
cd tools/HexStrike-AI && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== 11. advanced-bugbounty-mcp =====
echo "[11/11] Installing advanced-bugbounty-mcp..."
cd tools/advanced-bugbounty-mcp && pip install -r requirements.txt 2>/dev/null
cd ../..

# ===== تحديث قوالب Nuclei =====
nuclei -update-templates -silent 2>/dev/null

# ===== ضبط المسار =====
echo "export PATH=$PATH:$(go env GOPATH)/bin:/usr/local/bin" >> $GITHUB_ENV

echo "✅ ALL tools installed successfully!"

# ===== chrome-agent (التفاعل مع Chrome) =====
echo "[12/12] Installing chrome-agent..."
# تثبيت الأداة عبر uv (موصى به) أو pip
if command -v uv &> /dev/null; then
    uv tool install chrome-agent
else
    pip install chrome-agent
fi
