#!/usr/bin/env bash
#
# (C)Copyright Henri Shustak 2025
# Licenced Under the GNU GPL v3 or later
# https://www.gnu.org/licenses/gpl-3.0.en.html
#
# Simple build script to install
# the spb fish alias onto your system
#
# This script downloads and the
# files from this URL :
# https://github.com/henri/spb-fish-snippits
#
# This script may be run manually. However, typically this
# script is executed when installing or updating SPB :
# https://github.com/henri/spb
#
# version 1.0 - initial release
# version 1.1 - bug fixes
# version 1.2 - added check so we do not overwrite existing spb fish alias
#               this making custom option overriding a little easier
# version 1.3 - bug fixes
# version 1.4 - further bug fixes
# version 1.5 - additional improvments to script reliability on different operating systems
# version 1.6 - included support for updating start-private-browser fish alias
# version 1.7 - additional bug fixes
# version 1.8 - improved check mark box cross platform compatibility
# version 1.9 - improveed resect of overwrite checking enviroment variable to support auto updates
# version 2.0 - improved logging of clone operation for unattended executuoin logging
# version 2.1 - added a fish auto compltions file into the fish food
# version 2.2 - fixed bug related to auto compltions
# version 2.3 - fixed bug relating to non-interactive auto updates
# version 2.4 - improvements to output formating for fish auto-completions
# version 2.5 - additional improvements to output formating
# version 2.6 - added spb-update.bash fish auto-completions
# version 2.7 - bug fixes


# configuration
SPB_BUILD_DIRECTORY_NAME="spb-build-fish-functions"
SPB_DOWNLOAD_DIRECTORY_NAME="spb-fish-functions-latest"

# link to repostiroy which has all the data
fish_spb_snippits_repository_link="https://github.com/henri/spb-fish-snippits"

# list of fish functions to load from this repository # this list is not including alias such as 'spb' and 'start-private-browser' 
# do not add spb.fish - that will overwrite the way people customise their settings. BADBADBAD!
functions_to_load="
spb-yt.fish
spb-perlexity-ai.fish
spb-mistral-ai.fish
spb-ddg.fish
spb-ddg-ai.fish
spb-tor.fish
spb-brave.fish
spb-brave-ai.fish
spb-rum.fish
spb-bit.fish
spb-ody.fish
spb-twitch.fish
spb-smart.fish
spb-claude-ai.fish
spb-chatgpt.fish
spb-google-ai.fish
spb-imdb.fish
spb-wikipedia.fish
"

# special symbold
tick_mark='\xE2\x9C\x94'
bullet_mark='\xE2\x80\xA2'

# os detection
os_type=$(uname -s | tr '[:upper:]' '[:lower:]')

# setup enviroment varibles
if [[ "${SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK}" != "true" ]] ; then
    # SPB_SKIP_OVERWRITE_CHECK enviroment varible not detected ; set to false (default)
    SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK="false"
fi

which git >> /dev/null ; git_available=${?}
if [[ ${git_available} != 0 ]] ; then
    echo "ERROR! : The git command was not detected on your system."
    echo "         Ensure it is part of your path or install git onto your"
    echo "         system and try running this installer again."
    echo ""
    echo "         Learn more about git the link below :"
    echo "         https://git-scm.com/"
    exit -99
fi

which fish >> /dev/null ; fish_available=${?}
if [[ ${fish_available} != 0 ]] ; then
    echo "ERROR! : The fish shell was not detected on your system."
    echo "         Ensure it is part of your path or install fish onto your"
    echo "         system and try running this installer again."
    echo ""
    echo "         Learn more about the fish shell via the link below :"
    echo "         https://fishshell.com/"
    exit -99
fi

# create a build directory, we will be sucking down the latest version of
# everything from git into this directory, then to clean up, we can delete :)
cd $( mktemp -d /tmp/${SPB_BUILD_DIRECTORY_NAME}.XXXXXXX )
if [[ $? != 0 ]] ; then
        echo "ERROR! : Unable to setup the temporary build dirctory!"
    exit -99
