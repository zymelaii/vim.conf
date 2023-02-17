vim9script noclear

export def GetFoldedTextInlineSummary(): string
    const rawText: string = getline(v:foldstart)
    const markerLeader: string = &foldmarker[0 : stridx(&foldmarker, ',') - 1]
    const leaderWidth: number = len(markerLeader)
    const foldMarkIndex: number = stridx(rawText, markerLeader)

    #! 单词单元
    #> NOTE: 数字/字母/下划线/宽字符的任意组合
    const hintWordPattern: string = '\(\w\|[^\x00-\xff]\)\+'

    #! 折叠文本
    #> NOTE: 从第一个单词单元到最后一个单词单元之间的所有字符
    const hintPattern: string = '\(' .. hintWordPattern .. '\)\@='
        .. '\(.*' .. hintWordPattern ..  '\)'

    #! 获取折叠文本
    #> NOTE: 第一优先级：标记之后由方括号限定的文本
    #> NOTE: 第二优先级：标记之后的折叠文本
    #> NOTE: 第三优先级：标记之前的折叠文本
    #> NOTE: 第四优先级：预设替代文本
    var hint: string = ''
    if foldMarkIndex + leaderWidth < len(rawText)
        const text: string = rawText[foldMarkIndex + leaderWidth : -1]
        hint = matchstr(text, '\[\@<=.*\]\@=')
        if empty(hint)
            hint = matchstr(text, hintPattern)
        endif
    endif
    if empty(hint) && foldMarkIndex > 0
        hint = matchstr(rawText[0 : foldMarkIndex], hintPattern)
    endif
    if empty(hint)
        hint = '[Anonymous]'
    endif

    #! 获取折叠块行数信息
    const rowsIndicate: string = '[' .. (v:foldend - v:foldstart + 1) .. ' lines]'

    #! 计算折叠缩进
    const indent: string = repeat(' ', (v:foldlevel - 1) * &tabstop - 2)

    const components: list<string>  = ['ﲔ' .. indent, hint, '{ ... }', '~', rowsIndicate]
    return join(components, ' ') .. ' '
enddef

set foldtext=GetFoldedTextInlineSummary()
