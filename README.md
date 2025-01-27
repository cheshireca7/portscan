# ~ Bash Port Scanner
Simple bash-native port scanner, because why not.
## Usage
> delay can be a range (i.e. 5-10)

`portscan [-d delay] [-r resolver] [-t threads] <ports>`
## Examples
- Scanning domains
```bash
$ echo scanme.nmap.org | ./portscan 22,80,443
```
- Scanning IPs
```bash
$ echo 192.168.{0..1}.{1..10} | tr ' ' '\n' | ./portscan -d 0-3 22,443-445,80
```
