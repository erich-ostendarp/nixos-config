{ pkgs, username, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "eostendarp";
      email = "erich.ostendarp@gmail.com";
    };
  };

  programs.home-manager.enable = true;
}
