
#grava webcam + audio
ffmpeg -f alsa -i hw:CARD=PCH,DEV=0 -f video4linux2 -i /dev/video0 -async 1 -acodec libmp3lame -y  -t 5 out.mpg


#Sincroniza pastas - muito útil!!!
rsync -av --rsh=ssh ./HD/Workspace/ davi@10.10.10.104:Workspace/


#Arquivos para execução automática
~/.bashrc -> executa quando terminal é aberto
/etc/rc.local -> executa na inicialização
/etc/init.d/script -> executa em um dos níveis do systemd. Precisa ser formatado de acordo.
	*update-rc.d $YOUR_SERVICE_NAME defaults

#Encontrar arquivos
find $path$ -name ""

#entrar no modo console
sudo systemctl set-default multi-user.target #modo terminal
sudo systemctl set-default graphical.target #modo gráfico


#wifi
iwconfig wlan0 ESSID key PASSWORD

#montanto meu HD no FSTAB
UUID=6FC29BD734B87866 /home/marcus/HD_Externo ntfs auto,nofail,rw,users,exec,uid=1000,gid=1000 0 0

#montando SSHFS no FSTAB
zandor@10.10.10.104:/ /home/zandor/Servidor  fuse.sshfs x-systemd.automount,_netdev,users,idmap=user,IdentityFile=/home/zandor/.ssh/id_rsa,allow_other,reconnect 0 0

#montagem de pasta usando mount
sudo mount --bind "$WORKSPACE_PATH" /home/davi/Workspace
sudo /home/zandor/pms-1.90.1/PMS.sh &
exit 0

---------------------------------------------------------------------------
Start ubuntu at command line

sudo update-grub
sudo systemctl enable multi-user.target --force
sudo systemctl set-default multi-user.target

#undo


sudo systemctl enable graphical.target --force
sudo systemctl set-default graphical.target 

---------------------------------------------------------------------------


# SSH Tunneling
primeiro IP é o primário "Servidor"
-L -> binda a porta '2201' na maquina local à maquina "10.10.10.123:22"

ssh -L 2201:10.10.10.123:22 davi@181.221.217.141

msm coisa mas nao abre terminal pro servidor (util pra scripts)

ssh -nNT -L 2201:10.10.10.123:22 davi@181.221.217.141 


## SSH Tunneling + systemd
```
script
#!/bin/bash
# cat /home/servidor-pd/tunnel.sh
ssh -NR 8082:localhost:22 -i /home/servidor-pd/.ssh/id_rsa ubuntu@18.224.71.174


arquivo do serviço
#cat /etc/systemd/system/tunnel.service
[Unit]
Description=Tunnel for remote access
After=network-online.target

[Service]
User=servidor-pd
ExecStart=/home/servidor-pd/tunnel.sh

[Install]
WantedBy=multi-user.target
```
------------------------------------------------------------------------

#wifi @ boot!
https://weworkweplay.com/play/automatically-connect-a-raspberry-pi-to-a-wifi-network/

# wpa_supplicant
 https://www.linuxbabe.com/command-line/ubuntu-server-16-04-wifi-wpa-supplicant


--------------
```
auto eth0
iface eth0 inet static
	address 192.168.0.3
	netmask 255.255.255.0

# FOR ROUTER
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf


#for hostapd
#allow-hotplug wlan0
#iface wlan0 inet static
#	address 192.168.1.1
#	netmask 255.255.255.0
#	network 192.168.1.0
#	broadcast 192.168.1.255

```
------------------

Network Commands
nmcli -> ferramenta
nmcli <--ask> con up uuid (id) 


------- webcam stream ------
#jpeg
gst-launch-1.0 v4l2src device=/dev/video0 ! image/jpeg,width=1280,height=720,framerate=30/1 ! jpegdec ! videoconvert ! xvimagesink
#raw
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw,width=1280,height=720 ! videoconvert ! xvimagesink

# UDP

#send raw 
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=160,height=120 ! jpegenc ! udpsink host=10.10.10.129 port=8888


#send jpeg
gst-launch-1.0 -v v4l2src device=/dev/video0 ! video/x-raw,width=160,height=120 ! jpegenc ! udpsink host=10.10.10.129 port=8888
-- ou --
gst-launch-1.0 -v v4l2src device=/dev/video0 ! image/jpeg,width=160,height=120 ! udpsink host=10.10.10.129 port=8888

#raw
gst-launch-1.0 -vv udpsrc port=8888 caps="video/x-raw,width=160,height=120"  ! videoconvert ! xvimagesink

#jpeg
gst-launch-1.0 -vv udpsrc port=8888 ! jpegdec  ! xvimagesink

#LAPTOP lid close / login / power config
/etc/systemd/logind.conf
