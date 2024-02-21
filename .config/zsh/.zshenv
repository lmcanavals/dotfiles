if (( "x${CUSTOMZSHENV}x" == "xx" )); then
	export CUSTOMZSHENV="X"
fi

export ZDOTDIR=$HOME/.config/zsh

if [[ -d /usr/local/go/bin ]]; then
	PATH=$PATH:/usr/local/go/bin
fi

# C/C++ stuff
export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

# Java stuff
if [[ -d /opt/java ]]; then
	JAVA_HOME=/opt/java
	CLASSPATH=$JAVA_HOME/lib
	PATH=$JAVA_HOME/bin:$PATH
	export JAVA_HOME
	export CLASSPATH
fi

# Maven
if [[ -d /opt/maven ]]; then
	M2_HOME=/opt/maven
	M2=$M2_HOME/bin
	MAVEN_OPTS="-Xms256m -Xmx512m"
	PATH=$M2:$PATH
	export M2_HOME
	export M2
	export MAVEN_OPTS
fi

PATH=/home/lmcs/.local/bin:$PATH
typeset -U PATH
export PATH

export LCLR=$(<$ZDOTDIR/colors)

[[ -f "$HOME/.cargo/env" ]] && \
. "$HOME/.cargo/env"

# vim: set ts=2:sw=2:noet:sts=2:
