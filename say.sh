#!/system/bin/sh
#say.sh

#Sending intent to tasker 
#am broadcast --user 0 -a net.dinglish.tasker.[task name] -e [variable name] "[value]" > /dev/null
am broadcast --user 0 -a net.dinglish.tasker.say -e var1 "$1" > /dev/null
