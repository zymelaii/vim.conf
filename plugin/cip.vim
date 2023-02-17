" vim: set noet fenc=utf-8 ff=unix sts=4 sw=4 ts=4 :
"
" cip.vim completion in-place 
"
" Created by zymelaii on 2023/01/26
" Last Modified: 2023/01/27 00:40
"
" Features:
" 
" - use EnableCIP/DisableCIP to toggle for certain file.
"
" Usage:
"
" let g:cipEnabledFileTypes = {"text": 1}

" global configs
let g:cipEnabledFileTypes = get(g:, "cipEnabledFileTypes", {})	" 启用的文件类型（未使用）
let g:cipEnabledTabSwitch = get(g:, "cipEnabledTabSwitch", 1)	" 允许使用<Tab>切换补全项
let g:cipMinTriggerLength = get(g:, "cipMinTriggerLength", 2)	" 触发补全的最小单词长度
let g:cipCalloutKey = get(g:, "cipCalloutKey", "\<C-N>")		" 呼出补全的按键映射（未使用）
let g:cipIgnoreList = get(g:, "cipIgnoreList", [])				" 忽略的关键字
let g:cipCaseSensitive = get(g:, "cipCaseSensitive", 1)			" 大小写敏感

" tool functions
function! s:getLocalContext()
	return strpart(getline('.'), 0, col('.') - 1)
endfunction

function! s:shouldIgnore(keyword)
	if g:cipCaseSensitive
		for ignored in g:cipIgnoreList
			if a:keyword ==# ignored
				return 1
			endif
		endfor
	else
		for ignored in g:cipIgnoreList
			if a:keyword ==? ignored
			return 1
			endif
		endfor
	endif
	return 0
endfunction

function! s:getKeywordPrefix(context)
	return matchstr(a:context, '\(\k\{' . g:cipMinTriggerLength . ',}\)$')
endfunction
 
function! s:readyToCollectKeyword(context)
	if g:cipMinTriggerLength <= 0
		return 0
	endif
	const resp = s:getKeywordPrefix(a:context)
	if empty(resp)
		return 0
	endif
	return !s:shouldIgnore(resp)
endfunction

function! s:updateStatus()
	let b:cipLastCurPosX = col('.') - 1 
	let b:cipLastCurPosY = line('.') - 1
	let b:cipCurrentTick = b:changedtick
endfunction()

function! s:determineTabKeyMapping()
	if !pumvisible()
		return "\<Tab>"
	endif

	const context = s:getLocalContext()
	const prefix = s:getKeywordPrefix(context)	
	const ci = complete_info()
	const items = ci["items"]
	const totalNumber = len(items)
	const itemsNumber = get(b:, "cipCompletionItemsNumber", -1)
	const expectedNextSelection = (ci["selected"] + 2) % (totalNumber + 1) - 1

	let reachEnd = 1
	if expectedNextSelection != -1
		for i in range(expectedNextSelection, totalNumber - 1)
			if stridx(items[i]["word"], prefix) == 0
				let reachEnd = 0
				break
			endif
		endfor
	endif

	let key = itemsNumber == 1 ? "\<Down>\<C-Y>" : "\<Down>"
	if reachEnd
		let key = "\<Down>" .. key
	endif
	return key
endfunction

" autocmd callbacks
function! s:cipFeedCallout()
	const enabled = get(b:, 'cipEnabled', 0)
	const lastX = get(b:, "cipLastCurPosX", -1)
	const lastY = get(b:, "cipLastCurPosY", -1)
	const tick = get(b:, "cipCurrentTick", -1)

	const x = col('.') - 1
	const y = line('.') - 1

	if !enabled
		return -1
	elseif lastX == x && lastY == y
		return -2
	elseif tick == b:changedtick
		return -3
	endif

	const context = s:getLocalContext()
	const ready = s:readyToCollectKeyword(context)

	if ready == pumvisible()
		return 0
	elseif ready
		silent! call feedkeys("\<C-N>\<C-P>", "n")
		call s:updateStatus()
	else
		silent! call feedkeys("\<C-E>", "n")
	endif
	return 0
endfunction

function! s:cipFinishCompletion()
	let b:cipCompletionItemsNumber = -1
	call s:updateStatus()
endfunction

function! s:cipCompleteChangedCallback()
	let b:cipCompletionItemsNumber = v:event['size']
endfunction

" plugin interface
function! s:cipEnable()
	call s:cipDisable()

	if g:cipEnabledTabSwitch
		inoremap <silent><buffer><expr> <Tab> <SID>determineTabKeyMapping()
	endif

	inoremap <silent><buffer><expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

	augroup cipEventGroup
		autocmd!
		autocmd CursorMovedI <buffer> ++nested call s:cipFeedCallout()
		autocmd CompleteChanged <buffer> call s:cipCompleteChangedCallback()
		autocmd CompleteDone <buffer> call s:cipFinishCompletion()
	augroup END

	setlocal complete=.
	setlocal completeopt=menuone,menu
	let b:cipEnabled = 1
endfunction

function! s:cipDisable()
	augroup cipEventGroup	
		autocmd!
	augroup END

	let b:cipEnabled = 0
endfunction

" export command
command! -nargs=0 EnableCIP call s:cipEnable()
command! -nargs=0 DisableCIP call s:cipDisable()
