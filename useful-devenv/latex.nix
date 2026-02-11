{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  # https://devenv.sh/basics/
  env.GREET = "LaTeX Development Environment";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    texlive.combined.scheme-full # Full TeX Live distribution
    # Or use a smaller scheme:
    # texlive.combined.scheme-medium

    # PDF viewer for live preview
    zathura # Lightweight PDF viewer with auto-reload
    # evince  # Alternative: GNOME document viewer
  ];

  # https://devenv.sh/scripts/
  scripts.compile-tex.exec = ''
    if [ -z "$1" ]; then
      echo "Usage: compile-tex <filename.tex>"
      exit 1
    fi
    pdflatex -interaction=nonstopmode "$1"
  '';

  scripts.watch-tex.exec = ''
    if [ -z "$1" ]; then
      echo "Usage: watch-tex <filename.tex>"
      exit 1
    fi

    # Compile once first
    pdflatex -interaction=nonstopmode "$1"

    # Watch for changes and recompile
    while ${pkgs.inotify-tools}/bin/inotifywait -e modify "$1"; do
      echo "Recompiling $1..."
      pdflatex -interaction=nonstopmode "$1"
    done
  '';

  scripts.clean-tex.exec = ''
    rm -f *.aux *.log *.out *.toc *.lof *.lot *.fls *.fdb_latexmk *.synctex.gz *.bbl *.blg *.nav *.snm *.vrb
    echo "Cleaned LaTeX auxiliary files"
  '';

  enterShell = ''
    echo ""
    echo "🎓 $GREET"
    echo ""
    echo "📝 Available commands:"
    echo "  compile-tex <file.tex>  - Compile a LaTeX file once"
    echo "  watch-tex <file.tex>    - Watch and auto-compile on changes"
    echo "  clean-tex               - Remove auxiliary files"
    echo ""
    echo "💡 VS Code Extensions recommended:"
    echo "  - LaTeX Workshop (James-Yu.latex-workshop)"
    echo ""
  '';
}
