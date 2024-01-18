




/system script remove update_mk

/import add_update_mk.rsc

/file remove add_update_mk.rsc

/system scheduler add name=update_mk on-event="system script run update_mk" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/09/2023 start-time=04:00:00

/system scheduler add name=update_mk_routerboard on-event="system script run update_mk" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/09/2023 start-time=04:30:00

/system scheduler add name=remove_all_scheduler on-event="system scheduler remove [/system scheduler find]" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=sep/09/2023 start-time=05:00:00

