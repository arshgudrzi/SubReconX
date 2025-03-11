#!/bin/bash
# Optimized Automated Subdomain Enumeration Script

set -e  # Exit on error
set -o pipefail  # Catch pipeline errors

# Check for required tools
for tool in cewl dnsrecon host; do
    if ! command -v "$tool" &>/dev/null; then
        echo "Error: '$tool' is not installed. Install it and rerun the script."
        exit 1
    fi
done

# Get user input
read -p "Enter the target domain (e.g., example.com): " domain
domain=${domain,,} # Convert to lowercase

if [[ -z "$domain" ]]; then
    echo "No domain provided. Exiting."
    exit 1
fi

# Default URL for CEWL
default_url="https://$domain"
read -p "Enter the full URL for CEWL (default: $default_url): " url
url=${url:-$default_url}

# Filenames
words_file="${domain}_words.txt"
host_file="${domain}_hosts.txt"
final_file="${domain}_final_results.txt"
temp_crt="${domain}_crt.tmp"

# Run CEWL
echo "[+] Extracting words from $url with CEWL..."
cewl "$url" -w "$words_file" --quiet

if [[ ! -s "$words_file" ]]; then
    echo "[-] No words extracted from CEWL. Exiting."
    rm -f "$words_file"
    exit 1
fi

# DNS resolution with process limit
echo "[+] Resolving subdomains..."
rm -f "$host_file"

max_jobs=10  # Adjust this to control parallel execution
job_count=0

while IFS= read -r subdomain; do
    subdomain=$(echo "$subdomain" | xargs) # Trim spaces
    [[ -z "$subdomain" ]] && continue

    {
        result=$(host "$subdomain.$domain" 2>/dev/null)
        if echo "$result" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' &>/dev/null; then
            echo "$result" >> "$host_file"
        fi
    } &

    ((job_count++))
    if (( job_count % max_jobs == 0 )); then
        wait
    fi
done < "$words_file"

wait  # Ensure all background jobs complete

if [[ ! -s "$host_file" ]]; then
    echo "[-] No valid subdomains found via host lookup."
else
    echo "[+] Valid subdomains saved in $host_file."
fi

# Run DNSRecon
echo "[+] Running dnsrecon CRT search..."
dnsrecon -d "$domain" -k > "$temp_crt"

if [[ ! -s "$temp_crt" ]]; then
    echo "[-] DNSRecon failed or found no results. Skipping CRT search."
    rm -f "$temp_crt"
else
    echo "[+] DNSRecon results saved."
fi

# Merge and deduplicate results
echo "[+] Merging results and removing duplicates..."
awk '!seen[$0]++' "$host_file" "$temp_crt" 2>/dev/null > "$final_file"

# Cleanup temporary files
rm -f "$temp_crt"

echo "[✔] Subdomain enumeration completed! Results saved in $final_file."
