"===========================================================================
" Description:  Digit process for VimIM
" Author:       LiTuX <suxpert AT gmail DOT com>
" Last Change:  2014-03-06 16:39:41
" Version:      0.0.0
"
" Changes:
"       0.0.1:  TODO
"===========================================================================

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

" Convert Style Mask
let s:NumZeroNone = 0x0800      " do NOT output zero
let s:NumZeroOrig = 0x0400      " do NOT use the extend zero
let s:NumZeroTrim = 0x0200      " do NOT output zero before thousand
let s:NumZeroFour = 0x0100      " do NOT apart zero segment (>4)
let s:NumOneIgnoreGrp = 0x8000  " ignore 1 at 万/亿 et al.
let s:NumOneIgnoreThs = 0x4000  " ignore 1 at thousand
let s:NumOneIgnoreHnd = 0x2000  " ignore 1 at hundred
let s:NumOneEnableTen = 0x1000  " enable 1 at ten (e.g., 一十四)
let s:NumOneIgnoreAll = 0x80    " ignore 1 at every group(or only start)
let s:NumTwoBasic = 0x40        " do NOT use the extend two
let s:NumTwoExtHnd = 0x20       " use the extend two at hundred
let s:NumTwoExtStart = 0x10     " use the extend two only at start

" Convert styles for different languages, TODO
let g:vimim_digit_styles = {}
" Mainland China, small/big: 0x00/0x01
" 0: 零/〇(small only)：0x0000/0x0400
"    十万零一千/十万一千，三亿零五千/十万一千，三亿五千
"    0x0000/0x0200/0x0300
" 1: 一十/十/十 (only at start): small only
"    0x1000/0x0080/0x0000
" 2: 二/两/两 (only at start): small only
"    0x0040/0x0000/0x0010
let g:vimim_digit_styles['cn'] = [
\   [0x0000, 0x1000, 0x0040, 0x1040, 0x1001, 0x1201, 0x1301,],
\   [0x0200, 0x1200, 0x0240, 0x1240, 0x0001, 0x0201, 0x0301,],
\   [
\   0x0000, 0x0010, 0x0040,  0x0400, 0x0410, 0x0440,    0x0001,
\   0x0080, 0x0090, 0x00C0,  0x0480, 0x0490, 0x04C0,    0x0081,
\   0x1000, 0x1010, 0x1040,  0x1400, 0x1410, 0x1440,    0x1001,
\   0x0200, 0x0210, 0x0240,  0x0600, 0x0610, 0x0640,    0x0201,
\   0x0280, 0x0290, 0x02C0,  0x0680, 0x0690, 0x06C0,    0x0281,
\   0x1200, 0x1210, 0x1240,  0x1600, 0x1610, 0x1640,    0x1201,
\   0x0300, 0x0310, 0x0340,  0x0700, 0x0710, 0x0740,    0x0301,
\   0x0380, 0x0390, 0x03C0,  0x0780, 0x0790, 0x07C0,    0x0381,
\   0x1300, 0x1310, 0x1340,  0x1700, 0x1710, 0x1740,    0x1301,
\   ], ]
" Taiwan, TODO, small/big: 0x00/0x01
" 0: 零/〇(small only)：0x0000/0x0400
"    十万零一千/十万一千，三亿零五千/十万一千，三亿五千
"    0x0000/0x0200/0x0300
" 1: 一十/十/十 (only at start): small only
"    0x1000/0x0080/0x0000
" 2: 二/兩千/兩百/兩 (only at start): small only
"    0x0040/0x0000/0x0010
let g:vimim_digit_styles['tw'] = [
\   [0x0000, 0x1000, 0x0040, 0x1040, 0x1001, 0x1201, 0x1301,],
\   [0x0200, 0x1200, 0x0240, 0x1240, 0x0001, 0x0201, 0x0301,],
\   [
\   0x0000, 0x0010, 0x0040,  0x0400, 0x0410, 0x0440,    0x0001,
\   0x0080, 0x0090, 0x00C0,  0x0480, 0x0490, 0x04C0,    0x0081,
\   0x1000, 0x1010, 0x1040,  0x1400, 0x1410, 0x1440,    0x1001,
\   0x0200, 0x0210, 0x0240,  0x0600, 0x0610, 0x0640,    0x0201,
\   0x0280, 0x0290, 0x02C0,  0x0680, 0x0690, 0x06C0,    0x0281,
\   0x1200, 0x1210, 0x1240,  0x1600, 0x1610, 0x1640,    0x1201,
\   0x0300, 0x0310, 0x0340,  0x0700, 0x0710, 0x0740,    0x0301,
\   0x0380, 0x0390, 0x03C0,  0x0780, 0x0790, 0x07C0,    0x0381,
\   0x1300, 0x1310, 0x1340,  0x1700, 0x1710, 0x1740,    0x1301,
\   ], ]

