" 1. 基础行为
set nocompatible          " 使用 Vim 默认设置（不兼容 Vi）
filetype plugin indent on " 启用文件类型检测、插件和自动缩进
syntax on                 " 开启语法高亮

" 2. 界面显示
set number                " 显示行号
set relativenumber        " 显示相对行号（可选）
set showcmd               " 在状态栏显示已输入的命令
set ruler                 " 显示光标所在行列位置
set wildmenu              " 增强命令行补全菜单
set laststatus=2          " 始终显示状态栏
set ttyfast               " 禁用终端快速滚动，避免透明背景下滚动闪烁

" 3. 制表符与空格
set tabstop=4             " 一个 Tab 键显示的宽度（空格数）
set shiftwidth=4          " 自动缩进使用的空格数
set expandtab             " 将 Tab 展开为空格
set autoindent            " 新行继承上一行的缩进
set smartindent           " 智能自动缩进（适合 C 类语言）

" 4. 搜索设置
set hlsearch              " 高亮显示搜索结果
set incsearch             " 输入搜索词时实时高亮匹配
set ignorecase            " 搜索时忽略大小写
set smartcase             " 若包含大写字母，则区分大小写

" 5. 编辑与备份
set backspace=indent,eol,start " 允许退格键删除缩进、换行和已有字符
set history=1000          " 命令历史记录条数
set undofile              " 持久保存撤销历史（即使文件关闭）
set backupdir=~/.vim/backup " 备份文件存放目录
set directory=~/.vim/swap   " 交换文件（临时）存放目录
set undodir=~/.vim/undo     " 撤销历史文件存放目录

" 6. 换行处理
set wrap                  " 长行自动换行显示
set linebreak             " 在单词边界换行（不截断单词）
set textwidth=0           " 不自动插入换行符（保持原有格式）

" 7. 其他杂项
set mouse=a               " 启用鼠标支持（所有模式）
set clipboard=unnamedplus " 使用系统剪贴板（Linux/macOS 需支持 X11）
set nobackup              " 关闭旧的备份文件（用 undofile 替代）
set nowritebackup         " 编辑时禁止产生临时备份
set noerrorbells          " 关闭错误提示音
set visualbell            " 用视觉闪烁代替提示音

" 8. 自定义快捷键（可选）
" 设置 Leader 键为空格
let mapleader = " "
" 快速清除搜索高亮（按 空格+h）
nnoremap <leader>h :nohlsearch<CR>
" Ctrl+S 保存文件
nnoremap <C-s> :w<CR>

" 9. 透明背景（跟随终端透明度设置）
set background=dark
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
