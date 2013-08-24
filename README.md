# a bash environment fitting for a curmudgeon

this is part of a series. it's all my way of coping with the shit that
is the broken again shell.

## what is this?

naturally, these are my customizations for bash. they're opinionated,
and if you don't share the same opinions, we can perhaps agree to
disagree. or something.

it's actually set up properly, and it doesn't give a fuck as to whether
you `exec $SHELL -l` or `exec $SHELL`. it does the right thing either
way.

it doesn't (yet) have workable completion because it seems to break in
fun ways. completion still sort of works anyway, which has me puzzled.

it doesn't have any sort of bells and whistles. there is no integration
with `git`, it doesn't print your full working directory out, etc. if
you don't have a nervous habit of typing `git status` to see what branch
you're on or `pwd` to see where you are on the filesystem, you're a
failure.

the only thing it does is absolve you from having to echo out `$?` when
something exits with a non-zero return code.

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
	
(as an aside: `git config --global tar.tar.xz.command "xz -c"`)

## things to come

i want to keep fleshing this out as much as i can.

### get rid of the sourcery

i hope to make some of the actual development work for this suck less
since, well, it's kinda terrible at the moment. one thought is to do the
following:

    git clone --no-checkout github.com:nrr/rc-bash.git
    git config core.worktree="../../"
    git checkout master

this has a number of benefits, namely

* changes to dotfiles are known to git without any sort of extra
  sourcery
* new files become known to git when they're created, again without any
  extra sourcery
* my home directory will itself not be a git repository, but it will
  nonetheless be versioned

### abuse git subtree

i do actually dislike the multi-repository madness that i have going on
between `rc`, `rc-bash`, and `rc-plan9`, but i also prefer it to having
everything under one giant repository.

at some point, i'd like to look at abusing `git subtree` to this end and
seeing what sort of extra sourcery it'll require to get to a workable
state.