" Japan, TODO, small/big: 0x00/0x01
" 0: 零/〇(small only)：0x0000/0x0400   0x0800
" 1: 一十/十/十 (only at start): small only
"    0x1000/0x0080/0x0000
"    0x2000/0x3000
let g:vimim_digit_styles['jp'] = [
\   [],
\   [],
\   [
\   ], ]

scriptencoding utf8
let g:vimim_digit_single = {
\   'cn': [ split('〇一二三四五六七八九零　两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')            ],
\   'hk': [ split('〇一二三四五六七八九零　兩', '\zs'),
\           split('零壹貳叁肆伍陸柒捌玖　　　叄', '\zs')    ],
\   'mo': [ split('〇一二三四五六七八九零　兩', '\zs'),
\           split('零壹貳叁肆伍陆柒捌玖　　　叄', '\zs')    ],
\   'tw': [ split('〇一二三四五六七八九零　兩', '\zs'),
\           split('零壹貳參肆伍陸柒捌玖　　　叄', '\zs')    ],
\   'sg': [ split('〇一二三四五六七八九零　两', '\zs'),
\           split('零壹贰叁肆伍陆柒捌玖', '\zs')            ],
\   'jp': [ split('〇一二三四五六七八九零', '\zs'),
\           split('零壱弐参四五六七八九', '\zs')            ],
\   'ko': [ split('〇一二三四五六七八九零', '\zs'),
\           split('零壹貳參四五六柒八九', '\zs'),
\           split('영일이삼사오육칠팔구공', '\zs')          ],
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
\   'tw': [ split('萬億兆', '\zs'), split('萬億兆', '\zs') ],
\   'sg': [ split('万亿', '\zs'), split('万亿', '\zs') ],
\   'jp': [ split('万億兆京垓秭穣溝澗正載極', '\zs'),
\           split('万億兆京垓秭穣溝澗正載極', '\zs')   ],
\   'ko': [ split('万亿兆京垓秭穣沟涧正载极', '\zs'),
\           split('万亿兆京垓秭穣沟涧正载极', '\zs'),
\           split('만억조경해자양구간정재극', '\zs')   ],
\ }
scriptencoding

function! vimim#digits#list(dict, style)
    if and(a:style, s:NumStyleThd)
        let listnr = 2
    else
        let listnr = and(a:style, s:NumStyleBig)
    endif
    if !exists('a:dict[g:vimim_lang]')
        return []
    endif

    let uselist = a:dict[g:vimim_lang]
    if !exists('uselist[listnr]')
        let listnr = 0              " default is small
    endif
    return uselist[listnr]
endfunction

function! vimim#digits#single(num, style)
    if (a:num =~ '^\d$')
        let nr = str2nr(a:num)
    elseif a:num >= 0 && a:num <= 9
        let nr = a:num
    else
        return ''
    endif
    let uselist = vimim#digits#list(g:vimim_digit_single, a:style)

    if and(a:style, s:NumStyleExt) && exists('uselist[nr+10]') && uselist[nr+10] != '　'
        let result = uselist[nr+10]
    else
        let result = uselist[nr]
    endif
    return result
