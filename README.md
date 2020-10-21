# vim-sorbet

If you want to customize where the section goes:

```vim
let g:airline#extensions#sorbet#auto = 0
function! MyCustomAirlineInit() abort
  let g:airline_section_x = airline#section#create(['filetype', g:airline_symbols.space, 'sorbet'])
endfunction
au User AirlineAfterInit ++once call MyCustomAirlineInit()
```

