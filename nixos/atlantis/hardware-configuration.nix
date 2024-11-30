# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" ];
    };

  boot.initrd.luks.devices."root".device = "/dev/disk/by-uuid/ffa90a2c-2157-4062-92cc-098c6f32bf37";

  fileSystems."/home" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/mnt/hdd0" =
    { device = "/dev/mapper/hdd0";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."hdd0".device = "/dev/disk/by-uuid/84608766-9c74-4aa7-a499-3e75e8c1ae7f";

  fileSystems."/mnt/hdd1" =
    { device = "/dev/mapper/hdd1";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."hdd1".device = "/dev/disk/by-uuid/74d218d6-e8d7-461a-84b3-cd828efa8e74";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6ADD-4431";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp9s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0b1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
