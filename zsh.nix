{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    zsh-powerlevel10k
    meslo-lgs-nf
    fish
  ];

  environment.shellAliases = {
    nshell = "nix-shell --run $SHELL";
  };

  programs.fish.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;

    ohMyZsh = {
      enable = true;
      theme = "";
      plugins = [
        "git"
        "sudo"
        "z"
        "extract"
        "colored-man-pages"
        "history-substring-search"
      ];
    };

    promptInit = ''
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

      if [[ -n "$ALACRITTY_WINDOW_ID" && -z "$FASTFETCH_SHOWN" ]]; then
        export FASTFETCH_SHOWN=1
        fastfetch
      fi

      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down
      bindkey '^[OA' history-substring-search-up
      bindkey '^[OB' history-substring-search-down

      bindkey '^F' autosuggest-accept
    '';
  };

  users.defaultUserShell = pkgs.zsh;
  system.userActivationScripts.zshrc = "touch .zshrc";
  environment.shells = [ pkgs.zsh ];
}
