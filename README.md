# ~ Bash Port Scanner
Simple bash-native port scanner, because why not.
## Usage
> delay can be a range (i.e. 5-10)

`portscan.sh [-d delay] [-r resolver] [-t threads] [-w timeout] [-o open] <ports>`
## Examples
- Scanning domains
```bash
$ echo scanme.nmap.org | ./portscan.sh 22,80,443
```
- Scanning CIDR
```bash
$ echo 192.168.0.0/24 | ./portscan.sh -d 0-3 22,443-445,80
```
- Show only open ports
```bash
$ echo 192.168.0.1 | ./portscan.sh -o 21,80,443
```
