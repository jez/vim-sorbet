# vim-sorbet

> This is not an official Sorbet project.
> Be prepared to fix things yourself.

[![video demo](https://user-images.githubusercontent.com/5544532/96692164-97c17100-133a-11eb-8323-6c1e4f567a7b.png)](https://youtu.be/x8EFninTAio)

This plugin just adds support for showing Sorbet progress notifications.
You can see the notifications in the demo above.

## Requirements

- LanguageClient-neovim
- vim-airline

TODO(jez) document how to set up

## Usage

If you want to customize where the section goes:

```vim
let g:airline#extensions#sorbet#auto = 0
function! MyCustomAirlineInit() abort
  let g:airline_section_x = airline#section#create(['filetype', g:airline_symbols.space, 'sorbet'])
endfunction
au User AirlineAfterInit ++once call MyCustomAirlineInit()
```

## Future ideas

- Patch LanguageClient-neovim to send autocmd when server fails to start
  - Spawn fails + message
  - Read this commit more closely (c75636525bf2cedee9f30e3eee5c3fef5d56d6b2)
- Surface error message better to user
  - Especially watchman error, `--dir` error, file not found error, etc.
- Vim doc/ pages
- look at how `jdt://` is implemented, try to implement `sorbet://`

Read changelog

```
gla 055744014991647e03c92d537e9c2fd49f7d5d85..HEAD
```
