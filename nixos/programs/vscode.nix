{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    package = pkgs.unstable.vscode; 

    # User settings (applied to settings.json)
    userSettings = {
      # General editor settings
      "editor.fontFamily" = "'Fira Code'";
      "editor.fontSize" = 14;
      "editor.formatOnSave" = true;

      # Password-store management
      "password-store" = "gnome-libsecret";

      # Auto-save settings
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 500; # Auto-save after 1 second of inactivity

      # Nix-specific settings
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "nix.serverPath" = "nil";
        "editor.formatOnSave" = true;
        "editor.tabSize" = 2;
        "editor.insertSpaces" = true;
      };

      # Agent mode
      "workbench.experimental.featureSettings.agentChat" = true;

      # Theme
      "workbench.activityBar.location" = "bottom";
      "editor.minimap.enabled" = false;
      "window.commandCenter" = false;
      "workbench.sideBar.location" = "right";

      # Terminal settings
      "terminal.integrated.fontFamily" = "'Fira Code'";
      "terminal.integrated.fontSize" = 14;
    };

    # Extensions configuration
    extensions = with pkgs.vscode-extensions; [
      # Essential Nix support
      jnoortheen.nix-ide

      # Copilot and Copilot Chat
      github.copilot
      github.copilot-chat
    ];

    # Optional: Configure VS Code keybindings
    keybindings = [
      {
        key = "ctrl+q";
        command = "workbench.action.terminal.toggleTerminal";
        when = "editorTextFocus";
      }
    ];
  };
}
