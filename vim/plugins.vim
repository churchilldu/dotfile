" Bootstrap and loader for ~/.vim/plugin/*.vim fragments.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" All Plug declarations must run between plug#begin() and plug#end(), so each
" fragment (which adds Plug + that plugin's config) is sourced inside here.
call plug#begin()
for s:plug_file in sort(glob('~/.vim/plugin.d/*.vim', v:true, v:true))
  execute 'source' s:plug_file
endfor
unlet s:plug_file
call plug#end()
