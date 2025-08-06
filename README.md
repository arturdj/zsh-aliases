# Artur's Shell Aliases

A curated set of advanced shell aliases and functions for power users, focused on HTTP debugging, SSL inspection, DNS/CDN lookups, and especially for working with Azion CDN infrastructure. These tools are designed for macOS and integrate with common CLI utilities.

---

## Features

### 1. Differential cURL (`adcurlo`)
Run sequential cURL requests and view the differences between each run in real time.

- **Usage:**  
  `adcurlo <curl-args>`
- **What it does:**  
  - Loops cURL requests with your arguments.
  - Shows a side-by-side diff of the output between runs using `colordiff`.
  - Useful for debugging cache, CDN, or backend changes.
  - Converts line endings to avoid diff glitches.

### 2. Automatic cURL with Azion Features (`acurlo`)
Automate cURL requests with Azion-specific headers, output options, and interval control.

- **Usage:**  
  `acurlo [options] <curl-args>`
- **Options:**  
  - `-M <match>` or `--match <match>`: Set the header or string to match (default: `x-debug`).
  - `-o <file>` or `--output <file>`: Output cURL response to a file (default: `/dev/null`).
  - `-i <interval>` or `--interval <interval>`: Interval in seconds between requests (default: 5).
- **Features:**  
  - Repeats requests at a configurable interval.
  - Shows changes in the matched header value.
  - Notifies (with sound, via `say` on macOS) when the match changes.
  - Prints elapsed time, run count, and current match value.
  - All options use space-separated arguments (no `=`).

### 3. Quick cURL Shortcut (`curlo`)
A shortcut for running cURL with Azion debug headers.

- **Usage:**  
  `curlo <curl-args>`
- **What it does:**  
  - Runs `curl -v -H 'pragma: azion-debug-cache' -o /dev/null 2>&1`

### 4. Certificate Inspection (`certshow`, `certdns`)
Inspect SSL certificates and extract DNS names.

- **`certshow <domain> [ip]`**: Show full certificate details for a domain (optionally specify IP).
- **`certdns <domain> [ip]`**: List all DNS names from a certificate.

### 5. CDN and DNS Utilities

- **`searchcdn <domain>`**: Lookup DNS, reverse IP, and WHOIS info for a domain.
- **`azionip`**: Get Azion edge IP address (`a.map.azionedge.net`).
- **`azionipprev`**: Get Azion pre-production edge IP address (`lala.preview.map.azionedge.net`).
- **`azionstage`**: Find a responsive Azion staging server from a list (see `azion_stage_hosts.sh` for the list; tries each host and returns the first that responds on port 443 or 80).
- **`bestedge <ip>`**: Find the best Azion edge for a given IP (uses `dig` with `+subnet`).

### 6. Chrome Helper (`mychrome`)
Open a URL in Chrome with custom host resolver rules (useful for testing against specific IPs).

- **Usage:**  
  `mychrome <url> [ip]`
- **What it does:**  
  - Opens Chrome in incognito mode, mapping the target hostname to the given IP (or defaults to Azion preview IP).

### 7. Azion Edge Name Lookup (`azname`)
Find the Azion edge name for a given IP address using the SRE Manager API.

- **Usage:**  
  `azname [-v] <ip>`
- **What it does:**  
  - Looks up the edge name for the given IP.
  - With `-v`, prints detailed JSON info.

---

## Environment Variables

Some features depend on environment variables set in `azion_stage_hosts.sh`:

- `AZION_STAGE_HOSTS`: List of Azion staging hosts to probe (restricted access)
- `SRE_MANAGER_URL`: URL for Azion SRE Manager API (restricted access)

Source `azion_stage_hosts.sh` before using the aliases for full functionality, or export them manually.

---

## Requirements

- **macOS** (tested)
- [colordiff](https://www.colordiff.org/) (`brew install colordiff`)
- [coreutils](https://www.gnu.org/software/coreutils/) (`brew install coreutils`)
- [dig](https://linux.die.net/man/1/dig) (usually available by default)
- [openssl](https://www.openssl.org/)
- `say` (macOS, for notifications)
- `timeout` (from coreutils)
- [jq](https://stedolan.github.io/jq/) (for `azname`)

---

## Installation

1. Copy `artur_aliases.sh` to your home directory or a location of your choice.
2. Source it in your `.zshrc` or `.bashrc`:

   ```sh
   source ~/artur_aliases.sh
   ```

3. Install dependencies:

   ```sh
   brew install colordiff coreutils jq
   ```

---

## License

MIT License (see [LICENSE](LICENSE) file).

---

## Author

Artur Rossa
