{
  config,
  lib,
  ...
}:
let
  # https://mozilla.github.io/policy-templates/
  moz = short: "https://addons.mozilla.org/en-US/firefox/downloads/latest/${short}/latest.xpi";
  ublock = {
    "uBlock0@raymondhill.net" = {
      install_url = moz "ublock-origin";
      installation_mode = "normal_installed";
      private_browsing = true;
    };
  };
  dwhelper = {
    "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}" = {
      install_url = "https://addons.mozilla.org/firefox/downloads/file/4502183/video_downloadhelper-9.5.0.2.xpi";
      installation_mode = "normal_installed";
      private_browsing = true;
      updates_disabled = true;
    };
  };
  vimium = {
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
      install_url = moz "vimium-ff";
      installation_mode = "normal_installed";
      private_browsing = true;
    };
  };
  multi-account-containers = {
    "@testpilot-containers" = {
      install_url = moz "multi-account-containers";
      installation_mode = "normal_installed";
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
          "home" = ublock // vimium // multi-account-containers;
          "developer" = ublock // vimium;
        }
        .${config.my.firefox.type};
      };
    };
  };
}
