# **SubReconX** 🚀

## **Overview**
SubReconX is an automated subdomain enumeration tool that combines **CEWL**, **host lookups**, and **DNSRecon** to efficiently discover active subdomains. It extracts words from the target website, generates subdomains, resolves them, and performs a CRT certificate search for additional findings. The final results are cleaned and deduplicated for better usability.

## **Features**
✅ **CEWL Word Extraction** – Extracts words from the target website to generate potential subdomains.  
✅ **Parallel Subdomain Resolution** – Uses `host` for efficient resolution with controlled concurrency.  
✅ **DNSRecon CRT Search** – Finds subdomains from SSL certificates.  
✅ **Automatic Deduplication** – Ensures a clean, unique list of subdomains.  
✅ **Error Handling** – Handles failures gracefully for a smooth user experience.  

## **Installation**
Ensure the required dependencies are installed:
```bash
sudo apt install cewl dnsrecon dnsutils -y
```

## **Usage**
Make the script executable and run it:
```bash
chmod +x subreconx.sh
./subreconx.sh
```
You will be prompted to enter:
1️⃣ **Target Domain** (e.g., `example.com`)  
2️⃣ **URL for CEWL Extraction** (defaults to `https://example.com`)  

The script will:
- Extract words from the website using CEWL.
- Generate and resolve subdomains using `host`.
- Perform a CRT certificate search with DNSRecon.
- Merge, clean, and deduplicate results.

## **Output Files**
- `example.com_words.txt` → Extracted words from CEWL  
- `example.com_hosts.txt` → Active subdomains from host lookups  
- `example.com_final_results.txt` → Final deduplicated subdomains  

## **Example Output**
```
[+] Extracting words from https://example.com with CEWL...
[+] Resolving subdomains...
[+] Running dnsrecon CRT search...
[+] Merging results and removing duplicates...
[✔] Subdomain enumeration completed! Results saved in example.com_final_results.txt
```

## **Disclaimer**
This tool is intended for **ethical security research** and **bug bounty** purposes only. Do not use it against systems you do not own or have explicit permission to test. The author is not responsible for any misuse of this tool.

## **License**
This project is open-source under the **MIT License**.

---

### **Contributions & Issues**
Feel free to contribute or report issues via GitHub! 🚀

