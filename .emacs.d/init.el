;;MOST OF THIS CONFIG IS TAKEN FROM https://github.com/matman26/emacs-config

(require 'package)
(add-to-list 'package-archives '("gnu"."http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable"."http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa"."http://melpa.org/packages/"))
(package-initialize)

;;save the current session
;;(desktop-save-mode 1)

;;always open a buffer in a new tab
;;(setq display-buffer-base-action '(display-buffer-in-tab))

;;setup use-package if not installed
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(use-package org
	:ensure t)

(use-package undo-tree)
(global-undo-tree-mode)
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

;;scroll one line at a time (less "jumpy" than defaults)
;(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))) ; one line at a time
;(setq mouse-wheel-progressive-speed nil) ; don't accelerate scrolling
;(setq mouse-wheel-follow-mouse 't) ; scroll window under mouse
;(setq scroll-step .1) ; keyboard scroll one line at a time
;;smooth scrolling
;(pixel-scroll-mode 1)
(use-package good-scroll)
(good-scroll-mode 1)
;(use-package sublimity
;;            :ensure t
;;            :config
;;            (sublimity-mode 1))
;(setq pixel-scroll-precision-large-scroll-height 40.0)
;(setq pixel-scroll-precision-interpolation-factor 30)

;;Theme and font
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox t))
(add-to-list 'default-frame-alist '(font . "JetBrains Mono 12"))

;;Remove initial buffer, set index file
(setq inhibit-startup-message t)
;(setq initial-buffer-choice "index.org")

;;Hide Scroll bar, menu bar, tool bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;;Line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;;display battery for when in full screen mode
(display-battery-mode t)

(use-package treemacs)

;;Keybindings
(global-set-key (kbd "<f2>") 'treemacs)
(global-set-key (kbd "<f3>") 'magit)

;; tab width
(setq-default tab-width 2)

;; auto braces
(electric-pair-mode 1)
(setq electric-pair-preserve-balance 1)

;; comments
(global-set-key "\M-c" 'comment-line)
(global-set-key "\M-shift-c" 'comment-block)

;; default mode
;; (setq-default major-mode 'text-mode)

(use-package markdown-preview-mode)
(setq markdown-command "pandoc -s --mathjax -f markdown -t html")

(use-package lsp-mode
	:init
	(setq lsp-keymap-prefix "C-c l")
	:hook (c-mode . lsp)
	:hook (markdown-preview-mode . lsp)
	:commands lsp)

