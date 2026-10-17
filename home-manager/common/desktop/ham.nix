{ config, lib, pkgs, ...}:
{
    # Quansheng UV-K5 (egzumer) + Digirig Mobile.
    # Serial access to the Digirig needs the dialout group (nixos/common/user.nix).
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (with pkgs; [
        chirp
        direwolf
        xastir
        multimon-ng
        qsstv
        fldigi
        audacity
    ]);
}
