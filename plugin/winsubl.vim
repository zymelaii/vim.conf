vim9script

if exists('g:loaded_winsublPlugin') | finish | endif
const g:loaded_winsublPlugin = 'v1.0.0'

#! 当前是否处于聚焦模式
if !exists('g:winsubl_isFocusMode')
    g:winsubl_isFocusMode = false
endif

#! 退出聚焦模式的复原命令
if !exists('g:winsubl_retoreCommand')
    g:winsubl_retoreCommand = ''
endif

#! 窗口跳转过滤器
if !exists('g:WinSublSwitchFilter')
    g:WinSublSwitchFilter = (winId: number): bool => {
        const bufType: string = winId->winbufnr()->getbufvar('&buftype')
        return ['terminal', 'quickfix', 'popup']->index(bufType) != -1
    }
endif

#@{获取目标窗口的 ID
#!  \param win: 窗口序号或窗口 ID
#!  \return 目标窗口 ID
#!  \retval 目标窗口不存在: 0
#!  \note 不传入参数或 win 为 0 时将返回当前窗口 ID
export def GetWindowID(win: number = 0): number
    if win == 0
        return win_getid(winnr())
    elseif win <= winnr('$')
        return win_getid(win)
    elseif win_gettype(win) =~ 'unknown'
        return 0
    else
        return win
    endif
enddef
#@}

#@{将目标窗口提升至聚焦模式
#!  \param win: 窗口序号或窗口 ID
export def LiftWindowToFocusMode(win: number): void
    const winId: number = GetWindowID(win)
    if g:winsubl_isFocusMode
        execute g:winsubl_restoreCommand
    endif
    g:winsubl_restoreCommand = winrestcmd()

    var cmds: list<string> = []
    for thisNr in range(1, winnr('$'))
        const thisId: number = GetWindowID(thisNr)
        if winId == thisId | continue | endif
        cmds->add('vertical ' .. thisId .. 'resize 0')
        cmds->add('horizontal ' .. thisId .. 'resize 0')
    endfor

    const cmd: string = cmds->join(' | ')
    execute ': ' .. cmd
    g:winsubl_isFocusMode = true
enddef
#@}

#@{退出聚焦模式
#!  \return 是否成功退出
export def QuitFocusMode(): bool
    if !g:winsubl_isFocusMode | return false | endif
    execute g:winsubl_restoreCommand
    g:winsubl_restoreCommand = ''
    g:winsubl_isFocusMode = false
    return true
enddef
#@}

#@{设置窗口持有的缓冲区在该窗口唯一显示
#!  \param win: 目标窗口 ID 或目标窗口序号
#!  \return 移除的窗口数量
#!  \retval 目标窗口不存在: -1
#!> NOTE: 人话：关闭具有相同缓冲区的其他窗口
#!> TODO: 当焦点所在窗口在被移除的窗口时，
#!! 它应该以相同的状态被转移到目标窗口。
export def SetBufferUnique(win: number = 0): number
    const winId: number = GetWindowID(win)
    if winId == 0 | return -1 | endif
    const bufNr: number = winbufnr(winId)

    var targets: list<number> = []
    for nr in range(1, winnr('$'))
        const thisId: number = GetWindowID(nr)
        const thisBufNr: number = winbufnr(thisId)
        if thisId != winId && thisBufNr == bufNr
            targets->add(thisId)
        endif
    endfor

    for targetId in targets
        win_execute(targetId, 'quit!')
    endfor

    if targets->len() == 0
        echo 'Current buffer is already unique'
    else
        echo 'Removed ' .. targets->len() .. ' windows'
    endif

    return targets->len()
enddef
#@}

#@{跳转至下一个可用窗口
export def SwitchToNextAvailableWindow(): bool
    const total: number = winnr('$')
    const thisNr: number = winnr()
    for i in range(1, total - 1)
        const winId: number = win_getid((thisNr + i - 1) % total + 1)
        if !g:WinSublSwitchFilter(winId)
            win_gotoid(winId)
            return true
        endif
    endfor
    return false
enddef
#@}

#! 聚焦到当前窗口
noremap <C-k><C-o>O <ScriptCmd>LiftWindowToFocusMode(winnr())<CR>

#! 退出聚焦状态
noremap <C-k><C-o>o <ScriptCmd>QuitFocusMode()<CR>

#! 当前窗口去重
noremap <C-k><C-o>x <ScriptCmd>SetBufferUnique()<CR>

#! 跳转至下一个可用窗口
noremap <Tab> <ScriptCmd>SwitchToNextAvailableWindow()<CR>
