" statusline Colors
"   directory
hi default link User1 Directory
"   filename
hi default link User2 String
"   filetype
hi default link User3 Type
"   fugitive
hi default link User4 Conditional

" Add surrounding space Unless Empty
function! AUE(str)
    if a:str != ""
        return " ".a:str." "
    endif
    return ""
endfunction

function! IsFake()
    if !filewritable(bufname('%'))
        return 1
    endif

    return 0
endfunction

function! StatusLineBase()
    " vcvars will cause errors if this buffer doesn't represent a file
    if IsFake()
        return ""
    endif

    let [vcs, root, branch] = vcvars#CVcVars()

    if vcs == ''
        if getcwd() == "/"
            return "/"
        else
            return fnamemodify(getcwd(), ":t")
        endif
    endif

    let remainder = strpart(getcwd(), strlen(root))
    let ret = fnamemodify(root, ":t").l:remainder
    return ret
endfunction

function! StatusLineBranch()
    let [vcs, root, branch] = vcvars#CVcVars()
    if vcs == ''
        return ''
    endif

    return vcs."/".branch
endfunction

" Like %<%f, but handles stripping parent folder better
function! StatusLineFileSubPath()
    let root = getcwd()
    let filepath = fnamemodify(bufname('%'), ":p")
    if stridx(l:filepath, l:root) > -1 && l:root != '/'
        return strpart(l:filepath, strlen(l:root)+1)
    else
        " Show entire path
        return filepath
    endif
endfunction

if exists("g:vcvars")
    set statusline=\ \ %1*\ %{StatusLineBase()}\ %0*            " current root or dir
    set statusline+=\ \ %2*\ %{StatusLineFileSubPath()}%m\ %0*  " Filename/Modified
    set statusline+=\ %4*%{AUE(StatusLineBranch())}%0*          " VCS branch
else
    set statusline=\ \ %1*\ %{getcwd()}\ %0*                    " current root or dir
    " set statusline+=\ \ %2*\ %f%m\ %0*                        " Filename/Modified
    set statusline+=\ \ %2*\ %{StatusLineFileSubPath()}%m\ %0*  " Filename/Modified
endif
set statusline+=%=                                              " Right Aligned
set statusline+=%v/%l/%L\                                       " cursor pos
set statusline+=\ \ %3*\ %{&ft}\ %0*\                           " Filetype
set statusline+=%{&fenc?&fenc:&enc}/%{&ff}\                     " Encoding/EOL
set statusline+=%w                                              " Preview
set statusline+=%r\                                             " Read Only

" Remove highlight and re-load vcs info
nnoremap <silent> <C-L> :nohlsearch<CR>:unlet b:vcvars<CR><C-L>
