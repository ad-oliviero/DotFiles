(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)


(set-face-attribute 'default nil :font "JetBrains Mono" :height 120)

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
	     '("non-gnu-elpa" . "https://elpa.nongnu.org/nongnu/"))
(package-initialize)
;;(package-refresh-contents)

(unless (package-installed-p 'evil)
  (package-install 'evil))
(custom-set-variables
 '(custom-safe-themes
   '("cd4d1a0656fee24dc062b997f54d6f9b7da8f6dc8053ac858f15820f9a04a679" default))
 '(package-selected-packages '(gruvbox-theme gnu-elpa evil)))

(load-theme 'gruvbox)

(require 'evil)
(evil-mode 1)
