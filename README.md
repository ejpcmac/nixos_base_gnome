# NixOS Base GNOME

This repository contains a NixOS configuration based on
[confkit](https://github.com/ejpcmac/confkit) and using GNOME as Desktop
Environment.

## Usage

In a NixOS installer, run:

    # sh -c "$(curl -sSL https://ejpcmac.net/installers/nixos_base_gnome.sh)"

After a reboot, to gain the full comfort of the confkit goodies, setup
[home-manager](https://github.com/rycee/home-manager) for both root and your
user, open a terminal and run:

    $ config/home-install.sh

At this point, you can start editing your `configuration.nix` or `user.nix` to
add features. There are plenty of `confkit` goodies to uncomment in the
`user.nix`, like `direnv` support and aliases for several development tools.

Enjoy! :-D
