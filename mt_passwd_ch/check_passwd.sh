#/bin/bash
sshpass -p 'PASSWD' ssh admin@$1 /system identity print >> check.log
