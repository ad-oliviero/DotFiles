{ lib, config, pkgs, ... }:
let
  cfg = config.wlogout;
in
{
  options.wlogout = {
    enable = lib.mkEnableOption "enable wlogout module";
  };
  config = lib.mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
            label = "shutdown";
            action = "systemctl poweroff";
            text = "Shutdown";
            keybind = "s";
        }
        {
            label = "reboot";
            action = "systemctl reboot";
            text = "Reboot";
            keybind = "r";
        }
        {
            label = "suspend";
            action = "systemctl suspend-then-hibernate";
            text = "Suspend";
            keybind = "u";
        }
        {
            label = "hibernate";
            action = "systemctl hibernate";
            text = "Hibernate";
            keybind = "h";
        }
        {
            label = "lock";
            action = "swaylock";
            text = "Lock";
            keybind = "l";
        }
        {
            label = "logout";
            action = "loginctl terminate-user $USER";
            text = "Logout";
            keybind = "e";
        }
      ];
      style = ''
        * {
          font-family: JetBrains Mono;
          font-size: 24px;
          transition-property: background-color;
          transition-duration: 0.7s;
        }
        window {
          background-color: #282828;
          border-radius: 10px;
        }
        button {
          color: #ebdbb2;
          background-color: #076678;
          border-style: solid;
          border-width: 2px;
          border-radius: 50px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 15%;
          margin: 15px;
        }
        
        button:active,
        button:hover {
          background-color: #458488;
        }
        
        button:focus {
          background-color: #458488;
        }
        
        #lock {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"), url("${pkgs.wlogout}/local/share/wlogout/icons/lock.png"));
        }
        
        #logout {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"), url("${pkgs.wlogout}/local/share/wlogout/icons/logout.png"));
        }
        
        #suspend {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"),
            url("${pkgs.wlogout}/local/share/wlogout/icons/suspend.png")
          );
        }
        
        #hibernate {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"),
            url("${pkgs.wlogout}/local/share/wlogout/icons/hibernate.png")
          );
        }
        
        #shutdown {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"),
            url("${pkgs.wlogout}/local/share/wlogout/icons/shutdown.png")
          );
        }
        
        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("${pkgs.wlogout}/local/share/wlogout/icons/reboot.png"));
        }
      '';
    };
  };
}
