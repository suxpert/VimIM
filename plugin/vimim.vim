"===========================================================================
" Script Title: VimIM: vim build-in IME UI, next generation.
" Description:  VimIM allows you to input Chinese/Japanese into vim
"               *WITHOUT* a traditional input method, based on the
"               Omni completion introduced from version 7.
"               Copyright (C) 2013-2014 LiTuX, all wrongs reserved.
" Author:       LiTuX <suxpert AT gmail DOT com>
" Last Change:  2014-02-26 23:39:07
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