endfunction

function! vimim#digits#separator(pos, style)
    " in this function, style can be s:NumStyleBig or s:NumStyleThd
    " 2, 3, 4 => 10, 100, 1000
    if a:pos > 1 && a:pos < 5
        let pos = a:pos-2           " TODO
    else
        return ''
    endif
    let uselist = vimim#digits#list(g:vimim_digit_separator, a:style)
    let result = uselist[pos]
    return result
endfunction

function! vimim#digits#group(grp, style)
    " in this function, style can be s:NumStyleBig or s:NumStyleThd
    " 0, 1, 2, 3, ... => NONE, 1e4, 1e8, 1e12, ..
    if a:grp > 0
        let grp = a:grp-1           " TODO
    else
        return ''
    endif
    let uselist = vimim#digits#list(g:vimim_digit_group, a:style)
    let result = uselist[grp]
    return result
endfunction

" convert a 'integer' string to Chinese number,
" e.g., 5704310 => 五百七十万四千三百一十
" style can be combine of mask:
" s:NumStyleBig (1),
" s:NumStyleThd (2),
" s:NumZero... s:NumOne... s:NumTwo...
function! vimim#digits#number( num, style )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif

    let basicstyle = and(a:style, 3)    " the lower 3 bit
    let result = ''

    let start = 1
    let zeros = 0
    let len = strlen(a:num)

    for idx in range(len)
        let pos = (len-idx+3)%4+1       " 1, 2, 3, 4 for 个十百千
        let grp = (len-idx)/4
        if a:num[idx] == '0'
            if start
                if grp==0 && pos==1
                    let digitstyle = or(basicstyle, (and(a:style, s:NumZeroOrig)? 0: s:NumStyleExt))
                    let result .= vimim#digits#single(0, digitstyle)
                endif
                continue
            endif
            let zeros += 1
        else
            if !and(a:style, s:NumZeroNone)
                if (zeros>=4 && !and(a:style, s:NumZeroFour)) || (zeros>0 && pos!=4) || (zeros>0 && !and(a:style, s:NumZeroTrim))
                    let digitstyle = or(basicstyle, (and(a:style, s:NumZeroOrig)? 0: s:NumStyleExt))
                    let result .= vimim#digits#single(0, digitstyle)
                endif
            endif
            let zeros = 0           " reset zero counter
            if a:num[idx]=='1' && (and(a:style, s:NumOneIgnoreAll) || start)
                if pos==2 && !and(a:style, s:NumOneEnableTen)
                    " 十二 instead of 一十二
                elseif pos==3 && and(a:style, s:NumOneIgnoreHnd)
                    " 百六十 instead of 一百六十, TODO: if 100
                elseif pos==4 && and(a:style, s:NumOneIgnoreThs)
                    " 千八百 instead of 一千八百, TODO: if 1000
                elseif pos==1 && grp!=0 && and(a:style, s:NumOneIgnoreGrp)
                    " 万五千 insread of 一万五千, TODO: if 10000
                else
                    " This 1 should be converted.
                    let result .= vimim#digits#single(a:num[idx], basicstyle)
                endif
            elseif a:num[idx]=='2'
                let twoExt = 0
                if !and(a:style, s:NumTwoBasic)
                    if start && pos==1 && grp!=0        " 两万/两亿
                        let twoExt = 1
                    elseif start || !and(a:style, s:NumTwoExtStart)
                        if pos==4                       " 两千
                            let twoExt = 1
                        elseif pos==3 && and(a:style, s:NumTwoExtHnd)   " 两百
                            let twoExt = 1
                        endif
                    endif
                endif
                if twoExt == 1
                    let digitstyle = or(basicstyle, s:NumStyleExt)
                else
                    let digitstyle = and(basicstyle, invert(s:NumStyleExt))
                endif
                let result .= vimim#digits#single(a:num[idx], digitstyle)
            else
                let digitstyle = and(a:style, 0xF)      " the lower 4 bit
                let result .= vimim#digits#single(a:num[idx], digitstyle)
            endif
            let start = 0
        endif

        if a:num[idx]!='0' && pos!=1
            let result .= vimim#digits#separator(pos, basicstyle)
        elseif pos==1 && grp!=0
            if zeros>=4
                if grp%2==0
                    let result .= vimim#digits#group((grp+1)%2+1, basicstyle)
                endif
            else
                let result .= vimim#digits#group((grp+1)%2+1, basicstyle)
            endif
        endif
    endfor

    return result
