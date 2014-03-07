"==================================================================
" unit test for digits.vim, this file is part of VimIM
" Copyright (C) 2014 LiTuX, all wrongs reserved.
"==================================================================

let s:NumStyleDft = 0           " this is NOT a mask

let s:NumStyleBig = 1           " true: big style; false: small style;
let s:NumStyleThd = 2           " true: use the third list if exist.
let s:NumStyleExt = 4           " true: use extra characters; false: basic;

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

let s:saved_lang = g:vimim_lang
" echo all to @V
redir @V

" For Simplified Chinese
let g:vimim_lang = 'cn'
" Basic function test
let s:list = []
let s:list += [['vimim#digits#single', [0, s:NumStyleDft], '〇']]
let s:list += [['vimim#digits#single', [0, s:NumStyleBig], '零']]
let s:list += [['vimim#digits#single', [0, s:NumStyleExt], '零']]
let s:list += [['vimim#digits#single', [1, s:NumStyleDft], '一']]
let s:list += [['vimim#digits#single', [1, s:NumStyleBig], '壹']]
let s:list += [['vimim#digits#single', [1, s:NumStyleExt], '一']]
let s:list += [['vimim#digits#single', [2, s:NumStyleDft], '二']]
let s:list += [['vimim#digits#single', [2, s:NumStyleBig], '贰']]
let s:list += [['vimim#digits#single', [2, s:NumStyleExt], '两']]

let s:list += [['vimim#digits#separator', [2, s:NumStyleDft], '十']]
let s:list += [['vimim#digits#separator', [3, s:NumStyleDft], '百']]
let s:list += [['vimim#digits#separator', [4, s:NumStyleDft], '千']]
let s:list += [['vimim#digits#separator', [2, s:NumStyleBig], '拾']]
let s:list += [['vimim#digits#separator', [3, s:NumStyleBig], '佰']]
let s:list += [['vimim#digits#separator', [4, s:NumStyleBig], '仟']]

let s:list += [['vimim#digits#group', [1, s:NumStyleDft], '万']]
let s:list += [['vimim#digits#group', [2, s:NumStyleDft], '亿']]
let s:list += [['vimim#digits#group', [1, s:NumStyleBig], '万']]
let s:list += [['vimim#digits#group', [2, s:NumStyleBig], '亿']]
echo vimim#ut#unit_test(s:list)

" number convert
let s:list = []
let s:list += [['vimim#digits#digit', ['1002033', s:NumStyleDft],
            \   'vimim#digits#digit', ['1002033', s:NumStyleThd]    ]]
let s:list += [['vimim#digits#digit', ['1002033', s:NumStyleThd],
            \   'vimim#digits#digit', ['1002033', s:NumStyleBig+s:NumStyleThd]  ]]

let s:list += [['vimim#digits#digit', ['1002033', s:NumStyleDft], '一〇〇二〇三三']]
let s:list += [['vimim#digits#digit', ['1002033', s:NumStyleBig], '壹零零贰零叁叁']]
let s:list += [['vimim#digits#digit', ['1002033', s:NumStyleExt], '一零零二零三三']]

