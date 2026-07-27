# L-PANEL

## OCServ VPN Management Panel

پنل مدیریت حرفه‌ای برای مدیریت:

- کاربران VPN
- چندین سرور OCServ
- چندین ادمین
- نمایندگان فروش
- اشتراک‌ها


---

# Features


## VPN Users

- ایجاد کاربر OCServ
- حذف کاربر
- فعال / غیرفعال کردن
- مدیریت تاریخ انقضا


## Multi Server

پشتیبانی از چندین سرور:

- Ubuntu
- Debian
- AlmaLinux
- Rocky Linux


## Multi Admin

سطوح دسترسی:

- Super Admin
- Admin
- Reseller


## Reseller System

امکانات:

- ساخت نماینده
- محدودیت تعداد کاربر
- محدودیت سرور



---


# Requirements


- Linux Server

- PHP 8.2+

- PostgreSQL

- Composer

- Nginx

- Redis



---


# Installation


## One Line Installer


Clone:


```bash
git clone https://github.com/YOUR_USERNAME/l-panel.git
```


Enter:


```bash
cd l-panel
```


Install:


```bash
chmod +x installer/install.sh
```


Run:


```bash
./installer/install.sh
```



---

# Default Login


URL:


```
http://SERVER-IP/admin/login
```


Username:

```
admin
```


Password:

```
admin123
```


بعد از ورود رمز را تغییر دهید.



---


# Project Structure


```
l-panel/

app/

database/

resources/

routes/

installer/

docker/

```



---


# Supported OS


Currently:


- Ubuntu

- Debian

- AlmaLinux

- Rocky Linux

- CentOS



---


# Security


قبل از استفاده در محیط Production:


- تغییر رمز Admin

- فعال کردن SSL

- محدود کردن SSH

- تنظیم Firewall



---


# License


MIT License



## Installation

Automatic installation:

```bash
curl -s https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install.sh | sudo bash
or
bash <(curl -fsSL https://raw.githubusercontent.com/mohama226/l-panel/main/installer/install.sh)
