{
  config,
  lib,
  ...
}:
let
  ublock = {
    "uBlock0@raymondhill.net" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
  };
  dwhelper = {
    "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/video-downloadhelper/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
  };
  vimium = {
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/vimium-ff/latest.xpi";
      installation_mode = "force_installed";
      private_browsing = true;
    };
  };
in
{
  config = lib.mkIf config.my.firefox.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DontCheckDefaultBrowser = true;

        ExtensionSettings = {
          # install url template
          # https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi
          #
        }
        // {
          "private" = ublock // dwhelper // vimium;
          "home" = ublock // vimium;
          "developer" = ublock // vimium;
        }
        .${config.my.firefox.type};
      };
    };
  };
}
