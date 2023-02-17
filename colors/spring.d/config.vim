vim9script

#@{[Brief Intro]
#!  Name:           Spring.config
#!  Description:    Configurations provided by Spring colorscheme
#!  Author:         zymelaii <nes_ariky@outlook.com>
#!  Maintainer:     zymelaii <nes_ariky@outlook.com>
#!  Website:        https://www.github.com/zymelaii
#!  License:        <none>
#!  Last Updated:   2023 Feb 2
#@}

#@{[<Tab> 与缩进]}
set tabstop=4                   #!< 设置 <Tab> 的空格宽度
set softtabstop=4               #!< 设置编辑文本时使用的 <Tab> 的宽度
set expandtab                   #!< 将 <Tab> 转换为空格
set shiftwidth=4                #!< 设置每一步缩进的宽度
set autoindent                  #!< 使用自动缩进
set smartindent                 #!< 使用智能缩进
set backspace=indent,eol,nostop #!< 设置启用的退格目标
#@}
#@{[显示设置]za
set number                      #!< 显示行号栏
set norelativenumber            #!< 不显示相对行号（显示绝对行号）
set cursorline                  #!< 高亮当前行
set nocursorcolumn              #!< 不高亮当前列
set noshowmode                  #!< 不显示当前的模式
set noshowcmd                   #!< 不在最后一行显示部分命令
set noruler                     #!< 不显示当前光标的坐标
set showmatch                   #!< 显示匹配的括号
set showbreak=\                #!< 设置包裹换行的行首显示符
set termguicolors               #!< 设置使用 xterm-true-color
# set colorcolumn=+0            #!< 默认在 textwidth 的位置显示一列颜色列（用来反馈单行是否过长）
set showtabline=2               #!< 总是显示顶部标签栏
set laststatus=2                #!< 总是显示底部状态栏
set wildmenu                    #!< 在底部状态栏显示显示补全匹配列表
set signcolumn=auto             #!< 自动选择是否显示标志栏（仅当有标志时显示）
#@}
#@{[填充字符设置]
set fillchars=                  #!< 清除已有的填充字符设置
set fillchars+=vert:╪           #!< 垂直分割列填充字符
set fillchars+=eob:            #!< 缓冲区末尾列首填充符
set fillchars+=fold:<           #!< 折叠文本行尾填充符
set fillchars+=foldclose:      #!< 折叠块关闭时块首的列首填充符
set fillchars+=foldopen:╭       #!< 折叠块打开时块首的列首填充符
set fillchars+=foldsep:│        #!< 折叠块区域内的列首填充符
#@}
#@{[折叠设置]
set foldenable                  #!< 默认启用折叠
set foldclose=all               #!< 允许离开折叠块后自动折叠
set foldlevelstart=1            #!< 编辑新的缓冲区时重置窗口的 &foldlevel 为 1
set foldlevel=1                 #!< 默认折叠 1 级深度以上的折叠块
set foldcolumn=1                #!< 设置侧边栏用于显示折叠状态的宽度
set foldmethod=marker           #!< 设置折叠模式为 marker （使用 &foldmarker 折叠）
set foldmarker=@{,@}            #!< 设置 marker 折叠模式的标志符
#@}
#@{[文件编码设置]
set fileencodings=              #!< 重置可选的文件编码
set fileencodings+=utf-8        #!< 将utf-8 编码纳入考虑
set fileencodings+=gbk          #!< 将gbk 编码纳入考虑
set fileencodings+=gb2312       #!< 将gb2312 编码纳入考虑
set fileencodings+=gb18030      #!< 将gb18030 编码纳入考虑
set fileencodings+=cp936        #!< 将cp936 编码纳入考虑
set encoding=utf-8              #!< 设置 utf-8 为默认编码
set nobomb                      #!< 禁用 Unicode 签名
#@}
#@{[交互设置]
#! 设置光标样式
if has('cursorshape') && &term =~ "xterm"
    &t_SI = "\e[5 q"            #!< INSERT: 竖线（闪烁）
    &t_SR = "\e[4 q"            #!< REPLACE: 下划线（不闪烁）
    &t_EI = "\e[2 q"            #!< ELSE: 方块（不闪烁）
endif

#! 设置 GUI 界面字体
set guifont=Source_Code_Pro_for_Powerline:h12:cANSI

#! 对 Normal/Insert/Visible/Terminal 模式启用鼠标
if has('mouse') | set mouse=nvi | endif

#! 启用按键等待超时机制
#! NOTE: 这玩意不太好说清楚，可以简单理解为你需要多长时间来等待
#> 触发一个完整的按键序列详情见帮助文档
set timeout
set ttimeout
set timeoutlen=1000
set ttimeoutlen=100

#! 实时定位搜索结果
if has('reltime') | set incsearch | endif
#@}
#@{[其他设置]
language en_US.utf8             #!< 设置默认语言为英文
set autoread                    #!< 文件在外部被修改时自动重新加载
set history=256                 #!< 保留 256 条历史命令历史记录
set textwidth=64                #!< 设置插入文本的最大宽度（软性限制）
set ambiwidth=single            #!< 对有歧义的字符编码统一使用单字宽
set scrolloff=0                 #!< 设置保留在光标上下两端的最小行数（当行数足够时）
set winminheight=0              #!< 设置窗口最小高度为 0 （不包括状态栏）
set winminwidth=0               #!< 设置窗口最小宽度为 0 （不包括分隔栏）
#@}
#@{[类型检测设置]
filetype on                     #!< 启用文件类型检测
filetype indent on              #!< 自动检测并加载当前文件类型的
filetype plugin on              #!< 自动检测并加载当前文件类型的插件
syntax on                       #!< 启用语法高亮
#@}
