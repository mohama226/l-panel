#!/bin/bash


BASE="/var/www/html/l-panel"

LOG="$BASE/update.log"

DATE=$(date "+%Y-%m-%d %H:%M:%S")


echo "==============================" 
echo " L-PANEL UPDATE"
echo "=============================="



cd $BASE || exit



echo "Checking current version..."

OLD=$(git rev-parse HEAD)



echo "Current commit:"
echo $OLD



echo ""
echo "Updating from Github..."
echo ""



git fetch origin



NEW=$(git rev-parse origin/main)



if [ "$OLD" = "$NEW" ]; then

echo "Already up to date."

echo "$DATE | No update" >> $LOG


exit

fi



echo "Calculating changed files..."

FILES=$(git diff --name-only $OLD $NEW)



COUNT=$(echo "$FILES" | wc -l)



echo ""
echo "Files to update: $COUNT"
echo ""



i=0



echo "$FILES" | while read file
do

i=$((i+1))

PERCENT=$((i*100/COUNT))


echo "[$PERCENT%] Updating: $file"


done



echo ""

echo "Pulling changes..."

git pull origin main



echo ""

echo "=============================="
echo "UPDATE COMPLETE"
echo "=============================="


echo ""

echo "Updated files:"


echo "$FILES"



echo ""

echo "Total files updated: $COUNT"



echo ""

echo "Update time:"
echo "$DATE"



echo ""

echo "$DATE | Updated $COUNT files" >> $LOG


echo "$DATE" > "$BASE/.last_update"

