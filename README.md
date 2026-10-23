# dotfiles

Managed using GNU Stow with a setup similar to the one presented in [Managing your dotfiles with GNU Stow](http://codyreichert.github.io/blog/2015/07/07/managing-your-dotfiles-with-gnu-stow/).

## Installation

Files are managed using stow. Install stow using Homebrew.

```bash
brew install stow
```

## Usage

Dotfiles are stored relative to the home directory, `~`. Each directory in the root of the repository "simulates" the home directory.

To stow a directory, run `stow` followed by the directory name, e.g. `stow git`. This will put the dotfiles in the previous directory (`cd ..`). To specify a target directory, use `stow -t ~/ git`.

### Notes

This section contains notes on setting up specific tools.

#### gnupg

Used for [signing git commits](https://docs.github.com/en/github/authenticating-to-github/signing-commits). gnupg and pinentry-mac must be installed with Homebrew.

```bash
brew install gnupg pinentry-mac
```

Make sure to stow both the git and gnupg folders so all the settings are in place. Then import the GPG private key.

```bash
gpg --import gnupg-private-key.asc
```

Verify that it's imported by running the following command.

```bash
gpg --list-keys
```

#### Zsh and Starship

Zsh uses [Starship](https://starship.rs/guide/) for its prompt, with native Zsh history, completion, and key bindings. No plugin framework is required.

```bash
brew install starship
brew install --cask font-fira-code-nerd-font
stow -t ~ zsh starship
exec zsh
```

The prompt is configured in `starship/.config/starship.toml` (linked to `~/.config/starship.toml`, Starship's [default configuration location](https://starship.rs/config/)). It uses rounded Dracula-colored segments for the directory, Git, and contextual tool/environment information, with a second line for commands and duration/status information aligned right on the first line. Commands taking at least three seconds show their duration; failed commands show their exit code. The prompt requires a Nerd Font for its icons and rounded separators. Install [FiraCode Nerd Font](https://formulae.brew.sh/cask/font-fira-code-nerd-font) with the command above, or download FiraCode from [Nerd Fonts](https://www.nerdfonts.com/font-downloads) and install the `.ttf` files using Font Book. Ghostty uses `Fira Code Retina` for text and `FiraCode Nerd Font Mono` as a fallback for missing icon glyphs. Other terminals can use the same fallback arrangement where supported, or use `FiraCode Nerd Font Mono` as the main font. Reload Ghostty’s configuration with `Cmd+Shift+,` after installing the font, or restart Ghostty. Git status uses counts: `+` staged, `~` modified, `?` untracked, and arrows for commits ahead/behind.

If you set `XDG_CONFIG_HOME`, stow Starship's config there instead:

```bash
mkdir -p "$XDG_CONFIG_HOME"
stow -d starship/.config -t "$XDG_CONFIG_HOME" .
```

When migrating from the previous setup, remove the old `~/.p10k.zsh` symlink if it points to this repository's removed `powerlevel10k/.p10k.zsh`. Remove any Oh My Zsh or theme initialization from `~/.zshrc.local` and `~/.aliases.local`; keep machine-specific environment settings and aliases. Existing Oh My Zsh installations and prompt caches can be removed once the new shell is working.

Common Git shortcuts are defined directly in `.zshrc`, including `gst`, `ga`, `gaa`, `gcmsg`, `gco`, `gcb`, `gd`, `gl`, `gp`, and `glog`. This is a curated set rather than the entire Oh My Zsh Git plugin; add any additional shortcuts you use to `~/.aliases.local`. GPG integration is retained.

#### Shell tools

Install the optional tools used by the shell configuration:

```bash
brew install eza bat tmux zoxide
brew tap simonbs/wut https://github.com/simonbs/wut.git
brew install simonbs/wut/wut
exec zsh
```

- `ls`, `ll`, `la`, and `lt` use eza for file listings with icons and tree views. Use `command ls` for the system command.
- `cat` uses bat with the Dracula theme, and fzf can preview files using bat. The general-purpose pager remains `less`.
- `z <query>` jumps to a frequently visited directory; `zi` opens zoxide's fzf picker. Zoxide learns directories as you visit them and replaces the old `~/z/z.sh` integration.
- `wut` manages Git worktrees and loads its shell integration automatically; `wt` opens the worktree picker.
- `agents-tmux` creates or attaches to the `agents` tmux session. Stow the tmux configuration with `stow -t ~ tmux` to use its Dracula status bar and custom key bindings.

The shell no longer initializes asdf or adds its shims to PATH.

Machine-specific environment settings belong in `~/.zshrc.local`. Alias and function overrides belong in `~/.aliases.local`, which is loaded after the defaults. PATH entries are deduplicated automatically. PostgreSQL helpers default to `/opt/homebrew/var/postgresql@16`; set `POSTGRES_DATA_DIR` in `~/.zshrc.local` if your existing cluster lives elsewhere.

#### fzf

Install [fzf](https://github.com/junegunn/fzf) and restart the shell:

```bash
brew install fzf
exec zsh
```

The shell loads fzf's Zsh integration directly with `fzf --zsh`:

- **Ctrl-R** searches command history and puts the selection on the command line.
- **Ctrl-T** searches files under the current directory and inserts the selected paths.
- **Alt-C** searches directories and changes to the selection. On macOS, use Option as Alt, or press Escape followed by C.
- **`**` then Tab** starts fuzzy completion, for example `cd **` or `vim **` followed by Tab.
- **Escape** cancels the search.

The search uses Dracula colors and a rounded border. File/directory shortcuts include hidden entries and skip `.git`, `node_modules`, `.build`, and `target`. No separate `ag` or `fd` installation is required. If `bat` is installed, Ctrl-/ toggles a file preview in Ctrl-T search.

Existing helpers include `fd` to select a directory, `fo` to open a file, `fbr` to check out a Git branch, and `fshow` to browse commits.

#### Ghostty

Ghostty can be [downloaded here](https://ghostty.org). The preferences are stored in `~/Library/Application Support/com.mitchellh.ghostty`, so they should be stowewd like this:

```bash
stow -t /Users/simonbs/Library/Application\ Support/com.mitchellh.ghostty ghostty
```

#### Codex

Codex configuration can be stowed like this:

```bash
stow -t ~/.codex codex
```

The shell defines two account shortcuts:

| Command | Account directory |
| --- | --- |
| `codexfb` | `~/.codex-framna-business` |
| `codexfp` | `~/.codex-framna-personal` |

After reloading the shell, sign in to each account separately:

```bash
exec zsh
codexfb login
# Complete browser login with the intended business account/workspace.
codexfp login
# Complete browser login with the intended personal account/workspace.
codexfb login status
codexfp login status
```

These shortcuts are local wrappers, not built-in Codex account names. Each wrapper creates its account directory automatically and uses file-based credential storage, so each login is stored in its own `auth.json`. This uses the documented [`CODEX_HOME` credential storage behavior](https://learn.chatgpt.com/docs/auth#credential-storage). If browser login is inconvenient, use `codexfb login --device-auth` or `codexfp login --device-auth` where device login is enabled.

The wrappers link other existing entries from `~/.codex`, sharing configuration, skills, and session data. Credentials and daemon sockets/locks stay separate. Existing separate copies of shared entries are preserved in a `shared-backup.*` directory before linking. Account authentication files stay outside this repository.

Run `codexfb` or `codexfp` to start with that account. Plain `codex` defaults to `codexfb`; use `command codex` to invoke the CLI directly with its normal environment.
