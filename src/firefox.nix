{ config, pkgs, ... }:

{
  programs.firefox.enable = true;
  environment.sessionVariables.MOZ_USE_XINPUT2 = "1";

  programs.firefox.preferences = {
    "general.smoothScroll" = true;
    "browser.warnOnQuit" = false;
    "mousewheel.acceleration.factor" = "4"; # For some reason the following prefs can't be set for "stability reasons"
    "mousewheel.acceleration.start" = "2";
    "mousewheel.default.delta_multiplier_y" = "50";
  };

  # https://mozilla.github.io/policy-templates/#permissions
  programs.firefox.policies = {
    DisableTelemetry = true;
    DefaultDownloadDirectory = "/data/downloads"; # FIXME: should really pass in $DATA
    DisableAppUpdate = true;
    ManualAppUpdateOnly = true;
    DisplayBookmarksToolbar = "newtab";
    OfferToSaveLogins = false;
    OverrideFirstRunPage = "";
    PasswordManagerEnabled = false;
    EnableTrackingProtection = {
      Value = true;
      Locked = false;
      Cryptomining = true;
      Fingerprinting = true;
    };
    EncryptedMediaExtensions.enabled = false;
    FirefoxHome = {
      Search = false;
      TopSites = false;
      SponsoredTopSites = false;
      Highlights = false;
      Pocket = false;
      SponsoredPocket = false;
      Snippets = false;
      Locked = false;
    };
    Homepage.StartPage = "previous-session";
    Permissions = {
      Camera.Allow = [ "https://apps.google.com" ];
      Microphone.Allow = [ "https://apps.google.com" ];
      Location.Allow = [];
      Notifications.Allow = [];
      Autoplay.Allow = [];
    };
    PopupBlocking = {
      Allow = [];
      Default = false;
    };
    RequestedLocales = [ "en-GB" ];
    ExtensionSettings = {
      "{bb431b02-3350-4b58-b9fd-fb4d5e900fb6}" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/file/3602788/startpage_search_dark_theme-1.0.2.xpi";
      };
      "uBlock0@raymondhill.net" = {
        installation_mode = "force_installed";
        install_url = "https://addons.mozilla.org/firefox/downloads/file/4164949/ublock_origin-1.52.0.xpi";
      };
    };
    UserMessaging = {
      WhatsNew = false;
      ExtensionRecommendations = false;
      FeatureRecommendations = false;
      UrlbarInterventions = false;
      SkipOnboarding = true;
      MoreFromMozilla = false;
    };
  };
}