" https://github.com/twpayne/vim-testscript
" FIXME highlight variables in txtar data
" FIXME don't highlight keywords everywhere

if exists("b:current_syntax")
  finish
endif

syn case match

setlocal commentstring=#%s

syn match testscriptComment "\v#.*$"
hi def link testscriptComment Comment

syn keyword testscriptKeywords cd chmod cmp cmpenv cp env exec exists grep
syn keyword testscriptKeywords mkdir unquote rm stdin stderr stdout stop
syn keyword testscriptKeywords symlink wait
syn match testscriptKeywords "\vrequest(-\w+)*"
syn match testscriptKeywords "\vresponse(-\w+)*"

hi def link testscriptKeywords Keyword

syn match testscriptNeg "\v^\s*!"
hi def link testscriptNeg Operator

syn keyword testscriptConstants true false null
hi def link testscriptConstants Constant

syn match testscriptNumbers "\v\d+"
hi def link testscriptNumbers Number

syn keyword testscriptPredefCond exec link net short symlink contained
hi def link testscriptPredefCond Keyword

syn match testscriptTmpl "\v\{\{[^}]*}}"
hi def link testscriptTmpl Special

syn match testscriptCondOp "\v!" contained
syn match testscriptCondOp "\v:" contained
hi def link testscriptCondOp Operator

syn region testscriptCond oneline start="\v\s*\[" end="\v]" contains=testscriptPredefCond,testscriptCondOp
hi def link testscriptCond PreProc

syn keyword testscriptEnvKeywords env contained
hi def link testscriptEnvKeywords Keyword

syn match testscriptEnvVar "\v\i+\=" contained
hi def link testscriptEnvVar Special

syn region testscriptEnv start="\v^\s*env" end="\v$" contains=testscriptEnvKeywords,testscriptEnvVar,testscriptVar,testscriptPredefVar,testscriptPredefVarDelim transparent

syn match testscriptVar "\v\$\i+"
syn match testscriptVar "\v\$\{[^}]*}"
hi def link testscriptVar Identifier

syn match testscriptPredefVar "\v\$(HOME|PATH|TMP|TMPDIR|USERPROFILE|WORK|devnull|exe|goversion|home)>"
syn match testscriptPredefVar "\v\$\{(HOME|PATH|TMP|TMPDIR|USERPROFILE|WORK|devnull|exe|goversion|home)(\@R)?}"
hi def link testscriptPredefVar Special

syn match testscriptPredefVarDelim "\v\$\{(:|/)(\@R)?}"
hi def link testscriptPredefVarDelim Delimiter

syn region testscriptString oneline start="\v'" skip="\v''" end="\v'"
syn region testscriptString oneline start="\v\"" skip="\v\\\"" end="\v\""
hi def link testscriptString String

syn region testscriptTxtarHeader oneline start="\v^\-\- " end="\v \-\-$" contained
hi def link testscriptTxtarHeader Directory

syn region testscriptTxtarEntry start="\v^\-\- " end="\v(^\-\-)\@=$" contains=testscriptTxtarHeader transparent

let b:current_syntax = "testscript"
