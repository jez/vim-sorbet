
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
