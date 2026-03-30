
# one line command which setups up spb-ddg as a command to search Duck Duck Go with provided search arguments in a private browser
# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"


# run the following in a fish shell to configure for your shell : 
# OLD : function spb-ddg ; set urls ( while test (count $argv) -gt 0 ; echo "https://duckduckgo.com/?t=h_&q=$argv[1]" | tr " " "+" ; set --erase argv[1] ; end ) ; spb $urls ; end ; funcsave spb-ddg


# run the following in a fish shell to configure for your shell : 
function spb-ddg
    set url_count 0
    set urls ( 
        while test (count $argv) -gt 0
            switch $argv[1]
                case '--template' '--new-template' '--edit-template' '--force-stop' '--browser' '--template-path' '--browser-path'
                    echo "$argv[1]"
                    echo "$argv[2]"
                    set --erase argv[1]
                case '--help' '--list' '-ls' '-l' '--list-templates' '--update' '--tor' '--list-browsers' '--configuration-variables' '--version'
                    echo "$argv[1]"
                    break
                case  '--standard' '--quite' '--quiet' '--verbose' '--about'
                    echo "$argv[1]"
                case '*'
                    echo (echo "https://duckduckgo.com/?t=h_&q=$argv[1]" | tr " " "+")
                    set url_count (math $url_count + 1)
            end
            set --erase argv[1]
        end
        if test $url_count -eq 0
            echo "https://duckduckgo.com"
        end
    )
   spb $urls
end 
funcsave spb-ddg

# usage example to open private browser and search for "search for hello world" and "search this big world" in two DuckDuck Go tabs.
# spb-ddg "search for hello world" "search this big world" 


# note : this command is not complex only space characters are turned into plus signs. If you are searching
#        for something with odd characters then probably using this script is not a great idea.

# todo : turn this into a fisher package rather than a gist
