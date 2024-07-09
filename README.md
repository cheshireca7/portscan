# ~ Bash Port Scanner
Simple bash-native port scanner, because why not.
## Usage
`portscan [-d delay] [-r resolver] [-t threads] <ports>`
## Examples
```bash
$ echo scanme.nmap.org | portscan 22,80,443
[W] No DNS specified. System DNS will be used!
scanme.nmap.org:443 closed
scanme.nmap.org:22 open
scanme.nmap.org:80 open

[I] Results stored in /home/user/portscan
```
