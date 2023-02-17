vim9script

def g:GetModeString(): string
    var modeTable: dict<string> = {
        '^n$': "Normal",
        '^no.*$': "Normal│Pending",
        '^niI$': "Normal│Insert",
        '^niR$': "Normal│Replace",
        '^niV$': "Normal│VReplace",
        '^s$': "Select",
        '^S$': "Select│Line",
        "\x16": "Visible│Block",
        '^i$': "Insert",
        '^i\(c\|x\)$': "Insert│Complete",
        '^R$': "Replace",
        '^R\(c\|x\)$': "Replace│Complete",
        '^Rv$': "VReplace",
        '^Rv\(c\|x\)$': "VReplace│Complete",
        '^vs\?$': "Visible",
        '^Vs\?$': "Visible│Line",
        "\x13": "Select│Block",
        '^c\(v\|e\)\?$': "Command",
        '^n\?t$': "Terminal" }
    const mode: string = mode(1)
    var resp: dict<string> = filter(modeTable,
        (key: string, value: string): bool => {
            if char2nr(mode) <= 32
                return mode[0] == key[0]
            else
                return match(mode, key) == 0
            endif
        })
    return (empty(resp) ? "Unknown" : resp->values()[0])
enddef

export def SetFillChars(option: string, char: string): void
    const optionIndex: number = stridx(&fillchars, "fold")
    var fillCharsOption: string = &fillchars
    if optionIndex != -1
        var others: string = substitute(&fillchars, option .. ':\\\?.,\?', "", "g")
        fillCharsOption = escape(others, '| ')
    endif
    var cmd: string = "set fillchars=" .. option .. ':' .. escape(char, '| ')
    if !empty(fillCharsOption)
        cmd ..= ',' .. fillCharsOption
    endif
    execute cmd
enddef
