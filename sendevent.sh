#!/bin/bash

outFolder=out
outputFiles=$1

echo "begin "$outputFiles


function executeFile() {
  cmdFinal="ls /system/bin/sh"
  for words in `cat $1`; do
    if [ $words = "sendevent" ]; then
      echo $cmdFinal
      adb shell $cmdFinal
      cmdFinal="sendevent "
    else
      cmdFinal=$cmdFinal$words" "
    fi
  done
}

function executeFiles() {
  OLD_IFS="$IFS"
  IFS=","
  arr=($outputFiles)
  IFS="$OLD_IFS"
  for file in ${arr[@]}
  do
    outFile=$outFolder/$file
    echo "$outFile"
    executeFile $outFile
  done
}

# check network
adb shell ping -c 3 www.baidu.com
if [ $? = 0 ]; then
  echo "Network connected"
else
  echo "Network disconnect"
fi


adb shell input keyevent KEYCODE_POWER
sleep 3s
adb shell input tap 730 2463
sleep 3s
currentTime=`date +%Y%m%d_%H%M`
adb shell screenrecord --time-limit 60 /sdcard/$currentTime.mp4 &
adb shell input tap 140 450
sleep 10s
executeFile $outFolder/unlock
sleep 3s
adb shell input tap 1325 230
sleep 3s
adb shell input tap 740 1550
sleep 3s
adb shell input keyevent KEYCODE_POWER

echo "end /sdcard/$currentTime.mp4"
