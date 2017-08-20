#!/bin/bash
# By fzerorubigd (http://cyberrabbits.net)
# Install some Persian fonts (XB Series) and Tahoma on Linux
#
# if you do anything cool with it, let me know so I can publish or host it for you
# contact me at fzerorubigd {ATSIGN} gmail {DOT} com
# You can use "axel" instead of default "wget", just install axel first and call this
# with axel parameter.

FONT_PATH="/home/$USER/.fonts/truetype/"
function detect(){
  type -P $1 >/dev/null  || { echo "Require $1 but not installed. Aborting." >&2; exit 1; }
}

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

detect $DOWNLOADER
detect unzip
detect sudo

echo "Using $DOWNLOADER as downloader"
cd ~
rm -f $TOC
echo "Downloading font list file..."
$DOWNLOADER $PARAMETER $URL $OUTPARAM $TOC 2>/dev/null
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
        echo "* All fonts are going to be install in '.fonts' directory in your home."
	echo "Choose which fonts should be install or choose to quit"
	select fnt in ${fonts[*]};
	do
	  case $fnt in
		"$QUIT")
		return 0
		  break
		  ;;
		"$ALL")

		echo "All fonts are going to be download..."
			for i in `seq ${#filename[@]}`
			do
                                echo "Downloading font ${filename[i]}..."
				$DOWNLOADER $PARAMETER  ${urls[i]} $OUTPARAM ${filename[i]}  2>/dev/null
				DL=$(( $DL + 1 ))
				downloaded[$DL]=${filename[i]}
				mkdir -p $FONT_PATH${fonts[i]}
				unzip -o -d $FONT_PATH${fonts[i]} ~/${filename[i]} 1>/dev/null
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
                                        echo "Downloading font ${filename[LAST_REPLY]}..."
					$DOWNLOADER $PARAMETER ${urls[LAST_REPLY]} $OUTPARAM ${filename[LAST_REPLY]} 2>/dev/null
					DL=$(( $DL + 1 ))
					downloaded[$DL]=${filename[LAST_REPLY]}
                                        mkdir -p $FONT_PATH$fnt
                                        unzip -o -d $FONT_PATH$fnt ~/${filename[LAST_REPLY]} 1>/dev/null
                                        echo "Font ${filename[LAST_REPLY]} has been installed"
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
		echo "Do you want to detele all fonts' archive files?"
		echo "If you choose yes, all downloaded files in your home folder will be deleted!!!"
		PS3="Your answer: "

		select ans in yes no;
		do
			case $ans in
				"yes")
                                        echo "Removing all font archive files..." 
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
		echo "Updating font cache..."
		fc-cache -f -v $FONT_PATH >/dev/null
		echo "Done!"
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
export IFS=$OLD_IFS
