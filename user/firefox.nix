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
          # "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.search.defaultenginename" = "DuckDuckGo";
          "browser.search.order.1" = "DuckDuckGo";

          "sidebar.backupState" = ''{"panelOpen":true,"launcherExpanded":false,"launcherVisible":true}'';
          "sidebar.main.tools" = "aichat,syncedtabs,history,bookmarks";
          "sidebar.revamp" = true;
          "sidebar.verticalTabs" = true;
        };
        search = {
          force = true;
          default = "DuckDuckGo";
          order = [ "DuckDuckGo" "Google" ];
        };
      };
    };
  };
}
