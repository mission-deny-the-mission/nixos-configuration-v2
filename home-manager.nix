{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

#  nixpkgs.hostPlatform = {
#    gcc.arch = "znver2";
#    gcc.tune = "znver2";
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
      #freetube
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
      distrobox
      unzip
      ark
      rofi
      cinnamon.nemo
      swaylock-fancy
      tusk
      python3
      galculator
      playerctl
      mpv
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
    wayland.windowManager.hyprland.extraConfig = ''
windowrule=float,Rofi
windowrule=float,pavucontrol
windowrule=float,pwvucontrol
    '';
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
#      monitor = ",preferred,auto,1";
      monitor = "HDMI-A-1,2560x1440@144,0x0,1";
      gestures.workspace_swipe = true;
      bind = [
        "$mod, W, exec, qutebrowser"
        "$mod, RETURN, exec, kitty"
        "$mod, F, exec, nemo"
        "ALT, F2, exec, rofi -show run"
	"CTRL, SPACE, exec, rofi -show combi -modi window,run,combi -combi-modi window,run"
        "$mod SHIFT, O ,exec, swaylock-fancy"
        "$mod, M, exit"
        "$mod, Q, killactive,"
	"$mod, O, exec, killall -SIGUSR2 waybar"
	"$mod SHIFT, S, exec, ~/.suspend.sh"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", xf86KbdBrightnessUp, exec, brightnessctl -d *::kbd_backlight set +33%"
        ", xf86KbdBrightnessDown, exec, brightnessctl -d *::kbd_backlight set 33%-"
	", mouse:277, workspace, e+1"
	", mouse:278, workspace, e-1"
	", mouse:279, exec, playerctl play-pause"
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
	"$mod, MINUS, workspace, 11"
	"$mod, EQUAL, workspace, 12"
        "$mod, Z, togglespecialworkspace, magic"
        "$mod SHIFT, Z, movetoworkspace, special:magic"
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
        "$mod SHIFT, MINUS, movetoworkspace, 11"
        "$mod SHIFT, EQUAL, movetoworkspace, 12"
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
    programs.waybar.style = ''
* {
  /* `otf-font-awesome` is required to be installed for icons */
  font-family: "JetBrainsMono Nerd Font";
  font-size: 11pt;
  font-weight: 900;
  margin: 0;
  padding: 0;
  transition-property: background-color;
  transition-duration: 0.5s;
}


/* Reset all styles */
* {
    border: none;
    border-radius: 3px;
    min-height: 0;
    margin: 0.2em 0.3em 0.2em 0.3em;
}

/* The whole bar */
#waybar {
    /*background: @bg;*/
    background-color: transparent;
    /*color: @light;*/
    color: #ffffff;
    transition-property: background-color;
    transition-duration: 0.5s;
    /*border-top: 8px transparent;*/
    border-radius: 0px;
    margin: 0px 0px;
}

window#waybar.hidden {
  opacity: 0.2;
}

#workspaces button {
  padding: 0 0px;
  color: #7984a4;
  background-color: transparent;
  /* Use box-shadow instead of border so the text isn't offset */
  box-shadow: inset 0 -3px transparent;
  /* Avoid rounded borders under each workspace name */
  border: none;
  border-radius: 0;
}

#workspaces button.focused {
  background-color: transparent;
}
#workspace button.hover {
  background-color: transparent;
}
#workspaces button.active {
  color: #fff;
}

#workspaces button.urgent {
  background-color: #eb4d4b;
}

#window {
  /* border-radius: 20px; */
  /* padding-left: 10px; */
  /* padding-right: 10px; */
  color: #64727d;
}

/* Each module */
#clock,
#battery,
#cpu,
#memory,
#disk,
#temperature,
#backlight,
#network,
#pulseaudio,
#wireplumber,
#custom-media,
#custom-screenshot_t,
#tray,
#mode,
#idle_inhibitor,
#mpd,
#bluetooth,
#custom-hyprPicker,
#custom-power-menu,
#custom-spotify,
#custom-weather,
#custom-weather.severe,
#custom-weather.sunnyDay,
#custom-weather.clearNight,
#custom-weather.cloudyFoggyDay,
#custom-weather.cloudyFoggyNight,
#custom-weather.rainyDay,
#custom-weather.rainyNight,
#custom-weather.showyIcyDay,
#custom-weather.snowyIcyNight,
#custom-weather.default {
  padding: 0px 15px;
  color: #e5e5e5;
  /* color: #bf616a; */
  border-radius: 20px;
  background-color: #1e1e1e;
}

