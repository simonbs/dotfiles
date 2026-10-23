#!/usr/bin/env python3
"""Check configuration syntax and Stow links without changing the home folder."""

import ast
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

try:
    import tomllib
except ImportError:
    sys.exit("Python 3.11 or newer is required. Install it with brew bundle.")


ROOT = Path(__file__).resolve().parent.parent


def run(*args):
    subprocess.run(args, cwd=ROOT, check=True, stdout=subprocess.DEVNULL)


def main():
    for tool in ("zsh", "bash", "git", "ruby", "stow"):
        if not shutil.which(tool):
            sys.exit(f"Missing command: {tool}")

    run("zsh", "-n", str(ROOT / "zsh/.zshrc"))
    for script in ("rip-with-ffmpeg.sh", "rip-yt.sh", "tmp-codex"):
        run("bash", "-n", str(ROOT / "scripts" / script))
    for path in (ROOT / "scripts").glob("*.py"):
        ast.parse(path.read_text(), filename=str(path))
    ast.parse((ROOT / ".githooks/pre-commit").read_text())
    for path in ROOT.glob("*/*.toml"):
        tomllib.loads(path.read_text())
    for path in ROOT.glob("*/.config/**/*.toml"):
        tomllib.loads(path.read_text())
    json.loads((ROOT / "claude/settings.json").read_text())
    run("git", "config", "--file", str(ROOT / "git/.gitconfig"), "--list")
    run("ruby", "-c", str(ROOT / "Brewfile"))
    print("Configuration syntax passed.")

    with tempfile.TemporaryDirectory(prefix="dotfiles-check-") as temporary:
        home = Path(temporary) / "home"
        home.mkdir()
        groups = [
            (home, ["zsh", "starship", "tmux", "mise", "git", "gnupg", "psql", "vim"]),
            (home / "Library/Application Support/com.mitchellh.ghostty", ["ghostty"]),
            (home / ".claude", ["claude"]),
            (home / ".codex", ["codex"]),
        ]
        for target, packages in groups:
            target.mkdir(parents=True, exist_ok=True)
            run("stow", "--dir", str(ROOT), "--target", str(target), *packages)
            for package in packages:
                for source in (ROOT / package).rglob("*"):
                    if source.is_file():
                        link = target / source.relative_to(ROOT / package)
                        if not link.exists() or link.resolve() != source.resolve():
                            raise RuntimeError(f"Incorrect Stow link: {link}")
            run("stow", "--delete", "--dir", str(ROOT), "--target", str(target), *packages)
        if any(path.is_symlink() for path in home.rglob("*")):
            raise RuntimeError("Stow left links behind after removal")

        # Check the README's alternative setup for XDG_CONFIG_HOME.
        config = home / "custom-config"
        config.mkdir()
        for package in ("starship", "mise"):
            source_dir = ROOT / package / ".config"
            run("stow", "--dir", str(source_dir), "--target", str(config), ".")
            for source in source_dir.rglob("*.toml"):
                if (config / source.relative_to(source_dir)).resolve() != source.resolve():
                    raise RuntimeError(f"Incorrect XDG link for {package}")
            run("stow", "--delete", "--dir", str(source_dir), "--target", str(config), ".")
    print("Stow installation and removal passed, including custom XDG paths.")


if __name__ == "__main__":
    try:
        main()
    except (OSError, ValueError, RuntimeError, SyntaxError, subprocess.CalledProcessError) as error:
        sys.exit(f"Configuration check failed: {error}")