fi
# double sanity check (not needed) but lets avoid deleting anything important by mistake when we clean up
temporary_build_directory="$(pwd)"
if ! [[ $(echo "$(basename ${temporary_build_directory})" | grep "${SPB_BUILD_DIRECTORY_NAME}") ]] ; then
        echo "ERROR! : Unable to succesfully locate the temporary directory"
    exit -99
fi

# report the temporary build directory :
echo ""
echo "This script has created a temporay build directory : "
echo "$(pwd)"
echo ""

# clone a copy of the latest version into the temp directory
echo "Downloading latest SPB fish functions ..."
git clone --progress --depth 1 --single-branch --branch=main ${fish_spb_snippits_repository_link} ${SPB_DOWNLOAD_DIRECTORY_NAME} 2>&1
if [[ $? != 0 ]] ; then
    echo ""
    echo "ERROR! : Sucking down latest version from git!"
    echo "         It is likely that git is not installed on"
    echo "         this system or there is a problem with"
    echo "         network access or possibly GitHub has"
    echo "         crashed or has been blocked?"
    echo ""
    echo "         I am sure you will sort it out!"
    exit -98
fi

# check if any spb functions are already setup (do it before the trap is enabled)
existing_spb_functions_return_code=$( fish -c ' "functions" | grep -E "^spb" > /dev/null ; echo $status ' )
existing_and_home_bin_start_private_browser_alias_return_code=$( cat ~/.config/fish/functions/start-private-browser.fish 2> /dev/null | grep '~/bin/start-private-browser.bash $argv' > /dev/null ; echo $? )
existing_start_private_browser_alias_return_code=$( ls ~/.config/fish/functions/start-private-browser.fish 2>&1 > /dev/null ; echo $? )
existing_spb_alias_return_code=$( fish -c ' "alias" | grep -E "^alias spb " > /dev/null ; echo $status ' )

# preform exit if we hit an error ; in addition set an EXIT trap
trap 'echo "" ; echo "Something went horribly wrong! Sorry please try again later." ; echo ""' EXIT
set -e

# enter the local repo
pwd
cd ${SPB_DOWNLOAD_DIRECTORY_NAME}

# check if spb is installed?
if ! [[ -f ~/bin/start-private-browser.bash ]] ; then
  echo "ERROR! : unable to locate the required start-private-browser.bash file on your system"
  echo "         visit : http://github.com/henri for more information and installation instructions"
  exit -99
fi


function abort_fish_function_setup () {
    echo ""
    echo "Understood.. fish spb funtion setup aborted."
    echo ""
    # clear EXIT trap and exit (with error) - installation did not complete succesfully. 
    trap - EXIT ; exit -2
}


function create_or_update_start_private_browser_alias() {
    # that last funcsave is not needed but it seems to help sometimes.
    echo "    fish alias : 'start-private-browser ->~/bin/start-private-browser.bash' :"
    fish -c "alias -s start-private-browser=\"~/bin/start-private-browser.bash\" 2> /dev/null && funcsave start-private-browser"
    if [[ ${?} == 0 ]]  ; then
        echo -e "                 ${tick_mark}  [ configured successfully ]"
    echo ""
    else
        echo "                    x [ error during setup ]"
        echo ""
        exit -65
    fi
}

# install an alias for start-private-browser -> ~/bin/start-private-browser.bash
echo ""
echo "Fish alias related to SPB (start-private-browser) : "
echo ""
if [[ "${SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK}" == "true" ]] ; then
    echo "    WARNING! : SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK = true"
    echo "    WARNING! : Overwriting existing fish aliases"
    echo ""
fi
if [[ ${existing_and_home_bin_start_private_browser_alias_return_code} == 0 ]] ; then 
    echo "    fish alias : 'start-private-browser -> ~/bin/start-private-browser.bash' :"
    echo -e "                 ${tick_mark}  [ skipped ] already configured (exact match)"
    echo ""
