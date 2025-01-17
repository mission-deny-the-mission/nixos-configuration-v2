# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  nix.settings.system-features = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-znver2" ];
#  nixpkgs.hostPlatform = {
#    gcc.arch = "znver2";
#    gcc.tune = "znver2";
#    system = "x86_64-linux";
#  };

  nixpkgs.config.allowUnfree = true;

#  mkForce = mkOverride 50;
#  systemd.services.nix-daemon.serviceConfig.LimitNOFILE = mkDefault 2048576;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home-manager.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems."/four-used-zfs-drives-raidz" = {
    device = "192.168.0.30:/four-used-zfs-drives-raidz";
    fsType = "nfs";
    options = ["x-systemd.automount" "noauto"];
  };


  boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;

  services.ananicy = {
    enable = true;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  hardware.enableAllFirmware  = true;

  sound.enable = false;
  nixpkgs.config.pipewire = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  security.apparmor.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  services.flatpak.enable = true;

  programs.dconf.enable = true;

  services.power-profiles-daemon.enable = false;

  services.tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_AC="active";
        CPU_DRIVER_OPMODE_ON_BAT="active";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 80;

        DISK_DEVICES="nvme0n1";

        DISK_APM_LEVEL_ON_AC="254 254";
        DISK_APM_LEVEL_ON_BAT="128 128";

        DISK_SPINDOWN_TIMEOUT_ON_AC="0 0";
        DISK_SPINDOWN_TIMEOUT_ON_BAT="30 30";

        DISK_IOSCHED="mq-deadline mq-deadline";

        PLATFORM_PROFILE_ON_AC="performance";
        PLATFORM_PROFILE_ON_BAT="balanced";

        RUNTIME_PM_ON_AC="on";
        RUNTIME_PM_ON_BAT="auto";

        PCIE_ASPM_ON_AC="default";
        PCIE_ASPM_ON_BAT="powersave";

       #Optional helps save long term battery health
       # START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       # STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging

      };
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/Hyprland -c ${pkgs.nwg-hello}/etc/nwg-hello/hyprland.conf";
      };
    };
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  fonts.packages = with pkgs; [
    nerdfonts
    meslo-lgs-nf
  ];
  
  services.gvfs.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  programs.hyprland = {
    enable = true; 
  };

  services.dbus = {
    enable = true;
  };
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  programs.adb.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.harry = {
    shell = pkgs.fish;
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "docker" "audio" "adbusers" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    dig
    wget
    hyprlock
    hyprpaper
    hypridle
    waybar
    wofi
    nwg-displays
    nwg-drawer
    nwg-hello
    kitty
    networkmanagerapplet
    xdg-desktop-portal-hyprland
    fishPlugins.pure
    swww
    xdg-desktop-portal-gtk
    xwayland
    meson
    wayland-protocols
    wayland-utils
    wl-clipboard
    killall
    virt-manager
    swaylock
    lm_sensors
    git
    gh
    vulnix
    bat
    lsof
    android-tools
    parted
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

