{ pkgs, config, ... }:

{
  packages = [
    pkgs.git
    pkgs.file
    pkgs.bashInteractive

    pkgs.uv
    pkgs.python311 # or python311, whichever you prefer

    pkgs.gcc13
    pkgs.parallel
  ];

  enterShell = ''
    # Use tmp_pip for pip/uv temp files (prevents /tmp exhaustion)
    export TMPDIR="$PWD/tmp_pip"
    export PIP_CACHE_DIR="$PWD/tmp_pip/pip-cache"
    export UV_CACHE_DIR="$PWD/tmp_pip/uv-cache"
    mkdir -p "$TMPDIR" "$PIP_CACHE_DIR" "$UV_CACHE_DIR"
    export LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib:$LD_LIBRARY_PATH"

    # Create .venv if missing
      if [[ ! -d .venv ]]; then
        uv venv --python ${pkgs.python311}/bin/python .venv
      fi

      # Activate
      source .venv/bin/activate

      # Sync from uv.lock (much faster than requirements.txt, reproducible)
      # uv sync --no-cache

      # Install ipykernel for Jupyter
      # uv add ipykernel --no-cache

      # Register kernel
      # python -m ipykernel install --user \
        --name sbi-hackathon-uv \
        --display-name "Python (sbi-hackathon uv)"

      echo "✅ Python $(python --version)"
      echo "✅ uv sync complete from uv.lock"
      echo "✅ Jupyter kernel registered"
  '';
}
