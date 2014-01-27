"===========================================================================
" Script Title: VimIM: vim build-in IME UI, next generation.
" Description:  VimIM allows you to input Chinese/Japanese into vim
"               *WITHOUT* a traditional input method, based on the
"               Omni completion introduced from version 7.
"               Copyright (C) 2013-2014 LiTuX, all wrongs reserved.
" Author:       LiTuX <suxpert AT gmail DOT com>
" Last Change:  2014-01-27 18:01:02
" Version:      0.0.0
"
" Install:      unpack all into your plugin folder, that's all.
"               If you are using "vundle" or "vim-addons-manager",
"               see README at "https://github.com/suxpert/VimIM".
"
" Usage:        TODO
"
" Changes:
"       0.0.1:  TODO
"===========================================================================

if has('g:vimim_loaded')
    " finish
endif

scriptencoding utf8
let g:vimim_digit_single = {
\   'simplified':  ['〇一二三四五六七八九', '零壹贰叁肆伍陆柒捌玖'],
\   'traditional': ['〇一二三四五六七八九', '零壹貳叄肆伍陸柒捌玖'],
\ }
let g:vimim_digit_more = ['〇零零', '一壹弌', '二贰弍貳', '三叁弎參', '四肆', ]
let g:vimim_digit_separator = {
\   'simplified':  ['十百千', '拾佰仟'],
\   'traditional': ['十百千', '拾佰仟']
\ }
let g:vimim_digit_group = {
\   'simplified':  ['万亿', '万亿'],
\   'traditional': ['萬億', '萬億']
\ }
scriptencoding

" convert a 'integer' string to Chinese number,
" e.g., 5704310 => 五百七十万四千三百一十
function vimim#n2CNumber( num )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif
    let result = ''
    let length = len(a:num)
    let digitListL = split(g:vimim_digit_single.simplified[0], '\zs')
    for i in range(length, 1, -1)
        let group = (i-1)/4
        let position = (i-1)%4
    endfor
    return
endfunction

" covert a 'integer' string to Chinese digit,
" e.g., 5704310 => 五七〇四三一〇
function vimim#n2CDigits( num )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif
    let result = ['', '']
    let digitListL = split(g:vimim_digit_single.simplified[0], '\zs')
    let digitListU = split(g:vimim_digit_single.simplified[1], '\zs')
    for i in split(a:num, '\zs')
        let result[0] .= digitListL[char2nr(i)-char2nr(0)]
        let result[1] .= digitListU[char2nr(i)-char2nr(0)]
    endfor
    return result
endfunction

" test result: from excel
" 一亿二千三百四十五	壹亿贰仟叁佰肆拾伍	一億二千三百四十五	壹億貳仟參佰肆拾伍
" 一亿○三百四十五	壹亿零叁佰肆拾伍	一億○三百四十五	壹億零參佰肆拾伍
" 一千万○二百三十四	壹仟万零贰佰叁拾肆	一千萬○二百三十四	壹仟萬零貳佰參拾肆
" 一千万二千三百四十五	壹仟万贰仟叁佰肆拾伍	一千萬二千三百四十五	壹仟萬貳仟參佰肆拾伍
" 一百万○二百三十四	壹佰万零贰佰叁拾肆	一百萬○二百三十四	壹佰萬零貳佰參拾肆
" 一百万一千二百三十四	壹佰万壹仟贰佰叁拾肆	一百萬一千二百三十四	壹佰萬壹仟貳佰參拾肆
" 一十万○三百四十五	壹拾万零叁佰肆拾伍	一十萬○三百四十五	壹拾萬零參佰肆拾伍
" 一十万二千三百四十五	壹拾万贰仟叁佰肆拾伍	一十萬二千三百四十五	壹拾萬貳仟參佰肆拾伍
" 一万○三百四十五	壹万零叁佰肆拾伍	一萬○三百四十五	壹萬零參佰肆拾伍


" This VimIM use a Register-Enable management for IMEs and Addons,
" where IME means to transform a string matched by a RegExp,
" while for an Addon, the string should starting with a 'Leader'.
" For example, IME 'GooglePYOL' could take strings [a-hj-tw-z][a-z']*,
" and an Addon 'ChineseNum' takes [1-9][0-9]* starting with an 'i'.

" string with 'RegExp' type will be transformed by the function 'Func',
" aliased as 'IME', if is enabled.
" Every IME must be registered first, then can be actived or used.
function! vimim#RegisterIME( IME, RegExp, Func )
    return
endfunction

" string starting with 'Leader' with 'RegExp' type will be transformed
" by the function 'Func', aliased as 'Addon', if is enabled.
" Every Addon must be registered first, then can be actived or used.
function! vimim#RegisterAddon( Addon, Leader, RegExp, Func )
    return
endfunction




