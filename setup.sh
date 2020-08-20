#!/bin/bash
#
# Description: For building out VM based Kali Linux boxes. 
#
####> Add a splash of color

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

####> Useful Functions 

function installAPT() {
  arr=("$@")
  for j in "${arr[@]}";  do
    if [ $(apt-cache search ${j} | wc -l) -gt 0 ]; then
      if [ $(dpkg -s ${j} 2>/dev/null | grep Status | wc -l) -eq 0 ]; then
        echo -e "${YELLOW} [!] ${NC} Installing ${j}!"
        apt-get -y install ${j}
      else
        echo -e "${GREEN} [*] ${NC} ${j} is already installed"  
      fi
    else
      echo -e "${RED} [!!!] ${NC} ${j} cannot be installed using apt the method." 
    fi
  done
}

function gitClone() {
  arr=("$@")
  for k in "${arr[@]}"; do
    dirSTR=$(echo ${k} | sed 's/.*\///' | sed 's/\.git//')
    if [ -d /opt/${dirSTR} ]; then
      echo -e "${GREEN} [!] ${NC} Got ${dirSTR}"
    else
      echo -e "${YELLOW} [!] ${NC} Git'n ${k}"
      git clone https://github.com/${k} /opt/${dirSTR}
    fi
    dirSTR=""
  done
}

function installPIP() {
  arr=("$@")
  for l in "${arr[@]}";  do
    echo -e "${YELLOW} [!] ${NC} Installing ${l}!"
    pip install ${l}
  done
}

####> Not quite PTF, but its the tools I'm using 

#aptArray=(seclists curl enum4linux gobuster nbtscan nikto nmap onesixtyone oscanner smbclient smbmap smtp-user-enum snmp sslscan sipvicious tnscmd10g whatweb wkhtmltopdf)
#installAPT "${aptArray[@]}"

#aptArray=(python3 python3-pip)
#installAPT "${aptArray[@]}"

aptArray=("sealmindset/nmapAutomator" "vulnersCom/nmap-vulners" "rbsec/sslscan" "sullo/nikto" "rezasp/joomscan" "wpscanteam/wpscan" "droope/droopescan" "ShawnDEvans/smbmap" "portcullislabs/enum4linux" "darkoperator/dnsrecon" "quentinhardy/odat")
gitClone "${aptArray[@]}"

cp nmap-vulners/vulners.nse /usr/share/nmap/scripts/

#pipArray=(reconf python-nmap)
#installPIP "${pipArray[@]}"
