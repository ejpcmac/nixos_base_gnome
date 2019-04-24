##
## nixos-host users
##

{ config, pkgs, ... }:

{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;

    users.root = {
      # Use `mkpasswd -m SHA-512` to generate a new password hash.
      hashedPassword = "foo";
    };

    users.user = {
      isNormalUser = true;
      uid = 1000;
      description = "User";
      extraGroups = [ "wheel" "dialout" "wireshark" ];
      hashedPassword = "bar";
    };
  };
}
