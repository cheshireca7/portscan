# ~ Bash Port Scanner
Simple bash-native port scanner, because why not.
## Usage
> delay can be a range (i.e. 5-10)

`portscan.sh [-d <delay>] [-r <resolver>] [-t <threads>] [-w <timeout>] [-o show_open] [-f <output_file>] <ports>`
## Examples
- Scanning common ports of single IP 
```bash
$ echo 192.168.0.1 | ./portscan.sh
```
- Scanning domain using custom resolver
```bash
$ echo scanme.nmap.org | ./portscan.sh -r 8.8.8.8 -w 5 22,80,443
```
- Scanning CIDR, 3 IPs per second
```bash
$ echo 192.168.0.0/24 | ./portscan.sh -t 3 -d 1 22,443-445,80
```
- Scanning list of IPs, store open ports in file
```bash
$ cat ips.txt | ./portscan.sh -f open.txt -o 22,445 
```
