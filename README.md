# SPB specific fish snippits

These FISH snippits are specific to the [SPB (Start Private Browser)](https://github.com/henri/spb) project.

This repository includes [FISH](https://fishshell.com/) code, functions, completions, alias and other related snippits which intergrate into the SPB project.

Below you will also find an [installer file](spb-fish-function-installer.bash) and a [kick off file](https://github.com/henri/spb-fish-snippits/blob/main/spb-fish-function-installer-kickoff.bash). Copy and paste the kick off file into a BASH shell to start installation of the spb fish functions support files. If you install via the [SPB install script](https://github.com/henri/spb/blob/main/500.spb-install-script.bash) and already have the fish shell installed on your system, then during the install you will be prompted to update/install these spb related fish snippits.

Initating web searches and conversations from the shell will be [easy-as](https://github.com/henri/spb/blob/main/FAQ.md#what-is-easy-as) with these fish nippits configured on your system! [Get moving](https://github.com/henri/spb/blob/main/README.md#fish-shell-wrappers) in the worlds digital currents.

Functions include [spb-pai](https://gist.github.com/henri/4f034f04b35c01e089e98350c902bda8#file-spb-perlexity-ai-fish) for starting multiple simultanius converstations with [perplexity ai](https://www.perplexity.ai/) in a private browser window using SPB.

In addition to functions, there are also auto completions to make using the SPB via the command line a little easier. Just press tab to get some hopefully helpful completion and explanations as you work.

Note that if you override the spb command and add specific flags which firefox (for instance) will not recognise, then these snippits will fail to work with firefox. To work around this, it is reccomended that you create custom functions for firefox and it's drivitives. If I come up with a good way to make this work, then I will update this message. Right now SPB FireFox browser support is still experimental. 

Have fun swimming :tropical_fish:
