#!/bin/bash

blue "Installing PostgreSQL ..."

apt update

apt install -y postgresql postgresql-contrib

green "PostgreSQL Installed."
