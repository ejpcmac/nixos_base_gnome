################################################################################
##                                                                            ##
##                    System configuration for nixos-host                     ##
##                                                                            ##
################################################################################

{ config, pkgs, ... }:

let
  confkit = import ../../confkit;
in

{
  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03";  # Did you read the comment?

  imports = with confkit.modules; [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./users.nix

    # confkit modules
    environment
    nix
    tmux
    utilities
    vim
    zsh
  ];

  ############################################################################
  ##                          Boot & File systems                           ##
  ############################################################################

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";

      timeout = 1;
    };

    cleanTmpDir = true;
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  ############################################################################
  ##                         General configuration                          ##
  ############################################################################

  time.timeZone = "Europe/Paris";

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "fr_FR.UTF-8";
  };

  networking = {
    hostName = "nixos-host";
  };

  sound = {
    # Enable ALSA sound.
    enable = true;
    mediaKeys.enable = true;
  };

  hardware.u2f.enable = true;

  ############################################################################
  ##                                 Fonts                                  ##
  ############################################################################

  fonts = {
    enableDefaultFonts = true;

    fonts = with pkgs; [
      meslo-lg
      opensans-ttf
    ];

    fontconfig = {
      enable = true;
      antialias = true;
      hinting = { enable = true; autohint = false; };
      includeUserConf = false;
      penultimate.enable = true;
      ultimate.enable = false;
      useEmbeddedBitmaps = true;
    };
  };

  ############################################################################
  ##                            System packages                             ##
  ############################################################################

  environment.systemPackages = with pkgs; [
    # Utilities
    gnome3.gnome-session
    maim
    mpc_cli
    nix-prefetch-github
    wakelan
    xorg.xev

    # Applications
    firefox
    keepassx2

    # GNOME extensions
    gnomeExtensions.topicons-plus
  ];

  # Uninstall unneeded gnome applications.
  environment.gnome3.excludePackages = with pkgs.gnome3; [
    evolution
  ];

  ############################################################################
  ##                                 Programs                               ##
  ############################################################################

  programs = {
    ssh.startAgent = true;
  };

  ############################################################################
  ##                                Services                                ##
  ############################################################################

  services = {
    ntp.enable = true;
    pcscd.enable = true;

    xserver = {
      enable = true;

      # Set the keyboard layout to AZERTY.
      layout = "fr";

      # Enable touchpad support with natural scrolling.
      libinput = {
        enable = true;
        naturalScrolling = true;
      };

      # Use GNOME 3 as desktop manager.
      displayManager.gdm.enable = true;
      desktopManager.gnome3.enable = true;
    };
  };
}
