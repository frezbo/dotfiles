# dotfiles

Use Brewfile, topgrade to keep everything in sync

## Setup

Setup Brew on MacOS and run these commands:

```bash
brew install chezmoi 1password-cli
```

Login to 1Password account.

Then run the following:

```bash
chezmoi init frezbo
chezmoi apply
```

Then run `brew bundle --global install`

Then plug in the YubiKey and run `gpg --card-status` and retrieve the key via `gpg --card-edit` followed by `fetch`.

Then retrieve the resident ssh keys by running

```bash
ssh-keygen -K
mv id_ed25519_sk.pub ~/.ssh/git.pub
mv id_ed25519_sk ~/.ssh/git
```

Also run `git config remote.origin.pushurl git@github.com:frezbo/dotfiles.git` so we use ssh for pushes.

This should setup all the required dot files.

At last run to set generate the ssh config file.

Run `assh config build > ~/.ssh/config`

Verify GitHub login via `ssh -T git@github.com`
