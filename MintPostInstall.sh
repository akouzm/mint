#!/bin/sh
# My super-duper Mint post-install script
# Last update 25/01/2024
# Available at:  https://raw.githubusercontent.com/akouzm/mint/master/MintPostInstall.sh

# swapfile size in MB
SWAPMB=1024

if [[ $EUID -ne 0 ]]; then
   echo "=-(( This script must be run as root. ))=-" 
   exit 1
fi

echo "$(date +%r) -- Starting script"

echo
echo "-//- Configuring aliases..."
#echo "for bigfiles in \"*\"; do du -ks \$bigfiles 2>/dev/null; done | sort -nr | head -10" >/usr/local/bin/fbf && chmod +x /usr/local/bin/fbf
# This fbf shows hidden dirs and works on all systems
echo "for bigfiles in \$(ls -a); do du -sk \$bigfiles 2>/dev/null; done | sort -nr | grep -vw \"..\" | grep -vw \".\" | head -10" >/usr/local/bin/fbf && chmod +x /usr/local/bin/fbf
echo "dpkg --get-selections | grep -v deinstall | awk '{print \$1}'" >/usr/local/bin/listpkgs && chmod +x /usr/local/bin/listpkgs

echo
echo "-//- Installing extra packages..."; sleep 1
apt install  \
linssid \
screenfetch \
vim \
audacious \
xfce4-goodies \
gparted \
keepassx \
mc \
ttf-mscorefonts-installer \
pv \
imwheel \
lsb-release \
scrot \
lunzip \
lzip \
guake \
hardinfo \
&& echo OK || echo ERROR

# Auto-accept eula
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

echo
echo "-//- Removing stuff we don't want...";sleep 1
apt remove firefox thunderbird && echo OK ||echo ERROR

echo
echo "-//- Installing third-party repos... (need to hit enter on each one)";sleep 1
#echo Chrome
#add-apt-repository "deb http://dl.google.com/linux/chrome/deb/ stable main" && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
echo
echo "Grub-Customizer"
add-apt-repository ppa:danielrichter2007/grub-customizer
echo
# actually install now
echo "Installing third-party packages..."
apt install grub-customizer #google-chrome-stable

echo
#echo "-//- Dropbox missing icon tweak...";sleep 1
#su -c 'dropbox stop && DBUS_SESSION_BUS_ADDRESS="" dropbox start' andrew
#/usr/local/bin/DropBoxIconFix

echo
# Completely disable IPv6 (see http://www.techrepublic.com/article/how-to-fix-the-slow-apt-get-update-issue-on-linux-machines/)
echo -n "-//- Disabling IPv6... "
echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf && service networking restart && echo OK || echo ERROR

echo
echo "Setting keyboard delay 200 and repeat rate 30"
xset r rate 200 30
#for userhome in /home/*; do echo "xset r rate 200 30" >>$userhome/.xinitrc

echo
#echo "-//- Configuring imwheel..."
#echo "\".*\"
#None,      Up,   Button4, 3
#None,      Down, Button5, 3
#Control_L, Up,   Control_L|Button4
#Control_L, Down, Control_L|Button5
#Shift_L,   Up,   Shift_L|Button4
#Shift_L,   Down, Shift_L|Button5
#
# The number after Button4 and Button5 dictates the Scroll Line Multiplier, or something. 3 seems ideal." >/root/.imwheelrc && echo "imwheel" >> /etc/rc.local

echo
# No longer needed - looks like a swap file is now the default in Mint, rather than a swap partition.
#echo "-//- Creating swapfile... ";sleep 0.5
#dd if=/dev/zero of=/swapfile bs=1048576 count=$SWAPMB && mkswap /swapfile && chown root:root /swapfile && chmod 0600 /swapfile && swapon /swapfile && echo OK || echo ERROR
# or...... fallocate -l ${SWAPMB}M && mkswap /swapfile && chown root:root /swapfile && chmod 0600 /swapfile && swapon /swapfile
#echo -n "Adding fstab entry... "
#echo "/swapfile      swap      swap      defaults      0 0" >> /etc/fstab && echo OK || echo ERROR
echo
#echo -n "-//- Decreasing swappiness (to 5).. "
#sed -i "s/^vm.swappiness=.*/vm.swappiness=5/g" /etc/sysctl.conf && echo OK || echo ERROR

#echo "-//- Creating pingrouter.sh"
#echo "echo [\$(ping -c 1 192.168.20.1 |grep time= |awk '{print \$7}' | cut -f2 -d=)ms]">/usr/local/bin/pingrouter.sh && chmod +x /usr/local/bin/pingrouter.sh

echo
echo "-//- Grabbing PingMonitor.sh"
wget -O /usr/local/bin/PingMonitor.sh https://raw.githubusercontent.com/akouzm/mint/master/PingMonitor.sh && chmod 755 /usr/local/bin/PingMonitor.sh

echo
echo -n "-//- Setting time to use RTC rather than UTC... "
timedatectl set-local-rtc 1 && echo OK || echo ERROR

echo
echo "Final things to do:

- Clock string for status bar widget: %k:%M %n %a %e/%m
- Go into Keyboard settings and set delay to 200 and repeat rate to 30
- Enable compiz: 
   - Alt-F2 -> compiz --replace
   - Session and startup -> Add -> compiz --replace
   - Start -> Desktop Settings -> Window Manager ?? "
echo
echo
echo "$(date +%r) -- Script completed"