#window,
#workspaces {
  border-radius: 20px;
  padding: 0px 10px;
  background-color: #1e1e1e;
}

#cpu {
  color: #fb958b;
  background-color: #1e1e1e;
}

#memory {
  color: #ebcb8b;
  background-color: #1e1e1e;
}

#custom-power-menu {
  border-radius: 9.5px;
  background-color: #1b242b;
  border-radius: 7.5px;
  padding: 0 0px;
}

#custom-launcher {
  background-color: #1b242b;
  color: #6a92d7;
  border-radius: 7.5px;
  padding: 0 0px;
}

#custom-weather.severe {
  color: #eb937d;
}

#custom-weather.sunnyDay {
  color: #c2ca76;
}

#custom-weather.clearNight {
  color: #cad3f5;
}

#custom-weather.cloudyFoggyDay,
#custom-weather.cloudyFoggyNight {
  color: #c2ddda;
}

#custom-weather.rainyDay,
#custom-weather.rainyNight {
  color: #5aaca5;
}

#custom-weather.showyIcyDay,
#custom-weather.snowyIcyNight {
  color: #d6e7e5;
}

#custom-weather.default {
  color: #dbd9d8;
}

/* If workspaces is the leftmost module, omit left margin */
.modules-left > widget:first-child > #workspaces {
  margin-left: 0;
}

/* If workspaces is the rightmost module, omit right margin */
.modules-right > widget:last-child > #workspaces {
  margin-right: 0;
}

#pulseaudio {
  color: #7d9bba;
}

#backlight {
  /* color: #EBCB8B; */
  color: #8fbcbb;
}

#clock {
  color: #c8d2e0;
  /* background-color: #14141e; */
}

#battery {
  color: #c0caf5;
  /* background-color: #90b1b1; */
}

#battery.charging,
#battery.full,
#battery.plugged {
  color: #26a65b;
  /* background-color: #26a65b; */
}

@keyframes blink {
  to {
    background-color: rgba(30, 34, 42, 0.5);
    color: #abb2bf;
  }
}

#battery.critical:not(.charging) {
  color: #f53c3c;
  animation-name: blink;
  animation-duration: 0.5s;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
  animation-direction: alternate;
}

label:focus {
  background-color: #000000;
}

#disk {
  background-color: #964b00;
}

#bluetooth {
  color: #707d9d;
}

#bluetooth.disconnected {
  color: #f53c3c;
}

#network {
  color: #b48ead;
}

#network.disconnected {
  color: #f53c3c;
}

#custom-media {
  background-color: #66cc99;
  color: #2a5c45;
  min-width: 100px;
}

#custom-media.custom-spotify {
  background-color: #66cc99;
}

#custom-media.custom-vlc {
  background-color: #ffa000;
}

#temperature {
  background-color: #f0932b;
}

#temperature.critical {
  background-color: #eb4d4b;
}

#tray > .passive {
  -gtk-icon-effect: dim;
}

#tray > .needs-attention {
  -gtk-icon-effect: highlight;
  background-color: #eb4d4b;
}

#idle_inhibitor {
  background-color: #2d3436;
}

#idle_inhibitor.activated {
  background-color: #ecf0f1;
  color: #2d3436;
}

#language {
  background: #00b093;
  color: #740864;
  padding: 0 0px;
  margin: 0 5px;
  min-width: 16px;
}

#keyboard-state {
  background: #97e1ad;
  color: #000000;
  padding: 0 0px;
  margin: 0 5px;
  min-width: 16px;
}

#keyboard-state > label {
  padding: 0 0px;
}

#keyboard-state > label.locked {
  background: rgba(0, 0, 0, 0.2);
}
    '';
    programs.waybar.settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [ "hyprland/scratchpad" "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "mpd" "idle_inhibitor" "pipewire" "temperature" "cpu" "memory" "backlight" "battery" "tray" "clock" ];

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
