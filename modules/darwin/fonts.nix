{ pkgs, ... }:

{
  fonts.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "my-fonts";
      version = "1.0";

      src = ../../secrets/fonts/TX-02;
      dontUnpack = true;

      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/fonts/opentype
        cp -v "$src"/*.otf $out/share/fonts/opentype/
        runHook postInstall
      '';
    })
  ];
}

