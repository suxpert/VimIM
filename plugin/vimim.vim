"===========================================================================
" Script Title: VimIM: vim build-in IME UI, next generation.
" Description:  VimIM allows you to input Chinese/Japanese into vim
"               *WITHOUT* a traditional input method, based on the
"               Omni completion introduced from version 7.
"               Copyright (C) 2013-2014 LiTuX, all wrongs reserved.
" Author:       LiTuX <suxpert AT gmail DOT com>
" Last Change:  2014-02-18 00:26:16
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
\   'simplified':  [split('〇一二三四五六七八九零两', '\zs'),
\                   split('零壹贰叁肆伍陆柒捌玖', '\zs')],
\   'traditional': [split('〇一二三四五六七八九零', '\zs'),
\                   split('零壹貳叄肆伍陸柒捌玖', '\zs')],
\ }
let g:vimim_digit_more = ['〇零零', '一壹弌', '二贰弍貳', '三叁弎參', '四肆', ]
let g:vimim_digit_separator = {
\   'simplified':  [split('十百千', '\zs'), split('拾佰仟', '\zs')],
\   'traditional': [split('十百千', '\zs'), split('拾佰仟', '\zs')]
\ }
let g:vimim_digit_group = {
\   'simplified':  [split('万亿', '\zs'), split('万亿', '\zs')],
\   'traditional': [split('萬億', '\zs'), split('萬億', '\zs')]
\ }
scriptencoding

function! vimim#digit(num, upper)
    return g:vimim_digit_single['simplified'][a:upper][str2nr(a:num, 10)]
endfunction

function! vimim#num_digit_2(num, upper, style)
    if len(a:num) != 2          " only deal with two digits.
        return
    endif
    if a:num[0] == '0'
        return vimim#digit(a:num[1], a:upper)
    elseif a:num[0] == '1' && and(a:style, 1) == 0
        let result = ''
    else
        let result = vimim#digit(a:num[0], a:upper)
    endif
    let result .= g:vimim_digit_separator['simplified'][a:upper][0]
    if a:num[1] != '0'
        let result .= vimim#digit(a:num[1], a:upper)
    endif
    return result
endfunction

function! vimim#num_digit_3(num, upper, style)
    if len(a:num) != 3          " only deal with three digits.
        return
    endif
    if a:num[0] == '0'
        return vimim#num_digit_2(a:num[1:2], a:upper, a:style)
    else
        let result = vimim#digit(a:num[0], a:upper)
    endif
    let result .= g:vimim_digit_separator['simplified'][a:upper][1]
    if a:num[1] == '0'
        if a:num[2] != '0'
            let result .= vimim#digit('0', a:upper)
            let result .= vimim#digit(a:num[2], a:upper)
        endif
    else
        let result .= vimim#num_digit_2(a:num[1:2], a:upper, 1)
    endif
    return result
endfunction

function! vimim#num_digit_4(num, upper, style)
    if len(a:num) != 4          " only deal with four digits.
        return
    endif
    if a:num[0] == '0'
        return vimim#num_digit_3(a:num[1:3], a:upper, a:style)
    elseif a:num[0] == '2' && and(a:style, 2) != 0 && a:upper == 0
        let result = g:vimim_digit_single['simplified'][0][10]
    else
        let result = vimim#digit(a:num[0], a:upper)
    endif
    let result .= g:vimim_digit_separator['simplified'][a:upper][2]
    if a:num[1] == '0'
        if str2nr(a:num[2:3]) != 0
            let result .= vimim#digit('0', a:upper)
            let result .= vimim#num_digit_2(a:num[2:3], a:upper, 1)
        endif
    else
        let result .= vimim#num_digit_3(a:num[1:3], a:upper, a:style)
    endif
    return result
endfunction

" convert a 'integer' string to Chinese number,
" e.g., 5704310 => 五百七十万四千三百一十
function! vimim#n2CNumber( num, upper )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif
    let result = ''
    let length = len(a:num)
    if a:num[0] == '0'
    endif
    for i in range(length, 1, -1)
        if a:num[length-i] == '0'
            let lastiszero = 1
            continue
        else
            if lastiszero == 1 && (TODO)
                let result .= vimim#digit('0', a:upper)
            endif
            let group = (i-1)/4
            let position = (i-1)%4
            if a:num[length-i] =~ '[3-9]'
            endif
            let lastiszero = 0
        endif
    endfor
    return
endfunction

" covert a 'integer' string to Chinese digit,
" e.g., 5704310 => 五七〇四三一〇
function! vimim#n2CDigits( num )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif
    let result = ['', '']
    for i in split(a:num, '\zs')
        let result[0] .= vimim#digit(i, 0)
        let result[1] .= vimim#digit(i, 0)
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




