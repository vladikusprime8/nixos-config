{ config, pkgs, ... }:

{
  # импорты
  imports = [
    ./hardware-configuration.nix
    ./happ-nixos/happ-module.nix
  ];

  # загрузчик и ядро
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  # общие настройки пакетов
  nixpkgs.config.allowUnfree = true;

  # сеть и локализация
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # графика и nvidia
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    powerManagement.enable = false;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  # рабочий стол (plasma 6 + wayland) и раскладка
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.defaultSession = "plasma";
  services.xserver.xkb = {
    layout = "us,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  # звук и печать
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # кастомные сервисы
  services.happ = {
    enable = true;
    forceXwayland = true;
  };

  # пользователь
  users.users."me" = {
    isNormalUser = true;
    description = "me";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # программы и пакеты
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    fastfetch
    ayugram-desktop
    git
    alacritty
    fuzzel
    xwayland-satellite
    (builtins.getFlake "github:areofyl/fetch").packages.${stdenv.hostPlatform.system}.default
    pkgs.linuxKernel.packages.linux_zen.r8125  
];

  # nix-ld (для запуска обычных linux-бинарников)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      zlib
      openssl
      glib
      dbus
      fontconfig
      freetype
      libGL
      libxkbcommon
      wayland
      alsa-lib
      libx11
      libxcb
      libxcb-cursor
      libxcb-image
      libxcb-keysyms
      libxcb-render-util
      libxcb-wm
      libxcb-util
    ];
  };

  # настройки самого nix и флейки
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # версия состояния системы (после установки не менять)
  system.stateVersion = "26.05";
}
