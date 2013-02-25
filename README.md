# a bash environment fitting for a curmudgeon

this is part of a series. it's all my way of coping with the shit that is the broken again shell.

## what is this?

naturally, these are my customizations for bash. it's actually set up properly, and it doesn't give a fuck as to whether you `exec $SHELL -l` or `exec $SHELL`. it doesn't (yet) have workable completion because it seems to break in fun ways.

## my method to the madness

this is how i install an archive from github:

    DIR="${HOME}/lib/github.com/nrr/dotfiles-bashrc"
	URL="https://api.github.com/repos/nrr/dotfiles-bashrc/tarball"
	ARCHIVE="${DIR}/nrr-dotfiles-bashrc-master.tar.gz"
	
	mkdir -p "${DIR}"
	curl -LsSf "${URL}" > "${ARCHIVE}"
	
	REVISION="$(tar tavf "${ARCHIVE}" | head -n 1 | perl -pe 's/.*([[:alnum:]]+).$/$1/g')"
	cd "${DIR}"
	tar axvf "${ARCHIVE}"
	mv "nrr-dotfiles-${REVISION}" "${REVISION}"
	ln -s "${REVISION}" next
	
	unlink previous
	mv current previous
	mv next current
	
this is how i clone the repository for working on it:

	WORKSPACE="${HOME}/w/git/github.com/nrr/dotfiles-bashrc"
	REMOTE="git@github.com:nrr/dotfiles-bashrc"
	git clone "${REMOTE}" "${WORKSPACE}"
	
this is how i install an archive from my local working copy:

	DIR="${HOME}/lib/github.com/nrr/dotfiles-bashrc"
	TAG="$(date -u -I)"
	WORKSPACE="${HOME}/w/git/github.com/nrr/dotfiles-bashrc"
	cd "${WORKSPACE}"
	git archive --format=tar.xz --prefix="HEAD-${TAG}/" HEAD > "${DIR}/HEAD-${TAG}.tar.xz"
	cd "${DIR}"
	rm -rf "HEAD-${TAG}"
	tar axvf "HEAD-${TAG}.tar.xz"
	ln -s "HEAD-${TAG}" next
	
	unlink previous
	mv current previous
	mv next current
	
(as an aside: `git config tar.tar.xz.command "xz -c"`)
