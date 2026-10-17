# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../common/default.nix
      ../common/desktop/default.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  # Use swapfile
  swapDevices = [{
    device = "/swap/swapfile";
    size = 16 * 1024;
  }];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=zstd" # Options: lz4, zstd, etc.
    "zswap.zpool=z3fold"     # Options: z3fold, zbud, zsmalloc
    "zswap.max_pool_percent=20" # Max percentage of RAM zswap can use
    # Hibernate into the btrfs swapfile. Get the offset with:
    #   sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
    "resume_offset=5327580"
  ];
  boot.kernelModules = [ "zstd" "z3fold" ];

  # Suspend, then hibernate after an hour asleep.
  boot.resumeDevice = "/dev/mapper/root";
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend-then-hibernate";
    HandleSuspendKey = "suspend-then-hibernate";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "1h";
  # GNOME's idle/menu suspend calls logind's plain Suspend(), bypassing the
  # handlers above, so make every suspend a suspend-then-hibernate.
  systemd.services.systemd-suspend.serviceConfig.ExecStart = [
    ""
    "${config.systemd.package}/lib/systemd/systemd-sleep suspend-then-hibernate"
  ];

  networking.hostName = "endurance"; # Define your hostname.
  
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

  # nixos-hardware's gpu/intel module adds the VA-API driver packages.
  # Tiger Lake (Gen12) only needs iHD.
  hardware.graphics.enable = true;
  hardware.intelgpu.vaapiDriver = "intel-media-driver";

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # The rest of the PipeWire setup is in common/desktop/services.nix.
  security.rtkit.enable = true;

  # Synaptics 06cb:00bd. Enroll with `fprintd-enroll`.
  services.fprintd.enable = true;
  services.fwupd.enable = true;
  services.thermald.enable = true;

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

