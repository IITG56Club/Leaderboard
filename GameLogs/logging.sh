#!/bin/bash
# This program once given a table name, download the games for that table
# and sanitizes the data. The following data is obtained for each game
#
#  1. Game  Id         : This helps in fixing the order in which the games were played 
#  2. Competing Teams
#  3. Bid + Won /Loss
#
#  Game Id is the following format RefNo+timestring+gameindex
#  Ref No is the unique game id sanitised. The timestring is the time at which the game was downloaded.
#  Example FS1420200403-003024902266-0730-18 is to be understood as the game played on 2020 April 3rd
#  This particular game is the 18th game on the table number 14.
#
#  Competing Teams is a string of the form a1a2a3-b1b2b3 where ai and bi are the unique  4 digit (max)
#  identifier. The a's form a team and so does b's.
#
#  The Bid is a string of the form bidder+bidcount+double/redouble info +Win/Lose where bid is a number between 28 and 56 (both inclusive)
#  ,N indictating no double, D indicating Double and R indicating Redouble
#
#  Win or Loss is Indicated by W  or L respectively.
#
#  These  quantities  descirbed above will be given in a single comma separated line.
#  The table containing these values for all the games played is all that is
#  necessary for generating any type of score
#
# General Variables
DIR="/tmp/56games/"

#---------------------------------------------DOWNLOADING THE LOGS--------------------------------------------------------

TABLE_NO=$1
DATE=$(date +"%m-%d-%Y-%H-%M")
#echo $DATE


# Table url is a fixed string that depends only on the table number
TABLE_URL="www.liveplayok.com/WebForm56Score.aspx?plaingcardsTable_id=FS$TABLE_NO"

cd $DIR
mkdir -p tmp
cd $DIR/tmp
wget -o logfile -O $TABLE_NO.html  "$TABLE_URL"

#Extract Game Reference Number
REF_NO=$(cat $TABLE_NO.html|grep option|grep selected|perl -pe 's/.*value="//g'|perl -pe 's/">.*//g')
#echo $REF_NO

#Find the number of games played and download their logs
GAMECOUNT=$(cat $TABLE_NO.html|html2text|grep Select|grep -v Caller|grep -v name|wc -l) 
#echo $GAMECOUNT

counter=1
while [ $counter -le $GAMECOUNT ]
do
    GAME_URL_A="www.liveplayok.com/webformhistory56.aspx?plaingcardsTable_id=FS$TABLE_NO"
    GAME_URL_B="&Plyno_History=$counter&RefNo=$REF_NO"
    GAME_URL="$GAME_URL_A$GAME_URL_B"
    wget -o logfile -O game$counter.html "$GAME_URL"
    ((counter++))
done


#---------------------------------------------IDENTITY THE COMPETING TEAMS--------------------------------------------------------

counter=1
while [ $counter -le $GAMECOUNT ]
do
    FILENAME=game$counter.html
    lynx -dump  $FILENAME |head -n 8|tail -n 6|perl -pe 's/♠/#/g'|perl -pe 's/♣/#/g'|perl -pe 's/♥/#/g'|perl -pe 's/♦/#/g'|cut -d '#' -f 1|cut -c 4- >tempgame$counter.txt
    sed -i 's/[ \t]*$//' "tempgame$counter.txt"
    sed -i 's/@/\\@/g' "tempgame$counter.txt"
    echo $FILENAME tempgame$counter.txt|shortnames
    lynx -dump output.html>clean$counter.txt
    ((counter++))
done
rm output.html
counter=1


while [ $counter -le $GAMECOUNT ]
do
    GAMEID=$(echo $REF_NO|perl -pe 's/-//g')$counter#$DATE
    PLAYERS=$(cat tempgame$counter.txt|cut -c 1-4|perl -pe 's/\n/,/g')
    BIDDINGINFO=$(lynx -dump game$counter.html|grep -e Win -e Lost|tr -s ' '|cut -d ' ' -f 5-)
    echo -ne $GAMEID$PLAYERS
    echo -ne $BIDDINGINFO|bidstring
    ((counter++))
done
rm -rf *.txt
tar -czf $GAMEID.tar.gz *
rm -rf *.html logfile

cd ~-

