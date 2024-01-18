/ip firewall address-list remove [find where list~"ssh_stage*"]
/ip firewall nat 
add action=masquerade chain=srcnat dst-address=192.168.100.1 ipsec-policy=out,none out-interface-list=WAN
add action=masquerade chain=srcnat dst-address=192.168.1.1 ipsec-policy=out,none out-interface-list=WAN