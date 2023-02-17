vim9script

#@{[Brief Intro]
#!  Name:           Spring
#!  Description:    A colorscheme desigend for terminal Vim
#!  Author:         zymelaii <nes_ariky@outlook.com>
#!  Maintainer:     zymelaii <nes_ariky@outlook.com>
#!  Website:        https://www.github.com/zymelaii
#!  License:        <none>
#!  Last Updated:   2023 Feb 2
#!
#!  Spring 是我手把手调教的主题。
#!  这么名字是我乱取的，之后肯定还会改。
#!  最后，该主题是专门为终端环境设计的，
#!  也就是说 GUI 部分的配置基本是一点都没有！
#!  - 2023-01-30 Mon 03:22 AM
#!
#!  ↑↑↑ 以上内容纯属放屁
#!  因为我发现 Vim 编译时带上 +termguicolors 后只要终端支持就基
#!  本能用 24 位色了，所以能有真彩色为什么我要跟 xTerm 256 色斗
#!  智斗勇呢？我又不需要去兼容那些老旧的辣鸡终端！
#!  （摊牌了，其实是因为 xTerm 256 Colors 的颜色编号对应哪个颜
#!  色对我来说太不直观了）
#!  - 2023-01-31 Tue 10:06 PM
#!
#!  当然 256 色还是支持的！
#!  - 2023-01-31 Tue 10:08 PM
#!
#!  把地给挪了挪，全都整合放到 spring.d 目录下，更方便管理了。
#!  - 2023-02-01 Wed 03:43 PM
#@}

#@{[兼容性检查]
#! 不会吧不会吧不会真的有人 Vim 没有 eval 特性吧？
if !has('eval') | finish | endif

#! 终端不支持 256 色及以上就别用啦！
const fulfilled: bool = str2nr(&t_Co) >= 256
    || has('termguicolors')
    || has('gui_running')
if !fulfilled | finish | endif

#! 以 "evim" 模式启动时禁用配置
if v:progname =~? "evim" | finish | endif

#! 禁用对 Vi 的兼容
if &compatible | set nocompatible | endif
#@}

#@{[应用配置]
const SchemePath: string = fnamemodify(resolve(expand('<sfile>:p')), ':h') .. '/spring.d'
execute 'source ' .. SchemePath .. '/config.vim'
#@}

#@{[折叠文本配置]
import SchemePath .. '/textfolding.vim' as textfolding
const SpringGetFoldText: func(): string = textfolding.GetFoldedTextInlineSummary
set foldtext=SpringGetFoldText()
#@}

#@{[标签栏配置]
import SchemePath .. '/tabbar.vim' as tabbar
g:SpringGetTabLine = tabbar.GetTabBarFormatString
set tabline=%!SpringGetTabLine()
#@}

#@{[状态栏配置]
import SchemePath .. '/statusbar.vim' as statusbar
g:SpringGetStatusLine = statusbar.GetStatusBarFormatString
set statusline=%!SpringGetStatusLine()
#@}

#@{[高亮配置]
#! 选择主题
const ThemeScript: string = SchemePath .. '/' .. (
    &background == 'dark' ? 'dark-theme.vim' : 'light-theme.vim')

#! 导入主题
import ThemeScript as theme

#! 清除高亮
highlight clear

#! 重置语法高亮
if exists('syntax_on') | syntax reset | endif

#! 加载高亮
for group in theme.SpringColors->keys()
    const colorstyles: dict<list<string>> = theme.SpringColors[group]
    const values: string = colorstyles->keys()->mapnew(
        (index: number, target: string): string => {
            const styles: list<string> = colorstyles[target]
            return ['', 'fg', 'bg']->mapnew(
                (i: number, e: string): string => {
                    return target .. e .. '=' .. (
                        styles[i]->empty() ? 'NONE' : styles[i])
                })->join(' ')
        })->join(' ')
    execute 'highlight ' .. group .. ' term=NONE ' .. values
endfor

g:colors_name = 'spring'
#@}
