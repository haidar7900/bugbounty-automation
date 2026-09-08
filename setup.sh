#!/bin/bash
echo "🧠 Installing core bug bounty tools..."

sudo apt update -y
sudo apt install -y git golang-go python3-pip jq

go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest

pip install aiptx riftor

nuclei -update-templates -silent

echo "export PATH=$PATH:$(go env GOPATH)/bin" >> $GITHUB_ENV
echo "✅ All core tools installed"
