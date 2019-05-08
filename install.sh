#!/bin/sh

################################################################################
##                                                                            ##
##                     Auto-install script for nixos-host                     ##
##                                                                            ##
################################################################################

set -e
set -x

################################################################################
##                                  Options                                   ##
################################################################################

name=nixos-host
config_repo=https://github.com/ejpcmac/nixos_base_gnome.git
boot_disk=/dev/sda
boot_partition=/dev/sda1
system_partition=/dev/sda2

{ set +x; } 2> /dev/null

################################################################################
##                                   Script                                   ##
################################################################################

# Configure Nix.
printf "\n\e[32m=> Configuring Nix...\e[0m\n\n"
(
    set -x
    mkdir -p ~/.config/nix
    echo "auto-optimise-store = true" > ~/.config/nix/nix.conf
)

# Install the dependencies for the script.
printf "\n\e[32m=> Installing the dependencies for the script...\e[0m\n\n"
(
    set -x
    nix-env -Ai nixos.git
)

# Partition the boot disk.
printf "\n\e[32m=> Partitioning the boot disk...\e[0m\n\n"
(
    set -x
    parted $boot_disk mklabel gpt
    parted $boot_disk mkpart ESP fat32 1MiB 512MiB
    parted $boot_disk mkpart primary 512MiB 100%
    parted $boot_disk set 1 boot on
)

# Format the partitions.
printf "\n\e[32m=> Formatting the partitions...\e[0m\n\n"
(
    set -x
    mkfs.fat -F 32 -n boot $boot_partition
    mkfs.ext4 -L nixos $system_partition
)

# Mount the filesystems.
printf "\n\e[32m=> Mounting the filesystems...\e[0m\n\n"
(
    set -x
    mount $system_partition /mnt
    mkdir -p /mnt/boot/efi
    mount $boot_partition /mnt/boot/efi
)

# Generate the hardware configuration.
printf "\n\e[32m=> Generating the hardware configuration...\e[0m\n\n"
(
    set -x
    nixos-generate-config --root /mnt
)

# Install the configuration.
printf "\n\e[32m=> Installing the configuration...\e[0m\n\n"
(
    set -x
    user_home=/mnt/home/user
    mkdir -p $user_home
    git clone --recurse-submodules $config_repo $user_home/config
    chown -R 1000:users $user_home
    chmod 700 $user_home
    chmod 700 $user_home/config
    rm /mnt/etc/nixos/configuration.nix
    ln -s ../../home/user/config/Nix/$name/configuration.nix /mnt/etc/nixos/
)

# Install NixOS.
printf "\n\e[32m=> Installing NixOS...\e[0m\n\n"
(
    set -x
    nix-channel --update
    nixos-install
)

printf "\n\e[32m\e[1mInstallation complete!\e[0m\n\n"
