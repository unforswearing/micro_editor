# Mirco Help

## Basic Help

> These help links are also available via runtime help command

- [micro/runtime/help/commands.md](https://github.com/micro-editor/micro/blob/master/runtime/help/commands.md)
- [micro/runtime/help/keybindings.md](https://github.com/micro-editor/micro/blob/master/runtime/help/keybindings.md)
- [micro/runtime/help/options.md](https://github.com/micro-editor/micro/blob/master/runtime/help/options.md)
- [micro/runtime/help/plugins.md](https://github.com/micro-editor/micro/blob/master/runtime/help/plugins.md)
- [micro/runtime/help/tutorial.md](https://github.com/micro-editor/micro/blob/master/runtime/help/tutorial.md)
- [micro/runtime/help/defaultkeys.md](https://github.com/micro-editor/micro/blob/master/runtime/help/defaultkeys.md)

## Development Help

> Also search GitHub for specific commands to find usage, since the docs aren't thorough.

- [Issues · micro-editor/micro](https://github.com/micro-editor/micro/issues/)
- [Discussions · micro-editor/micro](https://github.com/micro-editor/micro/discussions)

## Multi-cursor

- Ctrl+MouseLeft - Apply multi cursors
- Alt+n - Apply multi-cursor for matched word
- Alt-x - Skip Multi-cursor for matched word
- Alt-m - Apply multi cursor at the beginning at selection lines
- Alt+p / Alt+c - Remove multicursor / Remove all
- Alt+Shift+Up - Add Multicursor Up
- Alt+Shift+Down - Add Multicursor Down

## Key Bindings for Split Panes and Tabs

>    "Alt-0": "NextTab",
>    "Alt-1": "VSplit",
>    "Alt-2": "HSplit",
>    "Alt-3": "PreviousSplit",
>    "Alt-4": "NextSplit",
>    "Alt-5": "Unsplit",
>    "Alt-9": "PreviousTab",


## Key Binding to Open a Terminal

The following binding opens the terminal in a split pane, rather than the default new pane.

>    "Ctrl-T": "HSplit,command:term",

## Getting Shell Input into Current Files

Instead of attempting to recreate shell commands / functions as init.lua scripts, just use `textfilter` to insert the output of shell commands into files. For example

`textfilter grep colorscheme settings.json` will insert the name of my current colorscheme below:
>    "colorscheme": "ryuuko",

Another example is using a [`lnks`](https://github.com/unforswearing/lnks) command to insert mardown formatted urls into a current markdown file:

`textfilter lnks init.lua --markdown`:

> [micro_editor/init.lua at master · unforswearing/micro_editor · GitHub](https://github.com/unforswearing/micro_editor/blob/master/init.lua)

This can also be used to create a templating system, add snippets from an external file, etc.
