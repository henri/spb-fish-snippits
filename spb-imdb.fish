# one line command to configure spb-imdb function to start multiple IMDB (internet movie database) searches in multiple private browser tabs.
# this function requires spb (start-private-browser) alias to be configured : https://github.com/henri/spb
# this function requires an alias 'start-private-browser' and 'spb' to be setup eg :
# alias --save start-private-browser="~/bin/start-private-browser.bash"
# alias --save spb="start-private-browser"

# run the following in a fish shell to configure for your shell : 
function spb-imdb
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
                    echo (echo "https://www.imdb.com/find/?q=$argv[1]" | tr " " "+")
                    set url_count (math $url_count + 1)
            end
            set --erase argv[1]
        end 
        if test $url_count -eq 0
            echo "https://gemini.google.com/"
        end
    )
   spb $urls
end 
funcsave spb-imdb



# usage example - lets say you want to start five searches in five tabs. Use the command below : 
# spb-imdb "keanu" "matrix" "blade runner" "back to the future" "zootopia"

# note : this command offers basic support for special characters. The only subsition is space characters are turned into plus signs. If you are searching
#        for something with odd characters then probably using this script is not a great idea.
