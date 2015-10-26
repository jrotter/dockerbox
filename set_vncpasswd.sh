#!/bin/sh

prog=/usr/bin/vncpasswd
mypass="Arm@d1LL0"

/usr/bin/expect <<EOF
spawn "$prog"
expect "Password:"
send "$mypass\r"
expect "Verify:"
send "$mypass\r"
expect "(y or n) ?"
send "$n\r"
expect eof
exit
EOF
