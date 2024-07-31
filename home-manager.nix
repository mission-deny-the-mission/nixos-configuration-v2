{ config, pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];
#  nixpkgs.hostPlatform = {
#    gcc.arch = "tigerlake";
#    gcc.tune = "tigerlake";
#    system = "x86_64-linux";
#  };

  home-manager.users.harry = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
      qutebrowser
      ranger
      vlc
      spotify
      freetube
      nixnote2
      bibata-cursors
      onlyoffice-bin
      fastfetch
      stress-ng
    ];

    programs.fish.shellAliases = {
      vim = "nvim";
      configsys = "nvim /etc/nixos/configuration.nix";
      confighome = "nvim /etc/nixos/home-manager.nix";
      rebuildsys = "sudo nixos-rebuild switch";
      configbar = "nvim ~/.config/waybar/config.jsonc";
      configland = "nvim ~/.config/hypr/hyrpland.conf";
    };

    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
        dynamic_background_opacity = true;
        enable_audio_bell = true;
        background_opacity = "0.5";
        background_blur = "5";
      };
    };
  };
}
