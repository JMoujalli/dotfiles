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
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t)

;; ido
(use-package ido-completing-read+ :ensure t)
(use-package smex :ensure t)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Dashboard
(setq inhibit-splash-screen t)
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t))

;; Elfeed for RSS feeds and YouTube videos.
(use-package elfeed
  :ensure t
  :defer t
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  (setq-default elfeed-search-filter "@1-year-old"))

(use-package elfeed-org
  :ensure t
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
      "Turn Flyspell on if it is off, or off if it is on.  When turning on, it uses `flyspell-on-for-buffer-type' so code-vs-text is handled appropriately."
      (interactive)
      (if (symbol-value flyspell-mode)
	  (progn ; flyspell is on, turn it off
	    (message "Flyspell off")
	    (flyspell-mode -1))
	  ; else - flyspell is off, turn it on
	(flyspell-mode 1)
	(flyspell-buffer)))

(keymap-global-set "C-'" 'flyspell-toggle)

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

;; Code
(require 'compile)

(keymap-global-set "C-z" 'shell)

;; Appearance
(add-to-list 'default-frame-alist '(font . "IosevkaTerm Nerd Font-18"))
(set-face-attribute 'default t :font "IosevkaTerm Nerd Font-18")

(global-whitespace-mode 1)
(setq-default whitespace-style
	      '(face spaces empty tabs newline trailing space-mark tab-mark))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Theme
(use-package gruber-darker-theme :ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(gruber-darker))
 '(custom-safe-themes
   '("e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages '(magit gruber-darker-theme dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
