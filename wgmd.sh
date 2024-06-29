#!/usr/bin/env bash
export PATH=$PATH:/usr/local/bin

red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[36m\033[01m$1\033[0m"
}
white(){
    echo -e "\033[1;37m\033[01m$1\033[0m"
}

bblue(){
    echo -e "\033[1;34m\033[01m$1\033[0m"
}

rred(){
    echo -e "\033[1;35m\033[01m$1\033[0m"
}


	if [[ -f /etc/redhat-release ]]; then
		release="Centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="Debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="Ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="Centos"
    fi

if [ $release = "Centos" ]
	then
            red "Centos is unsupported, use Debian or Ubuntu."
      exit 1
	   fi
 
	if ! type curl >/dev/null 2>&1; then
	   yellow "curl is not installed, installing..."
           apt update && apt install curl -y 
           else
           green "curl is installed, continuing."
fi

        if ! type wget >/dev/null 2>&1; then
           yellow "wget is not installed, installing..."
           apt update && apt install wget -y 
           else
           green "wget is installed, continuing."
fi  
	   
bit=`uname -m`
version=`uname -r | awk -F "-" '{print $1}'`
main=`uname  -r | awk -F . '{print $1 }'`
minor=`uname -r | awk -F . '{print $2}'`
rv4=`ip a | grep global | awk 'NR==1 {print $2}' | cut -d'/' -f1`
rv6=`ip a | grep inet6 | awk 'NR==2 {print $2}' | cut -d'/' -f1`
op=`hostnamectl | grep -i Operating | awk -F ':' '{print $2}'`
vi=`hostnamectl | grep -i Virtualization | awk -F ':' '{print $2}'`


yellow " Your VPS:"
    white "------------------------------------------"
    blue " OS Name -$op "
    blue " OS Version - $version " 
    blue " CPU Architecture  - $bit "
    blue " VM Architecture Type -$vi "
    white " -----------------------------------------------" 
sleep 1s

warpwg=$(systemctl is-active wg-quick@wgcf)
case ${warpwg} in
active)
     WireGuardStatus=$(green "Running")
     ;;
*)
     WireGuardStatus=$(red "Not Running")
esac


