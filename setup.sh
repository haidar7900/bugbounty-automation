#!/bin/bash
echo "🧠 Installing ALL Bug Bounty Tools (Ultimate System)..."

# تحديث الحزم
sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap redis

# أدوات Go الأساسية
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest

# أدوات Python
pip install --upgrade pip
pip install aiptx riftor bbot

# تثبيت كل أداة من مجلد tools/
for tool in tools/*/; do
    if [ -f "${tool}requirements.txt" ]; then
        echo "📦 Installing ${tool} dependencies..."
        pip install -r "${tool}requirements.txt" || true
    fi
    if [ -f "${tool}setup.py" ]; then
        echo "📦 Installing ${tool} via setup.py..."
        python "${tool}setup.py" install || true
    fi
    if [ -f "${tool}install.sh" ]; then
        echo "📦 Running ${tool}install.sh..."
        chmod +x "${tool}install.sh" && "${tool}install.sh" || true
    fi
done

# تحديث قوالب Nuclei
nuclei -update-templates

echo "✅ All tools installed successfully!"
