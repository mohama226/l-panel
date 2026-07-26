#!/bin/bash

set -e

REPO="https://raw.githubusercontent.com/mohama226/l-panel/main"

bash <(curl -fsSL "$REPO/installer/install.sh")
