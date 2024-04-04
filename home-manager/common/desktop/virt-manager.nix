{ config, pkgs, ...}:
{

    home.packages = with pkgs; [
	virt-manager
    ];
    programs.virt-manager = {
	enable = true;
    };
    dconf.settings = {
	"org/virt-manager/virt-manager/connections" = {
    		autoconnect = ["qemu:///system"];
    		uris = ["qemu:///system"];
    	};
    };
}
