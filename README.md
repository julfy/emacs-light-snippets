Lightweight snippets for emacs that work right out of the box
===
Simply copy `register-snippets` macro to your .emacs, that's all.

## Usage:

```elisp
(register-snippets lisp-snippets
  (;; (<word to match> . (<commands>))
   ("let" .
    ((insert "(let (")
     (setq final-pos (point))
     (insert ")")
     (newline 2) (insert ")")
     (goto-char final-pos)))))
(define-key lisp-mode-map (kbd "C-t") 'lisp-snippets)
```

Essentially you can write any valid elisp expressions in `<commands>` block.
The only special command provided is `(newline <diff>)`, it inserts a new line and indents it by `<previous line indent>+<diff>`.
Automatically on match only the matched string will be deleted, so if you choose to leave <commands> empty you will just end up with a fancy specific word remover.
`register-snippets` is language agnostic, but only works with single words as matrch strings.
