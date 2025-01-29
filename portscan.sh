#!/bin/bash

trap k SIGINT

nw=$(date "+%d%m%Y_%H%M%S")
k(){ echo -e "[\033[31mE\033[0m] Oh geez..." >&2; exit 1; }
d(){ [[ $1 =~ ${pr} ]] && echo $((RANDOM%(${1#*-}-${1%-*}+1)+${1%-*})) || echo "$1"; }; export -f d 
o(){ if ${o}; then [[ $1 == *"open" ]] && (echo "$1" | tee -a "${f}"); else (echo "$1" | tee -a "${f}"); fi; }
s(){ echo "${b[@]}" | (sed 's/ /\n/g'||true) | (shuf||true) | (xargs -P"${t}" -I{} bash -c $'timeout $2 bash -c \'</dev/tcp/{}\' &>/dev/null && (echo \'{} open\' | sed \'s/\//:/\') || (echo \'{} closed\' | sed \'s/\//:/\'); sleep $(d $1)' _ "${d}" "${w}"||true) | while read -r l; do o "${l}"; done; }
v(){ if [[ $1 =~ ${ir} ]]; then return 0; elif host -T "$1" "${r}" &>/dev/null; then return 0; else echo -e "[\033[31mE\033[0m] Failed to resolve $1" >&2; return 1; fi; }
l(){ for p in $(seq "$2" "$3"); do b+=("$1\/${p}"); done; }
p(){ IFS=',' read -ra ps <<< "$1"; for h in $(printf "%s\n" "${ips[@]}"); do v "${h}" && for p in "${ps[@]}"; do if [[ ${p} =~ ${pr} ]]; then l "${h}" "${p%-*}" "${p##*-}"; else l "${h}" "${p}" "${p}"; fi; done; done; s; }
c(){ IFS=/ read -r i m<<<"$1";IFS=. read -r a b c d<<<"${i}";i=$((a*256**3+b*256**2+c*256+d));s=$((32-m));n=$((2**s));b=$((i&~(n-1)));e=$((b+n-1));for((j=b+1;j<=e-1;j++)); do echo "$((j>>24&255)).$((j>>16&255)).$((j>>8&255)).$((j&255))"; done; }
u(){ echo -e "~ Bash Port Scanner\nUsage: $0 [-d <delay>] [-r <resolver>] [-t <threads>] [-w <timeout>] [-o show_open] [-f <output_file>] <ports>\nExample: echo scanme.nmap.org | $0 -d 5-10 20-25,80,443,8000-8008,445" && exit 1; }
while getopts "d:t:r:w:f:ho" opt; do case ${opt} in d) d=${OPTARG} ;; r) r=${OPTARG} ;; t) t=${OPTARG} ;; f) f=${OPTARG} ;; w) w=${OPTARG} ;; o) o=true;; h) u ;; *) u;; esac; done; shift $((OPTIND -1))
: "${d:=1}" "${t:=1}" "${w:=1}" "${o:=false}" "${f:=${nw}_portscan_results.txt}"

b=(); a=$1; ips=$(timeout 1 cat -)
nr='^[0-9]{1,}$'
pr='^[0-9]{1,5}-[0-9]{1,5}$'
ar='^[0-9]{1,5}(,[0-9]{1,5}|(-[0-9]{1,5}))?*$'
ir='^((25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2})$'
cr='^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9]?[0-9])/(3[0-2]|[1-2]?[0-9])$'
dp='7-9,13,21-26,37,53,79,80,81,88,100,106,110-113,119,135,139,143,144,179,199,389,427,443-445,465,513-515,543,544,548,554,587,631,636,646,873,990,993,995,1025-1029,1110,1433,1521,1720,1723,1755,1900,2000,2001,2049,2121,2717,3000,3128,3268,3269,3306,3389,3690,3986,4500,4899,5000,5009,5051,5060,5101,5190,5357,5432,5631,5666,5800,5900,5985,6000,6001,6646,6666-6669,7070,8000-8009,8080,8081,8443,8888,9100,9389,9999,10000,32768,47001,49152-49157'
[[ ! ${d} =~ ${pr} ]] && [[ ! ${d} =~ ${nr} ]] || [[ ! ${t} =~ ${nr} ]] || [[ ! ${w} =~ ${nr} ]] && u
[[ -z ${ips} ]] && echo -e "\n[\033[34mI\033[0m] Input AWOL!" >&2 && exit 1 
[[ -z ${r} ]] && echo -e "[\033[1;33mW\033[0m] No DNS specified. System DNS will be used!" >&2
[[ ${ips} =~ ${cr} ]] && echo -e "[\033[34mI\033[0m] Expanding CIDR..." >&2 && ips=$(c "${ips}")
[[ -n ${a} ]] && [[ ! ${a} =~ ${ar} ]] && echo -e "\n[\033[31mE\033[0m] Bad ports!" >&2 && exit 1 
echo -ne "[\033[34mI\033[0m] Scan started" >&2; [[ -z ${a} ]] && echo -n ". Scanning commom ports..." >&2 && a="${dp}"; echo>&2 && p "${a}"
echo -ne "\n[\033[34mI\033[0m] Scan finished" >&2; if [[ -s ${f} ]]; then sort -V "${f}" -o "${f}" && echo -e ". Results stored in ${f}" >&2; else rm -f "${f}" &>/dev/null; ${o} && echo ". No open ports" >&2 || echo>&2; fi
