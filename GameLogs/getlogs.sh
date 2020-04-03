#!/bin/bash
#This script downloads the logs from the site www.liveplayok.com
# Rewrite so that the script is more professional.
echo "Have you entered the table number?"
read TABLE_NO
DATE=$(date +"%m-%d-%Y-%H-%M")
echo $DATE


# Table url is a fixed string that depends only in the table number
TABLE_URL="www.liveplayok.com/WebForm56Score.aspx?plaingcardsTable_id=FS$TABLE_NO"

#OUTPUT_DIR_BASE is a variable which stores the base of the Logs files directory
OUTPUT_DIR_BASE="/home/ben/Work/Game56/Logs/"


TEMP_DIR="$OUTPUT_DIR_BASE$DATE"
mkdir -p $TEMP_DIR
OUTPUT_FILE="$TEMP_DIR/$TABLE_NO"

# Downloads the file at TABLE URL into the temporary OUTPUT FILE whose name is time dependent ( the time at which download was done)
wget -O $OUTPUT_FILE "$TABLE_URL"

#REF_NO Uniquely identifies the game played at the table. This is extracted from the downloaded OUTPUT FILE
REF_NO=$(cat $OUTPUT_FILE|grep option|grep selected|perl -pe 's/.*value="//g'|perl -pe 's/">.*//g')


echo "BENNY"
#A new directory is created into the OUTPUT_DIRECTORY_BASE with name $REF_NO and this director stores the details of games played at this table.
cd $OUTPUT_DIR_BASE
mkdir -p $REF_NO
cd -

GAMECOUNT=$(cat $OUTPUT_FILE|html2text|grep Select|grep -v Caller|grep -v name|wc -l) 
#GAMECOUNT=$(cat table.txt |cut -d " " -f 1|grep -x -E '[0-9]+'|wc -l)
echo $GAMECOUNT
#mv table.txt  $OUTPUT_DIR_BASE/$REF_NO/.
mv $OUTPUT_FILE $OUTPUT_DIR_BASE/$REF_NO/table.html

#DOWNLOAD ALL GAMECOUNT number of GAMES
counter=1
while [ $counter -le $GAMECOUNT ]
do
    #    GAME_URL="www.liveplayok.com/webformhistory56.aspx?plaingcardsTable_id=FS05&Plyno_History=$counter&RefNo=FS05-2020-04-02-15-42-45-254-7810"
    GAME_URL_A="www.liveplayok.com/webformhistory56.aspx?plaingcardsTable_id=FS$TABLE_NO"
    GAME_URL_B="&Plyno_History=$counter&RefNo=$REF_NO"
    GAME_URL="$GAME_URL_A$GAME_URL_B"
    echo $GAME_URL
    wget -O $counter.html "$GAME_URL"
    mv  $counter.html $OUTPUT_DIR_BASE/$REF_NO/.
    ((counter++))
done

#REMOVE THE OTHER FILES

echo "Removing"
rm -rf $TEMP_DIR




