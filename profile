# vim: filetype=zsh
# vim: foldmethod=marker
# vim: foldmarker=###\ ,###
#
# Vim Users:
# Use za, zr, zm to fold/unfold sections
#


### Environment Variables

ZDOTDIR=${HOME}/.zsh
fpath=(${ZDOTDIR}/functions ${ZDOTDIR}/completion $fpath)

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
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w" 
zstyle ':completion:complete:*' cache-path $ZDOTDIR/cache
zstyle ':completion:complete:*' use-cache 1
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.cpp~' '*?.pyc' '*?.java~'
# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

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
                     open_cmd='cmd.exe /c' || \
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


# web_search from terminal

function web_search() {
  emulate -L zsh

  # define search engine URLS
  typeset -A urls
  urls=(
    google      "https://www.google.com/search?q="
    bing        "https://www.bing.com/search?q="
    yahoo       "https://search.yahoo.com/search?p="
    duckduckgo  "https://www.duckduckgo.com/?q="
    github      "https://github.com/search?q="
  )

  # check whether the search engine is supported
  if [[ -z "$urls[$1]" ]]; then
    echo "Search engine $1 not supported."
    return 1
  fi

  # search or go to main page depending on number of arguments passed
  if [[ $# -gt 1 ]]; then
    # build search url:
    # join arguments passed with '+', then append to search engine URL
    url="${urls[$1]}${(j:+:)@[2,-1]}"
  else
    # build main page url:
    # split by '/', then rejoin protocol (1) and domain (2) parts with '//'
    url="${(j://:)${(s:/:)urls[$1]}[1,2]}"
  fi

  open_command "$url"
}


alias bing='web_search bing'
alias google='web_search google'
alias yahoo='web_search yahoo'
alias ddg='web_search duckduckgo'
alias github='web_search github'

#add your own !bang searches here
alias wiki='web_search duckduckgo \!w'
alias news='web_search duckduckgo \!n'
alias youtube='web_search duckduckgo \!yt'
alias map='web_search duckduckgo \!m'
alias image='web_search duckduckgo \!i'
alias ducky='web_search duckduckgo \!'

###

### Prompt
source ~/.zsh/prompt
###

### Aliases

alias ...=../..
alias ....=../../..
alias .....=../../../..
alias srm='sudo rm'
alias j="jobs"
alias ls='/bin/ls --color=auto'
alias l='/bin/ls --color=auto'
alias ll='/bin/ls --color=auto -lh'
alias la='/bin/ls --color=auto -ah'
alias lla='/bin/ls --color=auto -lah'
alias lal='/bin/ls --color=auto -alh'
alias lw='/bin/ls | wc -l'
alias grep='/bin/grep --colour=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,node_modules}'
alias o='open_command'
alias less='less -R'

###
