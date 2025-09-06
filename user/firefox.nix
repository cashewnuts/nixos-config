{ config, pkgs, ...}:
{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "sidebar.backupState" = ''{"panelOpen":true,"launcherExpanded":false,"launcherVisible":true}'';
          "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks";
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
        };
        search = {
          force = true;
          default = "ddg";
          order = [ "ddg" "google" ];
        };
      };
    };
  };
}
