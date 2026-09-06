#!/bin/bash
echo "🔧 Installing All Tools..."
pkg update -y && pkg upgrade -y
pkg install git golang python jq nmap -y
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
git clone https://github.com/Awarexone/Agentic-Bug-Hunter.git tools/Agentic-Bug-Hunter
git clone https://github.com/Btr4k/bugbounty-agent.git tools/hawkeye
echo "✅ All tools installed successfully!"
