"===========================================================================
" Script Title: VimIM: vim build-in IME UI, next generation.
" Description:  VimIM allows you to input Chinese/Japanese into vim
"               *WITHOUT* a traditional input method, based on the
"               Omni completion introduced from version 7.
"               Copyright (C) 2013-2014 LiTuX, all wrongs reserved.
" Author:       LiTuX <suxpert AT gmail DOT com>
" Last Change:  2014-02-18 23:10:42
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

if exists('g:vimim_loaded')
    " finish        " disable for debug
endif
let g:vimim_loaded = 1

if exists('g:vimim_lang')
    " use the user setting, do nothing
elseif v:lang =~ '^zh_TW'
    let g:vimim_lang = 'tw'
elseif v:lang =~ '^zh_HK'
    let g:vimim_lang = 'hk'
elseif v:lang =~ '^zh_MO'
    let g:vimim_lang = 'mo'
elseif v:lang =~ '^zh_SG'
    let g:vimim_lang = 'sg'
elseif v:lang =~ '^ja_JP'
    let g:vimim_lang = 'jp'
elseif v:lang =~ '^ko_KR'
    let g:vimim_lang = 'ko'
else
    let g:vimim_lang = 'cn'             " default
endif

" Number Style Mask, a style can be:
" 0: small (default);
" 1: big;
" 2(3): third (fall back to 0);
" 4: small with extra characters if exists;
" 5: big with extra characters if exists;
" 6: third with extra characters if exists;
let s:NumStyleBig = 1     " true: big style; false: small style;
let s:NumStyleThd = 2     " true: use the third list if exist.
let s:NumStyleExt = 4     " true: use extra characters; false: basic;

scriptencoding utf8
let g:vimim_digit_single = {
\   'cn': [ split('〇一二三四五六七八九零 两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')        ],
\   'hk': [ split('〇一二三四五六七八九零 两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')        ],
\   'mo': [ split('〇一二三四五六七八九零 两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')        ],
\   'tw': [ split('〇一二三四五六七八九零', '\zs'),
\           split('零壹貳叄肆伍陸柒捌玖', '\zs')        ],
\   'sg': [ split('〇一二三四五六七八九零 两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')        ],
\   'jp': [ split('〇一二三四五六七八九零', '\zs'),
\           split('零壱弐参四五六七八九', '\zs')        ],
\   'ko': [ split('〇一二三四五六七八九零', '\zs'),
\           split('零壹貳參四五六柒八九', '\zs'),
\           split('영일이삼사오육칠팔구공', '\zs')      ],
\ }
let g:vimim_digit_separator = {
\   'cn': [ split('十百千', '\zs'), split('拾佰仟', '\zs') ],
\   'hk': [ split('十百千', '\zs'), split('拾佰仟', '\zs') ],
\   'mo': [ split('十百千', '\zs'), split('拾佰仟', '\zs') ],
\   'tw': [ split('十百千', '\zs'), split('拾佰仟', '\zs') ],
\   'sg': [ split('十百千', '\zs'), split('拾佰仟', '\zs') ],
\   'jp': [ split('十百千', '\zs'), split('拾百千', '\zs') ],
\   'ko': [ split('十百千', '\zs'), split('拾佰仟', '\zs'), split('십백천', '\zs') ],
\ }
let g:vimim_digit_group = {
\   'cn': [ split('万亿', '\zs'), split('万亿', '\zs') ],
\   'hk': [ split('万亿', '\zs'), split('万亿', '\zs') ],
\   'mo': [ split('万亿', '\zs'), split('万亿', '\zs') ],
\   'tw': [ split('萬億', '\zs'), split('萬億', '\zs') ],
\   'sg': [ split('万亿', '\zs'), split('万亿', '\zs') ],
\   'jp': [ split('万億兆京垓秭穣溝澗正載極', '\zs'),
\           split('万億兆京垓秭穣溝澗正載極', '\zs')   ],
\   'ko': [ split('万亿兆京垓秭穣沟涧正载极', '\zs'),
\           split('万亿兆京垓秭穣沟涧正载极', '\zs'),
\           split('만억조경해자양구간정재극', '\zs')   ],
\ }
scriptencoding

function! vimim#digit_list(dict, style)
    if and(a:style, s:NumStyleThd)
        let listnr = 2
    else
        let listnr = and(a:style, s:NumStyleBig)
    endif
    if !exists('a:dict[g:vimim_lang]')
        return
    endif

    let uselist = a:dict[g:vimim_lang]
    if !exists('uselist[listnr]')
        let listnr = 0              " default is small
    endif
    return uselist[listnr]
endfunction

