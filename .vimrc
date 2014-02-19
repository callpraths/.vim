" Use the better VIM settings rather than Vi ones.
set nocompatible

" Set my leader keys before anything else.
let mapleader = ','
let maplocalleader = ';'

" Global option settings {{{
set backspace=2
set ruler
set hlsearch
set showmatch matchtime=2
set background=dark
set relativenumber
set spellfile=~/.vim/spell/tech.utf-8.add,~/.vim/spell/en.utf-8.add 
set noruler laststatus=2

" Build up my custome statusline. {{{
set statusline=%.40f  " Relative file path.
set statusline+=%.15y  " FileType
set statusline+=\ \  " Separate rest from the fileinfo.
set statusline+=%m  " Modified flag.
set statusline+=%r  " Readonly flag.
set statusline+=%=  " Rest appear on the right side of the statusline.
set statusline+=%n  " Buffer number.
set statusline+=%l/%L[%P]  " Current line / Total lines [percent].
" }}}

" Set search to smartcase by default. Prefix with '\C' for case sensetive
" search.
set ignorecase
set smartcase

" Although these options are programming specific, they are global enough...
" My current mood is no folding ;) You may override by setting autocmds.
set nofoldenable
syntax on

"This lets me use the .vim/ftplugin/ directory to do filetype specific stuff
"Remember to copy from /usr/share/vim/vim72/ftplugins and change it.
"My files are loaded first, so they will be overridden otherwise.
filetype plugin indent on

" Highlight long lines
hi ColorColumn ctermbg=darkblue ctermfg=white
set cc=+1
" }}} Global options settings 

" Global keymaps {{{

" Magic keys to <escape> from insert mode quickly.
" This means you can't use these keys in quick succession when typing!
:inoremap jk <esc>

" Make page-up and page-down more natural.
:noremap <leader>j <c-f>
:noremap <leader>k <c-b>

" Old habits die hard. 
:inoremap <esc> <nop>
:noremap <up> <nop>
:noremap <down> <nop>
:noremap <left> <nop>
:noremap <right> <nop>

" At least while I'm playing around with my vimrc, quick edit/source for vimrc.
:nnoremap <leader>ev :vsplit $MYVIMRC<cr>
:nnoremap <leader>sv :source $MYVIMRC<cr>:echom 'Sourced $VIMRC'<cr>

" Insert mode: Delete current line and return to insert mode.
:inoremap <c-d> <esc>ddi

" Insert mode: Turn the current word uppercase.
" This will attempt to leave the cursor beyond the word boundary.
:inoremap <c-u> <esc>viwU<esc>ea
" Normal mode: Turn the current word uppercase.
:nnoremap <Leader><c-u> viwU<esc>e

"Key bindings to speed up search and replace
:nnoremap <leader>; :%s:::gc<Left><Left><Left><Left>

" Search for selected text, forwards or backwards. {{{
vnoremap <silent> * :<C-U>
\mark o
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
\mark o
\let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
\gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
\gV:call setreg('"', old_reg, old_regtype)<CR>
" }}}

" Key binding for easier buffer switching
:nnoremap <leader>b :buffers<CR>:buffer!<Space>

" Shortcut to set the colours right on seldom used light backgrounds
:nnoremap <F6> :set<Space>background=light<CR>

