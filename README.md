# dotfiles

Use chezmoi, renovate and aqua to keep things updated

## Setup

Start by installing `chezmoi` and `comtrya` binary somewhere in the `PATH` and also the `git` package.

Then run:

`chezmoi init frezbo`

Then plug in the YubiKey and run `gpg --card-status` and retrieve the key via `gpg --card-edit` followed by `fetch`.

Then retrieve the resident ssh keys by running `ssh-keygen -K`, move the generated files to `~/.ssh`.

Then run `chezmoi cd` followed by

```bash
chezmoi apply ~/.config/chezmoi
chezmoi apply ~/.config/chezmoi/chezmoi.toml
chezmoi apply
```

Also run `git config remote.origin.pushurl git@github.com:frezbo/dotfiles.git` so we use ssh for pushes.

This should setup all the required dot files.

Now we can proceed to installing `aqua` binary.
Change into `comtrya` directory and run `comtrya apply -m dotfiles`

Now log out and login so that new dotfiles gets processed.

We can now proceed to installing other packages.

Run `chezmoi cd` and then cd into comtrya directory and run:

`comtrya apply` to install all required packages.

At last run to set generate the ssh config file.

Run `assh config build > ~/.ssh/config`

Verify GitHub login via `ssh -T git@github.com`
