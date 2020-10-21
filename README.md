# vim-sorbet

[![video demo](https://user-images.githubusercontent.com/5544532/96692164-97c17100-133a-11eb-8323-6c1e4f567a7b.png)](https://youtu.be/x8EFninTAio)

This assumes you have already configured LanguageClient-neovim to work with
Sorbet.

If you want to customize where the section goes:

```vim
let g:airline#extensions#sorbet#auto = 0
function! MyCustomAirlineInit() abort
  let g:airline_section_x = airline#section#create(['filetype', g:airline_symbols.space, 'sorbet'])
endfunction
au User AirlineAfterInit ++once call MyCustomAirlineInit()
```

