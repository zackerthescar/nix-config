{ config, lib, pkgs, ...}:
# libvirt and dconf are Linux-only.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {

    home.packages = with pkgs; [
		virt-manager
		ubootTools
		ubootQemuX86
		gnome-boxes
    ];
    dconf.settings = {
	"org/virt-manager/virt-manager/connections" = {
    		autoconnect = ["qemu:///system"];
    		uris = ["qemu:///system"];
    	};
    };
}