" Operator mode mappings {{{
:onoremap in( :<c-u>normal! f(vi(<cr>
:onoremap il( :<c-u>normal! F(vi(<cr>
:onoremap in[ :<c-u>normal! f[vi[<cr>
:onoremap il[ :<c-u>normal! F[vi[<cr>
:onoremap in{ :<c-u>normal! f{vi{<cr>
:onoremap il{ :<c-u>normal! F{vi{<cr>
:onoremap in" :<c-u>normal! f"vi"<cr>
:onoremap il" :<c-u>normal! F"vi"<cr>
:onoremap in' :<c-u>normal! f'vi'<cr>
:onoremap il' :<c-u>normal! F'vi'<cr>
" }}} Operator mode mappings
" }}} Global Keymaps

" FileType specific local options and keymaps {{{

" Functions used below
function! RemoveTrailingSpaces()
  " This is dangerous? But really handy.
  autocmd BufWritePre <buffer> :%s/\s\+$//e
endfunction

" Programming options. {{{
" Options common to most programming I do. These may be overridden below in
" more specific groups.
" TODO(pprabhu) Is there any guarantee that these options are overridden by the
" ones below?
augroup filetype_programming
  autocmd!
  autocmd FileType c,cpp,python,html setlocal shiftwidth=2 tabstop=2
  autocmd FileType c,cpp,python,html setlocal expandtab
  autocmd FileType c,cpp,python,html setlocal autoindent smartindent
  autocmd FileType c,cpp,python,html setlocal shiftround
  autocmd FileType c,cpp,python,html setlocal textwidth=80
augroup END
" }}} programming.

" FileType: cpp {{{
augroup filetype_cpp
  autocmd!
  autocmd FileType cpp setlocal cindent
  autocmd FileType cpp setlocal shiftwidth=2 tabstop=2
  autocmd FileType cpp setlocal foldmethod=syntax
  
  autocmd FileType cpp call RemoveTrailingSpaces()
  autocmd FileType cpp nnoremap <buffer> <localleader>c I// <esc>
augroup END
" }}} cpp

" FileType: c {{{
" This ensures that *.h files are treated as C headers.
let g:c_syntax_for_h=1
augroup filetype_c
  autocmd!
  
  autocmd FileType c setlocal cindent
  autocmd FileType c setlocal shiftwidth=4 tabstop=4
  autocmd FileType c setlocal foldmethod=syntax
  
  autocmd FileType c call RemoveTrailingSpaces()
  " This should be replaced by /*...*/
  autocmd FileType c nnoremap <buffer> <localleader>c I// <esc>
augroup END
" }}} c

" FileType: python {{{
augroup filetype_python
  autocmd!

  autocmd FileType python setlocal shiftwidth=4 tabstop=4
  
  autocmd FileType python call RemoveTrailingSpaces()
  autocmd FileType python nnoremap <buffer> <localleader>c I# <esc>
augroup END
" }}} python

" FileType: html {{{
augroup filetype_html
  autocmd!

  autocmd filetype html setlocal spell
augroup END
" }}} html

" FileType: makefile {{{
augroup filetype_makefile
  autocmd! 

  " This does not inherit from filetype_programming
  autocmd VimEnter,BufEnter Makefile setlocal noexpandtab 
  autocmd VimEnter,BufEnter Makefile setlocal autoindent smartindent 
  autocmd VimEnter,BufEnter Makefile setlocal textwidth=80

  autocmd VimEnter,BufEnter Makefile call RemoveTrailingSpaces()
augroup END
" }}} html

" FileType: markdown {{{
augroup filetype_markdown
  autocmd!

  autocmd FileType markdown onoremap ih :silent<c-u>execute
      \"normal! ?^\\(==\\+\\\\|--\\+\\)\r
               \:nohlsearch\r
               \kvg_"<cr>
augroup END
" }}} markdown

" FileType: vim {{{
augroup filetype_vim
  autocmd!

  autocmd FileType vim setlocal foldenable
  autocmd FileType vim setlocal autoindent smartindent
  autocmd FileType vim setlocal textwidth=80
  autocmd FileType vim setlocal expandtab shiftwidth=2 tabstop=2
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}} vim

" Miscellaneous autocmds group together. {{{
augroup misc
  autocmd!

  autocmd VimEnter,BufEnter *\/SCons* setlocal tabstop=2 shiftwidth=2 expandtab
  autocmd VimEnter,BufEnter *\/SCons* setlocal syn=python
  autocmd VimEnter,BufEnter *\/SCons* setlocal textwidth=80
  autocmd VimEnter,BufEnter *.ebuild setlocal tabstop=4 shiftwidth=4 noexpandtab
  autocmd VimEnter,BufEnter *.ebuild setlocal textwidth=80
  autocmd VimEnter,BufEnter COMMIT_EDITMSG setlocal syntax=gitcommit
  autocmd VimEnter,BufEnter COMMIT_EDITMSG setlocal textwidth=80

  autocmd VimEnter,BufEnter *.ebuild call RemoveTrailingSpaces()
  autocmd VimEnter,BufEnter COMMIT_EDITMSG call RemoveTrailingSpaces()
augroup END
" }}} misc

" }}} FileType specific autocmds.

" All done. Let's be friendly
autocmd VimEnter * echom ">^.^<"
