This is my statusline configuration.  It depends on [vim-vcvars][vcvars].  You're welcome to use this as is or customize it to your liking.

![Screenshot](https://github.com/cskeeters/i/raw/master/vim-statusline.png)

This adds color using `%1*` syntax supported natively in vim.  Colors are linked to the current colorscheme (which is [base16-default-dark][bdd] in the screenshot).  It does not requiring overly complex code and it easy to customize by modifying the `statusline` settings.  [vim-vcvars][vcvars] supports showing branches for hg and git.  Results are cached and reloads when modification time for `.git/HEAD` or `.hg/branch` changes.

[vcvars]: https://github.com/cskeeters/vim-vcvars
[bdd]: https://chriskempson.github.io/base16/
