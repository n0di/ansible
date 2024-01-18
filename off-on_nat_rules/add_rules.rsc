/ip firewall address-list remove [find where list~"ssh_stage*"]
/ip firewall nat remove  [find where dst-address="192.168.8.1"]
/ip firewall nat 
add action=masquerade chain=srcnat dst-address=192.168.8.1 ipsec-policy=out,none out-interface-list=WAN