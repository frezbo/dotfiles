# dotfiles

Use Brewfile, topgrade to keep everything in sync

## Setup

Setup Brew on MacOS and run these commands:

```bash
brew install chezmoi gpg pinentry-mac openssh
export PATH=$(brew --prefix openssh)/bin:$PATH
```

Then plug in the YubiKey and run `gpg --card-status` and retrieve the key via `gpg --card-edit` followed by `fetch`.

Then retrieve the resident ssh keys by running

```bash
ssh-keygen -K
mv id_ed25519_sk.pub ~/.ssh/git.pub
mv id_ed25519_sk ~/.ssh/git
```

We can now proceed to setup rest of the dotfiles.

```bash
chezmoi init frezbo
chezmoi apply ~/.config/chezmoi
chezmoi apply ~/.config/chezmoi/chezmoi.toml
chezmoi apply ~/.gnupg
chezmoi apply ~/.gnupg/gpg-agent.conf
chezmoi apply
```

Also run `git config remote.origin.pushurl git@github.com:frezbo/dotfiles.git` so we use ssh for pushes.

This should setup all the required dot files.

At last run to set generate the ssh config file.

Run `assh config build > ~/.ssh/config`

Verify GitHub login via `ssh -T git@github.com`
