# Artur's Shell Aliases

A collection of powerful shell aliases and functions for advanced cURL usage, SSL certificate inspection, DNS lookups, and more. These are tailored for power users, especially those working with Azion CDN, HTTP debugging, and network troubleshooting.

---

## Features

### 1. Differential cURL (`adcurlo`)
Run sequential cURL requests and see the differences between them in real time.

- **Usage:**  
  `adcurlo <curl-args>`
- **What it does:**  
  - Runs cURL requests in a loop.
  - Shows a side-by-side diff of the output between runs.
  - Highlights changes using `colordiff`.
  - Useful for debugging cache, CDN, or backend changes.

### 2. Automatic cURL with Azion Features (`acurlo`)
Automate cURL requests with Azion-specific headers and output options.

- **Usage:**  
  `acurlo [options] <curl-args>`
- **Options:**  
  - `-M=<match>` or `--match=<match>`: Set the header or string to match (default: `x-debug`).
  - `-o=<file>`: Output cURL response to a file (default: `/dev/null`).
- **Features:**  
  - Repeats requests at intervals (default: 5 seconds).
  - Shows changes in matched header values.
  - Notifies (with sound, via `say` on macOS) when the match changes.
  - Prints elapsed time and run count.

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
- **`azionip`**: Get Azion edge IP address.
- **`azionipprev`**: Get Azion pre-production edge IP address.
- **`azionstage`**: Find a responsive Azion staging server (tries a list of hosts and returns the first that responds on port 443).
- **`bestedge <ip>`**: Find the best Azion edge for a given IP (uses dig with +subnet).

### 6. Chrome Helper (`mychrome`)
Open a URL in Chrome with custom host resolver rules (useful for testing against specific IPs).

- **Usage:**  
  `mychrome <url> [ip]`
- **What it does:**  
  - Opens Chrome in incognito mode, mapping the target hostname to the given IP (or defaults to Azion preview IP).

---

## Requirements

- **macOS** (tested)
- [colordiff](https://www.colordiff.org/) (`brew install colordiff`)
- [coreutils](https://www.gnu.org/software/coreutils/) (`brew install coreutils`)
- [dig](https://linux.die.net/man/1/dig`) (usually available by default)
- [openssl](https://www.openssl.org/)
- `say` (macOS, for notifications)
- `timeout` (from coreutils)

---

## Installation

1. Copy `artur_aliases.sh` to your home directory or a location of your choice.
2. Source it in your `.zshrc` or `.bashrc`:

   ```sh
   source ~/artur_aliases.sh
   ```

3. Install dependencies:

   ```sh
   brew install colordiff coreutils
   ```

---

## License

MIT License (see [LICENSE](LICENSE) file).

---

## Author

Artur Rossa
