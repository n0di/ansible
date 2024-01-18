/system script
add dont-require-permissions=no name=backup owner=admin policy=\
ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source=":\
local saveRawExport true\r\
\n\r\
\n:local FTPServer \"***.***.***.***\"\r\
\n:local FTPPort 21\r\
\n:local FTPUser \"service-mikrotik\"\r\
\n:local FTPPass \"PASSWD\"\r\
\n:local FTPPath \"/\"\r\
\n\r\
\n:local ts [/system clock get time]\r\
\n:set ts ([:pick \$ts 0 2].[:pick \$ts 3 5].[:pick \$ts 6 8])\r\
\n\r\
\n:local ds [/system clock get date]\r\
\n:set ds ([:pick \$ds 7 11].[:pick \$ds 0 3].[:pick \$ds 4 6])\r\
\n\r\
\n:local fname ([/system identity get name].\"-\".\$ds.\"-\".\
\$ts)\r\
\n:local sfname (\"/\".\$fname)\r\
\n\r\
\nif (\$saveRawExport) do={\r\
\n /export file=(\$sfname.\".rsc\")\r\
\n :log info message=\"Raw configuration script export Finished\"\r\
\n}\r\
\n:delay 15s\r\
\n:local backupFileName \"\"\r\
\n\r\
\n:foreach backupFile in=[/file find] do={\r\
\n :set backupFileName (\"/\".[/file get \$backupFile name])\r\
\n :if ([:typeof [:find \$backupFileName \$sfname]] != \"nil\") do={\r\
\n /tool fetch address=\$FTPServer port=\$FTPPort src-path=\$backupFile\
Name user=\$FTPUser mode=ftp password=\$FTPPass dst-path=\"\$FTPPath/\$bac\
kupFileName\" upload=yes\r\
\n }\r\
\n}\r\
\n\r\
\n:delay 60s\r\
\n\r\
\n /file remove \$fname\r\
\n\r\
\n:log info message=\"Successfully removed Temporary Backup Files\"\r\
\n:log info message=\"Automatic Backup Completed Successfully\""


