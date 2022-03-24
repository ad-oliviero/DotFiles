(defconst pasta-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
	(modify-syntax-entry ?/ ". 124b")
	(modify-syntax-entry ?* ". 23")
	(modify-syntax-entry ?\n "> b")
  (modify-syntax-entry ?: "(}")
  (modify-syntax-entry ?\{ "(}")
  (modify-syntax-entry ?\; "){")
  (modify-syntax-entry ?\} "){")
  (modify-syntax-entry ?\( "()")
  (modify-syntax-entry ?_ "w")
  (modify-syntax-entry ?- "w")
  (modify-syntax-entry ?\" "\"")
  (modify-syntax-entry ?= ".")
  (syntax-table))
  "Syntax table for `pasta-mode'.")


(defun nps-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      ;; don't indent empty lines if they don't have the in it
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      ;; check whether we want to move to the end of line
      (when boi-p
        (setq move-eol-p t))
      ;; decrement the indent if the first character on the line is a
      ;; closer.
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      ;; indent the line
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))


(eval-and-compile
  (defconst pasta-keywords
    '("int" "car" "par" "se" "oppure" "mentre" "per" "fine" "scrivii" "funzione")))

(defconst pasta-highlights
  `((,(regexp-opt pasta-keywords 'symbols) . font-lock-keyword-face)))

(define-derived-mode pasta-mode prog-mode "pasta"
  "Major Mode for editing Pasta source code."
  :syntax-table pasta-mode-syntax-table
  (setq font-lock-defaults '(pasta-highlights))
  (setq-local comment-start "// "))

(add-to-list 'auto-mode-alist '("\\.pz\\'" . pasta-mode))

(provide 'pasta-mode)

