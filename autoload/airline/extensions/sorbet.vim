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

if !exists('g:airline#extensions#sorbet#use_short_descriptions')
  let g:airline#extensions#sorbet#use_short_descriptions = 1
endif

if !exists('g:airline#extensions#sorbet#short_descriptions')
  let g:airline#extensions#sorbet#short_descriptions = {}
endif

let s:default_short_descriptions = {
      \ 'Idle': '✔',
      \ 'ServerNotRunning': '✘',
      \ 'UnknownStatus': '?',
      \ 'Indexing': '⏳',
      \ 'SlowPathBlocking': '⌛️',
      \ 'SlowPathNonBlocking': '…',
      \ 'References': '⌛️',
      \ 'SymbolSearch': '⌛️',
      \ }

" keep means: don't overwrite an existing key when merging
call extend(g:airline#extensions#sorbet#short_descriptions, s:default_short_descriptions, 'keep')

if !exists('g:airline#extensions#sorbet#long_descriptions')
  " If you want to set this, this can be the same shape as short_descriptions
  " (one key per operationName)
  " operationName's without keys in this will default to the description from
  " the server.
  let g:airline#extensions#sorbet#long_descriptions = {}
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
    call airline#extensions#append_to_section('warning', '%{airline#extensions#sorbet#errors()}')
  endif
endfunction

function! airline#extensions#sorbet#status_bare()
  if !exists('b:LanguageClient_isServerRunning')
    " If you can get this to show up, you've found a bug. Please tell me.
    " I think that b:LanguageClient_isServerRunning should always be set.
    return '🐞'
  endif

  if !b:LanguageClient_isServerRunning
    if g:airline#extensions#sorbet#use_short_descriptions
      return g:airline#extensions#sorbet#short_descriptions.ServerNotRunning
    else
      let l:long_descs = g:airline#extensions#sorbet#long_descriptions
      return get(l:long_descs, 'ServerNotRunning', 'Server not running')
    end
  endif

  if !exists('g:sorbet_showOperation_status')
    if g:airline#extensions#sorbet#use_short_descriptions
      return g:airline#extensions#sorbet#short_descriptions.UnknownStatus
    else
      let l:long_descs = g:airline#extensions#sorbet#long_descriptions
      return get(l:long_descs, 'UnknownStatus', 'Server status unknown')
    end
  endif

  if empty(g:sorbet_showOperation_status)
    if g:airline#extensions#sorbet#use_short_descriptions
      return g:airline#extensions#sorbet#short_descriptions.Idle
    else
      let l:long_descs = g:airline#extensions#sorbet#long_descriptions
      return get(l:long_descs, 'Idle', 'Idle')
    end
  else
    let l:status = g:sorbet_showOperation_status[-1]
    if g:airline#extensions#sorbet#use_short_descriptions
      let l:short_descs = g:airline#extensions#sorbet#short_descriptions
      return get(l:short_descs, l:status.operationName, '?')
    else
      let l:long_descs = g:airline#extensions#sorbet#long_descriptions
      return get(l:long_descs, l:status.operationName, l:status.description)
    end
  endif
endfunction

function! airline#extensions#sorbet#status()
  let l:raw = airline#extensions#sorbet#status_bare()
  if l:raw == ''
    return ''
  else
    let l:spc = g:airline_symbols.space
    return g:airline_left_alt_sep.l:spc.'srb:'.l:spc.l:raw.l:spc
  endif
endfunction

function! airline#extensions#sorbet#errors()
  let l:diagnostics_dict = LanguageClient#statusLineDiagnosticsCounts()
  let l:spc = g:airline_symbols.space
  if !has_key(l:diagnostics_dict, 'E')
    return ''
  endif

  if l:diagnostics_dict.E == 0
    return ''
  endif

  return 'srb:'.l:spc.l:diagnostics_dict.E
endfunction
