"pydoc.vim: pydoc integration for vim

" So I found this somewhere and wanted to throw it back into the repository if
" you get bored.
"
" TODO: We could define an external command using
" `let g:pydoc_cmd etc etc
"
" Or you could define a function such that a remote host can utilize it.
" Then we don't block anything while looking through the docs.
" It'd make really large greps on pydocs a lot easier. It'd also make it
" faster if we integrated FZF into the mix and used  the output from this
" command as the sink to one of it's autoload functions.
" Alternatively though, you could just utilize jedi more effectively and have
" it set to set its mappings in py/rst/maybe rst.txt files.
" Then just get more comfortable with th go to usages and declarations.
"
" HOWEVER. Continue downwards for more of my thoughts.
"
"
"This plugin integrates the pydoc into vim. You can view the
"documentation of a module by using :Pydoc foo.bar.baz or search
"a word (uses pydoc -k) in the documentation by typing PydocSearch
"foobar. You can also view the documentation of the word under the
"cursor by pressing <leader>pw or the WORD (see :help WORD) by pressing
"<leader>pW.  "This is very useful if you want to jump to a module which was found by
"PydocSearch. To have a browser like feeling you can use u and CTRL-R to
"go back and forward, just like editing normal text.

"If you want to use the script and pydoc is not in your PATH, just put a
"line like  

" let g:pydoc_cmd = \"/usr/bin/pydoc" (without the backslash!!)

"in your .vimrc


"pydoc.vim is free software, you can redistribute or modify
"it under the terms of the GNU General Public License Version 2 or any
"later Version (see http://www.gnu.org/copyleft/gpl.html for details). 

"Please feel free to contact me.


set switchbuf=useopen
function! ShowPyDoc(name, type)
    if !exists('g:pydoc_cmd')
        let g:pydoc_cmd = 'pydoc'
    endif

    if bufloaded("__doc__") >0
        let l:buf_is_new = 0
    else
        let l:buf_is_new = 1
    endif

    " Stop using sb and abbreviations.
    if bufnr("__doc__") >0
        execute "sb __doc__"
    else
        execute 'split __doc__'
    endif
    setlocal noswapfile
    " Forgot the local or does it not work that way?
    set buftype=nofile
    setlocal modifiable
    normal ggdG
    let s:name2 = substitute(a:name, '(.*', '', 'g' )
    let s:name2 = substitute(a:name, ':', '', 'g' )
    if a:type==1
        execute  "silent read ! " . g:pydoc_cmd . " " . s:name2 
    else 
        execute  "silent read ! " . g:pydoc_cmd . " -k " . s:name2 
    endif	
    setlocal nomodified
    set filetype=man
    normal 1G

    if !exists('g:pydoc_wh')
        let g:pydoc_wh = 10
    end
    resize -999
    execute "silent resize +" . g:pydoc_wh 

    if !exists('g:pydoc_highlight')
        let g:pydoc_highlight = 1
    endif
    if g:pydoc_highlight == 1
        call Highlight(s:name2)
    endif	

    let l:line = getline(2)
    if l:line =~ "^no Python documentation found for.*$" 
        if l:buf_is_new
            execute "bd!"
        else
            normal u
        endif
        redraw
        echohl WarningMsg | echo l:line | echohl None
    endif
endfunction


function! Highlight(name)
    execute "sb __doc__"
    set filetype=man
    syn on
    execute 'syntax keyword pydoc '.s:name2
    hi pydoc gui=reverse
endfunction

" Should have a setting to disable all mappings
" In addition plugins conventionally should use localleader not leader

"mappings
au FileType python,man map <buffer> <leader>pw :call ShowPyDoc('<C-R><C-W>', 1)<CR>
au FileType python,man map <buffer> <leader>pW :call ShowPyDoc('<C-R><C-A>', 1)<CR>
au FileType python,man map <buffer> <leader>pk :call ShowPyDoc('<C-R><C-W>', 0)<CR>
au FileType python,man map <buffer> <leader>pK :call ShowPyDoc('<C-R><C-A>', 0)<CR>

"commands
command -nargs=1 Pydoc :call ShowPyDoc('<args>', 1)
command -nargs=*  PydocSearch :call ShowPyDoc('<args>', 0)

" These commands doe. We coudl grep them, fzf them, aggregate them. There's a whole lot
" of fun to be had here
