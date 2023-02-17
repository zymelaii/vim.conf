vim9script

#! vimrc 根目录
if !exists('g:VIMRC_HOME')
    const g:VIMRC_HOME = expand('%:p:h')
endif

#! 骑上我心爱的小毛驴~
colorscheme spring

#! 待加载的脚本
const scripts: list<string> = [
    'config/mappings.vim',
    'config/scheme.vim',
    'config/autocmd.vim',
]

#! 载入配置
for script in scripts
    silent! execute 'source ' .. g:VIMRC_HOME .. '/' .. script
endfor

#! FZF 配置
noremap <C-K>O <ScriptCmd>:FZF<CR>
inoremap <C-K>O <ScriptCmd>:FZF<CR>

#@{[Netrw 配置]
#! netrw 窗口配置
g:netrw_banner = false  #!< 隐藏顶端横幅
g:netrw_liststyle = 3   #!< 设置浏览器样式为树形
g:netrw_winsize = 18    #!< 设置浏览器宽度为 18% 屏幕宽度
#! 重载 netrw 状态栏
import './colors/spring.d/statusbar.vim' as springstl
def NetrwGetStatusLine(): string
    const filetype: string = g:statusline_winid->winbufnr()->getbufvar('&filetype')
    if filetype != 'netrw' | return '' | endif
    #! NOTE: 在非当前窗口使用 %N* 会有奇怪的 bug
    return "%#User6#\u258c%<Filesystem Explorer%= %-2(\uebdf%)"
enddef
def NetrwGetPreviousWindowStatusLine(): string
    const filetype: string = bufnr()->getbufvar('&filetype')
    const winId: number = winnr('#')->win_getid()
    if filetype != 'netrw' | return '' | endif
    if winId != g:statusline_winid | return '' | endif
    const bar = springstl.GetStatusBarFormatString(0)
    return bar
enddef
if g:spring_StatusLineOverrides->index(NetrwGetStatusLine) == -1
    g:spring_StatusLineOverrides->add(NetrwGetStatusLine)
endif
if g:spring_StatusLineOverrides->index(NetrwGetPreviousWindowStatusLine) == -1
    g:spring_StatusLineOverrides->add(NetrwGetPreviousWindowStatusLine)
endif
#@}

#! winsubl 配置
g:WinSublSwitchFilter = (winId: number): bool => {
    const bufType: string = winId->winbufnr()->getbufvar('&buftype')
    const fileType: string = winId->winbufnr()->getbufvar('&filetype')
    return ['terminal', 'quickfix', 'popup']->index(bufType) != -1
        || fileType =~ 'netrw'
}

#! 插件配置
plug#begin(g:VIMRC_HOME .. '/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
plug#end()
