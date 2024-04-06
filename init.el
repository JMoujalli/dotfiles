;; Setup use-package.
;; Uncomment only needed for Emacs 28 and prior.
;; May need to check that the current versions of packages support your version of Emacs.

(require 'package)
;; (add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))
;; (eval-and-compile
;;   (setq use-package-always-ensure t
;;         use-package-expand-minimally t))


;; Setting the theme first

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wombat))
 '(package-selected-packages
   '(sudo-edit magit lsp-mode flycheck which-key pdf-tools auctex all-the-icons dashboard xah-fly-keys)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-subscript-face ((t nil)))
 '(font-latex-superscript-face ((t nil))))

;; Xah-Fly-Keys is my preferred movement setup.
(use-package xah-fly-keys
  :ensure t
  :init
  (require 'xah-fly-keys)
  :config
  (xah-fly-keys 1))

;; Configuring the Emacs backups.
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)

;; Some basic Emacs configuration.
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;; Dashboard
;; The goal of the dashboard is to:
;; 1. Look cool.
;; 2. Quickly get me into the files I want i.e. Projects.
;; To start I will only use the recent files and bookmarks to get where I want.
;; Later I will use the recent files and projects to get where I want to be.

;; Nerd fonts icons for dashboard and other parts.
;; Need to run: M-x all-the-icons-install-fonts

;; copy paste from Distro Tube config. How to fix so it works?
(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(setq inhibit-splash-screen t)
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-items '((recents   . 5)
                          (bookmarks . 5))))

;; To help view pdfs in Emacs.
(use-package pdf-tools
  :ensure t
  :config
  (setq pdf-view-use-scaling nil))

;; Sets the dictionary.
;; Need to install en_AU in hunspell with sudo pacman -S hunspell-en_AU
(setq ispell-dictionary "en_AU")

;; AUCTeX for efficient editing of LaTeX documents.
(use-package tex
  :ensure auctex
  :config
  ;; Recommended settings found throughout the documentation.
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq-default TeX-master nil)
  (setq TeX-PDF-mode t)
  (add-hook 'TeX-mode-hook 'visual-line-mode)
  (add-hook 'TeX-mode-hook 'flyspell-mode)
  (add-hook 'TeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'TeX-mode-hook 'turn-on-reftex)
  ;; Enables folding mode. Need to press C-c C-o C-b to fold and C-c C-o b to unfold.
  (add-hook 'TeX-mode-hook
	    (lambda () (TeX-fold-mode 1)))
  (setq reftex-plug-into-AUCTeX t)
  ;; Prevents the sections from having a different font size. 
  (setq font-latex-fontify-sectioning 1.0)
  ;; Trying to stop changing of font.
  (setq font-latex-script-display (quote (nil)))
  (custom-set-faces
  '(font-latex-subscript-face ((t nil)))
  '(font-latex-superscript-face ((t nil)))
  )
  ;; Using PDF Tools to show rendered pdf.
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
	TeX-source-correlate-start-server t)
  ;; Reloads the pdf tools buffer after compiling is done. 
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))


;; Which-key. Installs and enables which-key. Not very useful right now but may find a use for it later.  
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; Git setup
(use-package magit :ensure t)

;; The following packages are setup to help with syntax highlighting in code. 
;; Shows syntax highlighting that may be useful. May disable later.
(use-package flycheck
  :ensure t
  :defer t
  :init (global-flycheck-mode))

(use-package lsp-mode :ensure t)

;; Sudo edit allows for the editing of files with sudo privliges.

(use-package sudo-edit :ensure t)
