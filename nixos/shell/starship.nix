{pkgs, ...}:{
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
      
      format = "$memory_usage$directory$git_branch$git_state$git_status$git_metrics$line_break$character";
      
      right_format = "$nix_shell $cmd_duration $jobs $time";

      jobs = {
        symbol = "";
        style = "bold red";
        number_threshold = 0;
        format = "[$symbol]($style)";
      };
      
      time = {
        disabled = false;
        style = "bold white";
        time_format = "%T"; # Hour:Minute:Second Format
        format = "[$time]($style)";
      };
      
      cmd_duration = {
        format = "[$duration ]($style)";
        style = "yellow";
      };
      
      directory = {
        style = "blue";
        read_only = " ";
        truncation_length = 4;
        truncate_to_repo = false;
      };
      
      git_branch = {
        symbol = " ";
        format = "[$symbol$branch]($style) ";
        style = " fg:#f77e05 ";
      };
      
      git_status = {
        format = "([\\[$all_status\\]]($style) )";
        style = "cyan";
      };
      
      git_state = {
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
        style = "bright-black";
      };
      
      git_metrics = {
        disabled = true;
      };
      
      hg_branch = {
        format = "[ $symbol$branch ]($style)";
        symbol = "";
      };
      
      character = {
        success_symbol = "[❯](green)";
        error_symbol = "[✗](red)";
        vicmd_symbol = "[❮](purple)";
      };
      
      memory_usage = {
        disabled = false;
        threshold = -1;
        symbol = " ";
        format = "[$ram_pct $symbol]($style) ";
        style = "bold dimmed green";
      };
      
      nix_shell = {
        disabled = false;
        # Custom messages for different shell types
        impure_msg = "[❄️ impure](bold blue)";
        pure_msg = "[❄️ pure](bold green)";
        unknown_msg = "[❄️ shell](bold yellow)";
        # Format: shows the shell type and optionally the shell name
        format = "[$state( \\($name\\))]($style) ";
        # Style for the entire nix-shell indicator
        style = "bold purple";
        # Show shell name when available (from shell.nix, flake.nix, etc.)
        heuristic = true;
      };
    };
  };
}