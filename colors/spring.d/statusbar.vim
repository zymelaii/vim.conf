vim9script

#! NOTE: 请务必使用 Nerd Font
#! NOTE: 推荐使用 Source Code Pro for Powerline 字体

#! 可选的状态栏重载，返回空时使用默认状态栏
#! NOTE: typename(spring_StatusLineOverrides) = 'func(): string'
if !exists('g:spring_StatusLineOverrides')
    g:spring_StatusLineOverrides = []
endif

#@{[获取模式字符串]
export def GetModeString(): string
    const modeTable: dict<string> = {
        '^n$': 'Normal',
        '^no.*$': 'Normal│Pending',
        '^niI$': 'Normal│Insert',
        '^niR$': 'Normal│Replace',
        '^niV$': 'Normal│VReplace',
        '^s$': 'Select',
        '^S$': 'Select│Line',
        "\x16": 'Visible│Block',
        '^i$': 'Insert',
        '^i\(c\|x\)$': 'Insert│Complete',
        '^R$': 'Replace',
        '^R\(c\|x\)$': 'Replace│Complete',
        '^Rv$': 'VReplace',
        '^Rv\(c\|x\)$': 'VReplace│Complete',
        '^vs\?$': 'Visible',
        '^Vs\?$': 'Visible│Line',
        "\x13": 'Select│Block',
        '^c\(v\|e\)\?$': 'Command',
        '^n\?t$': 'Terminal'
    }
    const mode: string = mode(true)
    const resp: dict<string> = filter(modeTable->copy(),
        (key: string, value: string): bool => {
            if char2nr(mode) <= 32
                return mode[0] == key[0]
            else
                return match(mode, key) == 0
            endif
        })
    return resp->empty() ? 'Unknown' : resp->values()[0]
enddef
#@}

#@{[获取状态栏]
#   \param DesiredFormat: 期待的状态栏格式，当为 -1 时自动选择
export def GetStatusBarFormatString(DesiredFormat: number = -1): string
    var format: number = DesiredFormat
    if DesiredFormat == -1
        for GetOverride in g:spring_StatusLineOverrides
            const bar = GetOverride()
            if !bar->empty() | return bar | endif
        endfor

        if g:statusline_winid == win_getid()
            format = 0
        else
            format = 1
        endif
    endif

    const bufNr: number = g:statusline_winid->winbufnr()
    const modifiable: bool = bufNr->getbufvar('&modifiable')
    const readonly: bool = bufNr->getbufvar('&readonly')
    const modified: bool = bufNr->getbufvar('&modified')
    const filetype: string = bufNr->getbufvar('&filetype')
    const encoding: string = bufNr->getbufvar('&encoding')->toupper()
    const wordcount: dict<number> = wordcount()

    var state: string = ''
    if !modifiable
        state = '[-]'
    elseif readonly
        state = '[RO]'
    elseif modified
        state = '[+]'
    endif

    var bar: string = ''
    if format == 0
        bar ..= '%#User1#'
        bar ..= ' ' .. GetModeString() .. ' '
        bar ..= '%#User2#'
        bar ..= "\ue0b0"
        bar ..= '%#StatusLine#'
        if !state->empty()
            bar ..= ' ' .. state
        endif
        bar ..= ' %t'
        bar ..= '%='
        bar ..= ' %<'
        if g:statusline_winid == win_getid()
            bar ..= '%#StatusLineNC#'
            bar ..= ' ' .. wordcount.words .. ' words'
            if wordcount.bytes < 2000
                bar ..= ' ' .. wordcount.bytes .. 'B'
            elseif wordcount.bytes < 2048000
                bar ..= ' ~ ' .. printf('%.2f', wordcount.bytes / 2000.0) .. 'KB'
            else
                bar ..= ' ~ ' .. printf('%.2f', wordcount.bytes / 2048000.0) .. 'MiB'
            endif
        endif
        bar ..= '%#StatusLine#'
        bar ..= ' <U+%04B>'
        bar ..= " \ue0b2"
        bar ..= '%#User8#'
        bar ..= "\ue0b2"
        bar ..= '%#User4#'
        if !filetype->empty()
            bar ..= ' ' .. filetype
            bar ..= " \ue0b3"
        endif
        bar ..= ' ' .. encoding .. ' '
        bar ..= '%#User5#'
        bar ..= "\ue0b2"
        bar ..= '%#User6#'
        bar ..= '%3p%%'
        bar ..= '%#User5#'
        bar ..= "\ue0b0"
        bar ..= '%#User4#'
        bar ..= ' w' .. g:statusline_winid->win_id2win() .. 'b' .. g:statusline_winid->winbufnr()
    elseif format == 1
        bar ..= '%<'
        bar ..= '%#User7#'
        bar ..= "\u258c"
        bar ..= '%#StatusLineNC#'
        if !state->empty()
            bar ..= ' ' .. state
        endif
        bar ..= ' %t'
        bar ..= '%='
        bar ..= 'W' .. g:statusline_winid .. 'b' .. g:statusline_winid->winbufnr()
    endif
    return bar
enddef
#@}
