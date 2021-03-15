# dotfiles

Managed using GNU Stow with a setup similar to the one presented in [Managing your dotfiles with GNU Stow](http://codyreichert.github.io/blog/2015/07/07/managing-your-dotfiles-with-gnu-stow/).

## Usage

Dotfiles are stored relative to the home directory, `~`. Each directory in the root of the repository "simulates" the home directory.

To stow a directory, run `stow` followed by the directory name, e.g. `stow git`. This will put the dotfiles in the previous directory (`cd ..`). To specify a target directory, use `stow -t ~/ git`.

Run `./stowall.sh` to stow all directories and put them in the home directory.

### Notes

This secton contains notes on setting up specfic tools.

#### gnupg

Used for [signing git commits](https://docs.github.com/en/github/authenticating-to-github/signing-commits). In gnupg and pinentry-mac must be installed with Homebrew.

```bash
brew install gnupg pinentry-mac
```

Make sure to stow both the git and gnupg folders so all the settings are in place.
