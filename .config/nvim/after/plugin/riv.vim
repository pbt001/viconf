" ============================================================================
    " File: riv.vim
    " Author: Faris Chugthai
    " Description: Plugin modifications for riv.vim
    " Last Modified: March 11, 2019
" ============================================================================

" Guards: {{{1

if !has_key(plugs, 'riv.vim')
    finish
endif

if exists('b:did_riv.vim') || &cp || v:version < 700
    finish
endif

" Options: {{{1

" Highlight py docstrings with rst highlighting
let g:riv_python_rst_hl = 1
let g:riv_file_link_style = 2  " Add support for :doc:`something` directive.
let g:riv_ignored_maps = '<Tab>'
let g:riv_ignored_nmaps = '<Tab>'
let g:riv_i_tab_pum_next = 0

let g:riv_global_leader='<Space>'

" From he riv-instructions. **THIS IS THE ONE!!** UltiSnips finally works again
let g:riv_i_tab_user_cmd = "\<c-g>u\<c-r>=UltiSnips#ExpandSnippet()\<cr>"

" Still so excited about the above ---^

let g:riv_fuzzy_help = 1

" Mar 11, 2019:
" which languages to highlight. not sure how this is gonna work out but we'll see
let g:riv_highlight_code = 'lua,python,cpp,javascript,vim,sh,PowerShell,bash,python3,rst,shell,console'

" link target's position when created. don't put it at the bottom because in a
" python file that means you put it out of the docstring and into the actual
" content where it gets executed...

let g:riv_create_link_pos = '.'

" this is absurdly annoying i need to figure out how to set this to all
let g:riv_ignored_imaps = '<Tab>,<S-Tab>,<Leader>cr'

let g:riv_default_path = expand('$HOME') . '/projects'
