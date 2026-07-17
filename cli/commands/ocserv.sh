#!/usr/bin/env bash

set -Eeuo pipefail


#############################################
# L-PANEL OCSERV INSTALLER
# Version: 1.5.0
#############################################


SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"
CLI_DIR="$(dirname "$SCRIPT_DIR")"


source "$CLI_DIR/lib/colors.sh"
source "$CLI_DIR/lib/common.sh"


require_root



#############################################
# Variables
#############################################


OCSERV_VERSION="1.5.0"

INSTALL_PREFIX="/usr"

CONFIG_DIR="/etc/ocserv"

CONFIG_FILE="$CONFIG_DIR/ocserv.conf"

SERVICE_FILE="/etc/systemd/system/ocserv.service"

SOURCE_DIR="/usr/local/src"

LP_CONFIG="/etc/l-panel"

INFO_FILE="$LP_CONFIG/ocserv.info"

PORT=""



#############################################
# Header
#############################################


clear

title


echo

echo "=============================================="

echo "        OCSERV INSTALLER"

echo "=============================================="

echo

echo "Version : $OCSERV_VERSION"

echo



#############################################
# Ask Port
#############################################


ask_port(){

    echo

    read -rp "Ocserv Port [443]: " PORT


    PORT=${PORT:-443}



    if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then

        fail "Invalid port"

        exit 1

    fi


    if [[ "$PORT" -lt 1 || "$PORT" -gt 65535 ]]; then

        fail "Port out of range"

        exit 1

    fi


}



#############################################
# Detect Package Manager
#############################################


detect_pm(){


    if command -v dnf >/dev/null 2>&1; then

        PM="dnf"


    elif command -v yum >/dev/null 2>&1; then

        PM="yum"


    else

        fail "Unsupported system"

        exit 1

    fi


}#############################################
# Install Dependencies
#############################################

install_dependencies(){

    info "Installing dependencies..."

    detect_pm


    $PM install -y epel-release || true

    $PM install -y dnf-plugins-core || true


    if command -v dnf >/dev/null 2>&1; then

        dnf config-manager --set-enabled crb || true

    fi



    info "Installing build tools..."


    $PM groupinstall -y "Development Tools"



    $PM install -y \
        meson \
        ninja-build \
        libev-devel \
        gperf \
        ipcalc \
        protobuf-c-devel \
        protobuf-c-compiler \
        gnutls-devel \
        readline-devel \
        pam-devel \
        libnl3-devel \
        libseccomp-devel \
        lz4-devel \
        krb5-devel \
        openssl-devel \
        gettext-devel \
        help2man \
        xz \
        wget \
        curl \
        tar \
        unzip \
        gcc \
        make \
        pkgconfig \
        certbot \
        gnutls-utils



    ok "Dependencies installed."

}



#############################################
# Check Existing Ocserv
#############################################


check_existing_ocserv(){


    if command -v ocserv >/dev/null 2>&1; then


        CURRENT=$(ocserv --version 2>/dev/null | head -1 || true)


        echo

        warn "Existing Ocserv detected"

        echo "$CURRENT"

        echo



        read -rp "Reinstall Ocserv? (y/n): " REINSTALL


        if [[ "$REINSTALL" != "y" ]]; then

            ok "Keeping existing installation."

            return 1

        fi


        systemctl stop ocserv 2>/dev/null || true


    fi


    return 0

}





#############################################
# Download Ocserv Source
#############################################


download_source(){


    info "Downloading Ocserv ${OCSERV_VERSION}..."


    cd "$SOURCE_DIR"



    rm -rf "ocserv-${OCSERV_VERSION}"

    rm -f ocserv.tar.xz



    wget \
    -q \
    "https://www.infradead.org/ocserv/download/ocserv-${OCSERV_VERSION}.tar.xz" \
    -O ocserv.tar.xz



    if [[ ! -f ocserv.tar.xz ]]; then

        fail "Download failed"

        exit 1

    fi



    tar -xf ocserv.tar.xz



    if [[ ! -d "ocserv-${OCSERV_VERSION}" ]]; then

        fail "Source extraction failed"

        exit 1

    fi



    ok "Source downloaded."

}




#############################################
# Build Ocserv
#############################################


build_ocserv(){


    cd "$SOURCE_DIR/ocserv-${OCSERV_VERSION}"



    info "Configuring build..."



    rm -rf build



    meson setup build \
        --prefix="$INSTALL_PREFIX" \
        --sysconfdir=/etc/ocserv



    info "Compiling..."



    meson compile -C build



    info "Installing..."



    meson install -C build



    ldconfig



    if ! command -v ocserv >/dev/null 2>&1; then

        fail "Ocserv binary not found"

        exit 1

    fi



    ok "Ocserv installed."

}#############################################
# Create Directories
#############################################

create_directories(){


    info "Creating directories..."


    mkdir -p "$CONFIG_DIR"

    mkdir -p /var/lib/ocserv

    mkdir -p /var/log/ocserv

    mkdir -p /run/ocserv

    mkdir -p "$LP_CONFIG"



    chmod 700 "$CONFIG_DIR"



    ok "Directories created."

}





#############################################
# Generate Certificates
#############################################

