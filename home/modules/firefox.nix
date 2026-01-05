{ config, pkgs, ... }:
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
          "browser.uiCustomization.state" =
            ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","firefox-view-button","urlbar-container","vertical-spacer","downloads-button","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button","_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action","ublock0_raymondhill_net-browser-action","_b9db16a4-6edc-47ec-a1f4-b86292ed211d_-browser-action","screenshot-button"],"dirtyAreaCache":["nav-bar","TabsToolbar","vertical-tabs","unified-extensions-area","toolbar-menubar","PersonalToolbar"],"currentVersion":23,"newElementCount":4}'';
        };
        search = {
          force = true;
          default = "ddg";
          order = [
            "ddg"
            "google"
          ];
        };
      };
    };
  };
}
