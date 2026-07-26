#!/bin/bash


banner(){

echo "
=================================
       L-PANEL INSTALLER
              Laravel
=================================
"

}



run_install(){


detect_os


install_packages


install_composer


install_dependencies


create_database


create_env


run_migrations


create_admin


install_nginx


install_command


}



run_install