function! vimim#digit_single(num, style)
    if (a:num =~ '^\d$')
        let nr = str2nr(a:num)
    elseif a:num >= 0 && a:num <= 9
        let nr = a:num
    else
        return
    endif
    let uselist = vimim#digit_list(g:vimim_digit_single, a:style)

    if and(a:style, s:NumStyleExt) && exists('uselist[nr+10]') && uselist[nr+10] != ' '
        let result = uselist[nr+10]
    else
        let result = uselist[nr]
    endif
    return result
endfunction

function! vimim#digit_separator(pos, style)
    " in this function, style can be s:NumStyleBig or s:NumStyleThd
    " 2, 3, 4 => 10, 100, 1000
    if a:pos > 1 && a:pos < 5
        let pos = a:pos-2           " TODO
    else
        return
    endif
    let uselist = vimim#digit_list(g:vimim_digit_separator, a:style)
    let result = uselist[pos]
    return result
endfunction

function! vimim#digit_group(grp, style)
    " in this function, style can be s:NumStyleBig or s:NumStyleThd
    " 0, 1, 2, 3, ... => NONE, 1e4, 1e8, 1e12, ..
    if a:grp > 0
        let grp = a:grp-1           " TODO
    else
        return
    endif
    let uselist = vimim#digit_list(g:vimim_digit_group, a:style)
    let result = uselist[grp]
    return result
endfunction

function! vimim#num_digit_2(num, upper, style)
    if len(a:num) != 2          " only deal with two digits.
        return
    endif
    if a:num[0] == '0'
        return vimim#digit_single(a:num[1], a:upper)
    elseif a:num[0] == '1' && and(a:style, 1) == 0
        let result = ''
    else
        let result = vimim#digit_single(a:num[0], a:upper)
    endif
    let result .= vimim#digit_separator(2, a:upper)
    if a:num[1] != '0'
        let result .= vimim#digit_single(a:num[1], a:upper)
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
        let result = vimim#digit_single(a:num[0], a:upper)
    endif
    let result .= vimim#digit_separator(3, a:upper)
    if a:num[1] == '0'
        if a:num[2] != '0'
            let result .= vimim#digit_single('0', a:upper+s:NumStyleExt)
            let result .= vimim#digit_single(a:num[2], a:upper)
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
        let result = vimim#digit_single(a:num[0], s:NumStyleExt)
    else
        let result = vimim#digit_single(a:num[0], a:upper)
    endif
    let result .= vimim#digit_separator(4, a:upper)
    if a:num[1] == '0'
        if str2nr(a:num[2:3]) != 0
            let result .= vimim#digit_single('0', a:upper+s:NumStyleExt)
            let result .= vimim#num_digit_2(a:num[2:3], a:upper, 1)
        endif
    else
        let result .= vimim#num_digit_3(a:num[1:3], a:upper, a:style)
    endif
    return result
endfunction

" convert a 'integer' string to Chinese number,
" e.g., 5704310 => 五百七十万四千三百一十
function! vimim#n2CNumber( num, style )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif

    let result = ''

    let start = 1
    let zeros = 0
    let len = strlen(a:num)

    for idx in range(len)
        let pos = (len-idx)%4
        let grp = (len-idx)/4
        if a:num[idx] == '0'
            if start
                if grp==0 && pos==1
                    let result .= '零'
                endif
                continue
            endif
            let zeros += 1
        else
            if zeros>=4 || (zeros>0 && pos!=0)
                let result .= '零'
            endif
            let zeros = 0           " reset zero counter
            if start && pos==2 && a:num[idx]=='1'
                " do nothing, this 1 do not need to converted
            elseif a:num[idx]=='2' && (pos==0 || (start && pos==1 && grp!=0))
                let result .= '两'
            else
                let result .= a:num[idx]
            endif
            let start = 0
        endif

        if a:num[idx]!='0' && pos!=1
            let result .= 'bsq'
        elseif pos==1 && grp!=0
            if zeros>=4
                if grp%2==0
                    let result .= '亿'
                endif
            else
                let result .= 'wy'
            endif
        endif
    endfor

    return result
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


let g:vimim_futlist = []
let g:vimim_futreport = []

function! vimim#ut_add_fun(funame, arglist, fres)
    let g:vimim_futlist = add(g:vimim_futlist, [a:funame, a:arglist, a:fres])
endfunction

