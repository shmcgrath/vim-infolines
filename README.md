# infolines.vim
infolines.vim is a simple statusline and tabline plugin for Vim. My main reason for making it a plugin (at this point in time) is to get it out of my .vimrc

## Requirements / Dependecies of infolines.vim

I use [Source Code Pro](https://github.com/adobe-fonts/source-code-pro) when I code. I use it almost everywere on all of my machines. I am using a handful of Unicode characters from Source Code Pro in this plugin. I would assume that any font that supports the following Unicode characters would work with infolines.vim:
-  - Git Branch Symbol from Source Code Pro
    - Possible Unicode Alternative: ⎇ [UTF-8 E2 8E 87](http://apps.timwhitlock.info/unicode/inspect?s=%E2%8E%87)
-  - LN Symbol from Source Code Pro
    - Possible Unicode Alternative: Wrapping the Lines in the following brackets:
        - ⌈ [UTF-8 E2 8C 88](http://apps.timwhitlock.info/unicode/inspect?s=%E2%8C%88)
        - ⌋ [UTF-8 E2 8C 8B](http://apps.timwhitlock.info/unicode/inspect?s=%E2%8C%8B)
        - Use 'ln' or use no symbols at all
- 🔒[UTF-8 F0 9F 94 92](http://apps.timwhitlock.info/unicode/inspect?s=%F0%9F%94%92)
- 💩[UTF-8 F0 9F 92 A9](http://apps.timwhitlock.info/unicode/inspect?s=%F0%9F%92%A9)
- ○ [UTF-8 E2 97 A6](http://apps.timwhitlock.info/unicode/inspect?s=%E2%97%A6)
- ● [UTF-8 E2 80 A2](http://apps.timwhitlock.info/unicode/inspect?s=%E2%80%A2)
- ▪ [UTF-8 E2 96 AA](http://apps.timwhitlock.info/unicode/inspect?s=%E2%96%AA)
- ‖ [UTF-8 E2 80 96](http://apps.timwhitlock.info/unicode/inspect?s=%E2%80%96)

If you are using Source Code Pro, make sure the Vim encoding is set to UTF-8 to display these symbols.
## Roadmap
I would like to add the following features:
- If statements so that a particular font is not needed and the information comes across well.
- The tabline is something that I am working on in my .vimrc. A prototype will be added when I get it provisionally working.
- I would like to allow people to change the color dictionary to meet their color scheme or figure out a way for the dictionary to automatically adopt colors from the selected color scheme. (This is a ways down the line. It is easy enough to modify this source.
- I would like to clean up the if statements a bit and add more surrounding file size.

## Version History
- v 0.0.1 - The statusline is useable for my needs. Tabline is not even started.
