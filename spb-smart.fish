# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"
#
# Note : This function is still a work in progress.
#        the idea is that rather than needed to quote or
#        search you could just put things in and this will
#        hopefully work out what you are after.
# 
#        If you use this in the current form, then 
#        you need to use the default spb options
#        or data from the config file
#        there is no argument overide
#        as there is for exists for many
#        other spb fish functions.
#

function spb-smart
    set input "$argv"

    # Match full URL (http/https)
    if string match -rq '^https?://.*' "$input"
        spb "$input"
        return
    end

    # Match domain pattern (contains a dot, no spaces)
    if string match -rq '^[A-Za-z0-9.-]+\.[A-Za-z]{2,}(/.*)?$' "$input"
        spb "https://$input"
        return
    end

    # Otherwise, treat input as a search query
    set encoded (string escape --style=url "$input")
    spb "https://search.brave.com/search?q=$encoded"
end
funcsave spb-smart


# usage example to open private browser and search for "hello world".
# spb-smart hello world

# usage example to open private browser and jump directly to a the provided URL (spb web page in this example.).
# spb-smart github.com/henri/spb

# usage example for searching for "hello world" and "this big world" in seperated instances 
# unlike other examples this approach loads multiple instances rather than multiple tabs
# spb-smart hello world && spb-smart this big world

# todo : - turn this into a fisher package rather than a gist
#        - improve and possibly look at how to not tie directly to a search engine like brave
#            - ideally this would be direct access to the URL bar and the browser would work out what to do

