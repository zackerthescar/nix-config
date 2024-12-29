{ config, pkgs, ...}:
{

    home.packages = with pkgs; [
        mpv-unwrapped
    ];
    programs.mpv = {
        config = {
	    vo = "gpu";
            hwdec = "auto";
            profile = "gpu-hq";
            scale = "ewa_lanczossharp";
            cscale = "ewa_lanczossharp";
            ytdl-format = "bestvideo[height<=?1080][codec^=avc1]+bestaudio/best";
        };
    };
}
