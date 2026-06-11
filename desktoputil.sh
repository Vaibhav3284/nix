#!/bin/bash
if [ "$1" == "bar" ]
then
	gbg='%{B#2aa198}%{F#FDF6E3}'
	dbg='%{B#FDF6E3}%{F#657B83}'
	while true
	do
		rbs=$(apm -b)
		rnetif="$(route -n get default | grep interface | cut -d' ' -f4)"
		if [ "$rnetif" == "" ]; then
		    netif="off"
		else
		    netif=$rnetif
		fi
		
		if [ "$netif" == "off" ]; then
			netssid="off"
		else
		        rnetssid="$(ifconfig ${netif} \
		    			| grep ssid \
					| sed -n 's/.*ssid \(.*\) channel.*/\1/p')"
			if [ "$rnetssid" == "" ]; then
			    netssid="none"
			else
			    netssid="conn"
		        fi
		fi
		if [ $rbs -eq 0 ]; then
			bs="high"
		elif [ $rbs -eq 1 ]; then
			bs="low"
		elif [ $rbs -eq 2 ]; then
			bs="critical"
		elif [ $rbs -eq 3 ]; then
			bs="charging"
		elif [ $rbs -eq 4 ]; then
			bs="unknown"
		elif [ $rbs -eq 255 ]; then
			bs="???"
		fi

		bat="$(apm -l)% ${bs}"
		net="${netssid} on ${netif}"
		clock="$(date +'%d/%m/%Y %H:%M' )"

		echo " ${bat} | ${net} | ${clock}"
		sleep 0.5
	done
elif [ "$1" == "shot" ]
then
    shotpath="screenshots/screenshot-$(date +'%d-%m-%Y_%H:%M:%S').png"
    if [ "$2" == "select" ]
    then
	grim -g "$(slurp)" $shotpath
    else
	grim $shotpath
    fi
    
	dunstify -i image-x-generic "Screenshot taken!" "Located at ${shotpath}"
elif [ "$1" == "rebuild" ]
then
    cd ~/.config/dwm
    alacritty -e sh build.sh
    dunstify -i computer "Rebuilt DWM!" "Press MS-q to quit, and relogin to see new changes!"
elif [ "$1" == "vol" ]
then
     if [ "$2" == "dec" ]
     then
	 mixer vol=-5%
	 nvol="$(mixer -o vol.volume | cut -d'=' -f2 | cut -d':' -f1)"
	 dunstify -i audio-volume-low -r 888 "Volume Decreased to ${nvol}"
     elif [ "$2" == "inc" ]
     then
	 mixer vol=+5%
	 nvol="$(mixer -o vol.volume | cut -d'=' -f2 | cut -d':' -f1)"
	 dunstify -i audio-volume-high -r 888 "Volume Increased to ${nvol}"
     fi    
elif [ "$1" == "bright" ]
then
     if [ "$2" == "dec" ]
     then
	 backlight - 5
	 nbri="$(backlight -q)"
	 dunstify -i computer -r 999 "Brightness Decreased" "Changed to ${nbri}%"
     elif [ "$2" == "inc" ]
     then
	 backlight + 5
	 nbri="$(backlight -q)"
	 dunstify -i computer -r 999 "Brightness Increased" "Changed to ${nbri}%"
     fi    
elif [ "$1" == "reconf" ]
then
    # soft reload
    pkill dunst && dunst & disown
    swaymsg reload
elif [ "$1" == "change-theme" ]
then
    ln -sf ~/.emacs.d/$2.el ~/.emacs.d/theme.el
    ln -sf ~/.config/dunst/$2 ~/.config/dunst/dunstrc
    ln -sf ~/.config/foot/$2.ini ~/.config/foot/theme.ini
    ln -sf ~/.config/sway/$2.theme ~/.config/sway/current.theme
    pkill dunst && dunst & disown
    pkill emacs && emacs --daemon
    swaymsg reload
fi
