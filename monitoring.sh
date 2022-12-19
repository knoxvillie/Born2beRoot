#!/bin/bash

# The architecture of your operating system and its kernel version.
arq=$(uname -mv)

# The number of physical processors
numcpu=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)

# The number of virtual processors.
numvpros=$(grep -c 'processor' /proc/cpuinfo)

# The current available RAM on your server and its utilization rate as a percentage.
avram=$(free --mega | grep 'Mem:' | awk '{printf "%d/%dMB (%.2f%%)", $3, $2, $3/$2 * 100}')

# The current available memory on your server and its utilization rate as a percentage.
avmem=$(df -Bm | awk 'NR>1 {used+=$3}{total+=$2} END{printf("%.f/%.fMB (%.2f%%)", used, total, (used/total)*100)}')

# The current utilization rate of your processors as a percentage.
ucpu=$(top -bn1 | sed -n '/PID/,$p' | awk 'NR>1 {var+=$9} END {printf("%.1f%%", var)}')

# The date and time of the last reboot.
rbot=$(uptime -s)

# Whether LVM is active or not.
lvm=$(lsblk | grep -c 'lvm' | awk '{var=$1; if(var>0) print"LVM is Up"; else print"LVM is Down"}')

# The number of active connections.
conec=$(ss -s | grep 'estab' | awk '{typ=$1;var=$4; printf("%s %d ESTABLISHED",typ, var)}' | tr -d ',')

# The number of users using the server.
userlog=$(who | wc -l)

# The IPv4 address of your server and its MAC (Media Access Control) address.
ipv4=$(hostname -I)
ipmac=$(awk '{print $1; exit}' /sys/class/net/*/address)

# The number of commands executed with the sudo program.
sud=$(grep -c 'COMMAND' /var/log/sudo/sudo_log)


wall "
	#Architecture	: $arq
	#CPU Physical	: $numcpu
	#vCPU		: $numvpros
	#Memory Usage	: $avram 
	#Disk Usage	: $avmem
	#CPU load	: $ucpu
	#Last boot	: $rbot
	#LVM use	: $lvm
	#Connections	: $conec
	#User log	: $userlog
	#Network	: IP $ipv4 ($ipmac)
	#Sudo		: $sud cmd(s)
"
