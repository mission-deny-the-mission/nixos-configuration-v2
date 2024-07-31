{ config, pkgs, ... }:
{
  imports = [ <home-manager/nixos> ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];

  home-manager.users.harry = {
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    home.packages = with pkgs; [
      spotify
      freetube
      nixnote2
      bibata-cursor
      onlyoffice-bin
    ];
  };
}
