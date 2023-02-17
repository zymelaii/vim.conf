vim9script

#@{[Brief Intro]
#!  Name:           Spring.dark-theme
#!  Description:    dark theme provided by Spring colorscheme (default)
#!  Author:         zymelaii <nes_ariky@outlook.com>
#!  Maintainer:     zymelaii <nes_ariky@outlook.com>
#!  Website:        https://www.github.com/zymelaii
#!  License:        <none>
#!  Last Updated:   2023 Feb 2
#@}

#@{[颜色配置]
#! 以字典形式配置便于维护
export const SpringColors: dict<dict<list<string>>> = {
    #@{[Normal 默认颜色]
    #! NOTE: 作用于底层颜色
    'Normal': {
        'cterm': ['', '15', '235'],
        'gui': ['', '#ffffff', '#262626'],
    },
    #@}
    #@{[NonText 非文本颜色]
    #! NOTE: 用于显示非文本内容的字符颜色
    'NonText': {
       'cterm': ['bold', '12', ''],
       'gui': ['bold', '#00afff', ''],
    },
    #@}
    #@{[SpecialKey 特殊键码]
    #! NOTE: 包括特殊键码与不可打印字符
    'SpecialKey': {
        'cterm': ['bold', '87', ''],
        'gui': ['bold', '#5fffff', ''],
    },
    #@}
    #@{[EndOfBuffer 缓冲区末尾]
    #! NOTE: 作用于整个区域而不仅仅是列首 eob 填充符
    #! NOTE: 与 NonText 保持一致
    'EndOfBuffer': {
        'cterm': ['bold', '12', ''],
        'gui': ['bold', '#00afff', ''],
    },
    #@}
    #@{[Conceal 隐藏字符];
    #! NOTE: 这玩意是个賊牛逼的东西，能根据设定的语法替换字符，
    #> 但我还没配置
    'Conceal': {
        'cterm': ['', '7', ''],
        'gui': ['', '#c0c0c0', ''],
    },
    #@}
    #@{[VertSplit 垂直分割线]
    'VertSplit': {
        'cterm': ['', '237', ''],
        'gui': ['', '#3a3a3a', ''],
    },
    #@}
    #@{[LineNr 行号栏]
    'LineNr': {
        'cterm': ['', '184', ''],
        'gui': ['', '#d7d700', ''],
    },
    #@}
    #@{[LineNrAbove 光标所在行以上的行号栏]
    #! NOTE: 仅当使用相对行号时生效
    #! NOTE: 与 LineNr 保持一致
    'LineNrAbove': {
        'cterm': ['', '184', ''],
        'gui': ['', '#d7d700', ''],
    },
    #@}
    #@{[LineNrBelow 光标所在行以下的行号栏]
    #! NOTE: 仅当使用相对行号时生效
    #! NOTE: 与 LineNr 保持一致
    'LineNrBelow': {
        'cterm': ['', '184', ''],
        'gui': ['', '#d7d700', ''],
    },
    #@}
    #@{[ColorColumn 颜色列]
    #! NOTE: 由 &colorcolumn 指定颜色列
    #! NOTE: 优先级低于 ColorLine
    'ColorColumn': {
        'cterm': ['', '', '196'],
        'gui': ['', '', '#ff0000'],
    },
    #@}
    #@{[Folded 折叠块]
    #! NOTE: 折叠块关闭时的显示行
    'Folded': {
        'cterm': ['italic,bold', '227', ''],
        'gui': ['italic,bold', '#ffff5f', ''],
    },
    #@}
    #@{[FoldColumn 折叠信息栏]
    #! NOTE: 由 &foldcolumn 指定折叠信息栏的宽度
    'FoldColumn': {
        'cterm': ['', '167', ''],
        'gui': ['', '#d75f5f', ''],
    },
    #@}
    #@{[SignColumn 标志栏]
    #! NOTE: 这玩意也贼牛逼
    #! NOTE: 该栏在行号栏左侧，折叠信息栏右侧
    #! NOTE: 当 &signcolumn 为 number 时，标志将替换行号且使用
    #> 行号栏的高亮，若行号栏不存在则不显示
    #! NOTE: 标志可以独立配置自己的高亮
    #! NOTE: 因为它太牛逼所以我也没有配
    'SignColumn': {
        'cterm': ['', '', ''],
        'gui': ['', '', ''],
    },
    #@}
    #@{[CursorColumn 光标所在列]
    #! TODO: 就讲究一个没有存在感
    'CursorColumn': {
        'cterm': ['', '', '236'],
        'gui': ['', '', '#303030'],
    },
    #@}
    #@{[CursorLine 光标所在行]
    'CursorLine': {
        'cterm': ['', '', '237'],
        'gui': ['', '', '#3a3a3a'],
    },
    #@}
    #@{[CursorLineNr 光标所在行的行号栏]
    'CursorLineNr': {
        'cterm': ['bold', '15', '160'],
        'gui': ['bold', '#ffffff', '#d70000'],
    },
    #@}
    #@{[CursorLineFold 光标所在行的折叠信息栏]
    #! NOTE: 当折叠块关闭时使用 CursorLine
    #! NOTE: 默认与 FoldColumn 保持一致
    'CursorLineFold': {
        'cterm': ['', '167', ''],
        'gui': ['', '#d75f5f', ''],
    },
    #@}
    #@{[StatusLine 当前窗口的状态栏]
    #! NOTE: 垂直分割线的下方有一个属于其左下方窗口状态栏的空白
    #! NOTE: 若高亮为空则填充 stl 到状态栏空白处（即左对齐项与
    #> 右对齐文本之间的剩余部分）
    'StatusLine': {
        'cterm': ['', '195', '236'],
        'gui': ['', '#d7ffff', '#303030'],
    },
    #@}
    #@{[StatusLineNC 非当前窗口的状态栏]
    #! NOTE: 垂直分割线的下方有一个属于其左下方窗口状态栏的空白
    #! NOTE: 若高亮为空则填充 stlnc 到状态栏空白处（即左对齐项
    #> 与右对齐文本之间的剩余部分）
    #! NOTE: 若与 StatusLine 相同，则会强制填充 stl 到当前活动
    #> 窗口的状态栏
    'StatusLineNC': {
        'cterm': ['bold', '6', '236'],
        'gui': ['bold', '#209a7e', '#303030'],
    },
    #@}
    #@{[StatusLineTerm 当前终端窗口的状态栏]
    #@}
    #@{[StatusLineTermNC 非当前终端窗口的状态栏]
    #@}
    #@{[TabLine 标签栏未选中标签]
    #@}
    #@{[TabLineSel 标签栏选中标签]
    #@}
    #@{[TabLineFill 标签栏填充段]
    'TabLineFill': {
        'cterm': ['', '235', '235'],
        'gui': ['', '#262626', '#262626'],
    },
    #@}
    #@{[MatchParen 配对的括号]
    'MatchParen': {
        'cterm': ['bold,underline', '12', ''],
        'gui': ['bold,underline', '#00afff', ''],
    },
    #@}
    #@{[User1]
    'User1': {
        'cterm': ['bold', '16', '51'],
        'gui': ['bold', '#000000', '#00ffff'],
    },
    #@}
    #@{[User2]
    'User2': {
        'cterm': ['', '51', '236'],
        'gui': ['', '#00ffff', '#303030'],
    },
    #@}
    #@{[User3]
    'User3': {
        'cterm': ['', '1', '236'],
        'gui': ['', '#ff0000', '#303030'],
    },
    #@}
    #@{[User4]
    'User4': {
        'cterm': ['bold', '15', '1'],
        'gui': ['bold', '#ffffff', '#ff0000'],
    },
    #@}
    #@{[User5]
    'User5': {
        'cterm': ['', '154', '1'],
        'gui': ['', '#afff00', '#ff0000'],
    },
    #@}
    #@{[User6]
    'User6': {
        'cterm': ['bold,italic', '88', '154'],
        'gui': ['bold,italic', '#870000', '#afff00'],
    },
    #@}
    #@{[User7]
    'User7': {
        'cterm': ['', '88', '236'],
        'gui': ['', '#870000', '#303030'],
    },
    #@}
    #@{[User8]
    'User8': {
        'cterm': ['', '1', '15'],
        'gui': ['', '#ff0000', '#ffffff'],
    },
    #@}
    #@{[User9]
    'User9': {
        'cterm': ['', '', ''],
        'gui': ['', '', ''],
    },
    #@}
}
#@}
