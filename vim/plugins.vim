call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'unblevable/quick-scope'
" Plug 'justinmk/vim-sneak'
Plug 'easymotion/vim-easymotion'
Plug 'mbbill/undotree'
Plug('https://github.com/vim-scripts/argtextobj.vim.git')

call plug#end()

" Quick scope pulgin
" Trigger a highlight in the appropriate direction when pressing these keys:
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

set rtp+=~/.fzf

" Persistent undo
" https://github.com/mbbill/undotree
if has("persistent_undo")
   let target_path = expand('~/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let &undodir=target_path
    set undofile
endif

