import subprocess

def add_user(username, password):
    cmd = f"ocpasswd -c /etc/ocserv/ocpasswd {username}"
    p = subprocess.Popen(cmd.split(), stdin=subprocess.PIPE)
    p.communicate(input=f"{password}\n{password}\n".encode())

def delete_user(username):
    subprocess.run(["ocpasswd", "-c", "/etc/ocserv/ocpasswd", "-d", username])

def list_users():
    with open("/etc/ocserv/ocpasswd") as f:
        return f.read().splitlines()
