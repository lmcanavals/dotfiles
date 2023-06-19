# vim: set ts=2:sw=2:noet:sts=2:

if (( "x${CUSTOMZSHENV}x" == "xx" )); then
	export CUSTOMZSHENV="X"
fi

export ZDOTDIR=/home/lmcs/.config/zsh

if [[ -d /usr/local/go/bin ]]; then
	PATH=$PATH:/usr/local/go/bin
fi

# Java stuff
JAVA_HOME=/opt/java
CLASSPATH=$JAVA_HOME/lib
PATH=$JAVA_HOME/bin:$PATH
export JAVA_HOME
export CLASSPATH

# Maven
#M2_HOME=/home/lmcs/Documents/Apps/maven
#M2=$M2_HOME/bin
#MAVEN_OPTS="-Xms256m -Xmx512m"
#PATH=$M2:$PATH
#export M2_HOME
#export M2
#export MAVEN_OPTS

PATH=/home/lmcs/.local/bin:$PATH
typeset -U PATH
export PATH

export LCLR=$(<$ZDOTDIR/colors)

[[ -f "$HOME/.cargo/env" ]] && \
. "$HOME/.cargo/env"
