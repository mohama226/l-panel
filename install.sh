
فعلاً اسکلت اولیه:

```bash
#!/bin/bash

set -e


echo "================================="
echo "        L-PANEL INSTALLER"
echo "================================="


if [ -f /etc/os-release ]; then
    source /etc/os-release
else
    echo "Cannot detect operating system"
    exit 1
fi


echo "Detected OS:"
echo "$PRETTY_NAME"


case "$ID" in

ubuntu|debian)

    echo "Debian based system detected"

;;

almalinux|rocky|centos|rhel)

    echo "RedHat based system detected"

;;

*)

    echo "Unsupported operating system"
    exit 1

;;

esac
