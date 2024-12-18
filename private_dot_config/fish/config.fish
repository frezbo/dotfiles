# use starship prompt

function set_win_title
    echo -ne "\033]0; $USER@$HOSTNAME:$PWD//$HOME/\~} \007"
end

# aqua
export AQUA_CONFIG="/home/frezbo/.local/share/chezmoi/aquaproj-aqua/aqua.yaml"
export AQUA_POLICY_CONFIG="/home/frezbo/.local/share/chezmoi/aquaproj-aqua/aqua-policy.yaml"
export AQUA_LOG_COLOR="always"
export AQUA_PROGRESS_BAR="true"

# disable topgrade self update since it's managed by aqua
export TOPGRADE_NO_SELF_UPGRADE=""

set starship_precmd_user_func "set_win_title"
starship init fish | source

# assh
alias ssh="assh wrapper ssh --"

# kubie aliases
alias kx="kubie ctx"
alias kn="kubie ns"

alias kleen="sed -i /current-context/d ~/.kube/config"

# fzf
fzf --fish | source

# set default EDITOR
set -x EDITOR "vim"

# Golang
set -x GOPATH "/home/frezbo/work/golang"

# direnv
direnv hook fish | source

# function to merge kubeconfig
function kmerge
  switch (count $argv)
    case '2'
      if ! test -e $argv[1]
        echo "file $argv[1] does not exist"
        return 1
      end
      k8s-ctx-import -name "$argv[2]" \
        -set-current-context=false \
        < "$argv[1]"
    case '*'
      echo "### Usage: kmerge <path to kubeconfig> <context name>"
      return 1
  end
end

# aws-vault helpers
function ave
    aws-vault exec --duration 12h $argv fish
end

function avl
    set -l login_url (aws-vault login --duration 12h --stdout $argv)

    set -l encoded_url (string replace -a '&' '%26' $login_url)
    set -l uri_handler "ext+container:name=Work&url=$encoded_url"
    firefox $uri_handler
end

function unmeta
  exiftool -all= -overwrite_original "$argv"
end

function device-shutdown
  switch (count $argv)
    case '1'
      udisksctl power-off -b "$argv[1]"
    case '*'
      echo "### Usage: device-shutdown <device name>"
      return 1
  end
end

function qq
  clear

  set -l logpath "$TMPDIR/q"

  if test -z "$TMPDIR"
      set logpath "/tmp/q"
  end

  echo $logpath

  if not test -f "$logpath"
      echo 'Q LOG' > "$logpath"
  end

  tail -100f -- "$logpath"
end

alias pbcopy='xclip -selection clipboard'
alias pbcopyi="xclip -selection clipboard -t image/png -i"
alias pbpaste='xclip -selection clipboard -o'
alias p='pushd .'
alias g='popd'
alias d='dirs'
alias gc='git clone'
alias gs='git status'
alias gd='git diff'
alias gcm='git commit'
alias grep="rg"
alias ls="eza"
alias cat="bat"

# talosctl bash completion
talosctl completion fish | source
