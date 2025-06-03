{pkgs, ...}:

{
  programs.vscode = {
    enable = true;
    
    # User settings (applied to settings.json)
    userSettings = {
      # General editor settings
      "editor.fontFamily" = "'Fira Code'";
      "editor.fontSize" = 14;
      "editor.formatOnSave" = true;
      
      # Nix-specific settings
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };
      
      # Terminal settings
      "terminal.integrated.fontFamily" = "'Fira Code'";
      "terminal.integrated.fontSize" = 14;
    };

    # Extensions configuration
    extensions = with pkgs.vscode-extensions; [
      # Essential Nix support
      jnoortheen.nix-ide
      
      # Version control
      github.copilot
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
