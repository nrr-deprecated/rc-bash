# $HOME/.bashrc
# Personal environment file for interactive bash subshells.

for customization in ${HOME}/.bashrc.d/*
do
    if [ -f $customization ]
    then
        source $customization
    fi
done
unset customization

# Local Variables:
# mode:shell-script
# End:
