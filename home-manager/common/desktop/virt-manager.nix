{ config, pkgs, ...}:
{

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
