# ~/.bash_logout: executed by bash(1) when login shell exits.

# when leaving the console clear the screen to increase privacy

if [ "$SHLVL" = 1 ]; then
    [ -x /usr/bin/clear_console ] && /usr/bin/clear_console -q
fi


if [[ $OS_TYPE = cygwin ]]
then
	ps |
	tail -n+2 |
	sed -re 's/  +/ /g' |
	cut -d ' ' -f2 |
	xargs.exe kill
fi

