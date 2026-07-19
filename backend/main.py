from flask import Flask
from flask import jsonify
from flask import render_template
from flask import request

import os
import subprocess

app = Flask(__name__)

APP_VERSION = "0.0.1"

INFO_FILE = "/etc/l-panel/ocserv.info"


def run(cmd):

    return subprocess.run(
        cmd,
        shell=True,
        text=True,
        capture_output=True
    )


def get_version():

    try:

        with open("/opt/l-panel/VERSION") as f:

            return f.read().strip()

    except:

        return APP_VERSION


def service_running(name):

    r = run(f"systemctl is-active {name}")

    return r.stdout.strip() == "active"
    @app.route("/")
def index():

    return jsonify({
        "project": "L-Panel",
        "version": get_version(),
        "status": "running"
    })


@app.route("/api/status")
def api_status():

    data = {
        "panel_version": get_version(),
        "ocserv": service_running("ocserv"),
        "firewalld": service_running("firewalld"),
        "fail2ban": service_running("fail2ban")
    }

    if os.path.exists(INFO_FILE):

        with open(INFO_FILE) as f:

            for line in f:

                if "=" not in line:
                    continue

                k, v = line.strip().split("=", 1)

                data[k.lower()] = v

    return jsonify(data)


@app.route("/api/system")
def api_system():

    hostname = run("hostname").stdout.strip()

    uptime = run("uptime -p").stdout.strip()

    kernel = run("uname -r").stdout.strip()

    memory = run(
        "free -m | awk '/Mem:/ {print $2\":\"$3\":\"$4}'"
    ).stdout.strip()

    disk = run(
        "df -h / | awk 'NR==2 {print $2\":\"$3\":\"$4\":\"$5}'"
    ).stdout.strip()

    cpu = run(
        "grep -m1 'model name' /proc/cpuinfo | cut -d: -f2"
    ).stdout.strip()

    return jsonify({

        "hostname": hostname,

        "uptime": uptime,

        "kernel": kernel,

        "cpu": cpu,

        "memory": memory,

        "disk": disk

    })
