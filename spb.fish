##### NOTE THIS SNIPPIT IS NOT INSTALLED BY DEFAULT #####

# spb-fish-function-installer.bash will setup this basic alias. But the idea is that
# you are able to load in a custom spb alias which may include other settings
# for example if you always want spb to use a proxy, just set that up 
# using the example below. If you want to spb to always use tor then set it up below.

# one line command which setups up spb as an alias to start-private-browser
# this function requires start-private-browser to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' to be setup eg : alias --save start-private-browser="~/bin/start-private-browser.bash"

# run the following in a fish shell to configure for your shell : 
alias -s spb "start-private-browser"

# usage example to open private browser and view http://slashdot.org" and "https://xkcd.com/"
# spb "http://slashdot.org" "https://xkcd.com/"

# The examples below are some additional alteratives. You may of course mix and match these to meet your needs.

# run the following in a fish shell to configure spb to always use a specific window location
alias -s spb "start-private-browser --window-position=0,0" --wraps start-private-browser

# use this to specify a proxy for all spb requests and snippits : 
alias -s spb "start-private-browser --proxy-server=http://<hostname:<port>"

# this example will result in all spb sessions using the tor network
alias -s spb "start-private-browser --tor" 

# todo : turn this into a fisher package rather than a gist

#////////////////////////////////////////////////////////////////////////
# the line below is added in just in case you source this scipt.
alias -s spb "start-private-browser"
#////////////////////////////////////////////////////////////////////////

