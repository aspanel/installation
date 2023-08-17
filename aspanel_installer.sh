#!/bin/bash

display_usage() {
    echo "Usage: $0 [--uninstall]     -> Removes aspanel and all of the dependencies installed during the installation process."
}

install() {
    sudo apt update -y
    sudo apt upgrade -y

    sudo apt-get install -y git

    while true; do
        read -p "Make sure aspanel is not already installed otherwise new installation can break the system configuration. Do you want to proceed? (y/n): " yn
        case $yn in
        [Yy]*)
            sudo mkdir -p /opt/aspanel
            sudo git clone https://github.com/abhishekprajapati1/aspanel.git /opt/aspanel
            break
            ;;
        [Nn]*)
            echo "Aborting the installation of aspanel"
            exit
            ;;
        *)
            echo "Please answer 'yes' or 'no'."
            ;;
        esac
    done

    sudo chmod -R +x /opt/aspanel/tasks
    sudo /bin/bash -c "source /opt/aspanel/tasks/dependencies/node/install.sh"
    sudo /bin/bash -c "source /opt/aspanel/tasks/creations/conf.service.sh"
}

uninstall() {
    while true; do
        read -p "Are you sure you want to uninstall aspanel ? This action is destructive it will uninstall all the packages and dependencies that aspanel installed and your system will be rebooted. Do you want to proceed? (y/n): " yn
        case $yn in
        [Yy]*)
            sudo systemctl stop aspanel
            sudo rm /etc/systemd/system/aspanel.service
            echo "Removing aspanel project"
            sudo rm -rf /opt/aspanel -Y
            echo "Removed project"
            sudo /bin/bash -c "source /opt/aspanel/tasks/dependencies/node/uninstall.sh"
            sudo reboot
            break
            ;;
        [Nn]*)
            echo "Thanks for using aspanel."
            exit
            ;;
        *)
            echo "Please answer 'yes' or 'no'."
            ;;
        esac
    done
}

if [ "$1" == "--help" ]; then
    display_usage
    exit 1
fi

if [ "$1" == "--uninstall" ]; then
    uninstall
else
    install
fi
