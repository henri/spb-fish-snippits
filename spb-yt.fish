# one line command which setups up spb-yt as a command to search YouTube with provided search arguments in a private browser
# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"


# run the following in a fish shell to configure for your shell : 
# OLD : function spb-yt ; set urls ( while test (count $argv) -gt 0 ; echo "https://www.youtube.com/results?search_query=$argv[1]" | tr " " "+" ; set --erase argv[1] ; end ) ; spb $urls ; end ; funcsave spb-yt


# run the following in a fish shell to configure for your shell : 
function spb-yt
    set url_count 0
    set urls ( 
        while test (count $argv) -gt 0
            switch $argv[1]
                case '--template' '--new-template' '--edit-template' '--force-stop' '--browser' '--template-path' '--browser-path'
                    echo "$argv[1]"
                    echo "$argv[2]"
                    set --erase argv[1]
                case '--help' '--list' '-ls' '-l' '--list-templates' '--update' '--tor' '--list-browsers' 
                    echo "$argv[1]"
                    break
                case  '--standard' '--quite' '--verbose' '--about'
                    echo "$argv[1]"
                case '*'
                    echo (echo "https://www.youtube.com/results?search_query=$argv[1]" | tr " " "+")
                    set url_count (math $url_count + 1)
            end
            set --erase argv[1]
        end
        if test $url_count -eq 0
            echo "https://www.youtube.com"
        end
    )
   spb $urls
end 
funcsave spb-yt


# usage example to open private browser and search for "hello world" and "this big world" in two YouTube tabs.
# spb-yt "hello world" "this big world" 


# note : this command is not complex only space characters are turned into plus signs. If you are searching
#        for something with odd characters then probably using this script is not a great idea.

# todo : turn this into a fisher package rather than a gist
