
function! sorbet#handleShowOperation(params) abort
  if !exists('g:sorbet_showOperation_status')
    let g:sorbet_showOperation_status = []
  endif

  if a:params.status == 'start'
    call add(g:sorbet_showOperation_status, a:params)
  elseif a:params.status == 'end'
    while !empty(g:sorbet_showOperation_status)
      let l:back = remove(g:sorbet_showOperation_status, -1)
      if l:back.operationName == a:params.operationName
        break
      endif
    endwhile
  endif
endfunction

function! sorbet#handleReadFileResponse(response, ...) abort
  if !has_key(a:response, 'result')
    call setline(1, json_encode(a:response))
  else
    call setline(1, split(a:response.result.text, '\n'))
  endif

  setlocal buftype=nofile
  setlocal noswapfile
endfunction

function! sorbet#readFile(uri) abort
  setlocal filetype=ruby
  let l:params = { 'uri': expand(a:uri) }
  " let l:Callback = function('sorbet#handleReadFileResponse')
  " call LanguageClient#Call('sorbet/readFile', l:params, l:Callback)
  let l:response = []
  call LanguageClient#Call('sorbet/readFile', l:params, l:response)
  while empty(l:response)
    " nothing, block to give callback time
  endwhile
  call sorbet#handleReadFileResponse(l:response[0])
endfunction

