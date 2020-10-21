
if exists(':LanguageClientStart')
  augroup vimSorbetLanguageClient
    au!
    au User LanguageClientStarted call LanguageClient#registerHandlers({
          \ 'sorbet/showOperation': 'sorbet#handleShowOperation'
          \ })
  augroup END
endif

