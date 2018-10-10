function! targets#sources#separators#new(args)
    return {
                \ 'args': {
                \     'delimiter': escape(a:args['d'], '.~\$'),
                \ },
                \ 'genFuncs': {
                \     'c': function('targets#sources#separators#current'),
                \     'n': function('targets#sources#separators#next'),
                \     'l': function('targets#sources#separators#last'),
                \ },
                \ 'modFuncs': {
                \     'i': function('targets#modify#drop'),
                \     'a': function('targets#modify#dropr'),
                \     'I': function('targets#modify#shrink'),
                \     'A': function('targets#modify#expands'),
                \ }}
endfunction

function! targets#sources#separators#current(args, opts, state)
    if !a:opts.first
        return targets#target#withError('only one current separator')
    endif

    return targets#util#select(a:args.delimiter, a:args.delimiter, '>')
endfunction

function! targets#sources#separators#next(args, opts, state)
    if targets#util#search(a:args.delimiter, 'W') > 0
        return targets#target#withError('no target')
    endif

    let oldpos = getpos('.')
    let target = targets#util#select(a:args.delimiter, a:args.delimiter, '>')
    call setpos('.', oldpos)
    return target
endfunction

function! targets#sources#separators#last(args, opts, state)
    if a:opts.first
        let flags = 'cbW' " allow separator under cursor on first iteration
    else
        let flags = 'bW'
    endif

    if targets#util#search(a:args.delimiter, flags) > 0
        return targets#target#withError('no target')
    endif

    let oldpos = getpos('.')
    let target = targets#util#select(a:args.delimiter, a:args.delimiter, '<')
    call setpos('.', oldpos)
    return target
endfunction


