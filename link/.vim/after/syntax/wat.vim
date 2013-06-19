" JavaScript syntax stuff! Yay!

syn clear   javaScriptParens
syn clear javaScriptBraces
syn keyword javaScriptExit               return throw
syn keyword javaScriptScopeIdentifier    this arguments
syn match   javaScriptBrackets	         "[\[\]]"
syn match javaScriptParensGrouping       "[()]"
syn region  javaScriptArguments          matchgroup=javaScriptParens start="\(function.*\|catch\)\@<=("  end=")" contains=javaScriptPunctuation
syn match   javaScriptPunctuation        "[,;]" 
syn match   javaScriptPropertyAccessor   "\.\(\d\)\@!"
syn match   javaScriptLogicalOperator    "\(&&\|||\)"
syn match   javaScriptComparitor         "\(<=\|>=\|===\|==\|>\|<\|!==\|!=\)"
syn match   javaScriptGeneralOperator           "[-*+\\~!]"
syn match   javaScriptAssignment         "[=][^=]"


syn region  javaScriptObject             matchgroup=javaScriptObjectBrace start="{" end="}" contains=ALL
syn region  javaScriptBlock              matchgroup=javaScriptBlockBrace start="\(\()\|else\|try\|do\)\s*\r*\s*\)\@<={" end="}"  contains=ALLBUT,javaScriptObjectLabel
syn match   javaScriptObjectLabel        "\(\w\+\)\(\s*:\)\@=" contained

" syn match   javaScriptObjectLabelRaw     "\"\?.\+\"\?\s*:" 


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_javascript_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink javaScriptParensGrouping     javaScriptParens
  HiLink javaScriptBlockBrace         javaScriptBraces
  HiLink javaScriptObjectBrace        javaScriptBraces
  delcommand HiLink
endif
