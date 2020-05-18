#!/usr/bin/env bash

# Title.........:  motd_helper.sh
# Description...:  This script downloads a custom motd - Welcome Banner / legal banner for the PiHole
# Author........:  MxMarl
# Version.......:  1.0
# Usage.........:  see README

date=`date +'%Y%m%d-%H%M%S'`

NC="\033[0m"
Gray="\033[1;30m"
BRed="\033[1;31m"
BBlue="\033[1;34m"
BGreen="\033[1;32m"
BYellow="\033[1;33m"
info="${BYellow}[i]${NC}"
error="[${BRed}✗${NC}]"
tick="[${BGreen}✓${NC}]"
done="${BGreen} done!${NC}"

touch /tmp/error-motd_install.log
exec 2> /tmp/error-motd_install.log

restart_sshd(){
	echo -e "$info Restarting sshd"
	sudo systemctl restart sshd
	}

#Backup 10-uname
backup_10_uname() {
	echo -e "$info Making backup of 10-uname to /etc/update-motd.d/"
	sudo cp -r /etc/update-motd.d/10-uname /etc/backup.$date.10-uname 
	echo -e "$tick Done\n"
	}
	
#Backup sshd_config 
backup_sshd_config() {
	echo -e "$info Making backup of sshd_config to /etc/ssh/sshd_config"
	sudo cp -r /etc/ssh/sshd_config /etc/ssh/backup.$date.sshd_config 
	echo -e "$tick Done\n"
	echo -e "$info Making backup of motd to /etc/"
	sudo cp -r /etc/motd /etc/backup.$date.motd 
	echo -e "$tick Done\n"
	}
	
#Backup legal banner
backup_legal_banner() {
	echo -e "$info Making backup of legal banner to /etc/"
	sudo cp -r /etc/issue.net /etc/backup.$date.issue.net
	echo -e "$tick Done\n"
	}

#Download and Move 10-uname
custom_10_uname() {
	echo -e "$info Downloading 10-uname"
	wget https://raw.githubusercontent.com/MxMarl/PiHole-motd/master/10-uname
	echo -e "$tick Done\n"
	echo -e "$info Moving Custom Welcome Banner to /etc/update-motd.d/"
	sudo mv 10-uname /etc/update-motd.d/
	sudo chmod  +x /etc/update-motd.d/10-uname
	echo -e "$tick Done\n"
	}

#Download and Move legal banner
legal_ba() {
	echo -e "$info Downloading issue.net"
	wget https://raw.githubusercontent.com/MxMarl/PiHole-motd/master/issue.net
	echo -e "$tick Done\n"
	echo -e "$info Moving Legal Banner to /etc/issue.net"
	sudo mv issue.net /etc/
	echo -e "$tick Done\n"
	}

edit_sshd_Config_uname(){
	 sudo sed -i 's/\#PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config 
	}
	
edit_sshd_Config_banner(){
	sudo sed -i 's/\#Banner none/Banner none/g' /etc/ssh/sshd_config 
	sudo sed -i 's#Banner none#Banner /etc/issue.net#g' /etc/ssh/sshd_config 
	}

printf "\033c" 

while true;
do	
	echo -e "${BBlue} What do you want? [1]-Custom motd | [2]-Legal Banner | [3]-both | [4]-Exit\n${NC}"
	read -rp " > " choice

	case $choice in

		1) 
		backup_10_uname
		backup_sshd_config
		sudo rm /etc/motd
		custom_10_uname
		edit_sshd_Config_uname
		restart_sshd
		echo -e "$info All done, ByeBye!\nlog can be found at: /tmp/error-motd_install.log\n "
		exit 
		;;

		2)
		backup_legal_banner
		backup_sshd_config
		sudo rm -r /etc/issue.net
		legal_ba
		edit_sshd_Config_banner
		restart_sshd
		echo -e "$info All done, ByeBye!\nlog can be found at: /tmp/error-motd_install.log\n "
		exit 
		;;

		3)
		backup_10_uname
		backup_sshd_config
		backup_legal_banner
		sudo rm /etc/motd
		sudo rm /etc/issue.net
		custom_10_uname
		edit_sshd_Config_uname
		legal_ba
		edit_sshd_Config_banner
		restart_sshd
		echo -e "$info All done, ByeBye!\nlog can be found at: /tmp/error-motd_install.log\n "
		exit 
		;;

		4)
		echo -e "$info ByeBye!\n"
		exit 
		;;

		*)
		echo -e "$error Wrong input! Try again!\n"
		;;

	esac
	
done
