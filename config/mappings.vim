vim9script

import './textedit.vim' as te

#@{文本操作
#! 删除至行首
inoremap <C-u> <ScriptCmd>te.DeleteAllBefore()<CR>
#! 删除至行尾
inoremap <C-k><C-k> <ScriptCmd>te.DeleteAllAfter()<CR>
#! 撤销
nnoremap <C-z> u
inoremap <C-z> <C-o>u
#! 重做
inoremap <C-r> <C-o><C-r>
#! 当前行上移
inoremap <C-S-Up> <C-o>:move -2<CR>
#! 当前行下移
inoremap <C-S-Down> <C-o>:move +1<CR>
#@{括号补全
#! ( ... )
inoremap <Char-40> <Char-40><Char-41><Left>
#! [ ... ]
inoremap <Char-91> <Char-91><Char-93><Left>
#! { ... }
inoremap <Char-123> <Char-123><Char-125><Left>
#@}
#@{文件操作
#! 保存文件
noremap <C-s> <ScriptCmd>te.SaveFile()<CR>
inoremap <C-s> <ScriptCmd>te.SaveFile()<CR>
#@}

#@{窗口操作
#! 窗口向上滚动
inoremap <C-Up> <C-o><C-y>
noremap <C-Up> <C-y>
nnoremap <C-S-Up> <C-u>
#! 窗口向下滚动
inoremap <C-Down> <C-o><C-e>
noremap <C-Down> <C-e>
nnoremap <C-S-Down> <C-d>
#! 整页滚动后调整至窗口中央
nmap <S-Up> <PageUp>
nmap <S-Down> <PageDown>
noremap <PageUp> <PageUp>zz
noremap <PageDown> <PageDown>zz
#! 垂直分割窗口并移动焦点到新窗口
nnoremap <C-k><Bar> :vsplit<CR><C-w><Right>
#! 水平分割窗口并移动焦点到新窗口
nnoremap <C-k><Char-45> :split<CR><C-w><Down>
#@}

#! 切换文件浏览器侧边栏
noremap <C-k><C-b> :Lexplore<CR>
inoremap <C-k><C-b> <C-o>:Lexplore<CR>

#! 匹配括号跳转
noremap <C-k><C-m> %
inoremap <C-k><C-m> <C-o>%

#! 调出自动补全
inoremap <C-k><C-i> <C-n><C-p>

#! 允许分号进入命令模式
noremap <Char-59> <Char-58>

#@{拓展命令
#! 打印当前文件的绝对路径
inoremap <expr> <C-p>absp expand('%:p')
#! 打印当前时间
inoremap <expr> <C-p>tm strftime("%Y-%m-%d %a %I:%M %p")
#@}

#@{禁用按键列表
#! 上一项自动补全
inoremap <C-p> <Ignore>
#! 终端挂起
noremap <C-z> <Ignore>
#! 跳转到前一个位置
noremap <C-o> <Ignore>
#! 向上滚屏
noremap <C-u> <Ignore>
#! 向下滚屏
noremap <C-d> <Ignore>
#@}
