<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&pause=1000&color=00FF00&center=true&vCenter=true&random=false&width=600&lines=%F0%9F%A4%96+ULTIMATE+Bug+Bounty+System;%E2%9A%A1+24%2F7+Auto-Hunt+with+AI;%F0%9F%9B%A1%EF%B8%8F+50%2B+Powerful+Tools+Integrated" alt="Typing SVG" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge&logo=githubactions&logoColor=white" alt="Status">
  <img src="https://img.shields.io/badge/Tools-50%2B-blue?style=for-the-badge" alt="Tools">
  <img src="https://img.shields.io/badge/AI-DeepSeek%20Powered-8A2BE2?style=for-the-badge" alt="AI">
  <img src="https://img.shields.io/badge/Platform-GitHub%20Actions-181717?style=for-the-badge&logo=github&logoColor=white" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
</p>

<p align="center">
  <img src="https://img.shields.io/github/stars/haidar7900/bugbounty-automation?style=social" />
  <img src="https://img.shields.io/github/forks/haidar7900/bugbounty-automation?style=social" />
  <img src="https://komarev.com/ghpvc/?username=haidar7900&label=Profile%20Views&color=0e75b6&style=flat" />
</p>

---

## What is this System?

This is a fully automated, AI-powered Bug Bounty pipeline that runs 24/7 on GitHub Actions.

It continuously:
- Fetches targets from HackerOne (or uses public scopes)
- Recons subdomains using 10+ tools
- Hunts vulnerabilities using AI agents (Strix, Dark Wxlf, METATRON)
- Exploits and generates real PoC (Proof of Concept)
- Generates a unified report and uploads it as an artifact

Just add your H1 token, and let the system do the rest.

---

## Integrated Tools (50+ Powerful Tools)

| Category | Tools | Count |
| :--- | :--- | :--- |
| Reconnaissance | Amass, Subfinder, Assetfinder, httpx, Katana, Gau, Waybackurls, theHarvester, ott3rrhunt, Recon-ng | 10+ |
| AI Agents | Strix (PoC), Dark Wxlf, BugTraceAI, Pinakastra (Payloads), METATRON (Local AI) | 5+ |
| Scanning | Nuclei, ONUS, Nosey Parker, TruffleHog (Secrets), GF, Httprobe | 6+ |
| Exploitation | Strix (Exploitation), Reaper, Metasploit (Optional), SQLmap (Optional) | 4+ |
| WAF Bypass | XSSHunt (Cloudflare/Akamai bypass), Dalfox, KXSS, Chypass (AI) | 4+ |
| Reporting | Agentic-Bug-Hunter, h1mcp (Draft reports), bbscope (Scope fetching) | 3+ |

---

## Workflow (How it works)

1. Schedule or Manual Trigger
2. Fetch H1 Scopes or Public Targets
3. Advanced Recon: Amass, Subfinder, etc.
4. Filter Alive Hosts with httpx
5. AI-Powered Hunting: Strix, Dark Wxlf
6. Exploitation and PoC Generation
7. WAF Bypass and XSS Testing
8. Generate Unified Report
9. Upload to Artifacts
10. Repeat Every 4 Hours

---

## Architecture

Targets (HackerOne) -> Recon (Subfinder, httpx) -> AI Hunt (Strix, METATRON, Nuclei) -> Report (PoC + MD Artifact)

---

## Quick Start

Clone the repo:
git clone https://github.com/haidar7900/bugbounty-automation.git
cd bugbounty-automation

Run setup:
chmod +x setup.sh
./setup.sh

Configure your HackerOne token:
export H1_TOKEN="your_token_here"

Run for a single target:
./scripts/validate.sh example.com && ./scripts/recon.sh example.com && ./scripts/scan.sh example.com && ./scripts/report.sh example.com

---

## Project Structure

bugbounty-automation/
- .github/workflows/  (CI/CD automation - GitHub Actions)
- config/  (Target configs and scopes)
- data/  (Subdomain lists and recon data)
- scripts/  (Core automation scripts: recon, scan, validate, report)
- tools/  (Integrated AI agents and external tools)
- reports/  (Generated scan reports)
- logs/  (Execution logs)
- setup.sh  (One-click environment setup)
- README.md

---

## Disclaimer

هذا المشروع مخصص للاستخدام على النطاقات المصرح بها فقط (Authorized Scopes) ضمن برامج Bug Bounty الرسمية (مثل HackerOne). استخدامه على أي هدف بدون إذن يعتبر مخالفة قانونية.

---

Made with love by haidar7900

Keep hunting, stay ethical.
