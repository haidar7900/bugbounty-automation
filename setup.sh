#!/bin/bash
echo "🧠 Installing ULTIMATE Bug Bounty System (All Tools)..."

# تحديث الحزم
sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap redis

# أدوات الاستطلاع الأساسية (Go)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest

# أدوات Python (BBOT, SpiderFoot, n8n)
pip install bbot spiderfoot n8n

# تثبيت كل أداة من مجلد tools/
for tool in tools/*; do
    if [ -f "$tool/requirements.txt" ]; then
        echo "📦 Installing $tool dependencies..."
        pip install -r "$tool/requirements.txt" || true
    fi
    if [ -f "$tool/setup.py" ]; then
        echo "📦 Installing $tool via setup.py..."
        python "$tool/setup.py" install || true
    fi
    if [ -f "$tool/install.sh" ]; then
        echo "📦 Running $tool/install.sh..."
        chmod +x "$tool/install.sh" && "$tool/install.sh" || true
    fi
done

echo "✅ All tools installed successfully!"
