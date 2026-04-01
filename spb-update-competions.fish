# spb-update.bash completions
#
# This fish completions are part of the SPB project :
# http://github.com/henri/spb/
#
# Documentation on updating this or creating your own
# custom completion for the fish shell is available from :
# https://fishshell.com/docs/current/completions.html
#
# version 1.0 - inital basic implimentation


# get help
complete -c spb-update.bash       -f -l help                     -d 'display help'

# generic options
complete -c spb-update.bash       -f -l no-delay                 -d 'prevent random delay when connected to tty'
complete -c spb-update.bash       -f -l auto-monitoring          -d 'behave like there is no tty connected'

