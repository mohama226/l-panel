#!/usr/bin/env bash

set -Eeuo pipefail


SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"

SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

CLI_DIR="$(dirname "$SCRIPT_DIR")"


source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"


require_root


TMP_DIR=$(mktemp -d)

OLD_DIR="/opt/l-panel"

UPDATED_FILES=()

TOTAL_FILES=0
CURRENT_FILE=0
UPDATED_COUNT=0



cleanup(){

    rm -rf "$TMP_DIR"

}

trap cleanup EXIT



#########################################
# Calculate Hash
#########################################

file_hash(){

    sha256sum "$1" 2>/dev/null | awk '{print $1}'

}



#########################################
# Download
#########################################

download_update(){


    info "Downloading latest version..."


    curl -fsSL \
    https://github.com/mohama226/l-panel/archive/refs/heads/main.zip \
    -o "$TMP_DIR/update.zip"


    unzip -q "$TMP_DIR/update.zip" -d "$TMP_DIR"


    NEW_DIR=$(find "$TMP_DIR" -maxdepth 1 -type d -name "l-panel-*")


    if [[ -z "$NEW_DIR" ]]; then

        fail "Update package not found."

        exit 1

    fi


}



#########################################
# Count Files
#########################################

count_files(){


    TOTAL_FILES=$(find "$NEW_DIR" -type f | wc -l)


}



#########################################
# Update Files
#########################################

update_files(){


    info "Checking files..."

    echo


    while IFS= read -r NEW_FILE
    do


        RELATIVE="${NEW_FILE#$NEW_DIR/}"

        OLD_FILE="$OLD_DIR/$RELATIVE"


        ((CURRENT_FILE++))


        PERCENT=$((CURRENT_FILE * 100 / TOTAL_FILES))


        printf "\rProgress: %s%%" "$PERCENT"



        if [[ -f "$OLD_FILE" ]]; then


            OLD_HASH=$(file_hash "$OLD_FILE")

            NEW_HASH=$(file_hash "$NEW_FILE")



            if [[ "$OLD_HASH" != "$NEW_HASH" ]]; then


                UPDATED_FILES+=("$RELATIVE")

                ((UPDATED_COUNT++))


            fi


        else


            UPDATED_FILES+=("$RELATIVE")

            ((UPDATED_COUNT++))


        fi



        mkdir -p "$(dirname "$OLD_FILE")"


        cp -f "$NEW_FILE" "$OLD_FILE"



    done < <(find "$NEW_DIR" -type f)



    echo

}



#########################################
# Permission Fix
#########################################

fix_permission(){


chmod +x /opt/l-panel/cli/l-panel

chmod +x /opt/l-panel/cli/commands/*.sh


}



#########################################
# Report
#########################################

report(){


echo

echo "================================"

ok "Update Finished"

echo "================================"


echo

echo "Total files checked : $TOTAL_FILES"

echo "Updated files       : $UPDATED_COUNT"


echo


if (( UPDATED_COUNT > 0 )); then


    echo "Changed files:"

    echo


    for FILE in "${UPDATED_FILES[@]}"
    do

        echo " - $FILE"

    done


else

    echo "No changes detected."

fi



echo


save_last_update


echo "Update time:"

get_last_update


pause


}



#########################################
# Main
#########################################

main(){


title


download_update


count_files


update_files


fix_permission


report



}



main
