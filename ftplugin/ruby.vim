
if exists(':LanguageClientStart')
  augroup vimSorbetLanguageClient
    au!
    au User LanguageClientStarted call LanguageClient#registerHandlers({
          \ 'sorbet/showOperation': 'sorbet#handleShowOperation'
          \ })
  augroup END
endif

let s:script_dir = fnamemodify(resolve(expand('<sfile>:p')), ':h')

if !exists('g:LanguageClient_settingsPath')
  " Later items in the list take precedence.
  " Put our settings.json first so they act as defaults
  let g:LanguageClient_settingsPath = [s:script_dir.'/settings.json', '.vim/settings.json']
else
  let g:LanguageClient_settingsPath = insert(g:LanguageClient_settingsPath, s:script_dir.'/settings.json', 0)
endif

" TODO(jez) Might be able to set LangageClient_rootMarkers

if !exists('g:LanguageClient_serverCommands')
  let g:LanguageClient_serverCommands = {}
endif

if !exists('g:sorbet_lsp_extra_args')
  let g:sorbet_lsp_extra_args = []
endif

function! s:get_server_command() abort
  if fnamemodify(getcwd(), ':p') =~# $HOME.'/stripe/pay-server'
    return ['pay', 'exec', 'scripts/bin/typecheck']
  endif

  if filereadable('Gemfile') && executable('bundle')
    call system('bundle exec srb tc --version < /dev/null > /dev/null 2> /dev/null')
    if !v:shell_error
      return ['bundle', 'exec', 'srb', 'tc']
    endif
  endif

  if executable('srb')
    return ['srb', 'tc']
  endif

  if executable('sorbet')
    return ['sorbet']
  endif
endfunction

function! s:get_server_args() abort
  let l:sorbet_lsp_args = ['--lsp']

  if !filereadable('sorbet/config')
        \ && fnamemodify(getcwd(), ':p') !~# $HOME.'/stripe/pay-server'
    let l:sorbet_lsp_args += ['-e', '0', fnamemodify(s:script_dir, ':h').'/.empty']
  endif

  " TODO(jez) --debug-log-file ?

  let l:sorbet_lsp_args += g:sorbet_lsp_extra_args
endfunction

if !has_key(g:LanguageClient_serverCommands, 'ruby')
  let s:sorbet_lsp_args = s:get_server_args()

  let s:sorbet_cmd = s:get_server_command()
  if type(s:sorbet_cmd) == v:t_list
    let g:LanguageClient_serverCommands.ruby = s:sorbet_cmd + s:sorbet_lsp_args
  endif

  " TODO(jez) Detect if this command we just built actually works.
endif

let g:LanguageClient_preferredMarkupKind = ['markdown', 'plaintext']