v44=`ping ipv4.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v44} == "1" ]]; then
 v4=`wget -qO- -4 ip.gs` 
 WARPIPv4Status=$(curl -s4 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv4Status} in 
 on) 
 WARPIPv4Status=$(green "WARP is on, current IPv4 is: $v4 ") 
 ;; 
 off) 
 WARPIPv4Status=$(yellow "WARP is off, current IPv4 is：$v4 ") 
 esac 
else
WARPIPv4Status=$(red "There is no IPv4 address.")

 fi 

v66=`ping ipv6.google.com -c 1 | grep received | awk 'NR==1 {print $4}'`

if [[ ${v66} == "1" ]]; then
 v6=`wget -qO- -6 ip.gs` 
 WARPIPv6Status=$(curl -s6 https://www.cloudflare.com/cdn-cgi/trace | grep warp | cut -d= -f2) 
 case ${WARPIPv6Status} in 
 on) 
 WARPIPv6Status=$(green "WARP is on, current IPv6 is: $v6 ") 
 ;; 
 off) 
 WARPIPv6Status=$(yellow "WARP is off, current IPv6 is: $v6 ") 
 esac 
else
WARPIPv6Status=$(red "There is no IPv6 address.")

 fi 
 
Print_ALL_Status_menu() {
blue "-----------------------"
blue "WGCF Running status\t: ${WireGuardStatus}"
blue "IPv4 Network status\t: ${WARPIPv4Status}"
blue "IPv6 Network status\t: ${WARPIPv6Status}"
blue "-----------------------"
}

if [[ ${vi} == " lxc" ]]; then
green " ---Scanning VPS---> "

elif [[ ${vi} == " OpenVZ" ]]; then
green " ---Scanning VPS---> "

else
yellow " VM Architecture Type - $vi "
yellow " The VPS architecture is not supported for this, and the script installation will automatically exit. Hurry up and remind your friend to add your architecture!"
exit 1
fi

if [[ ${bit} == "x86_64" ]]; then

function w64(){

	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/kosuke14/EUserv-deploy/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/kosuke14/EUserv-deploy/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/\:\:\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " WARP has been started successfully detected！\n IPv4 address：$(wget -qO- -4 ip.gs) "
green " As shown above, the IPV4 address:  ............, that shows success! \n If there is no IP display above, it means failure!!"
}

function w646(){
	    
	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/kosuke14/EUserv-deploy/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/kosuke14/EUserv-deploy/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i 's/1.1.1.1/8.8.8.8,2001:4860:4860::8888/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*precedence[ ]*::ffff:0:0/96[ ]*100' /etc/gai.conf || echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
yellow " Detect whether the successful startup (IPV4+IPV6) dual-stack Warp! \n IPV4 address: $(wget -qO- -4 ip.gs) IPv6 one: $(wget -qO- -6 ip.gs) "
green " As shown above, the IPV4 address: 8. ............, IPV6 address: 2a09:............, it shows that it is successful! \n If the IPV4 above has no IP display and IPV6 displays the local IP, it means that it has failed!"
}

function w66(){

	if [ $release = "Debian" ]
	then
		apt install sudo -y && apt install curl sudo lsb-release iptables -y
                echo "deb http://deb.debian.org/debian $(lsb_release -sc)-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
                apt update -y
                apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	elif [ $release = "Ubuntu" ]
	then
		apt-get update -y &&  apt install sudo -y
		apt -y --no-install-recommends install openresolv dnsutils wireguard-tools
	fi
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgcf -O /usr/local/bin/wgcf
wget -N -6 https://cdn.jsdelivr.net/gh/YG-tsj/EUserv-warp/wireguard-go -O /usr/bin/wireguard-go
chmod +x /usr/local/bin/wgcf
chmod +x /usr/bin/wireguard-go
echo | wgcf register
until [ $? -eq 0 ]
do
sleep 1s
echo | wgcf register
done
wgcf generate
sed -i "5 s/^/PostUp = ip -6 rule add from $rv6 table main\n/" wgcf-profile.conf
sed -i "6 s/^/PostDown = ip -6 rule delete from $rv6 table main\n/" wgcf-profile.conf
sed -i 's/engage.cloudflareclient.com/2606:4700:d0::a29f:c001/g' wgcf-profile.conf
sed -i '/0\.0\.0\.0\/0/d' wgcf-profile.conf
sed -i 's/1.1.1.1/2001:4860:4860::8888,8.8.8.8/g' wgcf-profile.conf
cp wgcf-account.toml /etc/wireguard/wgcf-account.toml
cp wgcf-profile.conf /etc/wireguard/wgcf.conf
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
rm -f wgcf* wireguard-go*
grep -qE '^[ ]*label[ ]*2002::/16[ ]*2' /etc/gai.conf || echo 'label 2002::/16   2' | sudo tee -a /etc/gai.conf
yellow " Detected whether WARP has been successfully started！\n 显示IPV6地址：$(wget -qO- -6 ip.gs) "
green " If the IPV6 address is shown above: 2a09:............, it indicates success! \n If the local IP is displayed on IPV6 above, it means that it has failed! "
}


function cwarp(){
systemctl stop wg-quick@wgcf
systemctl disable wg-quick@wgcf
reboot
}

function owarp(){
systemctl enable wg-quick@wgcf
systemctl start wg-quick@wgcf
}

function macka(){
wget -P /root -N --no-check-certificate "https://raw.githubusercontent.com/mack-a/v2ray-agent/master/install.sh" && chmod 700 /root/install.sh && /root/install.sh
}

function phlinhng(){
curl -fsSL https://raw.staticdn.net/phlinhng/v2ray-tcp-tls-web/main/src/xwall.sh -o ~/xwall.sh && bash ~/xwall.sh
}

function eure(){
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/YG-tsj/EUservRenew/EuRe.sh && chmod +x EuRe.sh && ./EuRe.sh
}

function reboot(){
reboot
}

function status(){
systemctl status wg-quick@wgcf
}

function up4(){
wget -N --no-check-certificate https://raw.githubusercontent.com/kosuke14/EUserv-deploy/main/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
}

function up6(){
echo -e nameserver 2a00:1098:2c::1 > /etc/resolv.conf
wget -6 -N --no-check-certificate https://raw.githubusercontent.com/kosuke14/EUserv-deploy/main/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
}

#主菜单
function start_menu(){
    clear
    yellow " Details: https://github.com/kosuke14/EUserv-deploy" 
    
    red " Remember that to run this script again, run: bash wgmd.sh "
    
    white " ==================I. VPS-related adjustment selection (updating)==========================================" 
    
    
    
    white " ==================II. "wg mode" WARP function selection (updating)======================================"
    
    yellow " ----Number of native VPS IPs------------------------------------Add the location of WARP virtual IP--------------"
    
    green " 2. IPv6-only VPS                                  Add WARP Virtual IPv4               "
    
    green " 3. IPv6-only VPS                                  Add WARP Virtual IPV4 + Virtual IPV6       "
    
    green " 4. IPv6-only VPS                                  Add WARP Virtual IPv6               "
    
    white " ------------------------------------------------------------------------------------------------"
    
    green " 5. Permanently turn off the WARP function "
    
    green " 6. Automatically turn on the WARP function "
    
    green " 7. IPV4: Update the script "
    
    green " 8. No IPV4: Update the script "
    
    white " ==================III. Agent protocol script selection (updating)==========================================="
    
    green " 9. Use the mack-a script (supports Xray, V2ray) "
    
    green " 10. Use phlinhng script (supports Xray, Trojan-go, SS+v2ray-plugin) "
    
    white " ============================================================================================="
    
    green " 11. Restart the VPS instance and reconnect to SSH. "
    
    white " ===============================================================================================" 
    
    green " 0. Quit "
    Print_ALL_Status_menu
    echo
    read -p "Enter the number: " menuNumberInput
    case "$menuNumberInput" in
        2 )
           w64
	;;
        3 )
           w646
	;;
        4 )
           w66
	;;
	5 )
           cwarp
	;;
	6 )
           owarp
	;;
	7 )
           up4
	;;
	8 )
           up6
	;;
	9 )
           macka
	;;
	10 )
           phlinhng
	;;
	11 )
           reboot
	;;
        0 )
            exit 1
        ;;
    esac
}


start_menu "first"  


else
 yellow "This CPU architecture is not X86 or ARM! Ultraman architecture?"
 exit 1
fi
