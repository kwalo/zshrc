# vim: filetype=zsh
# vim: foldmethod=marker
# vim: foldmarker=###\ ,###
#
# Vim Users:
# Use za, zr, zm to fold/unfold sections
#


### Environment Variables

ZDOTDIR=${HOME}/.zsh
fpath=(${ZDOTDIR}/completion $fpath)

export EDITOR="vim" \
       PAGER="less"

if [[ -d ~/.local/bin ]]; then
    export PATH=~/.local/bin:$PATH
fi
WORDCHARS='.'

###

### History

HISTFILE="${HOME}/.histfile"
HISTSIZE=1000
SAVEHIST=500

setopt hist_ignore_dups \
       hist_ignore_space \
       hist_verify \
       inc_append_history \
       share_history

###

### Completion
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:*:*:processes' command "ps -o pid,user,comm"
zstyle ':completion:complete:*' cache-path $ZDOTDIR/cache
zstyle ':completion:complete:*' use-cache 1
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.cpp~' '*?.pyc' '*?.java~'
zstyle ':completion:*' completer _complete _correct _expand
zstyle ':completion:*' completions 1
zstyle ':completion:*' menu select=long
zstyle ':completion:*' expand prefix
zstyle ':completion:*' file-sort access
zstyle ':completion:*' glob true
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute true
zstyle ':completion:*' verbose true

autoload -U calendar

autoload -U compinit
compinit

###

### Zsh Options

setopt autocd \
    extendedglob \
    check_jobs \
    notify \
    multios \
    NO_beep \
    always_to_end \
    auto_param_slash \
    prompt_subst \
    rm_star_silent

bindkey -e

###

### Functions

# Function borrowed from oh-my-zsh

# Open file using command, based on file type
function open_command() {
    emulate -L zsh
    setopt shwordsplit

    local open_cmd
    case "$OSTYPE" in
        darwin*)  open_cmd='open' ;;
        cygwin*)  open_cmd='cygstart' ;;
        linux*)   [[ $(uname -a) =~ "Microsoft" ]] && \
                     open_cmd='cmd.exe /c start' || \
                     open_cmd='xdg-open'  ;;
        msys*)    open_cmd='start ""'  ;;
        *)        echo "Platform $OSTYPE not supported"
                  return 1
                  ;;
    esac

    # don't use nohup on OSX
    if [[ "$OSTYPE" == darwin* ]]; then
        $open_cmd "$@" &>/dev/null
    else
        nohup $open_cmd "$@" &>/dev/null
    fi
}

# Pipe last command from history to $PAGER
function p() {
  EDITOR=cat fc -1 | $PAGER
}

#

###

### Prompt
source ~/.zsh/prompt
###

### Aliases

# cd
alias ...=../..
alias ....=../../..
alias .....=../../../..

# ls
alias ls='/bin/ls --color=auto'
alias l='/bin/ls --color=auto'
alias ll='/bin/ls --color=auto -lh'
alias la='/bin/ls --color=auto -ah'
alias lla='/bin/ls --color=auto -lah'
alias lal='/bin/ls --color=auto -alh'
alias lw='/bin/ls | wc -l'

# sane defaults for commands
alias less='less -R'
if [[ $(readlink -f $(which grep)) != $(which grep) ]]; then
  # grep is a symlink. Most probably to busybox. In such case it does
  # not support GNU options
else
  alias grep='/bin/grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,node_modules}'
fi
alias o='open_command'

# shortcuts
alias h=history
alias srm='sudo rm'
alias j="jobs"
alias ds="du -sh"

# git
alias gco='git checkout'
alias gd='git diff'
alias gst='git status'
alias glg='git log --stat'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gp='git push'

# awk
alias awks="awk -F '\ \ +'"

###
