if exists('b:did_ftplugin')
	finish
endif
let b:did_ftplugin = 1

setlocal commentstring={\ %s\ }
setlocal suffixesadd=.cal

" CAL names may contain periods and back-quotes for context qualification.
setlocal iskeyword+=.,96

let b:undo_ftplugin = 'setlocal commentstring< suffixesadd< iskeyword<'
