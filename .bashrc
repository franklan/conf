# .bashrc
# vim: filetype=sh



############################################################
# check working envrionment (host/user)
############################################################

my_host=`hostname | sed -e 's/\.fwmrm\.net//' | sed -e 's/\.dev$//'`
my_user=`whoami`

# id            host                      my_host         my_user
is_dev=0      # PEKdev201.dev.fwmrm.net   PEKdev201       ktong
is_launcher=0 # NYCdev01.fwmrm.net        NYCdev01        ktong
#             # STGdev01.stg.fwmrm.net    STGdev01.stg    ktong
is_qa=0       # PEKdev205.dev.fwmrm.net   PEKdev205       af
#             # PEKdev206.dev.fwmrm.net   PEKdev206       af
is_prod=0     # Forecast**.fwmrm.net      Forecast**      eng/ads
is_staging=0  # Forecast**.stg.fwmrm.net  Forecast**.stg  eng/ads

if [[ "$my_host" == "PEKdev201" ]]; then # dev
    is_dev=1
elif [[ "$my_host" == "NYCdev01" ]]; then # launcher
    is_launcher=1
    export my_host_tail=""
    export my_node_list="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16"
elif [[ "$my_host" == "STGdev01.stg" ]]; then # launcher
    is_launcher=1
    my_host=`echo $my_host | sed -e 's/\.stg//'`
    export my_host_tail=".stg"
    export my_node_list="03 04 05 06 07 12"
elif [[ ("$my_host" == "PEKdev104" || "$my_host" == "PEKdev105" || "$my_host" == "PEKdev106") && "$my_user" == "af" ]]; then # qa
    is_qa=1
    export HOME=/home/ktong
elif [[ "$my_host" =~ "Forecast" ]]; then # prod or staging
    if [[ "$my_host" =~ "stg" ]]; then
        is_staging=1
        my_launcher="STGdev01.stg"
        export my_host_tail=".stg"
    else
        is_prod=1
        my_launcher="NYCdev01"
        export my_host_tail=""
    fi
    export HOME=/tmp/.tk
    my_id=`echo $my_host | sed -e 's/Forecast//'`
    my_host=`echo $my_host | sed -e 's/Forecast/F-/'`
fi
cd; clear
# echo "$is_dev $is_launcher $is_qa $is_prod $is_staging $my_user@$my_host"



############################################################
# general setting
############################################################

# system prompt
`echo $TERM | grep screen &> /dev/null`
if [[ $? == 0 ]]; then
    flag_screen="(S) "
fi
`echo $TERMCAP | grep virtual &> /dev/null`
if [[ $? == 0 ]]; then
    flag_screen="(S) "
fi

if [ $is_dev -eq "1" ]; then
    export PS1="\[\e[31;1m\]$flag_screen[$my_user($my_host):\W] \[\e[0m\]"
elif [ $is_launcher -eq "1" ]; then
    export PS1="\[\e[35;1m\]$flag_screen[$my_user($my_host):\W] \[\e[0m\]"
elif [ $is_qa -eq "1" ]; then
    export PS1="\[\e[34;1m\]$flag_screen[$my_user($my_host):\W] \[\e[0m\]"
elif [ $is_prod -eq "1" ]; then
    export PS1="\[\e[37;1;41;4m\]$flag_screen[$my_user($my_host):\W] \[\e[0m\]"
elif [ $is_staging -eq "1" ]; then
    export PS1="\[\e[37;1;45;4m\]$flag_screen[$my_user($my_host):\W] \[\e[0m\]"
else
    export PS1="\[\e[31;1m\]$flag_screen[?? \[\e[35m\]$my_user($my_host) \[\e[31;1m\]\W] \[\e[0m\]"
fi

# commands shortcuts
alias +x='chmod +x'
alias ,='cd - > /dev/null'
alias .='pwd'
alias ..='cd ..'
alias ...='cd ../..'
alias md='mkdir'
alias H='head'
alias H2='head -2'
alias B='bunzip2 | head'
alias B2='bunzip2 | head -2'
alias M='more'
alias duk='du -sk *'
alias dum='du -sm ./*'
alias grep='grep --color'
# add color to ls
alias l='/bin/ls --color=tty -lF'
alias ll='/bin/ls --color=tty -lF'
alias la='/bin/ls --color=tty -alF'

