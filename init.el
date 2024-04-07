;; Setup use-package. Mostly needed in non-linux and old versions of Emacs.
;; This breaks with older versions, specifically in Debian, for some reason.
;; Will look into further shortly.

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))


;; Setting the theme first

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(wombat))
 '(package-selected-packages
   '(sudo-edit magit lsp-mode flycheck which-key pdf-tools all-the-icons dashboard xah-fly-keys)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-latex-subscript-face ((t nil)))
 '(font-latex-superscript-face ((t nil))))

;; Configuring the Emacs backups.
(setq backup-directory-alist `(("." . "~/.saves")))

;; Some basic Emacs configuration.
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)

;; Dashboard setup

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

;; Sets the dictionary.
;; Need to install en_AU in hunspell with sudo pacman -S hunspell-en_AU
(setq ispell-dictionary "en_AU")

;; AUCTeX for efficient editing of LaTeX documents.
;; (use-package tex
;;   :ensure auctex
;;   :config
;;   ;; Recommended settings found throughout the documentation.
;;   (setq TeX-auto-save t)
;;   (setq TeX-parse-self t)
;;   (setq-default TeX-master nil)
;;   (setq TeX-PDF-mode t)
;;   (add-hook 'TeX-mode-hook 'visual-line-mode)
;;   (add-hook 'TeX-mode-hook 'flyspell-mode)
;;   (add-hook 'TeX-mode-hook 'LaTeX-math-mode)
;;   (add-hook 'TeX-mode-hook 'turn-on-reftex)
;;   ;; Enables folding mode. Need to press C-c C-o C-b to fold and C-c C-o b to unfold.
;;   (add-hook 'TeX-mode-hook
;; 	    (lambda () (TeX-fold-mode 1)))
;;   (setq reftex-plug-into-AUCTeX t)
;;   ;; Prevents the sections from having a different font size. 
;;   (setq font-latex-fontify-sectioning 1.0)
;;   ;; Trying to stop changing of font.
;;   (setq font-latex-script-display (quote (nil)))
;;   (custom-set-faces
;;   '(font-latex-subscript-face ((t nil)))
;;   '(font-latex-superscript-face ((t nil)))
;;   )
;;   ;; Using PDF Tools to show rendered pdf.
;;   (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
;; 	TeX-source-correlate-start-server t)
;;   ;; Reloads the pdf tools buffer after compiling is done. 
;;   (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer))

;; Git setup
(use-package magit :ensure t)
