#!/bin/bash
# By fzerorubigd (http://cyberrabbits.net)
# Install some Persian fonts (XB Series) and Tahoma on Linux
#
# if you do anything cool with it, let me know so I can publish or host it for you
# contact me at fzerorubigd {ATSIGN} gmail {DOT} com
# You can use "axel" instead of default "wget", just install axel first and call this
# with axel parameter.


# Address of toc file, I keep this file updated.
readonly URL="http://fzerorubigd.github.com/persian-fonts-linux/list"
readonly TOC="/tmp/list.txt"

if [ $# -eq 0 ]; then
	DOWNLOADER=wget
	PARAMETER="-c"
	OUTPARAM="-O"
elif [ $1 == "wget" ]; then
	DOWNLOADER=$1
	PARAMETER="-c"
	OUTPARAM="-O"
elif [ $1 == "axel" ]; then
	DOWNLOADER=$1
	PARAMETER="-n 10 -a"
	OUTPARAM="-o"
else
	echo "Usage : $0 [axel|wget]"
	echo "defualt is wget"
	exit
fi
echo "Using $DOWNLOADER as downloader"
cd ~
rm -f $TOC
$DOWNLOADER $PARAMETER $URL $OUTPARAM $TOC
I=0
DL=0
declare -a downloaded
declare -a fonts
declare -a filename
declare -a urls
declare -a desc
OLD_IFS=$IFS
IFS=$'\n'
for nme in $(cat $TOC )
do
  I=$(( $I + 1 ))
  fonts[$I]=`echo $nme | cut -d'|' -f1`
  filename[$I]=`echo $nme | cut -d'|' -f2`
  urls[$I]=`echo $nme | cut -d'|' -f3`
  desc[$I]=`echo $nme | cut -d'|' -f4`
done
IFS=$OLD_IFS


QUIT="Quit"
ALL="All.."
I=$(( $I + 1 ))
fonts[$I]=$ALL
I=$(( $I + 1 ))
fonts[$I]=$QUIT

function mainmenu(){
	PS3="Your choice ($I for quit): "
	echo "Choose font to install or choose Quit"
	select fnt in ${fonts[*]};
	do
	  case $fnt in
		"$QUIT")
		return 0
		  break
		  ;;
		"$ALL")

		echo "All fonts are going to be downloaded..."
			for i in `seq ${#filename[@]}`
			do
				$DOWNLOADER $PARAMETER  ${urls[i]} $OUTPARAM ${filename[i]}
				DL=$(( $DL + 1 ))
				downloaded[$DL]=${filename[i]}
				sudo mkdir /usr/share/fonts/truetype/${fonts[i]}
				sudo unzip -o -d /usr/share/fonts/truetype/${fonts[i]} ~/${filename[i]}
			done
		return 0
		break
		  ;;
		*)
		LAST_REPLY=$REPLY
		echo ${desc[LAST_REPLY]}
		echo "Download and install??"
		PS3="Your choice : "
		select ans in yes no;
		do
			case $ans in
				"yes")
					$DOWNLOADER $PARAMETER ${urls[LAST_REPLY]} $OUTPARAM ${filename[LAST_REPLY]}
					DL=$(( $DL + 1 ))
					downloaded[$DL]=${filename[LAST_REPLY]}
					sudo mkdir -p /usr/share/fonts/truetype/$fnt
					sudo unzip -o -d /usr/share/fonts/truetype/$fnt ~/${filename[LAST_REPLY]}
					return 1
					break
		  		;;
				"no")
					return 1
					break
			esac
		done
		;;
	  esac
	done
}

function postaction(){
	clear
	if [ $DL -gt 0 ]; then
		echo "Delete downloaded files?"
		echo "IF YOU CHOOSE YES, ALL DOWNLOADED FILES IN YOUR HOME FOLDER WILL BE DELETED!!!"
		PS3="Your answer : "

		select ans in yes no;
		do
			case $ans in
				"yes")
					for i in `seq $DL`
					do
						rm -f ${downloaded[i]}
					done
				break
				;;
				"no")
				break
				;;
			esac
		done
		echo "Refresh font cache"
		sudo fc-cache -f -v >/dev/null
		echo "All done."
	fi
	rm -f $TOC
}

while true
do
	clear
	mainmenu
	return_val=$?
	if [ $return_val -eq 0 ]; then
		break
	else
		read -p "Press Enter to return to the menu..."
	fi
done

postaction
