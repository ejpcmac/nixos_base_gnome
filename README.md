# NixOS Base GNOME

This repository contains a NixOS configuration based on
[confkit](https://github.com/ejpcmac/confkit) and using GNOME as Desktop
Environment.

## Usage

1. In a NixOS installer or on a NixOS host, format the drive and mount the
    partitions.

2. Generate a base NixOS configuration:

        # nixos-generate-config --root /mnt

3. Create a home directory. If your user is named `user`, do:

        # mkdir -p /mnt/home/user

4. Install Git:

        # nix-env -Ai nixos.git

5. Clone this repository in the user home:

        # cd /mnt/home/user
        # git clone --recurse-submodules https://github.com/ejpcmac/nixos_base_gnome.git .config_files

6. Rename the directory `Nix/nixos-host` to fit your hostname.

7. Update the configuration in `Nix/nixos-host/configuration.nix`.

8. Update the users in `Nix/nixos-host/users.nix`. Especially, do not forget to
    generate password hashes.

9. Rename `Nix/nixos-test/user.nix` to fit your username.

10. Fix the permissions:

        # cd /mnt/home
        # chown -R 1000:users user
        # chmod 700 user
        # chmod 700 user/.config_files

11. Link the system configuration. If your host is named `nixos-host`, do:

        # cd /mnt/etc/nixos
        # rm configuration.nix
        # ln -s ../../home/user/.config_files/Nix/nixos-host/configuration.nix

12. To optimise the Nix store during the installation, do:

        # cd
        # mkdir -p .config/nix
        # vim .config/nix/nix.conf

    and add `auto-optimise-store = true`.

13. Install NixOS:

        # nixos-install
