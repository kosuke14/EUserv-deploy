### Add WARP to EUserv IPV6, and get the WARP high-speed channel for free!

### One-click script project for Deji renewal (for beginners only): https://github.com/YG-tsj/EUservRenew

### Benefits of adding WARP to IPV6 only VPS:

1: Enable VPS with only IPV6 to access IPV4, put on WARP's IP, and become a dual-stack VPS!

2: Can basically hide the real IP of VPS!

3: Support proxy protocol direct connection to Telegram, support proxy protocol connection to soft router Openwrt various wall-breaking plug-ins!

4: Support applications such as Docker that originally required IPV4 support!

5: Accelerate the access speed of VPS to CloudFlare CDN nodes!

6: Avoid the problem of Google verification code required for the original VPS IP (currently it cannot be completely avoided)!

7: Replace NAT64/DNS64 solution, higher network efficiency!

#### Joint Oracle https://github.com/YG-tsj/CFWarp-Pro 
-------------------------------------------------------------------------------------------------------

### Only supports Debian 10/Ubuntu 20.04 system one-click comprehensive script
```
wget -N --no-check-certificate https://cdn.jsdelivr.net/gh/kosuke14/EUserv-deploy/wgmd.sh && chmod +x wgmd.sh && ./wgmd.sh
```
Enter script shortcut ```bash wgmd.sh```

#### Script 2: IPV4 is the IP assigned by WARP, IPV6 is the local IP of VPS

#### Script 3: IPV4 and IPV6 are both IPs assigned by WARP

#### Script 4: IPV6 is the IP assigned by WARP, no IPV4 (I guess no one will choose script 4 at present...)

- [Refresh Script](https://purge.jsdelivr.net/gh/YG-tsj/EUserv-warp/wgmd.sh)

----------------------------------------------------------------------------------------------------

#### Note: The IP filled in for domain name resolution must be the local IP of the VPS, and has nothing to do with the IP assigned by WARP!

#### Recommended to use Xray script project (mack-a): https://github.com/mack-a/v2ray-agent Note: Please test it yourself. In some areas or operators, Delivr does not support TCP, and can only choose CDN (WS protocol and gRPC protocol). The IP address is changed to a custom preferred IP, for example: icook.tw

#### Tip: The configuration file wgcf.conf and the registration file wgcf-account.toml have been backed up in the /etc/wireguard directory!
------------------------------------------------------------------------------------------------------------------------------

#### View the current statistics of WARP: ```wg```

------------------------------------------------------------------------------------------------------------- 
#### IPV6 VPS dedicated diversion configuration file (the following defaults to global IPV4 priority, IP, domain name customization, video tutorial will be updated later)
```
{ 
"outbounds": [
{
"tag":"IP6-out",
"protocol": "freedom",
"settings": {}
},
{
"tag":"IP4-out",
"protocol": "freedom",
"settings": {
"domainStrategy": "UseIPv4" 
}
}
],
"routing": {
"rules": [
{
"type": "field",
"outboundTag": "IP4-out",
"domain": [""] 
},
{
"type": "field",
"outboundTag": "IP6-out",
"network": "udp,tcp" 
}
]
}
}
``` 
---------------------------------------------------------------------------------------------------------

#### Related WARP process commands

Manually temporarily shut down the WARP network interface
```
wg-quick down wgcf
```
Manually open the WARP network interface 
```
wg-quick up wgcf
```

Start systemctl enable wg-quick@wgcf

Start systemctl start wg-quick@wgcf

Restart systemctl restart wg-quick@wgcf

Stop systemctl stop wg-quick@wgcf

Disable systemctl disable wg-quick@wgcf

-------------------------------------------------------------------------------------------------------

### TG group: https://t.me/joinchat/nrUoeEJV_9UxNDhl
### YouTube channel: https://www.youtube.com/channel/UCxukdnZiXnTFvjF5B5dvJ5w

---------------------------------------------------------------------------------------------------------

Thanks to P3terx and the original authors, reference source:

https://p3terx.com/archives/debian-linux-vps-server-wireguard-installation-tutorial.html

https://p3terx.com/archives/use-cloudflare-warp-to-add-extra-ipv4-or-ipv6-network-support-to-vps-servers-for-free.html

https://luotianyi.vc/5252.html

https://hiram.wang/cloudflare-wrap-vps/

Translated with Google
