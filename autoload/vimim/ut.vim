
let s:NumStyleBig = 1     " true: big style; false: small style;
let s:NumStyleThd = 2     " true: use the third list if exist.
let s:NumStyleExt = 4     " true: use extra characters; false: basic;

" Convert Style Mask
let s:NumZeroNone = 0x0800      " do NOT output zero
let s:NumZeroBasic = 0x0400     " do NOT use the extend zero
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

let g:vimim_futlist = []
let g:vimim_futreport = []

function! vimim#ut#add_fun(funame, arglist, fres)
    let g:vimim_futlist = add(g:vimim_futlist, [a:funame, a:arglist, a:fres])
endfunction

function! vimim#ut#assert(funame, arglist, fres)
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
        elseif arglen == 5
            let result = Fref(a:arglist[0], a:arglist[1], a:arglist[2], a:arglist[3], a:arglist[4])
        else
            let report = 'Unsupported'
        endif
    catch
        let report = 'Exception: '.v:exception
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

function! vimim#ut#prepare()
    let g:vimim_futlist = []
    call vimim#ut#add_fun('vimim#digits#single', [0, 0], '〇')
    call vimim#ut#add_fun('vimim#digits#single', [0, 1], '零')
    call vimim#ut#add_fun('vimim#digits#single', [0, 4], '零')
    call vimim#ut#add_fun('vimim#digits#single', [1, 0], '一')
    call vimim#ut#add_fun('vimim#digits#single', [1, 1], '壹')
    call vimim#ut#add_fun('vimim#digits#single', [1, 4], '一')
    call vimim#ut#add_fun('vimim#digits#single', [2, 0], '二')
    call vimim#ut#add_fun('vimim#digits#single', [2, 1], '贰')
    call vimim#ut#add_fun('vimim#digits#single', [2, 4], '两')
    call vimim#ut#add_fun('vimim#digits#separator', [2, 0], '十')
    call vimim#ut#add_fun('vimim#digits#separator', [3, 0], '百')
    call vimim#ut#add_fun('vimim#digits#separator', [4, 0], '千')
    call vimim#ut#add_fun('vimim#digits#separator', [2, 1], '拾')
    call vimim#ut#add_fun('vimim#digits#separator', [3, 1], '佰')
    call vimim#ut#add_fun('vimim#digits#separator', [4, 1], '仟')
    call vimim#ut#add_fun('vimim#digits#group', [1, 0], '万')
    call vimim#ut#add_fun('vimim#digits#group', [2, 0], '亿')
    call vimim#ut#add_fun('vimim#digits#group', [1, 1], '万')
    call vimim#ut#add_fun('vimim#digits#group', [2, 1], '亿')
    call vimim#ut#add_fun('vimim#digits#digit', ['1002033', 0], '一〇〇二〇三三')
    call vimim#ut#add_fun('vimim#digits#digit', ['1002033', 1], '壹零零贰零叁叁')
    call vimim#ut#add_fun('vimim#digits#digit', ['1002033', 4], '一零零二零三三')
    call vimim#ut#add_fun('vimim#digits#number', ['0', 0], '零')
    call vimim#ut#add_fun('vimim#digits#number', ['0', 1], '零')
    call vimim#ut#add_fun('vimim#digits#number', ['0', s:NumZeroBasic], '〇')
    call vimim#ut#add_fun('vimim#digits#number', ['0', s:NumZeroBasic+s:NumStyleBig], '零')
    call vimim#ut#add_fun('vimim#digits#number', ['10', s:NumOneEnableTen], '一十')
    call vimim#ut#add_fun('vimim#digits#number', ['10', s:NumOneEnableTen+s:NumStyleBig], '壹拾')
    call vimim#ut#add_fun('vimim#digits#number', ['10', 0], '十')
    call vimim#ut#add_fun('vimim#digits#number', ['100', 0], '一百')
    call vimim#ut#add_fun('vimim#digits#number', ['1000', 0], '一千')
    call vimim#ut#add_fun('vimim#digits#number', ['10000', 0], '一万')
    call vimim#ut#add_fun('vimim#digits#number', ['100000', 0], '十万')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000', 0], '一百万')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000', 0], '一千万')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000', 0], '一亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000', 0], '十亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000', 0], '一百亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000', 0], '一千亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000', 0], '一万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000', 0], '十万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000', 0], '一百万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000000', 0], '一千万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000000', 0], '一亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000000', 0], '十亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000000000', 0], '一百亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000000000', 0], '一千亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000000000', 0], '一万亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10', 1], '拾')
    call vimim#ut#add_fun('vimim#digits#number', ['100', 1], '壹佰')
    call vimim#ut#add_fun('vimim#digits#number', ['1000', 1], '壹仟')
    call vimim#ut#add_fun('vimim#digits#number', ['10000', 1], '壹万')
    call vimim#ut#add_fun('vimim#digits#number', ['100000', 1], '拾万')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000', 1], '壹佰万')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000', 1], '壹仟万')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000', 1], '壹亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000', 1], '拾亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000', 1], '壹佰亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000', 1], '壹仟亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000', 1], '壹万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000', 1], '拾万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000', 1], '壹佰万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000000', 1], '壹仟万亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000000', 1], '壹亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000000', 1], '拾亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['1000000000000000000', 1], '壹佰亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['10000000000000000000', 1], '壹仟亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['100000000000000000000', 1], '壹万亿亿')
    call vimim#ut#add_fun('vimim#digits#number', ['12', 0], '十二')
    call vimim#ut#add_fun('vimim#digits#number', ['20', 0], '二十')
    call vimim#ut#add_fun('vimim#digits#number', ['28', 0], '二十八')
    call vimim#ut#add_fun('vimim#digits#number', ['109', 0], '一百零九')
    call vimim#ut#add_fun('vimim#digits#number', ['140', 0], '一百四十')
    call vimim#ut#add_fun('vimim#digits#number', ['270', 0], '二百七十')
    call vimim#ut#add_fun('vimim#digits#number', ['1006', 0], '一千零六')
    call vimim#ut#add_fun('vimim#digits#number', ['1020', 0], '一千零二十')
    call vimim#ut#add_fun('vimim#digits#number', ['2014', 0], '两千零一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['2100', 0], '两千一百')
    call vimim#ut#add_fun('vimim#digits#number', ['2002', 0], '两千零二')
    call vimim#ut#add_fun('vimim#digits#number', ['8504', 0], '八千五百零四')
    call vimim#ut#add_fun('vimim#digits#number', ['22222', 0], '两万两千二百二十二')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', 0], '一千万零两千零一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', 1], '壹仟万零贰仟零壹拾肆')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumZeroBasic], '一千万〇两千〇一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumZeroBasic+s:NumTwoBasic], '一千万〇二千〇一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumOneIgnoreAll], '一千万零两千零十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumZeroTrim], '一千万两千零一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumZeroTrim+s:NumZeroBasic], '一千万两千〇一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['10002014', s:NumZeroTrim+s:NumTwoBasic], '一千万二千零一十四')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', 0], '一亿零两千零一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroFour], '一亿零两千零一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroFour+s:NumTwoBasic], '一亿零二千零一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim+s:NumTwoBasic], '一亿二千零一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim+s:NumTwoBasic+s:NumStyleBig], '壹亿贰仟零壹拾')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroFour+s:NumZeroTrim], '一亿两千零一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100002010', s:NumZeroBasic], '一亿〇两千〇一十')
    call vimim#ut#add_fun('vimim#digits#number', ['100000345', 0], '一亿零三百四十五')
    call vimim#ut#add_fun('vimim#digits#number', ['100000345', s:NumZeroBasic], '一亿〇三百四十五')
    call vimim#ut#add_fun('vimim#digits#number', ['5920001245', 0], '五十九亿两千万零一千二百四十五')
    call vimim#ut#add_fun('vimim#digits#number', ['5920001245', s:NumTwoExtHnd], '五十九亿两千万零一千两百四十五')
endfunction

function! vimim#ut#funit_test()
    let g:vimim_lang = 'cn'
    let g:vimim_futreport = []
    let failed = 0
    call vimim#ut#prepare()
    let tlen = len(g:vimim_futlist)
    for i in range(tlen)
        let report = vimim#ut#assert(g:vimim_futlist[i][0], g:vimim_futlist[i][1], g:vimim_futlist[i][2])
        if !(report =~'Success')
            let failed += 1
        endif
        let g:vimim_futreport = add(g:vimim_futreport, report.":\t".g:vimim_futlist[i][0].'('.join(g:vimim_futlist[i][1], ', ').')' )
    endfor
    return string(failed).' test failed out of '.string(tlen).".\n".join(g:vimim_futreport, "\n")
endfunction


