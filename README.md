# PiHole custom motd - Welcome Banner / legal banner script

This script downloads a custom motd - Welcome Banner / legal banner for the PiHole, also optimized for 5.2inch screens
You can choose what you want to have

## Info
All of your clean files will be backed up:
- Old 10-uname in:        /etc/backup.$date.10-uname
- Old motd in:            /etc/backup.$date.motd
- Old sshd_config in:     /etc/ssh/backup.$date.sshd_config 
- Old issue.net in:       /etc/backup.$date.issue.net

![motd-PiHole](https://github.com/MxMarl/PiHole-motd/blob/master/motd.png)



![Legal Banner](https://github.com/MxMarl/PiHole-motd/blob/master/legal_banner.png)




## Installation
The simplest way, is to use the motd_helper.sh to install it directly via the Raspberry shell:
```
bash  <(curl -s https://raw.githubusercontent.com/MxMarl/PiHole-motd/master/motd_helper.sh)

```
 or alternative:
### for motd - Welcome Banner:
```
wget https://raw.githubusercontent.com/MxMarl/PiHole-motd/master/10-uname
sudo mv 10-uname /etc/update-motd.d/
sudo chmod +x /etc/update-motd.d/10-uname
sudo rm /etc/motd
sudo nano /etc/ssh/sshd_config  
```
Uncomment:
```
sudo nano /etc/ssh/sshd_config 
#PrintLastLog yes 
```
in 

```
PrintLastLog no 
```
or just with sed:
```
sudo sed -i 's/\#PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config 

```

restart sshd with:
``` 
sudo systemctl restart sshd
```


### for Legal Banner:
```
wget https://raw.githubusercontent.com/MxMarl/PiHole-motd/master/issue.net
sudo mv issue.net /etc/issue.net
```

Uncomment:
```
sudo nano /etc/ssh/sshd_config 
#Banner none
```
in 

```
Banner /etc/issue.net
```
or just with sed:
```
sudo sed -i 's/\#Banner none/Banner none/g' /etc/ssh/sshd_config 
sudo sed -i 's#Banner none#Banner /etc/issue.net#g' /etc/ssh/sshd_config 
```

restart sshd with:
``` 
sudo systemctl restart sshd
```

### Upcoming:
- More custom motd
- More custom legal banners

### License
MIT license; see LICENSE file.














