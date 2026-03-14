
# one line command to configure spb-ddg-ai functioin to start multiple DuckDuckGo AI a chats in multiple private browser tabs.
# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"


# run the following in a fish shell to configure for your shell : 
function spb-ddg-ai
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
                    echo (echo "https://duckduckgo.com/?t=h_&q=$argv[1]&ia=chat&bang=true" | tr " " "+")
                    set url_count (math $url_count + 1)
            end
            set --erase argv[1]
        end
        if test $url_count -eq 0
            echo "https://duck.ai/"
        end
    )
   spb $urls
end 
funcsave spb-ddg-ai


# usage example - lets say you want to start two chats. The first chat "tell me about cats" and have a second chat "tell me about the largest cats" 
# spb-ddg-ai  "tell me about cats" "tell me about the largest cats"
# starting a chat in a private browser window with DuckDuckGo AI chat, will require agreeing to DuckDuckGo usage policies with a number of clicks at the moment using the mouse.
# hopefully DuckDuck go will offer a way to include approval in the URL in the future.

# note : this command offers basic support for special characters. The only subsittion is space characters are turned into plus signs. If you are searching
#        for something with odd characters then probably using this script is not a great idea.

# todo : turn this into a fisher package rather than a gist
