" unit test module for vimim functions

let g:vimim#ut#last_reports = []

function! vimim#ut#assert(funame, arglist, fres)
    let report = ''
    try
        let result = call(a:funame, a:arglist)
    catch
        let report = 'Exception: '.v:exception
    endtry

    if report == ''
        if result == a:fres
            let report = 'Success: '.a:funame
            let report .= substitute(string(a:arglist), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.substitute(string(result), '\n', '\\n', 'g')
        else
            let report = 'Failed: '.a:funame
            let report .= substitute(string(a:arglist), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.substitute(string(result), '\n', '\\n', 'g')
            let report .= ' != '.substitute(string(a:fres), '\n', '\\n', 'g')
        endif
    endif
    return report
endfunction

function! vimim#ut#assert_functions(funame1, arglist1, funame2, arglist2)
    let report = ''
    try
        let result1 = call(a:funame1, a:arglist1)
        let result2 = call(a:funame2, a:arglist2)
    catch
        let report = 'Exception: '.v:exception
    endtry
    if report == ''
        if result1 == result2
            let report = 'Success: '.a:funame1
            let report .= substitute(string(a:arglist1), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.a:funame2
            let report .= substitute(string(a:arglist2), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.substitute(string(result1), '\n', '\\n', 'g')
        else
            let report = 'Failed: '.a:funame1
            let report .= substitute(string(a:arglist1), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.substitute(string(result1), '\n', '\\n', 'g')
            let report .= ' != '.a:funame2
            let report .= substitute(string(a:arglist2), '^\[\(.*\)]$', '(\1)', '')
            let report .= ' == '.substitute(string(result2), '\n', '\\n', 'g')
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
            let report = vimim#ut#assert_functions(a:utlist[i][0], a:utlist[i][1],
                        \   a:utlist[i][2], a:utlist[i][3])
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

function! vimim#ut#self_test()
    let utlist = []
    let utlist += [['getcwd', [],
                \   'getcwd', []        ]]
    let utlist += [['fmod', [31, 7],
                \   'fmod', [45, 7]     ]]
    let utlist += [['strlen', ['Hello world'],
                \   'len', ['Hello world']  ]]

    let utlist += [['call', ['getpid', []],
                \   'getpid', []        ]]
    let utlist += [['call', ['len', ['hello']],
                \   'len', ['hello']    ]]

    let utlist += [['call', ['join', [split('abcdef', '\zs'), ', ']],
                \               join(split('abcdef', '\zs'), ', ')  ]]

    let utlist += [['vimim#ut#assert', ['len', ['hello'], len('hello')],
                \       vimim#ut#assert('len', ['hello'], len('hello')) ]]
    let utlist += [['vimim#ut#assert', ['len', ['hello'], len('hell')],
                \       vimim#ut#assert('len', ['hello'], len('hell'))  ]]
    let utlist += [['vimim#ut#assert', ['leng', ['hello'], len('hello')],
                \       vimim#ut#assert('leng', ['hello'], len('hello'))]]

    let utlist += [['vimim#ut#assert_functions', ['len', ['hello'], 'len', ['hello']],
                \       vimim#ut#assert_functions('len', ['hello'], 'len', ['hello']) ]]
    let utlist += [['vimim#ut#assert_functions', ['len', ['hello'], 'len', ['hell']],
                \       vimim#ut#assert_functions('len', ['hello'], 'len', ['hell'])  ]]
    let utlist += [['vimim#ut#assert_functions', ['leng', ['hello'], 'len', ['hello']],
                \       vimim#ut#assert_functions('leng', ['hello'], 'len', ['hello'])]]

    let utlist += [['vimim#ut#unit_test', [[]],
                \       vimim#ut#unit_test([])]]

    let utlist += [['vimim#ut#unit_test', [[['len', ['hello'], len('hello')]]],
                \       vimim#ut#unit_test([['len', ['hello'], len('hello')]])]]
    let utlist += [['vimim#ut#unit_test', [[['len', ['hell'], len('hello')]]],
                \       vimim#ut#unit_test([['len', ['hell'], len('hello')]])]]
    let utlist += [['vimim#ut#unit_test', [[['leng', ['hello'], len('hello')]]],
                \       vimim#ut#unit_test([['leng', ['hello'], len('hello')]])]]

    let utlist += [['vimim#ut#unit_test', [[['len', ['hello'], 'len', ['hello']]]],
                \       vimim#ut#unit_test([['len', ['hello'], 'len', ['hello']]])]]
    let utlist += [['vimim#ut#unit_test', [[['len', ['hell'], 'len', ['hello']]]],
                \       vimim#ut#unit_test([['len', ['hell'], 'len', ['hello']]])]]
    let utlist += [['vimim#ut#unit_test', [[['leng', ['hello'], 'len', ['hello']]]],
                \       vimim#ut#unit_test([['leng', ['hello'], 'len', ['hello']]])]]

    return vimim#ut#unit_test(utlist)
endfunction

