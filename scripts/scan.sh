#!/bin/bash
echo "🚀 Starting Bug Bounty Scan on $(wc -l < config/targets.txt) targets"

mkdir -p reports logs

run_safe() {
    echo "[*] Running: $1"
    timeout 180 bash -c "$1" 2>&1 | tee -a logs/errors.log || {
        echo "[!] Command failed: $1 (continuing...)"
    }
}

while read target; do
    [ -z "$target" ] && continue
    echo "========================================"
    echo "🎯 Scanning: $target"
    echo "========================================"
    
    # 1. جمع النطاقات الفرعية
    echo "[1/3] Subfinder..."
    subfinder -d $target -silent -o reports/sub_${target}.txt || echo "Subfinder failed"
    
    # 2. إذا لم يجد subfinder أي شيء، نضيف الهدف الرئيسي يدوياً
    if [ ! -s reports/sub_${target}.txt ]; then
        echo "⚠️ No subdomains found, adding main target: $target"
        echo "$target" > reports/sub_${target}.txt
    fi
    
    # 3. فلترة النطاقات الحية
    echo "[2/3] Httpx..."
    httpx -l reports/sub_${target}.txt -silent -o reports/alive_${target}.txt || echo "Httpx failed"
    
    # 4. إذا لم يجد httpx أي host حي، نجبره على الهدف الرئيسي
    if [ ! -s reports/alive_${target}.txt ]; then
        echo "⚠️ No alive hosts found, forcing main target: $target"
        echo "$target" > reports/alive_${target}.txt
    fi
    
    # 5. مسح الثغرات بـ Nuclei
    echo "[3/3] Nuclei..."
    nuclei -l reports/alive_${target}.txt -severity low,medium,high,critical -o reports/nuclei_${target}.txt || echo "Nuclei failed"
    
    echo "✅ Done: $target"
    echo ""
done < config/targets.txt

echo "🎉 Scan completed! Check reports/ folder."
