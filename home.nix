{ config, pkgs, ... }:

{
  home.username = "bored";
  home.homeDirectory = "/home/bored";
  home.stateVersion = "25.11";

  programs.bash= {
    enable = true;
    shellAliases = {
      switch-nix = "sudo nixos-rebuild switch --impure --flake .";
      conf = "nvim ~/nix/configuration.nix";
    };
    initExtra = ''
      export  PS1='\[\e[38;5;32m\]\u\[\e[0m\] \w \\$ '
    '';
   };
  
}
