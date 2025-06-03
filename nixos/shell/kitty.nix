{ pkgs, ... }:

# terminals

let
  font = "JetBrainsMono Nerd Font";
  #cfg = config.programs.kitty;
in
{
  programs.kitty = {
    enable = true;
    settings = {
   	 confirm_os_window_close = 0;
	 hide_window_decorations = "yes";
    	 window_padding_width = 7;
         background_opacity = "0.1";
         background_blur = 15;
	 font_size = 12.0; 
	 
	# To correctly display starship icon of git 
    symbol_map = let
      mappings = [
        "U+23FB-U+23FE"
        "U+2B58"
        "U+E200-U+E2A9"
        "U+E0A0-U+E0A3"
        "U+E0B0-U+E0BF"
        "U+E0C0-U+E0C8"
        "U+E0CC-U+E0CF"
        "U+E0D0-U+E0D2"
        "U+E0D4"
        "U+E700-U+E7C5"
        "U+F000-U+F2E0"
        "U+2665"
        "U+26A1"
        "U+F400-U+F4A8"
        "U+F67C"
        "U+E000-U+E00A"
        "U+F300-U+F313"
        "U+E5FA-U+E62B"
      ];
    in
      (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
      # Basic colors
      foreground              = "#cdd6f4";
      background              = "#1e1e2e";
      selection_foreground    = "#1e1e2e";
      selection_background    = "#f5e0dc";
      
      # Cursor colors
      cursor                  = "#f5e0dc";
      cursor_text_color       = "#1e1e2e";
      
      # URL underline color
      url_color               = "#f5e0dc";
      
      # Window border colors
      active_border_color     = "#b4befe";
      inactive_border_color   = "#6c7086";
      bell_border_color       = "#f9e2af";
      
      # Titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color   = "system";
      
      # Tab bar colors
      active_tab_foreground   = "#11111b";
      active_tab_background   = "#cba6f7";
      inactive_tab_foreground = "#cdd6f4";
      inactive_tab_background = "#181825";
      tab_bar_background      = "#11111b";
      
      # Mark colors
      mark1_foreground = "#1e1e2e";
      mark1_background = "#b4befe";
      mark2_foreground = "#1e1e2e";
      mark2_background = "#cba6f7";
      mark3_foreground = "#1e1e2e";
      mark3_background = "#74c7ec";
      
      # 16 terminal colors
      color0 = "#45475a";
      color8 = "#585b70";
      color1 = "#f38ba8";
      color9 = "#f38ba8";
      color2 = "#a6e3a1";
      color10 = "#a6e3a1";
      color3 = "#f9e2af";
      color11 = "#f9e2af";
      color4 = "#89b4fa";
      color12 = "#89b4fa";
      color5 = "#f5c2e7";
      color13 = "#f5c2e7";
      color6 = "#94e2d5";
      color14 = "#94e2d5";
      color7 = "#bac2de";
      color15 = "#a6adc8";
      
      # Tab bar configuration (from previous settings)
      tab_bar_style = "separator";
      tab_separator = "";
      tab_bar_min_tabs = 2;
      
      # Tab title templates
      tab_title_template = "{fmt.fg._5c6370}{fmt.bg._11111b}{fmt.fg._cdd6f4}{fmt.bg._5c6370} ({index}) {title} {fmt.fg._5c6370}{fmt.bg._11111b}";
      active_tab_title_template = "{fmt.fg._BAA0E8}{fmt.bg._11111b}{fmt.fg._1e1e2e}{fmt.bg._BAA0E8} ({index}) {title} {fmt.fg._BAA0E8}{fmt.bg._11111b}";
      active_tab_font_style = "bold";
      
      # Keybindings
      "map alt+1" = "goto_tab 1";
      "map alt+2" = "goto_tab 2";
      "map alt+3" = "goto_tab 3";
      "map alt+4" = "goto_tab 4";
      "map alt+5" = "goto_tab 5";
      "map alt+6" = "goto_tab 6";
      "map alt+7" = "goto_tab 7";
      "map alt+8" = "goto_tab 8";
      "map alt+9" = "goto_tab 9";
      
      "map ctrl+t" = "new_tab";
      "map ctrl+w" = "close_tab";
      
      "map ctrl+shift+page_up" = "move_tab_backward";
      "map ctrl+shift+page_down" = "move_tab_forward";
    };
  };
}
