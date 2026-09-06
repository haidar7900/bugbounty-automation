#!/bin/bash
echo "🔧 Installing All Tools..."

# تحديث الحزم
sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap

# أدوات الاستطلاع
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# الأدوات الأساسية (تنصب وقت التشغيل)
git clone https://github.com/Awarexone/Agentic-Bug-Hunter.git tools/Agentic-Bug-Hunter
git clone https://github.com/Btr4k/bugbounty-agent.git tools/hawkeye
git clone https://github.com/BugTraceAI/BugTraceAI-CLI.git tools/BugTraceAI-CLI
git clone https://github.com/RaheesAhmed/wp-hunter-mcp.git tools/wp-hunter-mcp
git clone https://github.com/usestrix/strix.git tools/strix

# أدوات إضافية
pip install aiptx riftor

echo "✅ All tools installed successfully!"
