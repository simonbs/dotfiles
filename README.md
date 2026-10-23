# dotfiles

My macOS settings for Zsh, Ghostty, Git, tmux, and other tools. Most Homebrew paths are for Apple Silicon Macs.

## Install

Install [Homebrew](https://brew.sh) first. Run these commands from this repository:

```sh
brew bundle
stow -t "$HOME" zsh starship tmux mise
mise install
git config --local core.hooksPath .githooks
exec zsh
```

`Brewfile` lists the terminal, fonts, shell tools, Git tools, Python, and video helpers. Run `brew bundle check` to check for missing packages. `brew bundle` also upgrades installed packages; use `brew bundle --no-upgrade` to install only what is missing.

The Git hook needs Python 3. It blocks commits that contain saved Codex project approvals or hook trust state and checks the files staged for commit.

Stow creates links from your home folder to files in this repository. Changes here take effect through those links. Back up existing files if Stow reports a conflict. To remove links, use `stow -D -t "$HOME" <folder>`.

## Shell

Zsh uses Starship for the prompt. It shows the folder, Git branch, file changes, and relevant language versions. Commands that take at least three seconds show their duration. Failed commands show their exit code.

The prompt uses Dracula colors and Nerd Font icons. Edit `starship/.config/starship.toml` to change it. Git symbols include `+` for staged files, `~` for modified files, `?` for untracked files, and arrows for commits ahead or behind.

| Shortcut or command | Action |
| --- | --- |
| Ctrl-R | Search command history |
| Ctrl-T | Search files; Ctrl-/ shows or hides the preview |
| Escape, then C | Search folders below the current folder and jump to one |
| `**` then Tab | Search to complete a path, for example after `cd **` |
| `z <name>` / `zi` | Jump to a visited folder / search visited folders |
| `ls`, `ll`, `la`, `lt` | List files, details, hidden files, or a folder tree |
| `cat <file>` | Read a file with syntax colors using bat |
| `fd`, `fo` | Pick a folder to enter or a file to open |
| `fbr`, `fshow` | Pick a Git branch or browse commits |
| `wut`, `wt` | Manage Git worktrees / pick a worktree folder |
| `agents-tmux` | Create or return to the `agents` tmux session |
| `killport <port>` | Stop processes listening on a TCP port |

Press Escape to cancel a search. Use `command ls` or `command cat` for the standard commands. Common Git shortcuts include `gst`, `ga`, `gcmsg`, `gd`, `gl`, and `gp`; see `zsh/.zshrc` for the full list. The default editor is Nova.

Put machine-specific environment settings in `~/.zshrc.local`. Put alias and function overrides in `~/.aliases.local`. These files are not stored here. Run `exec zsh` after changing shell settings.

`startpostgresql` and `stoppostgresql` use `/opt/homebrew/var/postgresql@16`. Set `POSTGRES_DATA_DIR` in `~/.zshrc.local` for a different database folder.

If you set `XDG_CONFIG_HOME`, leave `starship` and `mise` out of the first Stow command and link them separately:

```sh
mkdir -p "$XDG_CONFIG_HOME"
stow -d starship/.config -t "$XDG_CONFIG_HOME" .
stow -d mise/.config -t "$XDG_CONFIG_HOME" .
mise install
```

## Node and mise

[mise](https://mise.jdx.dev) manages Node versions. The default is Node LTS, configured in `mise/.config/mise/config.toml`. Zsh switches versions automatically when entering a project with a `mise.toml` or `.tool-versions` file.

```sh
mise use node@22          # Set a project version in mise.toml
mise install              # Install tools declared by the current configuration
mise upgrade node         # Update Node within the configured version
mise current              # Show active tool versions
```

Commit a project’s `mise.toml` to share its version with others. Edit the dotfiles config to change the default version or add other tools, then run `mise install`.

## Ghostty and tmux

Ghostty is installed by `brew bundle`. Link its settings:

```sh
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
stow -t "$HOME/Library/Application Support/com.mitchellh.ghostty" ghostty
```

Ghostty uses Fira Code Retina for text and FiraCode Nerd Font Mono for missing icons. Reload settings with Cmd-Shift-comma, or restart Ghostty.

In tmux, press Ctrl-B, release it, then press `|` or `-` to split the window. Use `h`, `j`, `k`, `l` to move between panes, or `r` to reload settings.

To hide macOS's “Last login” message in new terminals, run `touch ~/.hushlogin`.

## Git and GPG

Git uses delta for diffs, GitHub CLI for GitHub credentials, and GPG for signed commits. Fetching removes stale remote branch references. The first push of a new branch sets its upstream automatically. Change the name, email, and signing key in `git/.gitconfig` before using it on another account.

```sh
stow -t "$HOME" git gnupg
gh auth login
gpg --import /path/to/private-key.asc
gpg --list-secret-keys --keyid-format LONG
```

## Codex accounts

Install the Codex CLI, then link its settings:

```sh
mkdir -p "$HOME/.codex"
stow -t "$HOME/.codex" codex
```

The shell provides two account commands. Run each login separately and finish signing in through the browser:

```sh
codexfb login  # Business account
codexfp login  # Personal account
codexfb login status
codexfp login status
```

`codexfb` uses `~/.codex-framna-business`; `codexfp` uses `~/.codex-framna-personal`. The commands create these folders and keep their logins separate. They share settings, skills, and session data from `~/.codex`. Existing separate files are backed up before linking. The saved configuration does not include project approvals or hook trust state.

Run `codexfb` or `codexfp` to start. Plain `codex` uses the business account. `command codex` bypasses these shortcuts. See [OpenAI's login documentation](https://learn.chatgpt.com/docs/auth) for other login methods.

## Other files

| Folder | Use |
| --- | --- |
| `psql` | PostgreSQL command-line settings: `stow -t "$HOME" psql` |
| `vim` | Vim settings and plugins: `stow -t "$HOME" vim` |
| `claude` | Claude Code settings: create `~/.claude`, then `stow -t "$HOME/.claude" claude` |
| `Alfred.alfredpreferences` | Saved Alfred preferences; choose this folder in Alfred's preferences settings |
| `scripts` | Video download helpers, an IPA copier, and a temporary-folder Codex launcher |

Vim uses the fzf binary installed by Homebrew. Its plugins are installed on first launch.

`rip` needs ffmpeg. `rip-yt` needs yt-dlp and ffmpeg and reads cookies from Chrome. `scripts/ipa-copier.py` copies Apple Configurator downloads to `~/Downloads`. `tmp-codex` runs Codex in a temporary folder and removes that folder when it exits.

## Check changes

Run from this repository after editing settings:

```sh
python3 scripts/check-config.py
```

The check needs Python 3.11 or newer, installed by `brew bundle`. It checks shell, Python, TOML, JSON, Git, and Brewfile syntax, then installs and removes Stow links in a temporary home folder. It also checks the custom `XDG_CONFIG_HOME` setup. Your installed settings are not changed. These checks do not launch apps or check their behavior.
