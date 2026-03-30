
# one line command to configure spb-brave functioin to start multiple Brave Searchs in multiple private browser tabs.
# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"


# run the following in a fish shell to configure for your shell : 
# OLD : function spb-brave ; set urls ( while test (count $argv) -gt 0 ; echo "https://search.brave.com/search?q=$argv[1]" | tr " " "+" ; set --erase argv[1] ; end ) ; spb $urls ; end ; funcsave spb-brave 

# run the following in a fish shell to configure for your shell : 
function spb-brave
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
                    echo (echo "https://search.brave.com/search?q=$argv[1]" | tr " " "+")
            end
            set --erase argv[1]
        end 
    )
   spb $urls
end 
funcsave spb-brave


# usage example - lets say you want to start two searchs. The first chat "tell me about cats" and have a second chat "tell me about the largest cats" 
# spb-brave  "tell me about cats" "tell me about the largest cats"
# starting two searches in a private browser window using Brave Search

# note : this command offers basic support for special characters. The only subsittion is space characters are turned into plus signs. If you are searching
#        for something with odd characters then probably using this script is not a great idea.

# todo : turn this into a fisher package rather than a gist
