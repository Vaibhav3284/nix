{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];
  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 10d";
  nix.settings.auto-optimise-store = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  services.xserver.enable = true;

  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.bored = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "bored";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    config = {
      user = {
        name  = "Vaibhav3284";
        email = "vaibhavjatoliya1@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };

  environment.systemPackages = with pkgs; [
  neovim 
  wget
  git
  steam
  ];

  system.stateVersion = "25.11"; # Did you read the comment?

}
