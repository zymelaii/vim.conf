vim9script

#@{删除至行首
#> NOTE: 不包含选中项
#> NOTICE: 若当前位于行首，则退格至上一行
export def DeleteAllBefore(): void
    if col('.') == 1
        feedkeys("\<BS>", 'n')
    else
        const column: number = getcharpos('.')[2]
        execute ':.s/^.\{' .. (column - 1) .. '}//'
    endif
enddef
#@}

#@{删除至行尾
#> NOTE: 包含选中项
#> NOTICE: 若当前位于行尾，则删除行末换行符
export def DeleteAllAfter(): void
    const column: number = col('.')
    const length: number = len(getline('.'))
    if column > length
        feedkeys("\<Del>", 'n')
    else
        feedkeys("\<C-o>D", 'n')
    endif
enddef
#@}

#@{保存文件
export def SaveFile(): bool
    # 拒绝保存只读缓冲区内容
    if &readonly | return false | endif

    # 非匿名缓冲区直接写入
    const anonymous: bool = bufname()->empty()
    if !anonymous
        write
        return true
    endif

    # 获取保存的文件名
    var filename: string = inputdialog('Save as: ', '', "\e")

    # 保存操作被取消
    const cancelled: bool = filename == "\e"
    if cancelled
        echo "Operation has been cancelled"
        return false
    endif

    # 确认是否覆写已存在文件
    if !findfile(filename, '.', 1)->empty()
        const choice: string = inputdialog(
            'Overwrite "' .. filename .. '"? (yes/no) ')->trim()
        if choice->empty() || !(choice[0] ==? 'y')
            echo "Operatoion has been cancelled"
            return false
        endif
    endif

    # 保存文件
    execute 'save! ' .. filename
    return true
enddef
#@}
