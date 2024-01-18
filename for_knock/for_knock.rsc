/ip firewall filter add action=add-src-to-address-list address-list=knock1 address-list-timeout=20s chain=input comment=knock packet-size=111 protocol=icmp place-before=3
/ip firewall filter add action=add-src-to-address-list address-list=knock2 address-list-timeout=20s chain=input comment=knock2 packet-size=121 protocol=icmp src-address-list=knock1 place-before=3
/ip firewall filter add action=add-src-to-address-list address-list=knock3 address-list-timeout=20s chain=input comment=knock3 packet-size=141 protocol=icmp src-address-list=knock2 place-before=3
/ip firewall filter add action=add-src-to-address-list address-list=knock_ok address-list-timeout=5m chain=input comment=knock_ok packet-size=2 protocol=icmp src-address-list=knock3 place-before=3
/ip firewall nat add action=masquerade chain=srcnat comment="for_knock" ipsec-policy=out,none out-interface-list=WAN src-address-list=knock_ok