# add color to less and man
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;35m'

# environment
export PAGER=less
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# software configuration
if [[ $is_dev == 1 || $is_launcher == 1 ]]; then
    my_vi="$HOME/software/bin/vim"
else
    my_vi="/usr/bin/vim"
    export LS_COLORS="no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=01;35:*.cmd=00;32:*.sh=00;32:*.tar=01;31:*.tgz=01;31:*.taz=01;31:*.zip=01;31:*.z=01;31:*.gz=01;31:*.bz2=01;31:"
fi
alias vi="$my_vi"
alias vim="$my_vi"
alias vd="${my_vi}diff"
alias vdiff="${my_vi}diff"
alias top="top -u $my_user"
export EDITOR="$my_vi"



############################################################
# custom function
############################################################

my-split()
{
    awk -F"\t" '
    {
        print NF; for (i=1; i<=NF; i++) { printf "%2d: %s\n", i, $i} print "";
    }'
}
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



############################################################
# for local dev
############################################################

if [[ $is_dev == 1 ]]; then
    alias en="export LC_ALL=en_US.UTF-8"
    alias cn="export LC_ALL=zh_CN.GB2312"
    # export LC_CTYPE=zh_CN.GB2312
    # export LC_ALL=zh_CN.GB2312

    export CODE_ROOT=~/code/debug

    alias cdforecast="cd $CODE_ROOT/forecast/"
    alias cdscheduler="cd $CODE_ROOT/forecast/scripts/"
    alias cdtest="cd ~/work/test"

    alias my-mirror='mysql -uqa -pqatest -h192.168.0.50 -Dfwmrm_oltp'
    # export TNS_ADMIN=~/bin/oracle
    # export SQLPATH=~/bin/oracle/
    # alias my-oracle='sqlplus user/pass@host'

    my-vip()
    {
        proj=$1
        conf=~/.vim/.prj.$1
        if [[ -f $conf ]]; then
            vi "+Project $conf"
        else
            vi
        fi
    }
fi



############################################################
# for launcher
############################################################

if [[ $is_launcher == 1 ]]; then
    # mysql -hcftool01 -p3306 -ubackend_new -preporting fwmrm_stats
    my-rsync()
    {
        if [[ ! -e $1 ]]; then
            return
        fi
        cmd="for i in $my_node_list; do echo \$i; scp -r $1 eng@forecast\$i$my_host_tail:/tmp/.tk/$2; echo; done"
        echo $cmd

        echo "confirm? (yes/no)"
        read res
        if [[ $res =~ "[yY][eE][sS]" ]]; then
            eval "$cmd"
        fi
    }
fi
############################################################
# for qa
############################################################

if [[ $is_qa == 1 ]]; then
    export TERM=linux
    ulimit -c unlimited
    alias cdregression="cd /export/af/af_regression"

    function mycd()
    {
        cd /export/af/af_regression/cases/$1/$2
    }

    # alias db='mysql -uads -pads -h192.168.0.205 fwmrm_newaf_oltp < '
    alias gc='cd /export/af/af_regression/cases'
    alias gr='cd /export/af/af_regression/results/'
    alias gs='cd /export/af/af_regression/server/'
    # alias gc='mycd'
    # alias ads='python /export/af/af_regression/cases/adsRequest.py'
    # alias 1010_repa='/export/af/af_regression/cases/forecast -f ads.conf --save-repository=1318204800'
fi



############################################################
# for prod/staging
############################################################