function! vimim#assert(funame, arglist, fres)
    let arglen = len(a:arglist)
    let Fref = function(a:funame)
    let report = ''
    try
        if arglen == 0
            let result = Fref()
        elseif arglen == 1
            let result = Fref(a:arglist[0])
        elseif arglen == 2
            let result = Fref(a:arglist[0], a:arglist[1])
        elseif arglen == 3
            let result = Fref(a:arglist[0], a:arglist[1], a:arglist[2])
        elseif arglen == 4
            let result = Fref(a:arglist[0], a:arglist[1], a:arglist[2], a:arglist[3])
        else
            let report = 'Unsupported'
        endif
    catch
        let report = 'Exception'
    finally
        if report == ''
            if result == a:fres
                let report = 'Success('.result.')'
            else
                let report = 'Failed('.result.'[ne]'.a:fres.')'
            endif
        endif
    endtry
    return report
endfunction

function! vimim#fut_prepare()
    let g:vimim_futlist = []
    call vimim#ut_add_fun('vimim#digit_single', [0, 0], '〇')
    call vimim#ut_add_fun('vimim#digit_single', [0, 1], '零')
    call vimim#ut_add_fun('vimim#digit_single', [0, 4], '零')
    call vimim#ut_add_fun('vimim#digit_single', [1, 0], '一')
    call vimim#ut_add_fun('vimim#digit_single', [1, 1], '壹')
    call vimim#ut_add_fun('vimim#digit_single', [1, 4], '一')
    call vimim#ut_add_fun('vimim#digit_single', [2, 0], '二')
    call vimim#ut_add_fun('vimim#digit_single', [2, 1], '贰')
    call vimim#ut_add_fun('vimim#digit_single', [2, 4], '两')
    call vimim#ut_add_fun('vimim#digit_separator', [2, 0], '十')
    call vimim#ut_add_fun('vimim#digit_separator', [3, 0], '百')
    call vimim#ut_add_fun('vimim#digit_separator', [4, 0], '千')
    call vimim#ut_add_fun('vimim#digit_separator', [2, 1], '拾')
    call vimim#ut_add_fun('vimim#digit_separator', [3, 1], '佰')
    call vimim#ut_add_fun('vimim#digit_separator', [4, 1], '仟')
    call vimim#ut_add_fun('vimim#digit_group', [1, 0], '万')
    call vimim#ut_add_fun('vimim#digit_group', [2, 0], '亿')
    call vimim#ut_add_fun('vimim#digit_group', [1, 1], '万')
    call vimim#ut_add_fun('vimim#digit_group', [2, 1], '亿')
    call vimim#ut_add_fun('vimim#num_digit_2', ['10', 0, 0], '十')
    call vimim#ut_add_fun('vimim#num_digit_2', ['12', 0, 0], '十二')
    call vimim#ut_add_fun('vimim#num_digit_2', ['20', 0, 0], '二十')
    call vimim#ut_add_fun('vimim#num_digit_2', ['28', 0, 0], '二十八')
    call vimim#ut_add_fun('vimim#num_digit_3', ['100', 0, 0], '一百')
    call vimim#ut_add_fun('vimim#num_digit_3', ['109', 0, 0], '一百零九')
    call vimim#ut_add_fun('vimim#num_digit_3', ['140', 0, 0], '一百四十')
    call vimim#ut_add_fun('vimim#num_digit_3', ['270', 0, 0], '二百七十')
    call vimim#ut_add_fun('vimim#num_digit_4', ['1000', 0, 0], '一千')
    call vimim#ut_add_fun('vimim#num_digit_4', ['1006', 0, 0], '一千零六')
    call vimim#ut_add_fun('vimim#num_digit_4', ['1020', 0, 0], '一千零二十')
    call vimim#ut_add_fun('vimim#num_digit_4', ['2014', 0, 0], '二千零一十四')
    call vimim#ut_add_fun('vimim#num_digit_4', ['2100', 0, 0], '二千一百')
    call vimim#ut_add_fun('vimim#num_digit_4', ['2014', 0, 2], '两千零一十四')
    call vimim#ut_add_fun('vimim#num_digit_4', ['2100', 0, 2], '两千一百')
    call vimim#ut_add_fun('vimim#num_digit_4', ['8504', 0, 0], '八千五百零四')
endfunction

function! vimim#funit_test()
    let g:vimim_lang = 'cn'
    let g:vimim_futreport = []
    let failed = 0
    call vimim#fut_prepare()
    let tlen = len(g:vimim_futlist)
    for i in range(tlen)
        let report = vimim#assert(g:vimim_futlist[i][0], g:vimim_futlist[i][1], g:vimim_futlist[i][2])
        if !(report =~'Success')
            let failed += 1
        endif
        let g:vimim_futreport = add(g:vimim_futreport, g:vimim_futlist[i][0].'('.join(g:vimim_futlist[i][1], ',').'): '.report)
    endfor
    return string(failed).' failed out of '.string(tlen).string(g:vimim_futreport)
endfunction


