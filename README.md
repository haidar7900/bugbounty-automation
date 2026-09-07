<p align="center">
  <img src="https://readme-typing-svg.demolab.com?font=Fira+Code&weight=600&size=28&pause=1000&color=00FF00&center=true&vCenter=true&random=false&width=600&lines=🤖+ULTIMATE+Bug+Bounty+System;⚡+24%2F7+Auto-Hunt+with+AI;🛡️+50%2B+Powerful+Tools+Integrated" alt="Typing SVG" />
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Active-brightgreen?style=for-the-badge&logo=githubactions&logoColor=white" alt="Status">
  <img src="https://img.shields.io/badge/Tools-50%2B-blue?style=for-the-badge&logo=openbugbounty&logoColor=white" alt="Tools">
  <img src="https://img.shields.io/badge/AI-DeepSeek%20Powered-purple?style=for-the-badge&logo=ai&logoColor=white" alt="AI">
  <img src="https://img.shields.io/badge/Platform-GitHub%20Actions-black?style=for-the-badge&logo=github&logoColor=white" alt="Platform">
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License">
</p>

---

## 🧠 **What is this System?**

This is a **fully automated, AI-powered Bug Bounty pipeline** that runs **24/7** on GitHub Actions.  
It continuously:
- 🔍 **Fetches** targets from HackerOne (or uses public scopes).
- 🕵️ **Recons** subdomains using 10+ tools.
- 🤖 **Hunts** vulnerabilities using AI agents (Strix, Dark Wxlf, METATRON).
- ⚡ **Exploits** and generates **real PoC** (Proof of Concept).
- 📊 **Generates** a unified report and uploads it as an artifact.

> **Just add your H1 token, and let the system do the rest!** 🚀

---

## 🛠️ **Integrated Tools (50+ Powerful Tools)**

| Category | Tools | Count |
| :--- | :--- | :--- |
| **🌐 Reconnaissance** | Amass, Subfinder, Assetfinder, httpx, Katana, Gau, Waybackurls, theHarvester, ott3rrhunt, Recon-ng | 10+ |
| **🤖 AI Agents** | Strix (PoC), Dark Wxlf, BugTraceAI, Pinakastra (Payloads), METATRON (Local AI) | 5+ |
| **🔎 Scanning** | Nuclei, ONUS, Nosey Parker, TruffleHog (Secrets), GF, Httprobe | 6+ |
| **⚡ Exploitation** | Strix (Exploitation), Reaper, Metasploit (Optional), SQLmap (Optional) | 4+ |
| **🛡️ WAF Bypass** | XSSHunt (Cloudflare/Akamai bypass), Dalfox, KXSS, Chypass (AI) | 4+ |
| **📋 Reporting** | Agentic-Bug-Hunter, h1mcp (Draft reports), bbscope (Scope fetching) | 3+ |

---

## 🔄 **Workflow (How it works)**

```mermaid
graph TD
    A[Schedule or Manual Trigger] --> B[Fetch H1 Scopes or Public Targets]
    B --> C[Advanced Recon Amass Subfinder etc]
    C --> D[Filter Alive Hosts with httpx]
    D --> E[AI Powered Hunting Strix Dark Wxlf]
    E --> F[Exploitation and PoC Generation]
    F --> G[WAF Bypass and XSS Testing]
    G --> H[Generate Unified Report]
    H --> I[Upload to Artifacts]
    I --> J[Repeat Every 4 Hours]
p align="center">
  <b>Made with ❤️ by haidar7900</b><br>
  <sub>⚡ Keep hunting, stay ethical!</sub>
</p>
