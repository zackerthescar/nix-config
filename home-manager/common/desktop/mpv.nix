{ config, pkgs, ...}:
{
    nixpkgs.overlays = with pkgs; [
        (self: super: {
            mpv-unwrapped = super.mpv-unwrapped.override {
                ffmpeg_5 = ffmpeg_5-full;
            };
        })
    ];

    home.packages = with pkgs; [
        mpv-unwrapped
    ];
    programs.mpv = {
        config = {
            hwdec = "auto";
            profile = "gpu-hq";
            scale = "ewa_lanczossharp";
            cscale = "ewa_lanczossharp";
            ytdl-format = "bestvideo[height<=?1080][codec^=avc1]+bestaudio/best";
        };
    };
}