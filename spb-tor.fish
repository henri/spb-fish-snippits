
# one line command which setups up spb as an alias to start-private-browser and passes along the flag to start tor automatically
# this function requires start-private-browser to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' to be setup eg : alias --save start-private-browser="~/bin/start-private-browser.bash"

# run the following in a fish shell to configure for your shell : 
alias -s spb-tor "spb --tor"

# usage example to open private browser and view http://slashdot.org" and "https://xkcd.com/"
# spb-tor "http://slashdot.org" "https://xkcd.com/"

# todo : turn this into a fisher package rather than a gist
