# start-private-browser completions
#
# This fish completions are part of the SPB project :
# http://github.com/henri/spb/
#
# Documentation on updating this or creating your own
# custom completion for the fish shell is available from :
# https://fishshell.com/docs/current/completions.html
#
# version 1.0 - inital basic implimentation
# version 1.1 - improvements for alias wrapping
# version 1.2 - added improved option descriptions
# version 1.3 - added support for dynamic lists
#

# get help
complete -c start-private-browser -f -l help               -d 'display help'

# generic options
complete -c start-private-browser -f -l standard           -d 'start browser without incognito option'
complete -c start-private-browser -f -l quiet              -d 'suppress important output information'
complete -c start-private-browser -f -l verbose            -d 'provide additional information output'
complete -c start-private-browser -f -l list               -d 'list of active spb sessions'
complete -c start-private-browser -f -l force-stop         -d 'kill a hung browser session' -r -a '(__start_private_browser_list_sessions)'
complete -c start-private-browser -f -l update             -d 'update SPB system and fish snippets'

# multi-browser support
complete -c start-private-browser -f -l browser            -d 'configure the use of a specific browser' -r -a '(__start_private_browser_list_browsers)'
complete -c start-private-browser -f -l list-browsers      -d 'provide a list default supported browser names'
complete -c start-private-browser -f -l browser-path       -d 'specify specific path to browser executable' -r

# templates (usage & management)
complete -c start-private-browser -f -l new-template       -d 'create new template' -r
complete -c start-private-browser -f -l list-templates     -d 'list available templates'
complete -c start-private-browser -f -l edit-template      -d 'edit existing template' -r -a '(__start_private_browser_list_templates)'
complete -c start-private-browser -f -l template           -d 'load existing template' -r -a '(__start_private_browser_list_templates)'
complete -c start-private-browser -f -l template-path      -d 'override default spb-templates path' -r

# configuration file
complete -c start-private-browser -f -l edit-configuration -d 'edit active spb configuration file'

# supporting fuctions - dynamic list generation
function __start_private_browser_list_templates
    start-private-browser --quiet --list-templates | awk '{ print$2 }'
end
function __start_private_browser_list_browsers
    start-private-browser --quiet --list-browsers
end
function __start_private_browser_list_sessions
    start-private-browser --quiet --list
end
