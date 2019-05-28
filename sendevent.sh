#!/bin/bash

adbCmd="/home/zhaofengyi/Android/Sdk/platform-tools/adb -s 84B7N16902001772 shell"
outFolder=out
outputFiles=$1
logFile=`date +%Y%m%d_%H%M`.log

function executeFile() {
  cmdFinal="ls /system/bin/sh"
  for words in `cat $1`; do
    if [ $words = "sendevent" ]; then
      #echo $cmdFinal >> $logFile
      $adbCmd $cmdFinal
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
    echo "$outFile" >> $logFile
    executeFile $outFile
  done
}

# check network
function checkNetwork() {
  $adbCmd ping -c 3 -w 10 www.baidu.com >> $logFile 2>&1
  if [ $? = 0 ]; then
    echo "Network connected" >> $logFile
  else
    echo "Network disconnect" >> $logFile
    echo "Retry..." >> $logFile
    connectNetwork
    $adbCmd ping -c 3 -w 10 www.baidu.com >> $logFile 2>&1
    if [ $? = 0 ]; then
      echo "Network connected after retry" >> $logFile
    else
      echo "Network disconnect after retry" >> $logFile
      exit 1
    fi
  fi
}

function connectNetwork() {
  $adbCmd input keyevent KEYCODE_POWER
  sleep 3s
  $adbCmd input tap 730 2463
  sleep 3s
  $adbCmd am start -a android.settings.WIFI_SETTINGS
  sleep 5s
  $adbCmd input tap 500 700
  sleep 5s
  $adbCmd input tap 1000 785
  sleep 8s
  $adbCmd input tap 640 1535
  sleep 5s
  $adbCmd input keyevent KEYCODE_HOME
  sleep 2s
  $adbCmd input keyevent KEYCODE_POWER
}

#check adb
function checkAdb() {
  $adbCmd ls /system/bin/ls >> $logFile 2>&1
  if [ $? = 0 ]; then
    echo "adb connected" >> $logFile
  else
    echo "adb disconnect" >> $logFile
    exit 1
  fi
}

function daka() {
  $adbCmd input keyevent KEYCODE_POWER
  sleep 3s
  $adbCmd input tap 730 2463
  sleep 3s
  currentTime=`date +%Y%m%d_%H%M`
  $adbCmd screenrecord --time-limit 60 /sdcard/$currentTime.mp4 &
  $adbCmd input tap 140 450
  sleep 10s
  executeFile $outFolder/unlock
  sleep 3s
  $adbCmd input tap 1325 230
  sleep 3s
  $adbCmd input tap 740 1550
  sleep 3s
  $adbCmd input tap 705 2055
  sleep 2s
  $adbCmd input keyevent KEYCODE_BACK
  $adbCmd input keyevent KEYCODE_BACK
  $adbCmd input keyevent KEYCODE_BACK
  sleep 2s
  $adbCmd input keyevent KEYCODE_POWER
}

touch $logFile
sleepSecond=`echo $RANDOM 1 900|awk '{srand($1);printf "%d",rand()*10000%($3-$2)+$2}'`
echo "begin after "$sleepSecond >> $logFile

sleep ${sleepSecond}s

checkAdb
checkNetwork
daka

echo "end /sdcard/$currentTime.mp4" >> $logFile

















