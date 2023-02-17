vim9script

#! 清除所有行尾空白
def RemoveTrailingBlanks(): void
    const lastCursorPos: list<number> = getpos('.')
    silent! :%s/\s*$//g
    setpos('.', lastCursorPos)
enddef

#! 常规任务列表
augroup LocalRoutineTasks
    autocmd!
    #! 文件写入前清除行尾空白
    autocmd BufWritePre * RemoveTrailingBlanks()
augroup END

