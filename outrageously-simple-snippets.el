;; Lightweight snippets for emacs that work right out of the box

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with paredit.  If not, see <http://www.gnu.org/licenses/>.

;;; Usage:
;;; Simply copy `register-snippets` macro to your .emacs, that's all.
;;; Then define:
;;; (register-snippets <name>
;;;   (;; (<string to match> . (<commands>))
;;;    ("let" .
;;;     ((insert "(let (")
;;;      (setq final-pos (point))
;;;      (insert ")")
;;;      (newline 2) (insert ")")
;;;      (goto-char final-pos)))))
;;; (define-key lisp-mode-map (kbd "C-t") '<name>)
;;;
;;; Essentially you can write any valid elisp expressions in <commands> block.
;;; The only special command provided is `(newline <diff>)`, it inserts a new
;;; line and indents it by `<previous line indent>+<diff>`
;;; Automatically on match only the matched string will be deleted, so if you
;;; choose to leave <commands> empty you will just end up with a fancy specific
;;; word remover.
;;; `register-snippets` is language agnostic, but only works with single words
;;; as matrch strings.

(defmacro register-snippets (id snippets)
  `(defun ,id () (interactive)
     (cl-flet
      ((newline (x)
        (insert "\n") (backward-char 1)
        (let* ((cid (current-indentation))
               ;; shenanigans due to current-indentation returning +1 when line is blank
               (n (max 0 (+ x cid (if (< (- (line-end-position) (line-beginning-position)) cid) -1 0)))))
         (insert "\n") (indent-to n) (delete-char 1))))
     (let ((sym (thing-at-point 'symbol))
           (snippets (list ,@(mapcar
                              #'(lambda (e) `(cons ,(car e) #'(lambda (bounds) (delete-region (car bounds) (cdr bounds)) ,@`,(cdr e))))
                              snippets))))
       (if (dolist (snipt snippets)
             (if (equal (car snipt) sym)
                 (progn (funcall (cdr snipt) (bounds-of-thing-at-point 'symbol)) (return t))))
         (message "Replaced!")
         (message "Not found"))))))