generate_certificates(){


    info "Generating SSL certificates..."



    if [[ -f "$CONFIG_DIR/server-cert.pem" ]] && \
       [[ -f "$CONFIG_DIR/server-key.pem" ]]; then


        warn "Certificates already exist."

        return

    fi



    cat > "$CONFIG_DIR/ca.tmpl" <<EOF
cn = L-Panel VPN CA
organization = L-Panel
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF



    cat > "$CONFIG_DIR/server.tmpl" <<EOF
cn = VPN Server
organization = L-Panel
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF



    certtool \
    --generate-privkey \
    --outfile "$CONFIG_DIR/ca-key.pem"



    certtool \
    --generate-self-signed \
    --load-privkey "$CONFIG_DIR/ca-key.pem" \
    --template "$CONFIG_DIR/ca.tmpl" \
    --outfile "$CONFIG_DIR/ca-cert.pem"




    certtool \
    --generate-privkey \
    --outfile "$CONFIG_DIR/server-key.pem"




    certtool \
    --generate-certificate \
    --load-ca-certificate "$CONFIG_DIR/ca-cert.pem" \
    --load-ca-privkey "$CONFIG_DIR/ca-key.pem" \
    --load-privkey "$CONFIG_DIR/server-key.pem" \
    --template "$CONFIG_DIR/server.tmpl" \
    --outfile "$CONFIG_DIR/server-cert.pem"




    chmod 600 "$CONFIG_DIR"/*key.pem



    ok "Certificates generated."

}







#############################################
# Create Ocserv Configuration
#############################################

create_config(){


    info "Creating ocserv configuration..."



    cat > "$CONFIG_FILE" <<EOF
auth = "plain[passwd=$CONFIG_DIR/ocpasswd]"


tcp-port = $PORT
udp-port = $PORT


server-cert = $CONFIG_DIR/server-cert.pem
server-key = $CONFIG_DIR/server-key.pem


auth-timeout = 240


max-clients = 500
max-same-clients = 2


run-as-user = nobody
run-as-group = nobody


device = vpns


socket-file = /run/ocserv-socket

pid-file = /run/ocserv.pid



isolate-workers = true



keepalive = 32400

dpd = 90

mobile-dpd = 1800



try-mtu-discovery = true



ipv4-network = 10.10.10.0

ipv4-netmask = 255.255.255.0



dns = 1.1.1.1

dns = 8.8.8.8



route = default



compression = true


cisco-client-compat = true

dtls-legacy = true

EOF




    touch "$CONFIG_DIR/ocpasswd"


    chmod 600 "$CONFIG_DIR/ocpasswd"



    ok "Configuration created."

}#############################################
# Enable IP Forwarding
#############################################

enable_forwarding(){


    info "Enabling IP forwarding..."



    cat > /etc/sysctl.d/99-l-panel-ocserv.conf <<EOF
net.ipv4.ip_forward = 1
EOF



    sysctl --system >/dev/null



    ok "IP forwarding enabled."

}





#############################################
# Create Systemd Service
#############################################

create_service(){


    info "Creating systemd service..."



    cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=L-Panel Ocserv VPN Server
After=network.target


[Service]

Type=simple

ExecStart=/usr/sbin/ocserv \
-c $CONFIG_FILE \
--foreground

Restart=always

RestartSec=5


RuntimeDirectory=ocserv

RuntimeDirectoryMode=0755



LimitNOFILE=65535



[Install]

WantedBy=multi-user.target

EOF




    systemctl daemon-reload


    systemctl enable ocserv



    ok "Systemd service created."

}





#############################################
# Firewall Configuration
#############################################

configure_firewall(){


    info "Configuring firewall..."



    if systemctl is-active firewalld >/dev/null 2>&1; then



        firewall-cmd \
        --permanent \
        --add-port=${PORT}/tcp



        firewall-cmd \
        --permanent \
        --add-port=${PORT}/udp



        firewall-cmd --reload



        ok "Firewall configured."



    else


        warn "Firewalld is not running."

    fi


}






#############################################
# Save Installation Info
#############################################

save_info(){


    mkdir -p "$LP_CONFIG"



    cat > "$INFO_FILE" <<EOF
VERSION=$OCSERV_VERSION
PORT=$PORT
CONFIG=$CONFIG_FILE
INSTALL_DATE=$(date "+%Y-%m-%d %H:%M:%S")
STATUS=installed
EOF



    chmod 600 "$INFO_FILE"



    ok "Installation information saved."

}





#############################################
# Create Default Admin Password File
#############################################

create_password_file(){


    if [[ ! -f "$CONFIG_DIR/ocpasswd" ]]; then

        touch "$CONFIG_DIR/ocpasswd"

    fi


    chmod 600 "$CONFIG_DIR/ocpasswd"



}





#############################################
# Start Ocserv
#############################################

start_ocserv(){


    info "Starting Ocserv..."



    systemctl restart ocserv



    sleep 3



    if systemctl is-active ocserv >/dev/null 2>&1; then


        ok "Ocserv is running."



    else



        fail "Ocserv failed to start."


        echo

        journalctl \
        -u ocserv \
        --no-pager \
        -n 80



        exit 1

    fi


}
