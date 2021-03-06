" Vim_Startify:

" Plugin Guard: {{{1
if !has_key(plugs, 'startify')
    finish
endif

if exists('b:did_startify') || &cp || v:version < 700
    finish
endif
let b:did_startify = 1

" What shows up in the startify list?

" List Commits: {{{1
function! s:list_commits()
    let git = 'git -C ~/projects/viconf/'
    let commits = systemlist(git .' log --oneline | head -n10')
    let git = 'G'. git[1:]
    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
endfunction

" Startify Lists: {{{1
" TODO: Would you wanna add other repos to the start list?

let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': function('s:list_commits'),  'header': ['   Viconf']},
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

" Setup_devicons: {{{1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction

" Center The Header And Footer: {{{1
function! s:filter_header(lines) abort
    let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
    let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
    return centered_lines
endfunction

let g:startify_custom_header = s:filter_header(startify#fortune#cowsay())

" Skiplist: {{{1
" Don't show these files
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ glob('plugged/*/doc'),
    \ 'C:\Program Files\Vim\vim81\doc',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc', ]

" Session Dir: {{{1
if has('gui_win32')
    let g:startify_session_dir = expand('$HOME\vimfiles\session')
else
    let g:startify_session_dir = expand('~/.vim/session')
endif

" General Options: {{{1
" TODO: Figure out how to set let g:startify_bookmarks = [ Contents of
" NERDTreeBookmarks ]
let g:startify_change_to_dir = 1
let g:startify_fortune_use_unicode = 1
let g:startify_update_oldfiles = 1
let g:startify_session_persistence = 1
let g:startify_session_sort = 1
" Configured correctly this could be a phenomenal way to store commands and
" expressions on a per directory basis aka projects / workspaces!
let g:startify_session_autoload = 1
let g:startify_session_sort = 1
