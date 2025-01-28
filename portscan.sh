#!/bin/bash

trap k SIGINT

k() { echo -e "[\033[31mE\033[0m] Oh geez..."; exit 1; }
d() { [[ $1 =~ ${pr} ]] && echo $((RANDOM%(${1#*-}-${1%-*}+1)+${1%-*})) || echo "$1"; }; export -f d 
s(){ echo "${b[@]}" | sed 's/ /\n/g' | shuf | xargs -P"${t}" -I{} bash -c $'timeout $2 bash -c \'</dev/tcp/{}\' &>/dev/null && (echo \'{} open\' | sed \'s/\//:/\') || (echo \'{} closed\' | sed \'s/\//:/\'); sleep $(d $1)' _ "${d}" "${w}" | tee -a "${e}"; };
v(){ if [[ $1 =~ ${ir} ]]; then return 0; elif host -T "$1" "${r}" &>/dev/null; then return 0; else echo -e "[\033[31mE\033[0m] Failed to resolve $1"; return 1; fi; }
l(){ for p in $(seq "$2" "$3"); do b+=("$1\/${p}"); done; }
p(){ IFS=',' read -ra ps <<< "$1"; for h in $(printf "%s\n" "${ips[@]}"); do v "${h}" && for p in "${ps[@]}"; do if [[ ${p} =~ ${pr} ]]; then l "${h}" "${p%-*}" "${p##*-}"; else l "${h}" "${p}" "${p}"; fi; done; done; s; }
u(){ echo -e "~ Bash Port Scanner\nUsage: $0 [-d delay] [-r resolver] [-t threads] [-w <timeout>] <ports>\nExample: echo scanme.nmap.org | $0 -d 5-10 20-25,80,443,8000-8008,445" && exit 1; }
while getopts "d:t:r:w:h" opt; do case ${opt} in d) d=${OPTARG} ;; r) r=${OPTARG} ;; t) t=${OPTARG} ;; w) w=${OPTARG} ;; h) u ;; *) u;; esac; done; shift $((OPTIND -1))

: "${d:=1}" "${t:=1}" "${w:=1}"
b=(); a=$1; e="${PWD}/$(date "+%d%m%Y_%H%M%S")_portscan_results.txt"
ips=$(timeout 1 cat -)
nr='^[0-9]{1,}$'
pr='^[0-9]{1,5}-[0-9]{1,5}$'
ar='^[0-9]{1,5}(,[0-9]{1,5}|(-[0-9]{1,5}))?*$'
ir='^((25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2})\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9]{1,2})$'
[[ ! ${d} =~ ${pr} ]] && [[ ! ${d} =~ ${nr} ]] || [[ ! ${t} =~ ${nr} ]] || [[ ! ${w} =~ ${nr} ]] && u
[[ -z ${ips} ]] && echo -e "\n[\033[34mI\033[0m] Input AWOL!" && exit 1 
[[ -z ${r} ]] && echo -e "[\033[1;33mW\033[0m] No DNS specified. System DNS will be used!"
[[ -z ${a} ]] && echo -e "[\033[34mI\033[0m] Scanning commom ports..." && a='20-25,53,79,80,81,88,110,111,135,139,143,389,443,445,500,636,1433,1521,1723,2049,2121,3128,3268,3269,3306,3389,3690,4500,5432,5900,5985,6666-6669,8000,8008,8080,8443,8888,9100,9389,9999,10000,47001'; if [[ ${a} =~ ${ar} ]];then p "${a}"; else u; fi
if [[ -s ${e} ]]; then sort -V "${e}" -o "${e}" && echo -e "\n[\033[34mI\033[0m] Results stored in ${e}"; else rm -f "${e}" &>/dev/null; fi
