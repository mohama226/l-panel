#!/usr/bin/env bash


wait_for_apt() {

    local count=0


    while fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1
    do

        count=$((count+1))

        echo "Waiting for apt lock ${count}/60"

        if [ $count -ge 60 ]; then
            echo "Apt locked too long."
            exit 1
        fi

        sleep 10

    done

}
