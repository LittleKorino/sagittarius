#!/system/bin/sh
#runTermuxCommandIntent.sh

am startservice -n com.termux/com.termux.app.RunCommandService   -a com.termux.RUN_COMMAND   --es com.termux.RUN_COMMAND_PATH $1   --ez com.termux.RUN_COMMAND_BACKGROUND 'true' 
