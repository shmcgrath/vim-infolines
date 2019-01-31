# infolines.vim
infolines.vim is a simple statusline and tabline plugin for Vim. This plugin's primary design philosophy is 'minimalism' and that includes NO patched fonts.

## Roadmap
I would like to add the following features:
- If statements so that a particular font is not needed and the information comes across well.
- The tabline is something that I am working on in my .vimrc. A prototype will be added when I get it provisionally working.
- I would like to allow people to change the color dictionary to meet their color scheme or figure out a way for the dictionary to automatically adopt colors from the selected color scheme. (This is a ways down the line. It is easy enough to modify this source.
- I would like to clean up the if statements a bit and add more surrounding file size.
- Remove if statements for sourcing the infoline. I removed unicode symbols because I do not use them.

## Version History
- v 0.0.2 - Significant changes to the back end of the statusline 
    - commit 25dc77899095d9d92be93968e4000e0e25712e5c
- v 0.0.1 - The statusline is useable for my needs. Tabline is not even started.
