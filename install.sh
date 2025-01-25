#!/bin/bash

#* Installation of Flatpak and Paru (AUR)

function install_flatpak_and_paru {
    echo -e "${txtylw}Installing Flatpak and Paru (AUR)...${txtwht}"

    sudo $pkg_update
    sudo $pkg_install flatpak xdg-desktop-portal-gtk xdg-desktop-portal

    echo -e "${txtgrn}Flatpak is installed. It's recommended to reboot your system.${txtwht}"
    echo 
    echo -e "${txtylw}Installing Paru (AUR)...${txtwht}"

    sudo $pkg_install git base-devel

    git clone https://aur.archlinux.org/paru.git
    cd paru || exit
    less PKGBUILD #! Always check PKGBUILD before installing!
    makepkg -si
    cd ..
    rm -rf paru

    echo "${txtgrn}Paru (AUR) is installed.${txtwht}"
}

#* Nvidia driver installation

function choose_driver_type {
    echo -e "${txtylw}It is required to tun on multilib repository for Nvidia driver installation!"
    echo 
    echo -e "${txtcyn}Please choose the type of Nvidia driver you want to install:"
    echo "1) Nvidia driver"
    echo "2) Nvidia driver DKMS"
    echo -e "3) Quit${txtwht}"

    read -p "Enter your choice: " choice

    case $choice in
        1) install_nvidia_driver ;;
        2) install_nvidia_driver_dkms ;;
        3) quit ;;
    esac
}

function install_nvidia_driver {
    echo -e "${txtylw}Installing Nvidia driver...${txtwht}"

    sudo $pkg_update
    sudo $pkg_install - < nvidia_driver/nvidia.txt

    echo
    echo "${txtgrn}Nvidia driver is installed.${txtwht}"

    configure_nvidia_driver
}

function install_nvidia_driver_dkms {
    echo -e "${txtylw}Installing Nvidia driver DKMS...${txtwht}"

    sudo $pkg_update
    sudo $pkg_install - < nvidia_driver/dkms.txt

    echo
    echo "${txtgrn}Nvidia driver DKMS is installed.${txtwht}"

    configure_nvidia_driver
}

#! Use only on the Linux distributions, that require manual configuration of Nvidia driver! Arch, Artix, Gentoo, etc.
function configure_nvidia_driver {
    echo -e "${txtylw}Configuring Nvidia driver...${txtwht}"

    echo -e "${txtylw}Checking if Nvidia hooks are installed...${txtwht}"
    
    if [ -f "/etc/pacman.d/hooks/nvidia-hook.hook" ]; then
        echo -e "${txtgrn}Nvidia hooks are arleady installed.${txtwht}"
    else
        echo -e "${txtylw}Installing Nvidia hooks...${txtwht}"
        sudo cp nvidia_driver/nvidia.hook /etc/pacman.d/hooks/nvidia.hook
    fi

    echo -e "${txtylw}Blacklisting nouveau driver...${txtwht}"
    if [ -f "/etc/modprobe.d/blacklist-nvidia-nouveau.conf" ]; then
        echo -e "${txtylw}Blacklist file already exists.${txtwht}"
    else
        sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
        echo -e "${txtgrn}Blacklist file created.${txtwht}"
    fi

    echo
    echo "${txtgrn}Nvidia driver is configured.${txtwht}"
}

#* Installation of packages

function install_basic_packages {
    echo -e "${txtylw}Installing basic system packages...${txtwht}"

    sudo $pkg_update
    sudo $pkg_install - < pkg_lists/basic.txt

    echo
    echo -e "${txtgrn}Basic system packages are installed.${txtwht}"
}

function install_application_packages {
    echo -e "${txtylw}Installing application packages...${txtwht}"

    sudo $pkg_update
    sudo $pkg_install - < pkg_lists/apps.txt

    echo
    echo -e "${txtgrn}Application packages are installed.${txtwht}"
}

#* Menu options

function choose_pkgs_to_install {
    echo -e "${txtcyn}Would you like to install basic system packages or application packages?"
    echo "1) Basic system packages"
    echo "2) Application packages"
    echo -e "3) Quit${txtwht}"

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
    echo -e "${txtylw}Exiting...${txtwht}"
    exit 0
}

#* Package manager variables (!Configure!)

pkg_update="pacman -Syu"
pkg_install="pacman -S"

#* Color variables

txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White

#* Display menu

while true; do
    echo -e "${txtcyn}================================================================"
    echo "#            Welcome to the menu of automated                  #"
    echo "#              dotfiles installer for Linux                    #"
    echo "================================================================"

    echo "1) Install package list"
    echo "2) Install dotfiles"
    echo "3) Install Nvidia graphic drivers"
    echo "4) Install Flatpak and Paru (AUR)"
    echo -e "5) Quit${txtwht}"

    read -p "Enter your choice: " choice

    case $choice in
        1) choose_pkgs_to_install ;;
        2) option_two ;;
        3) choose_driver_type ;;
        4) install_flatpak_and_paru ;;
        5) quit ;;
        *) echo -e "${txtred}Invalid option${txtwht}" ;;
    esac
done
//TODO: Add Multilib repository installation