# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
# head -n1 iso.nix | cut -c3- | sh
{ config, lib, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];
  console.keyMap = "it";
  environment.systemPackages = with pkgs; [
    neovim
    python313
    curl
    git
    android-tools
    android-udev-rules
  ];
  systemd.services.adb-server = {
    description = "ADB Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.android-tools}/bin/adb start-server";
      Restart = "always";
      RestartSec = 10;
    };
  };
  boot.postBootCommands = ''
    mkdir -p /home/nixos
    content="curl https://raw.githubusercontent.com/ad-oliviero/DotFiles/nixos/installation/install.py > /root/install.py && sudo python /root/install.py" 
    printf "$content" > /home/nixos/bootstrap
    printf "$content" > /bin/bootstrap
    chmod +x /home/nixos/bootstrap
    chmod +x /bin/bootstrap
  '';
}