let s:list += [['vimim#digits#number', ['0', s:NumStyleDft], '零']]
let s:list += [['vimim#digits#number', ['0', s:NumStyleBig], '零']]
let s:list += [['vimim#digits#number', ['0', s:NumZeroOrig], '〇']]
let s:list += [['vimim#digits#number', ['0', s:NumZeroOrig+s:NumStyleBig], '零']]
let s:list += [['vimim#digits#number', ['10', s:NumOneEnableTen], '一十']]
let s:list += [['vimim#digits#number', ['10', s:NumOneEnableTen+s:NumStyleBig], '壹拾']]
let s:list += [['vimim#digits#number', ['10', s:NumStyleDft], '十']]
let s:list += [['vimim#digits#number', ['100', s:NumStyleDft], '一百']]
let s:list += [['vimim#digits#number', ['1000', s:NumStyleDft], '一千']]
let s:list += [['vimim#digits#number', ['10000', s:NumStyleDft], '一万']]
let s:list += [['vimim#digits#number', ['100000', s:NumStyleDft], '十万']]
let s:list += [['vimim#digits#number', ['1000000', s:NumStyleDft], '一百万']]
let s:list += [['vimim#digits#number', ['10000000', s:NumStyleDft], '一千万']]
let s:list += [['vimim#digits#number', ['100000000', s:NumStyleDft], '一亿']]
let s:list += [['vimim#digits#number', ['1000000000', s:NumStyleDft], '十亿']]
let s:list += [['vimim#digits#number', ['10000000000', s:NumStyleDft], '一百亿']]
let s:list += [['vimim#digits#number', ['100000000000', s:NumStyleDft], '一千亿']]
let s:list += [['vimim#digits#number', ['1000000000000', s:NumStyleDft], '一万亿']]
let s:list += [['vimim#digits#number', ['10000000000000', s:NumStyleDft], '十万亿']]
let s:list += [['vimim#digits#number', ['100000000000000', s:NumStyleDft], '一百万亿']]
let s:list += [['vimim#digits#number', ['1000000000000000', s:NumStyleDft], '一千万亿']]
let s:list += [['vimim#digits#number', ['10000000000000000', s:NumStyleDft], '一亿亿']]
let s:list += [['vimim#digits#number', ['100000000000000000', s:NumStyleDft], '十亿亿']]
let s:list += [['vimim#digits#number', ['1000000000000000000', s:NumStyleDft], '一百亿亿']]
let s:list += [['vimim#digits#number', ['10000000000000000000', s:NumStyleDft], '一千亿亿']]
let s:list += [['vimim#digits#number', ['100000000000000000000', s:NumStyleDft], '一万亿亿']]
let s:list += [['vimim#digits#number', ['10', s:NumStyleBig], '拾']]
let s:list += [['vimim#digits#number', ['100', s:NumStyleBig], '壹佰']]
let s:list += [['vimim#digits#number', ['1000', s:NumStyleBig], '壹仟']]
let s:list += [['vimim#digits#number', ['10000', s:NumStyleBig], '壹万']]
let s:list += [['vimim#digits#number', ['100000', s:NumStyleBig], '拾万']]
let s:list += [['vimim#digits#number', ['1000000', s:NumStyleBig], '壹佰万']]
let s:list += [['vimim#digits#number', ['10000000', s:NumStyleBig], '壹仟万']]
let s:list += [['vimim#digits#number', ['100000000', s:NumStyleBig], '壹亿']]
let s:list += [['vimim#digits#number', ['1000000000', s:NumStyleBig], '拾亿']]
let s:list += [['vimim#digits#number', ['10000000000', s:NumStyleBig], '壹佰亿']]
let s:list += [['vimim#digits#number', ['100000000000', s:NumStyleBig], '壹仟亿']]
let s:list += [['vimim#digits#number', ['1000000000000', s:NumStyleBig], '壹万亿']]
let s:list += [['vimim#digits#number', ['10000000000000', s:NumStyleBig], '拾万亿']]
let s:list += [['vimim#digits#number', ['100000000000000', s:NumStyleBig], '壹佰万亿']]
let s:list += [['vimim#digits#number', ['1000000000000000', s:NumStyleBig], '壹仟万亿']]
let s:list += [['vimim#digits#number', ['10000000000000000', s:NumStyleBig], '壹亿亿']]
let s:list += [['vimim#digits#number', ['100000000000000000', s:NumStyleBig], '拾亿亿']]
let s:list += [['vimim#digits#number', ['1000000000000000000', s:NumStyleBig], '壹佰亿亿']]
let s:list += [['vimim#digits#number', ['10000000000000000000', s:NumStyleBig], '壹仟亿亿']]
let s:list += [['vimim#digits#number', ['100000000000000000000', s:NumStyleBig], '壹万亿亿']]
let s:list += [['vimim#digits#number', ['12', s:NumStyleDft], '十二']]
let s:list += [['vimim#digits#number', ['20', s:NumStyleDft], '二十']]
let s:list += [['vimim#digits#number', ['28', s:NumStyleDft], '二十八']]
let s:list += [['vimim#digits#number', ['109', s:NumStyleDft], '一百零九']]
let s:list += [['vimim#digits#number', ['140', s:NumStyleDft], '一百四十']]
let s:list += [['vimim#digits#number', ['270', s:NumStyleDft], '二百七十']]
let s:list += [['vimim#digits#number', ['1006', s:NumStyleDft], '一千零六']]
let s:list += [['vimim#digits#number', ['1020', s:NumStyleDft], '一千零二十']]
let s:list += [['vimim#digits#number', ['2014', s:NumStyleDft], '两千零一十四']]
let s:list += [['vimim#digits#number', ['2100', s:NumStyleDft], '两千一百']]
let s:list += [['vimim#digits#number', ['2002', s:NumStyleDft], '两千零二']]
let s:list += [['vimim#digits#number', ['8504', s:NumStyleDft], '八千五百零四']]
let s:list += [['vimim#digits#number', ['22222', s:NumStyleDft], '两万两千二百二十二']]
let s:list += [['vimim#digits#number', ['10002014', s:NumStyleDft], '一千万零两千零一十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumStyleBig], '壹仟万零贰仟零壹拾肆']]
let s:list += [['vimim#digits#number', ['10002014', s:NumZeroOrig], '一千万〇两千〇一十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumZeroOrig+s:NumTwoBasic], '一千万〇二千〇一十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumOneIgnoreAll], '一千万零两千零十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumZeroTrim], '一千万两千零一十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumZeroTrim+s:NumZeroOrig], '一千万两千〇一十四']]
let s:list += [['vimim#digits#number', ['10002014', s:NumZeroTrim+s:NumTwoBasic], '一千万二千零一十四']]
let s:list += [['vimim#digits#number', ['100002010', s:NumStyleDft], '一亿零两千零一十']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroFour], '一亿零两千零一十']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroFour+s:NumTwoBasic], '一亿零二千零一十']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim+s:NumTwoBasic], '一亿二千零一十']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim+s:NumTwoBasic+s:NumStyleBig], '壹亿贰仟零壹拾']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim], '一亿两千零一十']]
let s:list += [['vimim#digits#number', ['100002010', s:NumZeroOrig], '一亿〇两千〇一十']]
let s:list += [['vimim#digits#number', ['100000345', s:NumStyleDft], '一亿零三百四十五']]
let s:list += [['vimim#digits#number', ['100000345', s:NumZeroOrig], '一亿〇三百四十五']]
let s:list += [['vimim#digits#number', ['5920001245', s:NumStyleDft], '五十九亿两千万零一千二百四十五']]
let s:list += [['vimim#digits#number', ['5920001245', s:NumTwoExtHnd], '五十九亿两千万零一千两百四十五']]

echo vimim#ut#unit_test(s:list)
redir END

