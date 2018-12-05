#!/bin/bash
#
# Title:      PGClone (A 100% PG Product)
# Author(s):  Admin9705
# URL:        https://plexguide.com - http://github.plexguide.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/keys.sh
source /opt/plexguide/menu/functions/keyback.sh
source /opt/plexguide/menu/functions/pgclone.sh
################################################################################
question1 () {
  touch /opt/appdata/plexguide/rclone.conf
  account=$(cat /var/plexguide/project.account)
  project=$(cat /var/plexguide/pgclone.project)
  project=$(cat /var/plexguide/pgclone.transport)
  gstatus=$(cat /var/plexguide/gdrive.pgclone)
  tstatus=$(cat /var/plexguide/tdrive.pgclone)
  transportdisplay

tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎 Welcome to PGClone                     reference:pgclone.plexguide.com
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1 - Data Transport Mode : [$transport]
2 - Google Account Login: [$account]
3 - Project Options     : [$project]
4 - Configure - gdrive  : [$gstatus]
5 - Configure - tdrive  : [$tstatus]
6 - Key Management      : [keysdeployed]
7 - Encryption Setup
Z - Exit
A - Deploy ~ $transport

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
read -p '🌍 Type Selection | Press [ENTER] ' typed < /dev/tty

  if [ "$typed" == "1" ]; then
  transportmode
  question1
elif [ "$typed" == "2" ]; then
  gcloud auth login
  echo "NOT SET" > /var/plexguide/pgclone.project
  question1
elif [ "$typed" == "3" ]; then
  projectmenu
  question1
elif [[ "$typed" == "Z" || "$typed" == "z" ]]; then
  exit
else
  badinput
  keymenu; fi
#menu later
inputphase
}

inputphase () {
  if [ "$type" == "tdrive" ]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: TeamDrive Identifer
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTES:
1. Type > td.plexguide.com
2. Select the TeamDrive
3. Within the URL, look for .../02CGnO4COUqr2Uk9PVF
4. Ending of the URL is your TeamDrive

Quitting? Type > exit
EOF
  read -p 'Type Identifer | PRESS [ENTER] ' public < /dev/tty
fi
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 System Message: Client Key
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

NOTES:
1. Type > td.plexguide.com
2. Select the TeamDrive
3. Within the URL, look for .../02CGnO4COUqr2Uk9PVF
4. Ending of the URL is your TeamDrive

Quitting? Type > exit
EOF

  read -p 'Client | PRESS [ENTER] ' public < /dev/tty
  read -p 'Secret | PRESS [ENTER] ' secret < /dev/tty

tee <<-EOF

Copy & Paste Url into the Browser & Login with the CORRECT Account!

https://accounts.google.com/o/oauth2/auth?client_id=$public&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/drive&response_type=code

EOF
  read -p 'Token | PRESS [ENTER] ' token < /dev/tty
  curl --request POST --data "code=$token&client_id=$public&client_secret=$secret&redirect_uri=urn:ietf:wg:oauth:2.0:oob&grant_type=authorization_code" https://accounts.google.com/o/oauth2/token > /opt/appdata/plexguide/pgclone.info

  accesstoken=$(cat /opt/appdata/plexguide/pgclone.info | grep access_token | awk '{print $2}')
  refreshtoken=$(cat /opt/appdata/plexguide/pgclone.info | grep refresh_token | awk '{print $2}')
  rcdate=$(date +'%Y-%m-%d')
  rctime=$(date +"%H:%M:%S" --date="$givenDate 60 minutes")
  rczone=$(date +"%:z")
  final=$(echo "${rcdate}T${rctime}${rczone}")

  testphase
}

# Reminder for gdrive/tdrive / check rclone to set if active, below just placeholder
variable /var/plexguide/project.account "NOT-SET"
variable /var/plexguide/pgclone.project "NOT-SET"
variable /var/plexguide/pgclone.transport "NOT-SET"
variable /var/plexguide/gdrive.pgclone "Not Active"
variable /var/plexguide/tdrive.pgclone "Not Active"

question1
