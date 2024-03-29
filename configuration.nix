# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Hardware configuration settings for xps 13.
      /etc/nixos/nixfiles/dell/xps/13-7390/default.nix
	  /etc/nixos/nixconfigs/computers/laptop.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  # Limit the number of configurations that live in boot
  # to avoid it filling up.
  boot.loader.grub.configurationLimit = 50;
  boot.extraModprobeConfig = ''
	  options snd_mia index=0
	  options snd_hda_intel index=1
	  '';
 # remove later.
  # boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jacksons-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  virtualisation.docker.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  # Set your time zone.
    time.timeZone = "Europe/London";
    nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
	  (import /etc/nixos/nixconfigs/programs/papis/papis.nix )
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; let
        install-python-packages = python-packages: with python-packages; [
           requests
           numpy
           scipy
           matplotlib
           setuptools
		   mypy-extensions
		   pyyaml
];
        python3-with-packages = python3.withPackages install-python-packages;
   in
	   [
		   wget
		   vim
		   neovim
		   htop
		   psmisc
		   git
		   calc
		   bind
		   traceroute
		   # terminal utils
		   tmux
		   terminator
		   zsh
		   fzf
		   fd
		   ripgrep
		   ripgrep-all
		   unzip
		   file
		   # misc
		   openvpn
		   networkmanager
		   networkmanagerapplet
		   dejavu_fonts
		   powerline-fonts
		   vanilla-dmz
		   docker
		   # programs
		   zoom
		   libreoffice
		   pdfsam-basic
		   chromium
		   firefox
		   dropbox
		   qpdfview
		   evince
		   parallel
		   papis
		   spotify-tui
		   spotifyd
		   spotify
		   mautrix-whatsapp
		   zoom-us
		   feh
		   # tex and paper writing utils
		   texlive.combined.scheme-full
		   graphviz
		   inkscape
		   # utils
		   nethogs
		   iotop
		   wireshark
		   tcpdump
		   rofi
		   xorg.xbacklight
		   acpilight
		   xclip
		   redshift
		   # Audio
		   playerctl
		   alsaTools
		   alsaLib
		   alsaUtils
		   alsaPlugins
		   # nix tools
		   nix-index
		   # Development tools
		   python3-with-packages
		   python2
		   python37Packages.virtualenv
		   python37Packages.pip
		   python27Packages.pip
		   gnome3.adwaita-icon-theme
	   ];

   services.xserver.windowManager.i3.enable = true;
   services.xserver.libinput.enable = true;
   services.xserver.synaptics.maxSpeed = "2.0";
   services.xserver.synaptics.accelFactor = "0.1";
   services.xserver.displayManager.defaultSession = "none+i3";
   services.xserver.displayManager.sessionCommands = ''
	   ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name ${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ/cursors/left_ptr 128 &disown
	   '';
   services.xserver.config = ''
	 Section "Device"
	  Identifier "Intel Graphics"
	  Driver "intel"
	  Option "Backlight" "intel_backlight"
	 EndSection
   '';
   environment.variables.XCURSOR_SIZE = "32";
   hardware.opengl.driSupport32Bit = true;

   # This isn't working right now, not sure why.
   # services.openvpn.servers = {
	   # UoEVPN = { config = '' config ~/config/nixos/ed.ovpn ''; };
   # };

   networking.networkmanager = {
     enable = true;
   };
   networking.hostId = "ac174b52";

  services.xserver.dpi = 210;

  services.cron = {
	  enable = true;
	  systemCronJobs = [
		#  m  h dom mon dow  command
		  "* * * * * jackson ./etc/profile; /home/jackson/.scripts/randomize-backgrounds"
	  ];
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.light.enable = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
    services.printing.enable = true;

  # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.layout = "gb";
    #services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.jackson = {
      isNormalUser = true;
      home = "/home/jackson";
      extraGroups = [ "wheel" "plugdev" "networkmanager" "audio" "docker"]; # Enable ‘sudo’ for the user.
      shell = "/run/current-system/sw/bin/zsh";
      uid = 1000;
    };

  programs.zsh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

