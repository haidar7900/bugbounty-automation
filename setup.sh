#!/bin/bash
set +e  # لا يتوقف عند أي خطأ

echo "🔥 Installing ALL Powerful Tools (Recon, Exploitation, Bypass, Info Disclosure)"

# ===== 1. تحديث الحزم الأساسية =====
sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap massan curl wget unzip

# ===== 2. أدوات الاستطلاع (Recon) =====
echo "[1/6] Installing Recon Tools..."
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest 2>/dev/null
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest 2>/dev/null
go install -v github.com/projectdiscovery/katana/cmd/katana@latest 2>/dev/null
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest 2>/dev/null
go install -v github.com/tomnomnom/waybackurls@latest 2>/dev/null
go install -v github.com/tomnomnom/assetfinder@latest 2>/dev/null
go install -v github.com/OWASP/Amass/v3/...@master 2>/dev/null

# ===== 3. أدوات فحص المسارات وFuzzing =====
echo "[2/6] Installing Fuzzing & Path Discovery..."
go install -v github.com/ffuf/ffuf/v2@latest 2>/dev/null
pip install dirsearch 2>/dev/null
git clone https://github.com/maurosoria/dirsearch.git tools/dirsearch 2>/dev/null

# ===== 4. أدوات XSS و WAF Bypass =====
echo "[3/6] Installing XSS & WAF Bypass..."
go install -v github.com/hahwul/dalfox/v2@latest 2>/dev/null
go install -v github.com/Emoe/kxss@latest 2>/dev/null
# XSSHunt (بديل عبر git clone لأن go install قد يفشل)
git clone https://github.com/Serdar715/xsshunt.git tools/xsshunt 2>/dev/null
cd tools/xsshunt && go build -o xsshunt 2>/dev/null
sudo cp tools/xsshunt/xsshunt /usr/local/bin/ 2>/dev/null

# ===== 5. أدوات الاستغلال (Exploitation) =====
echo "[4/6] Installing Exploitation Tools..."
# Commix (حقن الأوامر)
git clone https://github.com/commixproject/commix.git tools/commix 2>/dev/null
sudo ln -s $PWD/tools/commix/commix.py /usr/local/bin/commix 2>/dev/null

# Strix (ذكاء اصطناعي للاستغلال)
git clone https://github.com/usestrix/strix.git tools/strix 2>/dev/null
cd tools/strix && pip install -r requirements.txt 2>/dev/null
sudo cp tools/strix/strix /usr/local/bin/ 2>/dev/null

# ===== 6. أدوات اكتشاف المعلومات الحساسة =====
echo "[5/6] Installing Info Disclosure Tools..."
# TruffleHog
pip install truffleHog 2>/dev/null
# Nosey Parker (إصدار مستقر)
go install -v github.com/praetorian-inc/noseyparker@latest 2>/dev/null

# ===== 7. أدوات الذكاء الاصطناعي =====
echo "[6/6] Installing AI Tools..."
pip install aiptx riftor 2>/dev/null
git clone https://github.com/0xsuomin/METATRON.git tools/metatron 2>/dev/null

# ===== 8. تحديث قوالب Nuclei (مع قوالب الاستغلال) =====
nuclei -update-templates -silent 2>/dev/null

# ===== 9. ضبط المسار PATH =====
echo "export PATH=$PATH:$(go env GOPATH)/bin" >> $GITHUB_ENV
echo "export PATH=$PATH:/usr/local/bin" >> $GITHUB_ENV

echo "✅ ALL tools installed successfully (some warnings are normal)"
