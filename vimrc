if has("gui_running")
  set background=light
else
  set background=dark
endif
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
set cino=>2,e0,n0,f0,{2,}0,^0,\:2,=2,p2,t2,c1,+2,(2,u2,)20,*30,g2,h2
set modeline
set modelines=3
set expandtab
set cindent
set hls
set ruler
set bs=2
set sw=2
set gfn=terminal\ Medium\ 16
filetype plugin on
syntax on
hi Comment ctermfg=Green
hi Constant ctermfg=Yellow
hi PreProc ctermfg=Red
hi Type ctermfg=none
hi Statement ctermfg=none
hi Label ctermfg=White
hi Function ctermfg=cyan

" Go to tab by number
noremap <A-1> 1gt
noremap <A-2> 2gt
noremap <A-3> 3gt
noremap <A-4> 4gt
noremap <A-5> 5gt
noremap <A-6> 6gt
noremap <A-7> 7gt
noremap <A-8> 8gt
noremap <A-9> 9gt
noremap <A-0> :tablast<cr>
cnoreabbrev tn tabnew
iab teh the
iab Teh The

" Don't display the toolbar - we never use it
set guioptions-=T
" Longer / wider window tab
set guitablabel={%N}\ %m%-025.50f\ %r
" Set marker based folding by default
augroup vimrc
  au BufReadPre * setlocal foldmethod=marker
  au BufWinEnter * if &fdm == 'marker' | setlocal foldmethod=manual | endif
augroup END
autocmd BufEnter *.bh,*.bs :setlocal filetype=c
