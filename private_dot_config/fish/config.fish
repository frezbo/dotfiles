if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path (brew --prefix openssh)/bin
fish_add_path (brew --prefix make)/libexec/gnubin
fish_add_path (brew --prefix gnu-sed)/libexec/gnubin
fish_add_path (brew --prefix jq)/bin
fish_add_path (brew --prefix findutils)/libexec/gnubin
fish_add_path (brew --prefix coreutils)/libexec/gnubin

starship init fish | source

# assh
alias ssh="assh wrapper ssh --"

# kubie aliases
alias kx="kubie ctx"
alias kn="kubie ns"

alias kleen="sed -i /current-context/d ~/.kube/config"

# set default EDITOR
set -x EDITOR vim

# direnv
direnv hook fish | source

# function to merge kubeconfig
function kmerge
    switch (count $argv)
        case 2
            if ! test -e $argv[1]
                echo "file $argv[1] does not exist"
                return 1
            end
            k8s-ctx-import -name "$argv[2]" \
                -set-current-context=false <"$argv[1]"
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

function qq
    clear

    set -l logpath "$TMPDIR/q"

    if test -z "$TMPDIR"
        set logpath /tmp/q
    end

    echo $logpath

    if not test -f "$logpath"
        echo 'Q LOG' >"$logpath"
    end

    tail -100f -- "$logpath"
end

alias p='pushd .'
alias g='popd'
alias d='dirs'
alias gc='git clone'
alias gs='git status'
alias gd='git diff'
alias gcm='git commit'
alias vim="hx"
alias vi="hx"

# talosctl bash completion
talosctl completion fish | source

# 1password plugins
source ~/.config/op/plugins.sh
