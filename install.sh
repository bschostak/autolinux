#!/bin/bash

#* Nvidia driver installation

function choose_driver_type {
    echo "Please choose the type of Nvidia driver you want to install:"
    echo "1) Nvidia driver"
    echo "2) Nvidia driver DKMS"
    echo "3) Quit"
}

#* Installation of packages

function install_basic_packages {
    echo "Installing basic system packages..."
    sudo $pkg_update
    sudo $pkg_install - < pkg_lists/basic.txt

    echo
    echo "Done!"
}

function install_application_packages {
    echo "Installing application packages..."

    sudo $pkg_update
    sudo $pkg_install - < pkg_lists/apps.txt

    echo
    echo "Done!"
}

#* Menu options

# Function definitions
function install_pkg_list {
    echo "You selected option 1"
    # Add your code for option one here
    echo
    echo "Would you like to install basic system packages or application packages?"
    echo "1) Basic system packages"
    echo "2) Application packages"
    echo "3) Quit"

    read -p "Enter your choice: " choice

    case $choice in
        1) install_basic_packages ;;
        2) install_application_packages ;;
        3) quit ;;
        esac
}

function option_two {
    echo "You selected option 2"
    # Add your code for option two here
}

function quit {
    echo "Exiting..."
    exit 0
}

#* Package manager variables (!Configure!)

pkg_update="pacman -Syu"
pkg_install="pacman -S"

# Display menu
while true; do
    echo "================================================================"
    echo "#            Welcome to the menu of automated                  #"
    echo "#              dotfiles installer for Linux                    #"
    echo "================================================================"

    echo "1) Install package list"
    echo "2) Install dotfiles"
    echo "3) Install Nvidia graphic drivers"
    echo "4) Quit"

    read -p "Choose an option [1-4]: " choice

    case $choice in
        1) install_pkg_list ;;
        2) option_two ;;
        3) install_nvidia_graphic_drivers ;;
        4) quit ;;
        *) echo "Invalid option" ;;
    esac
done
