#!/bin/bash
echo "🔥 Installing Exploitation & Bypass Tools..."

sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap

# ===== 1. أدوات المسارات والـ Fuzzing =====
go install -v github.com/ffuf/ffuf/v2@latest
pip install dirsearch

# ===== 2. أدوات تجاوز الحماية (WAF Bypass) =====
go install -v github.com/Serdar715/xsshunt@latest
go install -v github.com/hahwul/dalfox/v2@latest

# ===== 3. أدوات الاستغلال (Exploitation) =====
# Commix (حقن الأوامر)
git clone --depth 1 https://github.com/commixproject/commix.git tools/commix
# Strix (وكيل ذكاء اصطناعي للاستغلال)
git clone https://github.com/usestrix/strix.git tools/strix
cd tools/strix && pip install -r requirements.txt
cd ../..

# ===== 4. أدوات الفحص العميق =====
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
pip install aiptx

# تحديث قوالب Nuclei مع قوالب الاستغلال والتجاوز
nuclei -update-templates -silent

echo "export PATH=$PATH:$(go env GOPATH)/bin" >> $GITHUB_ENV
echo "✅ All exploitation tools installed!"
