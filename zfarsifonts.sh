#!/bin/bash
# By fzerorubigd (http://cyberrabbits.net) & 733amir
# Install some Persian fonts (XB Series) and Tahoma on Linux
#
# if you do anything cool with it, let me know so I can publish or host it for you
# contact me at fzerorubigd {ATSIGN} gmail {DOT} com

function detect(){
  type -P $1  || { echo "Require $1 but not installed. Aborting." >&2; exit 1; }
}

function download() {
  rand="$RANDOM `date`"
  pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
  mkfifo $pipe
  wget -c -O$2 $1 2>&1 | while read data;do
    if [ "`echo $data | grep '^Length:'`" ]; then
      total_size=`echo $data | grep "^Length:" | sed 's/.*\((.*)\).*/\1/' |  tr -d '()'`
    fi
    if [ "`echo $data | grep '[0-9]*%' `" ];then
      percent=`echo $data | grep -o "[0-9]*%" | tr -d '%'`
      current=`echo $data | grep "[0-9]*%" | sed 's/\([0-9BKMG.]\+\).*/\1/' `
      speed=`echo $data | grep "[0-9]*%" | sed 's/.*\(% [0-9BKMG.]\+\).*/\1/' | tr -d ' %'`
      remain=`echo $data | grep -o "[0-9A-Za-z]*$" `
      echo $percent
      echo "#Downloading $3...\n$current of $total_size ($percent%)\nSpeed : $speed/Sec\nEstimated time : $remain"
    fi
  done > $pipe &

  wget_info=`ps ax |grep "wget.*$1" |awk '{print $1"|"$2}'`
  wget_pid=`echo $wget_info|cut -d'|' -f1 `

  zenity --progress --auto-close --text="Connecting...\n\n\n" --width="350" --title="Downloading"< $pipe
  if [ "`ps -A |grep "$wget_pid"`" ];then
    kill $wget_pid
  fi
  rm -f $pipe
}

function installFont(){
  gksu "mkdir -p /usr/share/fonts/truetype/$1"
  gksu "unzip -o -d /usr/share/fonts/truetype/$1 ./$2"
}

#
detect wget
detect zenity
detect gksu

# Address of toc file, I keep this file updated.
readonly URL="http://733amir.github.io/persian-fonts-linux/list"
readonly TOC="/tmp/list.txt"
readonly LIST="/tmp/ids"
cd ~
rm -f $TOC
download "$URL" "$TOC"
I=0
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
for i in `seq ${#fonts[@]}`
do
	echo FALSE
	echo "$i"
	echo "${fonts[i]}"
	TEMP=`echo "${desc[i]}" | tr -d '"' `
	echo "$TEMP"
done | zenity --list --checklist --hide-column=2 --column="#" --column="ID" --column="Font name" --column="Description" --title="List of available fonts." --text="List of available fonts, choose to download and install:" --width=650 --height=450 --separator="\n" > $LIST

cat $LIST | while read data;do
	download "${urls[data]}" "${filename[data]}" "${fonts[data]}"
	installFont "${fonts[data]}" "${filename[data]}"
done;

if [ -s $LIST ]; then
  rand="$RANDOM `date`"
  pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
  mkfifo $pipe
  gksu "fc-cache -f -v >$pipe" &
  cat $pipe |  while read data;do
	echo "#$data"
  done |  zenity --progress --pulsate --title="Refresh font cache" --text="Refresh font cache, please wait..." --auto-close --width="350"
  rm -f $pipe
fi

rm -f $TOC
rm -f $LIST
