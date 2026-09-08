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

## Getting Shell Input Current Files

Instead of attempting to recreate shell commands / functions as init.lua scripts, just use `textfilter` to insert the output of shell commands into files. For example

`textfilter grep colorscheme settings.json` will insert the name of my current colorscheme below:
>    "colorscheme": "ryuuko",

This can also be used to create a templating system, add snippents from an external file, etc.
