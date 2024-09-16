  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (fetchTarball "https://github.com/nix-community/nixos-vscode-server/tarball/master")
    ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.gnome.excludePackages = (with pkgs; [
      gnome-tour
      gnome-photos
      gedit #text-editor
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp # Help view
      eog # image viewer
      simple-scan # document scanner
      totem       # video player
      evince      # document viewer
      file-roller # archive manager
      geary       # email client
      gnome-calendar
      gnome-contacts
      gnome-music
      gnome-weather
      gnome-initial-setup
      gnome-maps
    ]);

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    zsh-autoenv.enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableLsColors = true;
    setOptions = [
      "BANG_HIST"                 # Treat the '!' character specially during expansion.
      "EXTENDED_HISTORY"          # Write the history file in the ":start:elapsed;command" format.
      "INC_APPEND_HISTORY"        # Write to the history file immediately, not when the shell exits.
      "SHARE_HISTORY"             # Share history between all sessions.
      "HIST_EXPIRE_DUPS_FIRST"    # Expire duplicate entries first when trimming history.
      "HIST_IGNORE_DUPS"          # Don't record an entry that was just recorded again.
      "HIST_IGNORE_ALL_DUPS"      # Delete old recorded entry if new entry is a duplicate.
      "HIST_FIND_NO_DUPS"         # Do not display a line previously found.
      "HIST_IGNORE_SPACE"         # Don't record an entry starting with a space.
      "HIST_SAVE_NO_DUPS"         # Don't write duplicate entries in the history file.
      "HIST_REDUCE_BLANKS"        # Remove superfluous blanks before recording entry.
      "HIST_VERIFY"               # Don't execute immediately upon history expansion.
      "HIST_BEEP"                 # Beep when accessing nonexistent history.0
    ];
    shellAliases = {
      ll="ls -alsh";
      cat="bat -pp --theme=TwoDark";
      history="history -E -10000000";
      update="sudo nixos-rebuild switch";
    };
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    histSize = 10000000000000;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "dirhistory"
        "fasd"
        "history-substring-search"
        # "zsh-z" do not work
        "thor"
        "docker"
        #history-sync
        "kubectl"
        # "zsh-motd" does not work
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ vim-airline vim-airline-themes vim-lastplace vim-nix ];
        opt = [ ];
      };
      customRC = ''
        set nocompatible
        set backspace=indent,eol,start
        set number
        set smartindent
        set autoindent
        set shiftwidth=2
        set tabstop=2
        set pastetoggle=<F2>
        syntax on
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
      '';
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    zsh-powerlevel10k
    nixd
    nixpkgs-fmt
    deadnix
    bat
    meslo-lgs-nf
    restic
    gnome-extension-manager
    gnome.gnome-tweaks
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-dock
    gnomeExtensions.simple-monitor  
  ];

  font.packages = with pkgs; [(
    nerdfonts.override {
      fonts = [
        "Meslo" 
      ]; 
    }) 
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";