else
    if [[ "${SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK}" != "true" ]] ; then
        if [[ ${existing_start_private_browser_alias_return_code} == 0 ]] ; then 
            echo "    fish alias : 'start-private-browser -> ~/bin/start-private-browser.bash' :"
            echo "                 [detected] ***NOT*** configured to use : ~/bin/start-private-browser.bash "
            echo ""                
            echo "                 current alias configuration : "
            # display the current start-private-browser alias setup (if a user has lots of aliass configured this may take a moment
            fish -c "alias | grep 'alias start-private-browser '" | awk '{print $2 " -> " $3}' |  sed 's/^/                 /'
            echo ""
            echo "                     to manually reconfigure the start-private-browser alias to point"
            echo "                     to the copy of SPB in your home directory use the following command : "
            echo ""
            echo "                     alias start-private-browser '~/bin/start-private-browser.bash'"
            echo ""
            echo "    WARNING! : if you continue your existing 'start-private-browser' alias will be overwritten!"
            echo -n "    overwrite your alias start-private-browser alias [Y/n] : "
            read option_to_bottle_out
            if \
                [[ "${option_to_bottle_out}" == "n" ]] || \
                [[ "${option_to_bottle_out}" == "N" ]] || \
                [[ "${option_to_bottle_out}" == "no" ]] || \
                [[ "${option_to_bottle_out}" == "No" ]] || \
                [[ "${option_to_bottle_out}" == "NO" ]] \
            ; then
                abort_fish_function_setup
            fi
            create_or_update_start_private_browser_alias
        else
           create_or_update_start_private_browser_alias
        fi
    else
        create_or_update_start_private_browser_alias
    fi
fi
echo ""

# install an alias for spb -> start-private-browser (yep we do that as well)
if [[ ${existing_spb_alias_return_code} == 0 ]]  ; then
    echo "    fish alias : 'spb -> start-private-browser' :"
    echo -e "                 ${tick_mark}  [ skipped ] already configured (exact matching is not checked)"
else
    # no existing spb fish alias configured ; so we setup the alias
    echo "fish alias : 'spb -> start-private-browser' : "
    echo "             [ configuring ] no previous configuration detected"
    fish -c "source ./spb.fish > /dev/null"
    if [[ ${?} == 0 ]] ; then 
        echo -e "    ${bullet_mark} alias saved : 'spb' ${tick_mark}" 
    else
        echo "    ERROR! : unable to save alias : spb" ; echo ""
    echo "             fish spb funtion setup aborted." ; echo ""
    exit -77
    fi
fi

# echo print some helpful information about overiding the spb alias to include desired options ; which should be used with fish snippits
echo ""
echo "                 If you would like to have custom options passed to spb when using the"
echo "                 fish snippits, then override the spb alias. An example is provided below:"
echo "                 alias --save spb \"start-private-browser --window-position=10,10\""
echo ""

# install the spb auto completions
echo "Fish completions related to SPB (start private browser) : " ; echo ""
echo "    fish auto-completion configuration : "
mkdir -p ~/.config/fish/completions
if [[ ${?} != 0 ]] ; then
    echo "ERROR! : unable to locate or create fish completion direcotry: "
    echo "         ~/.config/fish/completions" ; echo ""
    exit -6
fi
if ! [ -f ./completion/spb-completions.fish ] ; then
    echo "ERROR! : unable to locate completion : "
    echo "         $PWD/spb-completions.fish" ; echo ""
    exit -5
fi
cp ./completion/spb-completions.fish ~/.config/fish/completions/start-private-browser.fish
if [[ ${?} != 0 ]] ; then
    echo "ERROR! : unable to install spb fish completion : "
    echo "         ~/.config/fish/completions/start-private-browser.fish" ; echo ""
    exit -7
fi
fish -c "source ~/.config/fish/completions/start-private-browser.fish > /dev/null"
echo -e "                 ${tick_mark}  [ configured ]  ~/.config/fish/completions/start-private-browser.fish"
# currently macOS versions of fish new and old have issues with loading the .bash.fish completion files
# once we have a work around put it in place for now skip completions for ~/bin/spb-update.bash
if ! [ -f ./completion/spb-update-completions.fish ] ; then
    echo "ERROR! : unable to locate completion : "
    echo "         $PWD/spb-completions.fish" ; echo ""
    exit -5
