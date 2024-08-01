{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
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
      bibata-cursors
      onlyoffice-bin
      fastfetch
      stress-ng
      acpi
      armcord
      bat
      brightnessctl
      btop
      firefox
      kate
      nwg-look
      pwvucontrol
      qbittorrent
      stremio
      texlive.combined.scheme-medium
      texstudio
      wlsunset
      hyprshade
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

    home.pointerCursor = {
      gtk.enable = true;
      # x11.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };

    #wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.systemd.variables = ["--all"];
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      input.touchpad.clickfinger_behavior = true;
      exec-once = [
      	"waybar"
	"nm-applet"
	"hyprshade on blue-light-filter"
      ];
      monitor = ",preferred,auto,1";
      gestures.workspace_swipe = true;
      bind = [
        "$mod, W, exec, qutebrowser"
	", XF86AudioRaiseVolume, exec, wpctl set-sink-volume @DEFAULT_SINK@ +5%"
	", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
	", XF86AudioMute, exec, wpctl set-sink-mute @DEFAULT_SINK@ toggle"
	", XF86AudioMicMute, exec, wpctl set-source-mute @DEFAULT_SOURCE@ toggle"
	", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
	", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
	", xf86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
	", xf86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
      ];
    };

    programs.waybar.settings = {
      layer = "top";
      position = "top";
      modules-left = [ "hyprland/workspaces" "hyprland/window" ];
      modules-center = [  ];
      modules-right = [ "mpd" "idle_inhibitor" "pipewire" "temperature" "cpu" "memory" "backlight" "battery" "tray" "clock" ];
    };
  };
}
