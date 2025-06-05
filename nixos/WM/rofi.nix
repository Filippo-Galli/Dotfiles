{ config, pkgs, ... }:
let
  sharedStyles = ''
    /*****----- Global Properties -----*****/
    * {
        font:                        "JetBrainsMono Nerd Font 11";
        
        /* Color Palette */
        bg0:     rgba(0,0,0,0.7);
        bg1:     #1a1a1a;
        bg2:     #2d2d2d;
        bg3:     #404040;
        
        fg0:     #cdd6f4;
        fg1:     #bac2de;
        fg2:     #a6adc8;
        
        accent:  #777777;
        border:  rgba(55,55,55,0.5);
        urgent:  #f38ba8;
        warning: #fab387;
        
        transparent: rgba(0,0,0,0);
    }

    /*****----- Main Window -----*****/
    window {
        transparency:                "real";
        location:                    center;
        anchor:                      center;
        fullscreen:                  false;
        width:                       600px;
        height:                      450px;
        x-offset:                    0px;
        y-offset:                    0px;

        enabled:                     true;
        margin:                      0px;
        padding:                     0px;
        border:                      2px solid;
        border-radius:               15px;
        border-color:                @border;
        cursor:                      "default";
        background-color:            @bg0;
    }

    /*****----- Inputbar -----*****/
    inputbar {
        enabled:                     true;
        spacing:                     12px;
        margin:                      0px 0px 15px 0px;
        padding:                     15px 20px;
        border:                      0px;
        border-radius:               12px;
        border-color:                @border;
        background-color:            @bg1;
        children:                    [ "textbox-prompt-colon", "entry" ];
    }

    textbox-prompt-colon {
        enabled:                     true;
        expand:                      false;
        padding:                     0px;
        border-radius:               0px;
        background-color:            @transparent;
        text-color:                  @border;
        str:                         "";
    }

    entry {
        enabled:                     true;
        padding:                     0px;
        border:                      0px;
        background-color:            @transparent;
        text-color:                  @fg0;
        cursor:                      text;
        placeholder:                 "Type to search...";
        placeholder-color:           @fg2;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }

    /*****----- Elements -----*****/
    element {
        enabled:                     true;
        spacing:                     12px;
        margin:                      0px;
        padding:                     12px 15px;
        border:                      0px;
        border-radius:               10px;
        background-color:            @bg1;
        text-color:                  @fg1;
        cursor:                      pointer;
    }

    element normal.normal {
        background-color:            @bg1;
        text-color:                  @fg1;
    }

    element normal.urgent {
        background-color:            @urgent;
    }

    element selected.normal {
        background-color:            @border;
    }

    element selected.urgent {
        background-color:            @urgent;
    }

    element-icon {
        background-color:            @transparent;
        size:                        28px;
        cursor:                      inherit;
    }

    element-text {
        background-color:            @transparent;
        text-color:                  inherit;
        cursor:                      inherit;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }

    /*****----- Message -----*****/
    error-message {
        padding:                     20px;
        border:                      0px;
        border-radius:               15px;
        background-color:            @urgent;
    }

    message {
        padding:                     0px;
        border:                      0px;
        border-radius:               0px;
        background-color:            @transparent;
        text-color:                  @fg0;
    }

    textbox {
        padding:                     15px;
        border:                      0px;
        border-radius:               10px;
        background-color:            @bg2;
        text-color:                  @fg0;
        vertical-align:              0.5;
        horizontal-align:            0.0;
    }
  '';

  # Function to generate theme with specific layout configurations
  mkTheme = { columns ? 2, lines ? 6, showModeSwitcher ? true, spacing ? "15px" }: ''
    ${sharedStyles}

    /*****----- Main Box -----*****/
    mainbox {
        enabled:                     true;
        spacing:                     ${spacing};
        padding:                     25px;
        background-color:            @transparent;
        children:                    [ "inputbar", "listview"${if showModeSwitcher then '', "mode-switcher"'' else ""} ];
    }

    /*****----- Listview -----*****/
    listview {
        enabled:                     true;
        columns:                     ${toString columns};
        lines:                       ${toString lines};
        cycle:                       true;
        dynamic:                     true;
        scrollbar:                   false;
        layout:                      vertical;
        reverse:                     false;
        fixed-height:                true;
        fixed-columns:               true;
        
        spacing:                     ${if columns == 1 then "6px" else "10px"};
        margin:                      ${if showModeSwitcher then "10px 0px 0px 0px" else "0px"};
        background-color:            @transparent;
        cursor:                      "default";
    }

    ${if showModeSwitcher then ''
    /*****----- Mode Switcher -----*****/
    mode-switcher {
        enabled:                     true;
        expand:                      false;
        spacing:                     12px;
        margin:                      10px 0px 0px 0px;
        padding:                     12px;
        border:                      0px;
        border-radius:               12px;
        background-color:            @bg1;
    }

    button {
        padding:                     10px 16px;
        border:                      0px;
        border-radius:               8px;
        background-color:            @transparent;
        text-color:                  @fg1;
        cursor:                      pointer;
    }

    button selected {
        background-color:            @border;
    }
    '' else ""}
  '';
in
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    extraConfig = {
      modi = "drun,window";
      show-icons = true;
      display-drun = "󰀻 Apps";
      display-window = "󰖯 Windows";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      font = "JetBrainsMono Nerd Font 11";

      # dmenu specific settings
      dmenu-display-format = "{text}";
      markup-rows = false;
      auto-select = false;
      sort = false;
      matching = "fuzzy";
    };
    
    # Use the custom theme file
    theme = "~/.config/rofi/custom-theme.rasi";
  };
  
  # Create theme files using the shared base
  home.file = {
    # Main theme (2 columns, with mode switcher)
    ".config/rofi/custom-theme.rasi".text = mkTheme {
      columns = 2;
      lines = 6;
      showModeSwitcher = true;
      spacing = "15px";
    };
    
    # Dmenu theme (1 column, no mode switcher)
    ".config/rofi/custom-theme-dmenu.rasi".text = mkTheme {
      columns = 1;
      lines = 10;
      showModeSwitcher = false;
      spacing = "0px";
    };
  };
}