#!/bin/bash

outFolder=out
mkdir $outFolder
inputFile=$1
tempFile=$outFolder/temp_$1
outputFile=$outFolder/$1

echo "begin"

cp -rf $inputFile $tempFile
rm -rf $outputFile
sed -i -e "s/\/dev/sendevent \/dev/g" $tempFile
sed -i -e "s/event0:/event0/g" $tempFile

while read line
do
  pre1=`echo $line | cut -d " " -f1`
  pre2=`echo $line | cut -d " " -f2`
  num1org=`echo $line | cut -d " " -f3`
  num1=$((16#$num1org))
#  echo $num1org"->"$num1
  num2org=`echo $line | cut -d " " -f4`
  num2=$((16#$num2org))
#  echo $num2org"->"$num2
  num3org=`echo $line | cut -d " " -f5`
  num3=$((16#$num3org))
#  echo $num3org"->"$num3
  cmd=$pre1" "$pre2" "$num1" "$num2" "$num3
  echo $cmd
  echo $cmd >> $outputFile
done  < $tempFile

tail -1 $outputFile >> $outputFile

echo "end"