if [[ $is_prod == 1 || $is_staging == 1 ]]; then
    export PATH=$PATH:$HOME/bin
    alias ads='if [[ `whoami` == "eng" ]]; then expect /tmp/.tk/bin/ads; fi'
    alias eng='if [[ `whoami` == "ads" ]]; then exit; fi'
    alias tk="source /tmp/.tk/.bashrc"
    alias ib="cd /export/data/infobright"
    alias nt="cd /ads-forecast/data/run"
    alias od="cd /ads-ondemand/data/run"
    alias sc="cd /ads-forecast/scheduler"

    my-transfer()
    {
        # process parameters
        cmd=$1; host=$2; src=$3; dest=$4
        if [[ !($host != $my_id && ($host =~ "^0[0-9]$" || $host =~ "^1[0-6]$")) || !(-n "$src") ]]; then
            echo "my-$cmd HOST(!=$my_id) FROM_PATH TO_PATH[=FROM_PATH]"
            return
        fi
        if [[ $dest == "" ]]; then
            dest=$src
        if [[ $dest == "" ]]; then
            dest=$src
        fi

        # check path
        if [[ $cmd == "get" ]]; then
            check_dir=$src
        elif [[ $cmd == "put" ]]; then
            check_dir=$dest
        fi
        if [[ "`echo $check_dir | sed -e 's/\(.\).*/\1/'`" != "/" ]]; then
            flag_relative="~/"
        else
            flag_relative=""
        fi
        if [[ $host == "00" ]]; then
            host="ktong@$my_launcher:$flag_relative"
        else
            host="Forecast$host$my_host_tail:$flag_relative"
        fi

        # get cmd
        if [[ $cmd == "get" ]]; then
            cmd="rsync -av $host$src $dest"
        elif [[ $cmd == "put" ]]; then
            cmd="rsync -av $src $host$dest"
        fi
        echo $cmd

        # run
        echo "confirm? (yes/no)"
        read res
        if [[ $res =~ "[yY][eE][sS]" ]]; then
            eval "$cmd"
        fi
    }

    my-get()
    {
        my-transfer get $1 $2 $3 $4
    }

    my-put()
    {
        my-transfer put $1 $2 $3 $4
    }
fi
############################################################
# for HADOOP, not used now
############################################################

if [[ $is_hadoop == 1 ]]; then
    # environment
    export HADOOP_HOME=/usr/local/hadoop/hadoop-0.20.1
    export HADOOP_LIB=$HOME/HADOOP_LIB
    export HADOOP_CLASSPATH=$HADOOP_LIB/commons-cli-2.0-SNAPSHOT.jar
    export PIG_CLASSPATH=$HADOOP_HOME/conf
    export PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_LIB/pig-0.9.0/bin:$HOME/bin
    export GRID_USER=""
    export GRID_HDFS=""
    export GRID_UGI="-D hadoop.job.ugi=$GRID_USER,normalusers"
    export GRID_UGI_BOSS="-D hadoop.job.ugi=boss,supergroup"
    export GRID_PARAM="-D mapred.job.tracker=$GRID_HDFS:54311 -D fs.default.name=hdfs://$GRID_HDFS:54310 $GRID_UGI -D hadoop.job.history.user.location=none"

    # shortcuts
    alias    hls="hadoop fs $GRID_PARAM -ls"
    alias    hmv="hadoop fs $GRID_PARAM -mv"
    alias    hcp="hadoop fs $GRID_PARAM -cp"
    alias    hrm="hadoop fs $GRID_PARAM -rm"
    alias   hrmr="hadoop fs $GRID_PARAM -rmr"
    alias  hrmrt="hadoop fs $GRID_PARAM -rmr -skipTrash"
    alias    hmd="hadoop fs $GRID_PARAM -mkdir"
    alias   hget="hadoop fs $GRID_PARAM -get"
    alias   hput="hadoop fs $GRID_PARAM -put"
    alias   hcat="hadoop fs $GRID_PARAM -cat"
    alias   hdus="hadoop fs $GRID_PARAM -dus"
    alias hchmod="hadoop fs $GRID_PARAM -chmod -R"
    alias hchown="hadoop fs $GRID_PARAM -chown -R"

    # useful command
    alias grid_kill="hadoop job $GRID_PARAM -kill"
    alias grid_pig="pig $GRID_PARAM -D pig.temp.dir=/user/$GRID_USER/tmp -D pig.noSplitCombination=true"
    alias grid_streaming="hadoop jar $HADOOP_LIB/hadoop-streaming.jar $GRID_PARAM"
fi



############################################################
# misc
############################################################


