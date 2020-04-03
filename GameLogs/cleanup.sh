#!/bin/bash
# This script processes the   files downloaded by the getlogs.sh script.
# When run the the directory containing the downloaded files, all the downloaded files are sanitised to
# obtain fixed size ids

directoryname=$1
cd $1
game_count=$(cat table.html |html2text |grep Select|grep -v Caller|grep -v name|wc -l)
echo $game_count
counter=1
while [ $counter -le $game_count ]
do
    FILENAME=$counter.html
    lynx -dump  $FILENAME |head -n 8|tail -n 6|perl -pe 's/♠/#/g'|perl -pe 's/♣/#/g'|perl -pe 's/♥/#/g'|perl -pe 's/♦/#/g'|cut -d '#' -f 1|cut -c 4- >game$counter.txt
    sed -i 's/[ \t]*$//' "game$counter.txt"
    sed -i 's/@/\\@/g' "game$counter.txt"
    echo $FILENAME game$counter.txt|shortnames
    lynx -dump output.html>clean$counter.txt
   
    ((counter++))
done
rm output.html
counter=1
while [ $counter -le $game_count ]
do
    echo -ne "Players \n \n";
    cat game$counter.txt|cut -c 1-4
    echo -ne "\nBid Information : "
    cat clean$counter.txt |head -n 1|perl -pe 's/.*Cards//g'| sed 's/^[ \t]*//;s/[ \t]*$//'|perl -pe 's/Bid.*//g'
    echo -ne "\nFinal Points : "
    cat clean$counter.txt |tail -n 1|cut -d ")" -f 7|sed 's/^[ \t]*//;s/[ \t]*$//'    
    ((counter++))
done
cd -

