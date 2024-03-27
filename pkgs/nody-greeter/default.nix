{pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation rec {
  pname = "lightdm-nody-greeter";
  version = "1.5.2";

  src = pkgs.fetchurl {
    url = "https://github.com/JezerM/nody-greeter/releases/download/${version}/nody-greeter-${version}-debian.deb";
    sha256 = "4a3aec5b52db3fdaa4731d95524f057ff1a4d0ba4736c3ae3099a79a1d47c4f1";
  };

  buildInputs = with pkgs; [
    dpkg
  ];

  # postFixup = ''
  #   wrapProgram $out/usr/bin/nody-greeter\
  #     --prefix PATH ":" ""
  # '';

  # postPatch = ''
  #   sed -i "s/\/Xgreeter.patch \/etc\/os-release/\/Xgreeter.patch/g" Makefile
  #   substituteInPlace "dist/nody-greeter.desktop" \
  #     --replace-fail "Exec=/opt/nody-greeter" "Exec=$out/usr/bin"
  # '';
  # installFlags = [
  #   "DESTDIR=$out"
  #   "PREFIX=$out/usr"
  # ];
  # buildPhase = true;
  installPhase = ''
    dpkg -x $src $out
    cp $out/usr/share/applications/nody-greeter.desktop $out
    substituteInPlace $out/nody-greeter.desktop \
      --replace-fail "Exec=/opt" "Exec=$out/opt"
  '';
  meta = with pkgs.lib; {
    description = "LightDM greeter that allows to create wonderful themes with web technologies.";
    homepage = "https://jezerm.github.io/nody-greeter-page";
    license = licenses.gpl3;
    maintainers = with maintainers; [TheDarkBug];
  };
}
