;; Package Repositories
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t)
  (setq-default visual-fill-column-center-text t))

;; Emacs backups
;; The files get int he way and I don't use them ever.
(setq make-backup-files nil)

;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
;; (setq delete-old-versions t)

;; ido
;; (use-package ido-completing-read+ :ensure t)
;; (use-package smex :ensure t)

;; (ido-mode 1)
;; (ido-everywhere 1)
;; (ido-ubiquitous-mode 1)

;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; NOTE: smex and ido did not work for me. I often found myself fighting the completions. For example, when I wanted to go to ~/dotfiles/emacs/.emacs.d/ it would take me to ~/.emacs.d/ (Prior to when I was using Stow). When I tried to make files using C-x C-f with the same name as other files I needed to hit RET quickly so that it would not complete. I did not have such troubles with helm. I chose not to use helm because it felt to "bulky". I am currently using vertico. I may do some more tests but the current setup works for now.

;; Disables the dialog UI elements that pop up.
(setq use-dialog-box nil)

;; Dashboard
(setq inhibit-splash-screen t)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; (defun display-startup-echo-area-message ()
;;     (message "Message here."))

;; (use-package dashboard
;;   :ensure t
;;   :config
;;   (dashboard-setup-startup-hook)
;;   (setq dashboard-center-content t))

;; Elfeed for RSS feeds and YouTube videos.
(global-set-key (kbd "C-x w") 'elfeed)
(use-package elfeed
  :ensure t
  :defer t
  :config
  (setq-default elfeed-search-filter "@1-year-old"))

(use-package elfeed-org
  :ensure t
  :after elfeed
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/elfeed.org")))

(defun mpv-play-url (url &rest args)
  "Play the given URL in MPV."
  (interactive)
  (start-process "my-process" nil "mpv"
                        "--speed=1.0"
                        "--pause"
                        "--cache=yes"
                        "demuxer-max-bytes=5000M"
                        "demuxer-max-back-bytes=3000M" url))

(setq browse-url-handlers
      '(("youtu\\.?be.*\\.xml" . browse-url-default-browser)  ; Open YouTube RSS feeds in the browser
        ("youtu\\.?be" . mpv-play-url)))                      ; Use mpv-play-url for other YouTube URLs

;; Spell Check
;; Need to install en_AU in hunspell with sudo pacman -S hunspell-en_AU (Depending on OS)
(setq flyspell-issue-message-flag nil)
(setq ispell-dictionary "en_AU")

(defun flyspell-toggle ()
      "Turn Flyspell on if it is off, or off if it is on. No distinction is made between code and text."
      (interactive)
      (if (symbol-value flyspell-mode)
	  (progn ; flyspell is on, turn it off
	    (message "Flyspell off")
	    (flyspell-mode -1))
	  ; else - flyspell is off, turn it on
	(flyspell-mode 1)
	(flyspell-buffer)))

(global-set-key (kbd "C-'") 'flyspell-toggle)

;; I don't know how to unbind keys in every mode. Thus, I have manually removed it from the mode I need it in.
(add-hook 'org-mode-hook
          (lambda ()
                  (keymap-unset org-mode-map "C-'")))

;; Git
(use-package magit :ensure t)

;; Org
(use-package org :ensure t)

;; (use-package org-roam
;;   :ensure t)

;; Editing
(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "C-s-c C-s-c") 'mc/edit-lines)
  (global-set-key (kbd "C->")         'mc/mark-next-like-this)
  (global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this))

(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))

;; Not working for some reason.
(defun delete-other-buffers ()
  "Delte all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; Completion
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '(".emacs.snippets/"))
  (yas-global-mode 1))

(use-package company
  :ensure t
  :config
  (global-company-mode))

;; Adds a vertical layout to the minibuffer.
;; TODO Slightly decrease the number of items in the vertica list.
(use-package vertico
  :ensure t
  :config
  (setq vertico-cycle t)
  (setq vertico-resize nil)
  (vertico-mode 1))

;; Adds information in the "margin" of the minibuffer. This takes advantage of what would otherwise be unused space.
(use-package marginalia
  :ensure t
  :config
  (marginalia-mode 1))

;; Gives more complex completion suggestions.
(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic)))

;; Saves the history of the minibuffer for when emacs has been restarted.
(savehist-mode 1)

;; (use-package helm
;;   :ensure t
;;   :config
;;   (helm-mode)
;;   (global-set-key (kbd "M-x") #'helm-M-x)
;;   (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
;;   (global-set-key (kbd "C-x C-f") #'helm-find-files)
;;   (global-set-key (kbd "C-x b") #'helm-mini))

;; (use-package helm-xref :ensure t)
;; (require' helm-xref)

;; Code
(require 'compile)

;; (use-package lsp-mode
;;   :ensure t
;;   :config
;;   (add-hook 'c-mode-hook 'lsp)
;;   (add-hook 'c++-mode-hook 'lsp))

;; ;; Not quite sure if this will work. May remove at a later date.
;; (use-package dap-mode :ensure t)

;; (use-package helm-lsp :ensure t)

;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024)
;;       company-idle-delay 0.0
;;       company-minimum-prefix-length 1
;;       lsp-idle-delay 0.1)  ;; clangd is fast

;; (with-eval-after-load 'lsp-mode
;;   (require 'dap-cpptools))

(use-package flycheck
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'flycheck-mode))

;; (use-package projectile
;;   :ensure t
;;   :config
;;   (projectile-mode +1)
;;   (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(global-set-key (kbd "C-z") 'eshell)

;; Appearance
;; NOTE: This is now set in the early-init-file to prevent a change in size on startup.
;; (add-to-list 'default-frame-alist '(font . "IosevkaTerm Nerd Font-12"))
;; (set-face-attribute 'default t :font "IosevkaTerm Nerd Font-12")

;; NOTE: Whitespace mode works with the current theme but looks bad with other themes. Maybe want to add a toggle function similar to the flyspell toggle.
(global-whitespace-mode 1)
(setq-default whitespace-style
	      '(face spaces empty tabs newline trailing space-mark tab-mark))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Theme
(use-package gruber-darker-theme :ensure t)
;; NOTE: May be worth settings themes statically within the init.el file rather than through the customizse menus. More reading about this needed.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(orderless marginalia vertico alarm-clock helm-lsp flycheck helm-xref helm projectile dap-mode lsp-mode magit gruber-darker-theme dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