endfunction

" covert a 'integer' string to Chinese digit,
" e.g., 5704310 => 五七〇四三一〇
function! vimim#digits#digit( num, style )
    " validate argument
    if !(a:num =~ '^\d\+$')
        return
    endif
    let result = ''
    for i in split(a:num, '\zs')
        if i == '2' && a:style == s:NumStyleExt
            let result .= vimim#digits#single(i, xor(a:style, s:NumStyleExt))
        else
            let result .= vimim#digits#single(i, a:style)
        endif
    endfor
    return result
endfunction

function! vimim#digits#number_list(num, behave)
    " 0: common results;    1: extra;       2: all
    let starttime = reltime()
    let result = []
    let dict = {}
    for style in g:vimim_digit_styles[g:vimim_lang][a:behave]
        let cnum = vimim#digits#number(a:num, style)
        if !has_key(dict, cnum)
            let dict[cnum] = [printf("%#06x", style)]
            let result = add(result, cnum)
        else
            let dict[cnum] = add(dict[cnum], printf("%#06x", style))
        endif
    endfor
    let dict[a:num] = reltimestr(reltime(starttime))
    let dict['result'] = result
    return dict
endf

function! vimim#digits#number_styles(num)
    " TODO: this function is too slow!
    let starttime = reltime()
    let styleAboutOne = [   0x1000,
                \           0x0000, 0x3000, 0x5000, 0x9000,
                \           0x2000, 0x4000, 0x8000, 0x7000, 0xB000, 0xD000,
                \           0x6000, 0xA000, 0xC000, 0xF000,
                \           0xE000,
                \           0x1080,
                \           0x0080, 0x3080, 0x5080, 0x9080,
                \           0x2080, 0x4080, 0x7080,
                \           0x6080, ]
    let styleAboutZero = [  0x000, 0x100, 0x200, 0x300,
                \           0x400, 0x500, 0x600, 0x700, 0x800, ]
    let styleAboutTwo = [   0x00, 0x10, 0x20, 0x30, 0x40, ]
    let styleAboutList = [  0x00, 0x01, 0x02, 0x04, 0x05, 0x06, ]
    " 0: small (default)    1: big              2: third string
    " 4: small with extend  5: big with extend  6: third with extend
    let result = {}
    " for styleA in g:vimim_digit_styles.cn " styleAboutList
    for styleA in styleAboutList
        for styleB in styleAboutTwo
            for styleC in styleAboutZero
                for styleD in styleAboutOne
                    let style = styleA+styleB+styleC+styleD
                    " let result = add(result, vimim#digits#number(a:num, style).'('.style.')')
                    let cnum = vimim#digits#number(a:num, style)
                    if !has_key(result, cnum)
                        let result[cnum] = [printf("%#06x", style)]
                    else
                        " let result[cnum] = printf("%#06x", and(str2nr(result[cnum], 16), style))
                        let result[cnum] = add(result[cnum], printf("%#06x", style))
                    endif
                endfor
            endfor
        endfor
    endfor
    let result[reltimestr(reltime(starttime))] = a:num
    return result
endf


