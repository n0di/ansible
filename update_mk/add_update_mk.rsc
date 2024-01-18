/system script
add dont-require-permissions=no name=update_mk owner=admin policy=\
ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon source="\
##\r\
\n##   Automatically upgrade RouterOS and Firmware\r\
\n##   https://github.com/massimo-filippi/mikrotik\r\
\n##\r\
\n##   script by Maxim Krusina, maxim@mfcc.cz\r\
\n##   based on: http://wiki.mikrotik.com/wiki/Manual:Upgrading_RouterOS\r\
\n##   created: 2014-12-05\r\
\n##   updated: 2019-01-26\r\
\n##   tested on: RouterOS 6.43.8 / multiple HW devices\r\
\n##\r\
\n########## Set variables\r\
\n## Update channel can take values before 6.43.8: bugfix    | current | development | release-candidate\r\
\n## Update channel can take values after  6.43.8: long-term | stable  | development | testing\r\
\n:local updChannel       \"long-term\"\r\
\n## Notify via Slack\r\
\n:local notifyViaSlack   false\r\
\n:global SlackChannel    \"#log\"\r\
\n## Notify via E-mail\r\
\n:local notifyViaMail    false\r\
\n:local email            \"your@email.com\"\r\
\n########## Upgrade firmware\r\
\n## Let's check for updated firmware\r\
\n:local rebootRequired false\r\
\n/system routerboard\r\
\n\r\
\n:if ( [get current-firmware] != [get upgrade-firmware]) do={\r\
\n\r\
\n   ## New version of firmware available, let's upgrade\r\
\n   ## Notify via Log\r\
\n   :log info (\"Upgrading firmware on router \$[/system identity get name] from \$[/system routerboard get current-firmware] to \$[/system routerboard get upgrade-firmware]\")\r\
\n   ## Notify via Slack\r\
\n   :if (\$notifyViaSlack) do={\r\
\n       :global SlackMessage \"Upgrading firmware on router *\$[/system identity get name]* from \$[/system routerboard get current-firmware] to *\$[/system routerboard get upgrade-firmware]*\";\r\
\n       :global SlackMessageAttachements  \"\";\r\
\n       /system script run \"Message To Slack\";\r\
\n   }\r\
\n   ## Notify via E-mail\r\
\n   :if (\$notifyViaMail) do={\r\
\n       /tool e-mail send to=\"\$email\" subject=\"Upgrading firmware on router \$[/system identity get name]\" body=\"Upgrading firmware on router \$[/system identity get name] from \$[/system routerboard get current-firmware] to \$[/system routerboard get upgrade-firmware]\"\r\
\n   }\r\
\n   ## Upgrade (it will no reboot, we'll do it later)\r\
\n   upgrade\r\
\n   :set rebootRequired true\r\
\n\r\
\n}\r\
\n\r\
\n\r\
\n########## Upgrade RouterOS\r\
\n\r\
\n## Check for update\r\
\n/system package update\r\
\nset channel=\$updChannel\r\
\ncheck-for-updates\r\
\n## Wait on slow connections\r\
\n:delay 15s;\r\
\n## Important note: \"installed-version\" was \"current-version\" on older Roter OSes\r\
\n:if ([get installed-version] != [get latest-version]) do={\r\
\n   ## Notify via Log\r\
\n   :log info (\"Upgrading RouterOS on router \$[/system identity get name] from \$[/system package update get installed-version] to \$[/system package update get latest-version] (channel:\$[/system package update get channel])\")\r\
\n   ## Notify via Slack\r\
\n   :if (\$notifyViaSlack) do={\r\
\n       :global SlackMessage \"Upgrading RouterOS on router *\$[/system identity get name]* from \$[/system package update get installed-version] to *\$[/system package update get latest-version] (channel:\$[/system package update get channel])*\";\r\
\n       :global SlackMessageAttachements  \"\";\r\
\n       /system script run \"Message To Slack\";\r\
\n   }\r\
\n\r\
\n   ## Notify via E-mail\r\
\n   :if (\$notifyViaMail) do={\r\
\n       /tool e-mail send to=\"\$email\" subject=\"Upgrading RouterOS on router \$[/system identity get name]\" body=\"Upgrading RouterOS on router \$[/system identity get name] from \$[/system package update get installed-version] to \$[/system package update get latest-version] (channel:\$[/system package update get channel])\"\r\
\n   }\r\
\n   ## Wait for mail to be sent & upgrade\r\
\n   :delay 15s;\r\
\n   install\r\
\n} else={\r\
\n    :if (\$rebootRequired) do={\r\
\n        # Firmware was upgraded, but not RouterOS, so we need to reboot to finish firmware upgrade\r\
\n        ## Notify via Slack\r\
\n        :if (\$notifyViaSlack) do={\r\
\n            :global SlackMessage \"Rebooting...\";\r\
\n            :global SlackMessageAttachements  \"\";\r\
\n            /system script run \"Message To Slack\";\r\
\n        }\r\
\n        /system reboot\r\
\n    } else={\r\
\n        # No firmware nor RouterOS upgrade available, nothing to do, just log info\r\
\n        :log info (\"No firmware nor RouterOS upgrade found.\")\r\
\n        ## Notify via Slack\r\
\n        :if (\$notifyViaSlack) do={\r\
\n            :global SlackMessage \"No firmware nor RouterOS upgrade found.\";\r\
\n            :global SlackMessageAttachements  \"\";\r\
\n            /system script run \"Message To Slack\";\r\
\n        }\r\
\n    }\r\
\n}"

