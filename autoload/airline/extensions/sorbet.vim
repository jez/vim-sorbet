scriptencoding utf-8

" Avoid installing twice
if exists('g:loaded_vim_sorbet_airline_extensions_sorbet')
  finish
endif

let g:loaded_vim_sorbet_airline_extensions_sorbet = 1
let s:spc = g:airline_symbols.space

if !exists('g:airline#extensions#sorbet#auto')
  let g:airline#extensions#sorbet#auto = 1
endif

" First we define an init function that will be invoked from extensions.vim
function! airline#extensions#sorbet#init(ext)
  call airline#parts#define_raw('sorbet', '%{airline#extensions#sorbet#status()}')

  if g:airline#extensions#sorbet#auto
    call a:ext.add_statusline_func('airline#extensions#sorbet#apply')
  endif
endfunction

function! airline#extensions#sorbet#apply(...)
  if &filetype == "ruby"
    call airline#extensions#append_to_section('c', '%{airline#extensions#sorbet#status()}')
  endif
endfunction

function! airline#extensions#sorbet#status_bare()
  if exists('g:sorbet_showOperation_status')
    if empty(g:sorbet_showOperation_status)
      return '✔'
    else
      let l:desc = g:sorbet_showOperation_status[-1].operationName
      if l:desc ==# 'Indexing'
        return '⏳'
      elseif l:desc ==# 'SlowPathBlocking'
        return '⌛️'
      elseif l:desc ==# 'SlowPathNonBlocking'
        return '…'
      elseif l:desc ==# 'References'
        return '⌛️'
      else
        return '?'
      endif
    endif
  else
    return ''
  endif
endfunction

function! airline#extensions#sorbet#status()
  let l:raw = airline#extensions#sorbet#status_bare()
  if l:raw == ''
    return ''
  else
    let l:spc = g:airline_symbols.space
    let l:prefix = g:airline_left_alt_sep.l:spc.'srb: '
    return l:prefix.l:raw.l:spc
  endif
endfunction
