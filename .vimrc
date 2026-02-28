let mapleader = " "

" Setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd

" 見た目系
" Colorscheme
colorscheme murphy
" 行番号を表示
set number
" インデントはスマートインデント
set smartindent
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable
" txt->sh
autocmd BufRead,BufNewFile *.txt set filetype=sh
" background color
set termguicolors
highlight Normal guibg=#222222
" gvim window size
if has('gui_running')
  set columns=100
  set lines=40
  set guifont=PlemolJP\ Console\ NF
endif

" Tab系
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅
set shiftwidth=4

" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Keymaps
nnoremap m 5<C-e>
nnoremap t 5<C-y>
" send yank to clipboard (no yank for x)
nnoremap y "+y
xnoremap y "+y
nnoremap Y "+Y
nnoremap yy "+yy
nnoremap x "_x
xnoremap x "_x
nnoremap X "_X
xnoremap X "_X
" multiselect
nmap <C-d> <C-n>
vmap <C-d> <C-n>
" ctrl+t -> NERTTree
nnoremap <leader>e :NERDTreeFocus<CR>
" open terminal
nnoremap <leader>t :bel term<CR>

" no jump to matched parenthesis
let g:loaded_matchparen = 1

" Plugins
call plug#begin('~/.vim/plugged')

Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'preservim/nerdtree'

call plug#end()

