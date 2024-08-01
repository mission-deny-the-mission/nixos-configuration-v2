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
      nwg-panel
      pwvucontrol
      pavucontrol
      qbittorrent
      stremio
      texlive.combined.scheme-medium
      texstudio
      wlsunset
      hyprshade
      strawberry
    ];

    programs.fish.enable = true;
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

    wayland.windowManager.hyprland.enable = true;
    wayland.windowManager.hyprland.systemd.variables = ["--all"];
    wayland.windowManager.hyprland.settings = {
      #general.gaps_in=5;
      #general.gaps_out=5;
      decoration.rounding = 10;
      input.kb_layout = "gb";
      "$mod" = "SUPER";
      input.touchpad.clickfinger_behavior = true;
      exec-once = [
        "waybar"
        "nm-applet"
        "wlsunset -l 53.5 -L 32.4"
      ];
      monitor = ",preferred,auto,1";
      gestures.workspace_swipe = true;
      bind = [
        "$mod, W, exec, qutebrowser"
        "$mod, T, exec, kitty"
        "$mod, F, exec, dolphin"
        "ALT, F2, exec, wofi --show run"
        "$mod, D, exec, wofi --show drun"
        "$mod, M, exit"
        "$mod, C, killactive,"
        ", XF86AudioRaiseVolume, exec, wpctl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", xf86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
        ", xf86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
      ];
    };

    programs.waybar.enable = true;
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/scratchpad" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "mpd" "idle_inhibitor" "pipewire" "keyboard-state" "temperature" "cpu" "memory" "backlight" "battery" "tray" "clock" ];

        "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
                "activated" = "";
                "deactivated" = "";
            };
        };

        "hyprland/scratchpad" = {
          "format" = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = ["" ""];
          "tooltip" = true;
          "tooltip-format" = "{app} = {title}";
        };

        "keyboard-state" = {
          "numlock" = true;
          "capslock" = true;
          "format" = "{name} {icon}";
          "format-icons" = {
              "locked" = "";
              "unlocked" = "";
          };

        };

        "cpu" = {
          "format" = "{usage}% ";
        };

        "memory" = {
          "format" = "{}% ";
        };

        "backlight" = {
          # "device" = "acpi_video1";
          "format" = "{percent}% {icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
        };

        "battery" = {
          "format" = "{capacity}% {icon}";
          "format-full" = "{capacity}% {icon}";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = ["" "" "" "" ""];
        };

        "tray" = {
          "icon-size" = 21;
          "spacing" = 10;
        };
        "clock" = {
          # "timezone" = "America/New_York";
          "tooltip-format" = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{ =%Y-%m-%d}";
        };
      };
    };
  };
}
