#!/bin/sh
#
# Download the bash environment from fossil.moyi.us and install them to $HOME.
#
# Usage: curl -LsSf http://fossil.moyi.us/nrr-dotfiles-bash-environment/doc/trunk/move-in.sh | sh -
#

TD=`mktemp -d XXXXXXX`
REPO_NAME="nrr-dotfiles-bash-environment"

maybe_create_ssh_directory() {
	if [ ! -d $HOME/.ssh ]
	then
		mkdir -p -v $HOME/.ssh
		chmod -v u=rwx,og-rwx $HOME/.ssh
	fi
}

kill_all_history() {
	for f in .bash_history .mysql_history .psql_history .sqlite_history
	do
		rm -f $HOME/$f
		ln -s /dev/null $HOME/$f
	done
}

pull_files_from_fossil() {
	# This relies on TD above.

	repo_host="fossil.moyi.us"
	repo_name=${REPO_NAME}
	repo_path="/tarball/${repo_name}-tip.tar.gz?uuid=tip"
	url="http://${repo_host}/${repo_name}/tarball/${repo_name}-tip.tar.gz?uuid=tip"

	curl -LsSf $url | tar -C $TD -xvzf -
}

install_into_HOME() {
	# This relies on TD above.

	mv -f $TD/$REPO_NAME-*/src/.???* $HOME/
	rm -rf $TD
}

pull_files_from_fossil
install_into_HOME
maybe_create_ssh_directory
kill_all_history
