;; MOST OF THIS CONFIG IS TAKEN FROM https://github.com/matman26/emacs-config

(setq user-emacs-directory "/home/adri/.emacs.d")

;; setup repos 
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; setup use-package if not installed
(eval-after-load 'gnutls
  '(add-to-list 'gnutls-trustfiles "/etc/ssl/cert.pem"))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(require 'bind-key)
(setq use-package-always-ensure t)

(package-initialize)
(require 'package)
(require 'use-package)

(use-package org
  :ensure t)

(use-package undo-tree)
(global-undo-tree-mode)
(use-package evil
  :ensure t
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-tree))

;; Theme and font
(use-package gruvbox-theme
  :config
  (load-theme 'gruvbox t))
(set-frame-font "JetBrains Mono 12" nil t)

;; Remove initial buffer, set index file
(setq inhibit-startup-message t)
;;(setq initial-buffer-choice "index.org")

;; Hide Scroll bar,menu bar, tool bar
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Line numbering
(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; display battery for when in full screen mode
(display-battery-mode t)

;; Keybindings
(global-set-key (kbd "<f5>") 'revert-buffer)
(global-set-key (kbd "<f3>") 'org-export-dispatch)
(global-set-key (kbd "<f6>") 'eshell) 
(global-set-key (kbd "<f7>") 'dired) 
(global-set-key (kbd "<f8>") 'magit) 

;; Misc stuff
(fset 'yes-or-no-p 'y-or-n-p)
(setenv "HOME" "/home/adri")
;; (server-start)


;; ------- OTHER PACKAGES -------

;; auto braces
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)

(use-package try
  :ensure t)

(use-package which-key

  :config 
    (setq which-key-idle-delay 0.3)
    (setq which-key-popup-type 'frame)
    (which-key-mode)
    (which-key-setup-minibuffer)
    (set-face-attribute 'which-key-local-map-description-face nil 
       :weight 'bold)
  :ensure t)

;; auto complete
(use-package auto-complete
  :ensure t
  :config 
  (ac-config-default)
)

;; comments
(global-set-key "\M-c" 'comment-line)
(global-set-key "\M-shift-c" 'comment-block)

;; lsp
(setq lsp-keymap-prefix "s-l")
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
	 (rust-mode . lsp)
	 (python-mode . lsp)
	 (c-mode . lsp)
	 ;; if you want which-key integration
	 (lsp-mode . lsp-enable-which-key-integration)
	 (lsp-evil-multiedit-highlights . lsp))
  :commands lsp)
(setq lsp-file-watch-threshold 10000)

;; C/C++
(use-package clang-format)
(require 'clang-format)
(setq clang-format-style "file")
(add-hook 'c-mode-common-hook
	  (function (lambda ()
		      (add-hook 'before-save-hook
				'clang-format-buffer))))

;; rust
(use-package rust-mode)
;;(add-hook 'after-save-hook 'rustic-format-buffer) ;; works, but formats in two different ways at the same time
(add-hook 'rust-mode-hook
	  (lambda () (prettify-symbols-mode)))
(use-package racer)
(add-hook 'rust-mode-hook 'racer-mode)
(define-key rust-mode-map (kbd "C-c C-c") 'rust-run)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
(add-hook 'racer-mode-hook 'company-mode)
(define-key rust-mode-map (kbd "TAB") 'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; python
(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
			 (require 'lsp-pyright)
			 (lsp))))  ; or lsp-deferred

;; markdown
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil-multiedit which-key use-package undo-tree try rustic racer lsp-pyright helm gruvbox-theme flycheck evil elpy clang-format clang-capf auto-complete auctex)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
