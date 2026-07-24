#!/bin/bash

PANEL="/var/www/html/l-panel"
LOG="$PANEL/update.log"
LAST="$PANEL/.last_update"

DATE=$(date "+%Y-%m-%d %H:%M:%S")


echo "=============================="
echo " L-PANEL UPDATE"
echo "=============================="


cd $PANEL || exit 1


echo "Fetching Github..."

git fetch origin


OLD=$(git rev-parse HEAD)

NEW=$(git rev-parse origin/main)


if [ "$OLD" = "$NEW" ]; then

echo "No updates available"

echo "$DATE | No update" >> $LOG

echo "$DATE" > $LAST

exit 0

fi



echo ""
echo "Detecting changed files..."
echo ""


FILES=$(git diff --name-only $OLD $NEW)


COUNT=$(echo "$FILES" | grep -c .)



echo "Files changed: $COUNT"
echo ""


NUMBER=0


while read file
do

NUMBER=$((NUMBER+1))

PERCENT=$((NUMBER*100/COUNT))


echo "[$PERCENT%] $file"


done <<< "$FILES"



echo ""

echo "Updating files..."


git pull origin main



echo ""

echo "=============================="
echo " UPDATE FINISHED"
echo "=============================="


echo ""

echo "Updated files:"
echo "$FILES"


echo ""

echo "Total:"
echo "$COUNT files"


echo ""

echo "Update time:"
echo "$DATE"



echo "$DATE | Updated $COUNT files" >> $LOG


echo "$DATE" > $LAST
