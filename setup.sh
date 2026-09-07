#!/bin/bash
echo "🧠 Installing ULTIMATE Bug Bounty System (All Tools)"

sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap masscan redis

# ========== أدوات Go الأساسية ==========
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/OWASP/Amass/v3/...@master
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/hahwul/dalfox/v2@latest
go install -v github.com/Emoe/kxss@latest
go install -v github.com/Serdar715/xsshunt@latest
go install -v github.com/praetorian-inc/noseyparker@latest

# ========== أدوات Python (ذكاء اصطناعي) ==========
pip install --upgrade pip
pip install bbot aiptx riftor
pip install git+https://github.com/maverickaayush/ONUS.git
pip install git+https://github.com/ItAkIlA/recon_osint.git

# ========== Strix (وكيل استغلال) ==========
git clone https://github.com/usestrix/strix.git /tmp/strix
cd /tmp/strix && pip install -r requirements.txt
sudo cp /tmp/strix/strix /usr/local/bin/

# ========== Dark Wxlf (أتمتة متكاملة) ==========
git clone https://github.com/ibdtech/dark_wxlf.git tools/dark_wxlf
cd tools/dark_wxlf && pip install -r requirements.txt

# ========== BugTraceAI (وكيل اكتشاف) ==========
git clone https://github.com/BugTraceAI/BugTraceAI-CLI.git tools/bugtrace
cd tools/bugtrace && pip install -r requirements.txt

# ========== Pinakastra (توليد حمولات) ==========
git clone https://github.com/gh0x0st/Pinakastra.git tools/pinakastra
cd tools/pinakastra && pip install -r requirements.txt

# ========== METATRON (AI محلي بالكامل) ==========
git clone https://github.com/0xsuomin/METATRON.git tools/metatron
cd tools/metatron && pip install -r requirements.txt

# ========== Reaper (إطار اختبار شامل) ==========
git clone https://github.com/ghostsecurity/reaper.git tools/reaper

# ========== ott3rrhunt (استطلاع متكامل) ==========
git clone https://github.com/ott3rr-1/ott3rrhunt.git tools/ott3rrhunt
cd tools/ott3rrhunt && chmod +x install.sh && ./install.sh

# ========== BugBounty-Toolkit ==========
git clone https://github.com/Axke/bugbounty-toolkit.git tools/bugbounty-toolkit
cd tools/bugbounty-toolkit && pip install -r requirements.txt

# ========== theHarvester (OSINT) ==========
git clone https://github.com/laramies/theHarvester.git tools/theharvester
cd tools/theharvester && pip install -r requirements.txt

# ========== TruffleHog (بحث عن الأسرار) ==========
pip install truffleHog

# ========== تحديث قوالب Nuclei ==========
nuclei -update-templates

echo "export PATH=$PATH:$(go env GOPATH)/bin" >> $GITHUB_ENV
echo "✅ All tools installed successfully!"
