; MOST OF THIS CONFIG IS TAKEN FROM https://github.com/matman26/emacs-config

(require 'package)
(require 'use-package)
(add-to-list 'package-archives '("gnu"."http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable"."http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa"."http://melpa.org/packages/"))
(package-initialize)

; save the current session
(desktop-save-mode 1)

; setup use-package if not installed
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

; (use-package org
; :ensure t)

(use-package undo-tree)
(global-undo-tree-mode)
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

; scroll one line at a time (less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))) ; one line at a time
;(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
;(setq mouse-wheel-follow-mouse 't) ; scroll window under mouse
;(setq scroll-step .1) ; keyboard scroll one line at a time
; smooth scrolling
;(pixel-scroll-mode 1)
(use-package good-scroll)
(good-scroll-mode 1)
;(use-package sublimity
;             :ensure t
;             :config
;             (sublimity-mode 1))
;(setq pixel-scroll-precision-large-scroll-height 40.0)
;(setq pixel-scroll-precision-interpolation-factor 30)

; Theme and font
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox t))
;(set-frame-font "JetBrains Mono 12" nil t)
(add-to-list 'default-frame-alist '(font . "JetBrains Mono 12"))

; Remove initial buffer, set index file
(setq inhibit-startup-message t)
;(setq initial-buffer-choice "index.org")

; Hide Scroll bar, menu bar, tool bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

; Line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

; display battery for when in full screen mode
(display-battery-mode t)

; Keybindings
; (global-set-key (kbd "<f5>") 'revert-buffer)
; (global-set-key (kbd "<f3>") 'org-export-dispatch)
; (global-set-key (kbd "<f6>") 'eshell)
; (global-set-key (kbd "<f7>") 'dired)
; (global-set-key (kbd "<f8>") 'magit)

; Misc stuff
(setenv "HOME" "/home/adri")
; (server-start)

; tab width
(setq-default tab-width 2)

; auto braces
(electric-pair-mode 1)
(setq electric-pair-preserve-balance 1)

; auto complete
(use-package auto-complete
  :ensure t
  :config
  (ac-config-default))

; comments
(global-set-key "\M-c" 'comment-line)
(global-set-key "\M-shift-c" 'comment-block)

; default mode
(setq-default major-mode 'text-mode)

; lsp
; (use-package lsp-mode
; :init
; (setq lsp-keymap-prefix "C-c l")
; :commands lsp)
; (add-hook 'lsp (c-mode))
; (add-hook 'lsp (rust-mode))
; (add-hook 'lsp (python-mode))
; (add-hook 'lsp (makefile-mode))
; (add-hook 'lsp (makefile-gmake-mode))

; (setq lsp-file-watch-threshold 10000)

; C/C++
(use-package clang-format)
(require 'clang-format)
(setq clang-format-style "file")
(defun setup-c-mode () (add-hook 'before-save-hook 'clang-format-buffer))
(add-hook 'c-mode-common-hook 'setup-c-mode)
(c-toggle-comment-style)

; assembly
(require 'asm-mode)
(add-hook 'asm-mode-hook (lambda ()
													 (setq indent-tabs-mode nil) ; use spaces to indent
													 (electric-indent-mode -1) ; indentation in asm-mode is annoying
                           (setq tab-stop-list (number-sequence 2 60 2))))

(define-key asm-mode-map (kbd "<ret>") 'newline-and-indent)
(define-key asm-mode-map (kbd "M-.") 'helm-etags-select)

; rust
(use-package rust-mode)
(use-package racer)
(define-key rust-mode-map (kbd "C-c C-c") 'rust-run)
; (define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)
; (setq company-tooltip-align-annotations t)

; python
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred

; markdown
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
