# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/default.nix
      ../common/desktop/default.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.initrd.availableKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  # MSI X870E firmware has S3 but no LPS0 device, so s2idle cannot reach s0ix.
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.initrd.systemd = {
    storePaths = [
      "${config.boot.initrd.systemd.package}/lib/systemd/systemd-tpm2-setup"
      "${config.boot.initrd.systemd.package}/lib/systemd/system-generators/systemd-tpm2-generator"
    ];
  };

zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };

  networking.hostName = "atlantis"; # Define your hostname.
  
  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

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

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  services.usbmuxd.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = false;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # "Balanced" profile for the AORUS RTX 4090 Xtreme Waterforce (AIO).
  # Undervolt = lock the max core clock + a positive core clock offset. The
  # offset moves the V/F curve up, so the GPU reaches the clock cap at a lower
  # voltage. NVML exposes one fan channel (the radiator fans, 30-100 %).
  # The AIO pump is NOT exposed on Linux and stays under card firmware control.
  # Tune: raise the offset in +15 MHz steps until a stress test fails, then
  # go back two steps. Check with `lact cli` / the LACT GUI.
  #
  # The config is raw YAML and not `services.lact.settings`: the fan curve map
  # has integer keys, but pkgs.formats.yaml quotes every attribute name, and
  # lactd (serde_norway) rejects '50' as an i32 key.
  services.lact.enable = true;
  environment.etc."lact/config.yaml".text = ''
    # Must be the current schema version. A lower value makes lactd run its
    # migrations, and one of them deletes max_core_clock on NVIDIA GPUs.
    version: 7
    daemon:
      log_level: info
      admin_group: wheel
    apply_settings_timer: 5
    gpus:
      10DE:2684-1458:40DA-0000:01:00.0:
        # 80 % of the 450 W default. Costs about 3-5 % performance.
        power_cap: 360.0
        # Stock boost goes to ~2750-2800 MHz at ~1.05-1.10 V. Cap at 2610 MHz.
        min_core_clock: 210
        max_core_clock: 2610
        # With +120 MHz, 2610 MHz is reached ~2-3 V/F points (~25-40 mV) lower.
        gpu_clock_offsets:
          0: 120
        fan_control_enabled: true
        fan_control_settings:
          mode: curve
          temperature_key: GPU
          interval_ms: 1000
          # Firmware floor is 30 %. lactd rejects values below 0.30.
          curve:
            50: 0.30
            60: 0.38
            66: 0.50
            72: 0.65
            78: 0.85
            83: 1.00
          # Hysteresis: fewer speed changes means less fan motor wear.
          spindown_delay_ms: 8000
          change_threshold: 2
  '';
  systemd.services.lactd.restartTriggers = [
    config.environment.etc."lact/config.yaml".source
  ];


  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Keychron V1 Ultra in Mac mode sends Super for Cmd. GNOME keeps Super for
  # itself, so send the usual Mac Cmd shortcuts as Ctrl instead.
  # 3434:0c10 is the wired keyboard, 3434:d028 is the Ultra-Link 8K receiver.
  services.keyd = {
    enable = true;
    keyboards.keychron = {
      ids = [ "3434:0c10" "3434:d028" ];
      settings = {
        meta = {
          a = "C-a";
          c = "C-c";
          v = "C-v";
          x = "C-x";
          z = "C-z";
          s = "C-s";
          f = "C-f";
          t = "C-t";
          w = "C-w";
          n = "C-n";
          r = "C-r";
          q = "C-q";
        };
        "meta+shift" = {
          z = "C-S-z";
          t = "C-S-t";
        };
      };
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # The rest of the PipeWire setup is in common/desktop/services.nix.
  services.pipewire.alsa.support32Bit = true;
  security.rtkit.enable = true;
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     firefox
  #     tree
  #   ];
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    sbctl
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
  # services.openssh.enable = true;

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

