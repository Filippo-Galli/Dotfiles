{ config, pkgs, ... }:

{
  home.packages = [
    (pkgs.python3Packages.buildPythonApplication rec {
      pname = "gazelle-tui";
      version = "1.6";

      src = pkgs.fetchFromGitHub {
        owner = "Zeus-Deus";
        repo = "gazelle-tui";
        rev = "v1.6";
        sha256 = "sha256-H8+mI63cuHXqqzk7z06dPKwKoxxEGjNwjr+WWV5dVOI=";
      };

      format = "other";

      propagatedBuildInputs = with pkgs.python3Packages; [
        textual
        rich
        platformdirs
      ];

      installPhase = ''
        mkdir -p $out/bin $out/lib/gazelle-tui
        cp -r * $out/lib/gazelle-tui
        cp gazelle $out/bin/
        patchShebangs $out/bin/gazelle
        chmod +x $out/bin/gazelle

        mv $out/bin/gazelle $out/bin/gazelle-real
        cat > $out/bin/gazelle <<EOF
      #!/bin/sh
      export PYTHONPATH=$out/lib/gazelle-tui:\$PYTHONPATH
      exec $out/bin/gazelle-real "\$@"
      EOF
        chmod +x $out/bin/gazelle
      '';

      meta = with pkgs.lib; {
        description = "Minimal NetworkManager TUI with 802.1X enterprise WiFi support";
        homepage = "https://github.com/Zeus-Deus/gazelle-tui";
        license = pkgs.lib.licenses.mit;
        platforms = pkgs.lib.platforms.linux;
      };
    })
  ];
}