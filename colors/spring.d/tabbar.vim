vim9script

export def TabBarMakeFullPathComponent(path: string): string
    if path->empty() | return '' | endif
    if path->findfile()->empty()
        highlight link TabBarPathItem SpringTabBarPathItemNe
        highlight link TabBarPathSep SpringTabBarPathSepNe
        highlight link TabBarPathEnd SpringTabBarPathEndNe
    else
        highlight link TabBarPathItem SpringTabBarPathItem
        highlight link TabBarPathSep SpringTabBarPathSep
        highlight link TabBarPathEnd SpringTabBarPathEnd
    endif
    const actualPath: string = path->substitute('\', '/', 'g')
    const homePathRegex: string = $HOME->escape('\')
    const dirs: list<string> = actualPath->substitute(homePathRegex, '~', '')->split('/')
    var prompt: string = ''
    prompt ..= '%#TabBarPathItem#'
    prompt ..= ' '
    for i in range(0, dirs->len() - 2)
        prompt ..= '%#TabBarPathItem#'
        prompt ..= (dirs[i] == '~' ? "%-2(\ueb06%)" : dirs[i])
        prompt ..= '%#TabBarPathSep#'
        prompt ..= " \uf460 "
    endfor
    prompt ..= '%#TabBarPathItem#'
    prompt ..= dirs[-1]
    prompt ..= '%#TabBarPathEnd#'
    prompt ..= "\ue0b0"
    prompt ..= '%#TabLineFill#'
    return prompt
enddef

export def GetTabBarFormatString(): string
    highlight SpringTabBarPathItemNe cterm=italic ctermfg=16 ctermbg=184 gui=italic guifg=#000000 guibg=#d7d700
    highlight SpringTabBarPathSepNe cterm=NONE ctermfg=243 ctermbg=184 gui=NONE guifg=#767676 guibg=#d7d700
    highlight SpringTabBarPathEndNe cterm=NONE ctermfg=184 ctermbg=235 gui=NONE guifg=#d7d700 guibg=#262626

    highlight SpringTabBarPathItem cterm=italic ctermfg=15 ctermbg=99 gui=italic guifg=#ffffff guibg=#875fff
    highlight SpringTabBarPathSep cterm=NONE ctermfg=157 ctermbg=99 gui=NONE guibg=#afffaf guibg=#875fff
    highlight SpringTabBarPathEnd cterm=NONE ctermfg=99 ctermbg=235 gui=NONE guifg=#875fff guibg=#262626

    highlight SpringTabBar cterm=NONE ctermfg=99 ctermbg=235 gui=NONE guifg=#afffaf guibg=#262626
    highlight SpringTabBarEmphasis cterm=bold,italic,underline ctermfg=99 ctermbg=235 gui=bold,italic,underline guifg=#afffaf guibg=#262626

    #! 只有一个时启用聚焦模式
    if tabpagenr('$') == 1
        return TabBarMakeFullPathComponent(expand('%:p'))
    endif

    var bar: string = '%#TabLineFill#'
    for tabNr in range(1, tabpagenr('$'))
        if tabNr == tabpagenr()
            bar ..= '%#TabLineSel#'
        else
            bar ..= '%#TabLine#'
        endif
        var bufferName: string = tabNr
            ->tabpagewinnr()
            ->win_getid(tabNr)
            ->winbufnr()
            ->bufname()
        if bufferName->empty()
            bufferName = '[Anonymous]'
        endif
        bar ..= '%' .. tabNr .. 'T ' .. bufferName->fnamemodify(':t')
        bar ..= ' %' .. tabNr .. "X\uea76%X "
    endfor
    bar ..= '%T%#TabLineFill#%='
    return bar
enddef

