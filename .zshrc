# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"


# .bashrc
#
# # id            host                      my_host         my_user
# is_dev=0      # PEKdev201.dev.fwmrm.net   PEKdev201       ktong
# is_launcher=0 # NYCdev01.fwmrm.net        NYCdev01        ktong
# #             # STGdev01.stg.fwmrm.net    STGdev01.stg    ktong
# is_qa=0       # PEKdev205.dev.fwmrm.net   PEKdev205       af
# #             # PEKdev206.dev.fwmrm.net   PEKdev206       af
# is_prod=0     # Forecast**.fwmrm.net      Forecast**      eng/ads
# is_staging=0  # Forecast**.stg.fwmrm.net  Forecast**.stg  eng/ads
#
#
# Aliases

alias ..="cd .."
alias df="df -h"
alias du="du -h"
alias g105="ssh af@192.168.0.105"
alias g106="ssh af@192.168.0.106"
alias g201="ssh tlan@192.168.0.201"
alias gnyc="ssh tlan@NYCdev01.fwmrm.net"
alias gstg="ssh tlan@STGdev01.stg.fwmrm.net"
alias scre="screen -x tlan"
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias H='head'
alias tarx='tar xvf'
alias tarcz='tar czvf'
alias tarxz='tar xzvf'
alias gzipd='gzip -d'

x() # screen
{
    name=$1; action=$2
    if [[ $name == "" ]]; then
        screen -ls
        return
    fi

    name="__TMP__$name"
    if [[ $action == "clear" ]]; then
        ps ux | grep $name | grep -i screen | awk '{print $2}' |
        while read line;
        do
            kill -9 $line
        done;
        screen -wipe $name
        return
    fi

    `screen -ls | grep $name &> /dev/null`
    if [[ $? == 1 ]]; then
        param="-S"
    else
        `screen -ls | grep $name | grep Attached &> /dev/null`
        if [[ $? == 0 ]]; then
            param="-x"
        else
            param="-r"
        fi
    fi
    screen $param $name
}

