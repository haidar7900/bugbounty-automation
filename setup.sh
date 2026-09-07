#!/bin/bash
set -uo pipefail   # يوقف عند متغيرات غير معرّفة، ويكمل السكربت حتى لو أمر وحد فشل (نطبع تحذير بدل ما نطيح)

echo "🧠 Installing ULTIMATE Bug Bounty System (All Tools)"

# ===== دالة مساعدة: تنفذ أمر وتكمل حتى لو فشل =====
run_step() {
  echo "▶ $1"
  eval "$1" || echo "⚠️  WARNING: Step failed but continuing → $1"
}

# ========== 0. تصدير PATH أول شي (قبل أي استخدام لأدوات Go) ==========
export PATH=$PATH:$(go env GOPATH 2>/dev/null)/bin:$HOME/go/bin:$HOME/.cargo/bin
mkdir -p "$(go env GOPATH 2>/dev/null || echo $HOME/go)/bin"

# ========== 1. حزم النظام الأساسية ==========
sudo apt update -y
sudo apt install -y git golang-go python3-pip jq nmap masscan redis-server curl unzip build-essential

# تثبيت Rust/Cargo (مطلوب لبعض الأدوات مثل noseyparker)
if ! command -v cargo &> /dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
fi

# ========== 2. أدوات Go الأساسية ==========
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/ffuf/ffuf/v2@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/tomnomnom/gf@latest
go install -v github.com/tomnomnom/httprobe@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/hahwul/dalfox/v2@latest
go install -v github.com/Emoe/kxss@latest
go install -v github.com/sw33tLie/bbscope@latest          # ✅ كان ناقص بالكامل

# Amass — المسار الجديد بعد انتقال المشروع من OWASP
go install -v github.com/owasp-amass/amass/v4/...@master  # ✅ محدث من v3 القديم

# xsshunt — تأكد من الاسم الصحيح للمستودع، إذا فشل جرب النسخة البديلة
run_step "go install -v github.com/Serdar715/xsshunt@latest"

# noseyparker — أداة Rust وليست Go، تُبنى بـ cargo أو تُجلب كـ binary جاهز
echo "▶ Installing noseyparker (Rust tool, not Go)"
NOSEY_URL="https://github.com/praetorian-inc/noseyparker/releases/latest/download/noseyparker-linux-x86_64.tar.gz"
run_step "curl -sSL $NOSEY_URL -o /tmp/noseyparker.tar.gz && \
          tar -xzf /tmp/noseyparker.tar.gz -C /tmp && \
          sudo mv /tmp/noseyparker /usr/local/bin/noseyparker || \
          cargo install noseyparker"   # fallback لو الـ binary مو متوفر لهذا المعمار

# ========== 3. أدوات Python (ذكاء اصطناعي) ==========
pip install --upgrade pip --break-system-packages
run_step "pip install --break-system-packages bbot"
run_step "pip install --break-system-packages aiptx"
run_step "pip install --break-system-packages riftor"
run_step "pip install --break-system-packages git+https://github.com/maverickaayush/ONUS.git"
run_step "pip install --break-system-packages git+https://github.com/ItAkIlA/recon_osint.git"

# TruffleHog v3 (النسخة النشطة الحين — binary مو pip)
run_step "curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin"

# ========== 4. أدوات AI/استغلال (كل وحدة بـ subshell عشان ما تفسد الـ cd) ==========
mkdir -p tools

echo "▶ Installing Strix"
git clone https://github.com/usestrix/strix.git /tmp/strix
(
  cd /tmp/strix && pip install --break-system-packages -r requirements.txt
  # تأكد من وجود الملف قبل النسخ
  if [ -f "./strix" ]; then
    sudo cp ./strix /usr/local/bin/
  else
    echo "⚠️  strix binary not found at expected path — check repo structure manually"
  fi
)

echo "▶ Installing Dark Wxlf"
git clone https://github.com/ibdtech/dark_wxlf.git tools/dark_wxlf
( cd tools/dark_wxlf && pip install --break-system-packages -r requirements.txt )

echo "▶ Installing BugTraceAI"
git clone https://github.com/BugTraceAI/BugTraceAI-CLI.git tools/bugtrace
( cd tools/bugtrace && pip install --break-system-packages -r requirements.txt )

echo "▶ Installing Pinakastra"
git clone https://github.com/gh0x0st/Pinakastra.git tools/pinakastra
( cd tools/pinakastra && pip install --break-system-packages -r requirements.txt )

echo "▶ Installing METATRON"
git clone https://github.com/0xsuomin/METATRON.git tools/metatron
( cd tools/metatron && pip install --break-system-packages -r requirements.txt )

echo "▶ Installing Reaper"
git clone https://github.com/ghostsecurity/reaper.git tools/reaper

echo "▶ Installing ott3rrhunt"
git clone https://github.com/ott3rr-1/ott3rrhunt.git tools/ott3rrhunt
( cd tools/ott3rrhunt && chmod +x install.sh && ./install.sh )

echo "▶ Installing BugBounty-Toolkit"
git clone https://github.com/Axke/bugbounty-toolkit.git tools/bugbounty-toolkit
( cd tools/bugbounty-toolkit && pip install --break-system-packages -r requirements.txt )

echo "▶ Installing theHarvester"
git clone https://github.com/laramies/theHarvester.git tools/theharvester
( cd tools/theharvester && pip install --break-system-packages -r requirements.txt )

# ========== 5. تحديث قوالب Nuclei (الآن PATH صحيح من البداية) ==========
run_step "nuclei -update-templates -silent"

# ========== 6. تصدير PATH بشكل دائم لجلسات الطرفية القادمة ==========
if ! grep -q "go env GOPATH" "$HOME/.bashrc" 2>/dev/null; then
  echo 'export PATH=$PATH:$(go env GOPATH)/bin:$HOME/.cargo/bin' >> "$HOME/.bashrc"
fi

# ملاحظة: $GITHUB_ENV يشتغل بس داخل GitHub Actions، لذا نضيفه بأمان (يتجاهل الخطأ لو خارج CI)
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "PATH=$PATH" >> "$GITHUB_ENV"
fi

echo "✅ All tools installed (check warnings above for any skipped steps)"