fi
cp ./completion/spb-update-completions.fish ~/.config/fish/completions/spb-update.bash.fish
if [[ ${?} != 0 ]] ; then
    echo "ERROR! : unable to install spb fish completion : "
    echo "         ~/.config/fish/completions/spb-update.bash.fish" ; echo ""
    exit -7
fi
fish -c "source ~/.config/fish/completions/spb-update.bash.fish > /dev/null"
echo -e "                 ${tick_mark}  [ configured ]  ~/.config/fish/completions/spb-update.bash.fish"
echo -e "\n    --- fish auto completions installed succesfully --- " ; echo ""

# are we going to install the fish functions - check if there are alrady some and allow user to cancel if any are found
echo "Fish functions related to SPB (start private browser) : " ; echo ""
if [[ "${SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK}" == "false" ]] ; then
    if [[ ${existing_spb_functions_return_code} == 0 ]]  ; then
        echo "Existing spb functions were detected : "
        echo ""
        fish -c "functions" | grep -E "^spb-" | sed "s/^/$(echo -e '    \xE2\x80\xA2 ')/"
        echo ""
        echo -n "    continue and update/overwrite existing spb fish functions? [Y/n] : "
        read overwrite_existing
        if \
        [[ "${overwrite_existing}" == "n" ]] || \
        [[ "${overwrite_existing}" == "N" ]] || \
        [[ "${overwrite_existing}" == "no" ]] || \
        [[ "${overwrite_existing}" == "No" ]] || \
        [[ "${overwrite_existing}" == "NO" ]] \
        ; then
            abort_fish_function_setup
        fi
        echo ""
    fi
else
    echo "    WARNING! : SPB_FISH_FUNCTION_SKIP_OVERWRITE_CHECK = true"
    echo "    WARNING! : Overwriting existing fish functions"
fi
echo ""

# prevent exit if we hit an error and remove the EXIT trap
set +e
trap - EXIT

# install the various functions (execute the scripts inplace ratherthan coping into place. This should be switched to fisher at some point)
echo "    sourcing latest spb fish functions ..."
for current_function_name in $(echo ${functions_to_load} | tr "\n" " " ) ; do
    if ! [ -f ./${current_function_name} ] ; then
        echo "ERROR! : unable to locate function to load : "
        echo "         $PWD/${current_function_name}" ; echo ""
        echo "         fish spb funtion setup aborted." echo ""
        exit -3
    fi
    fish -c "source ./${current_function_name} > /dev/null" 
    if [[ ${?} == 0 ]] ; then 
        echo -e "         ${bullet_mark} ${current_function_name} ${tick_mark}" 
    else
        echo "ERROR! : unable to load function : ${current_function_name}" ; echo ""
    echo "         fish spb funtion setup aborted." ; echo ""
    exit -77
    fi
done
echo -e "\n     --- fish functions loaded succesfully --- " ; echo ""

# print some helpful informaiton about finding more information
echo "Uninstall instruction : "
echo ""
echo "    uninstall spb fish alias :"
echo "        rm -v ~/.config/fish/functions/spb.fish"
echo "        rm -v ~/.config/fish/functions/start-private-browser.fish"
echo ""
echo "    uninstall spb fish functions : (caution this is using a wild card)"
echo "        rm -v ~/.config/fish/functions/spb-*.fish"
echo ""
echo "    uninstall spb fish auto-completions : "
echo "        rm -v ~/.config/fish/completions/spb-completions.fish"
echo "        rm -v ~/.config/fish/completions/spb-update.bash.fish"
echo "" ; echo "" 
echo "Documentation and usage instructions for spb fish functions is available from : "
echo "${fish_spb_snippits_repository_link}" ; echo ""

# clean up
cd /tmp/ && rm -rf ${temporary_build_directory}
exit ${?}


