{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.wlogout;
in {
  options = {
    wlogout.enable = lib.mkEnableOption "Enable wlogout";
  };
  config = lib.mkIf cfg.enable {
    programs.wlogout = {
      enable = true;
      layout = [
        {
          "action" = "systemctl poweroff";
          "keybind" = "s";
          "label" = "shutdown";
          "text" = "Shutdown";
        }
        {
          "action" = "systemctl reboot";
          "keybind" = "r";
          "label" = "reboot";
          "text" = "Reboot";
        }
        {
          "action" = "systemctl hibernate";
          "keybind" = "h";
          "label" = "hibernate";
          "text" = "Hibernate";
        }
      ];
      style = ''
        * {
          font-family: JetBrains Mono;
          font-size: 24px;
          transition-property: background-color;
          transition-duration: 0.7s;
          opacity: 1;
        }
        window {
          background-color: #282828;
          border-radius: 10px;
          opacity: 0.6;
        }
        button {
          color: #ebdbb2;
          background-color: #076678;
          border-style: solid;
          border-width: 2px;
          border-radius: 5%;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 5%;
          margin: 15px;
        }

        button:active,
        button:hover {
          background-color: #458488;
        }

        button:focus {
          background-color: #458488;
        }

        #suspend {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"),
            url("${pkgs.wlogout}/share/wlogout/icons/suspend.png")
          );
        }

        #hibernate {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png"),
            url("${pkgs.wlogout}/share/wlogout/icons/hibernate.png")
          );
        }

        #shutdown {
          background-image: image(
            url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"),
            url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png")
          );
        }

        #reboot {
          background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"), url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
        }

      '';
    };
  };
}
