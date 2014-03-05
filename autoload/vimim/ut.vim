" unit test module for vimim functions

let g:vimim#ut#last_reports = []

function! vimim#ut#execute(funame, arglist)
    let arglen = len(a:arglist)
    let Fref = function(a:funame)
    if     arglen == 0
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
        let result = ''
        throw "vimim#ut#execute: ".a:funame."(".a:arglist."): arglist too long."
    endif
    return result
endfunction

function! vimim#ut#assert(funame, arglist, fres)
    let report = ''
    try
        " let result = vimim#ut#execute(a:funame, a:arglist)
        let result = call(a:funame, a:arglist)
    catch
        let report = 'Exception: '.v:exception
    endtry

    if report == ''
        if result == a:fres
            let report = 'Success: '.a:funame.'('.join(a:arglist, ', ')
                        \ .') == '.result
        else
            let report = 'Failed: '.a:funame.'('.join(a:arglist, ', ')
                        \ .') == '.result.'[NE]'.a:fres
        endif
    endif
    return report
endfunction

function! vimim#ut#assert_functions(funame1, arglist1, funame2, arglist2)
    let report = ''
    try
        " let result1 = vimim#ut#execute(a:funame1, a:arglist1)
        " let result2 = vimim#ut#execute(a:funame2, a:arglist2)
        let result1 = call(a:funame1, a:arglist1)
        let result2 = call(a:funame2, a:arglist2)
    catch
        let report = 'Exception: '.v:exception
    endtry
    if report == ''
        if result1 == result2
            let report = 'Success: '.a:funame1.'('.join(a:arglist1, ', ')
            \.') == '.a:funame2.'('.join(a:arglist2, ', ').') == '.result1
        else
            let report = 'Failed: '.a:funame1.'('.join(a:arglist1, ', ').') == '
            \.result1.'[NE]'.a:funame2.'('.join(a:arglist2, ', ').') == '.result
        endif
    endif
    return report
endfunction

function! vimim#ut#unit_test(utlist)
    let utreport = []
    let failed = 0

    let tlen = len(a:utlist)
    for i in range(tlen)
        let argnum = len(a:utlist[i])
        if argnum == 3
            let report = vimim#ut#assert(a:utlist[i][0], a:utlist[i][1], a:utlist[i][2])
        elseif argnum == 4
            let report = vimim#ut#assert_functions(a:utlist[i][0], a:utlist[i][1], a:utlist[i][2], a:utlist[i][3])
        else
            let report = 'List error: '.join(a:utlist[i], '|')
        endif
        if !(report =~'Success')
            let failed += 1
        endif

        let utreport = add(utreport, report)
    endfor

    let g:vimim#ut#last_reports = utreport
    return string(failed).' test failed out of '.string(tlen).".\n"
                \.join(utreport, "\n")
endfunction

function! vimim#ut#test()
    let utlist = []
    let utlist += [['vimim#ut#execute', ['getpid', []], 'getpid', []]]
    let utlist += [['vimim#ut#execute', ['getpid', []], 'call', ['getpid', []]]]
    let utlist += [['vimim#ut#execute', ['len', ['hello']], 'len', ['hello']]]
    let utlist += [['vimim#ut#execute', ['join', [split('abcdef', '\zs'), ', ']], join(split('abcdef', '\zs'), ', ')]]
    let utlist += [['vimim#ut#assert', ['len', ['hello'], len('hello')], vimim#ut#assert('len', ['hello'], len('hello'))]]
    let utlist += [['vimim#ut#assert', ['len', ['hello'], len('hell')], vimim#ut#assert('len', ['hello'], len('hell'))]]
    let utlist += [['vimim#ut#assert', ['leng', ['hello'], len('hello')], vimim#ut#assert('leng', ['hello'], len('hello'))]]
    return vimim#ut#unit_test(utlist)
endfunction

