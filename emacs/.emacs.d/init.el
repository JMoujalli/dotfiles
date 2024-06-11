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
(setq make-backup-files nil)

;; (setq backup-directory-alist `(("." . "~/.saves")))
;; (setq backup-by-copying t)
;; (setq delete-old-versions t)

;; Disables the dialog UI elements that pop up.
(setq use-dialog-box nil)

;; Modeline customisation
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Startup
(setq inhibit-splash-screen t)

;; Obtained from someone on the internet. Can't recall exactly who.
(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

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

;; Email
(use-package notmuch
  :ensure t
  :defer t
  :bind (("C-c m" . notmuch-hello)))

;; Git
(use-package magit :ensure t)

;; Org
(use-package org :ensure t)

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/Notes/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

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
(use-package vertico
  :ensure t
  :config
  (setq vertico-count 5)
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

;; Code
(require 'compile)

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
;; NOTE: When disabling whitespace mode buffers need to be updated to change the whitespaces.
;; (global-whitespace-mode 1)
;; (setq-default whitespace-style
;; 	      '(face spaces empty tabs newline trailing space-mark tab-mark))

;; (global-display-line-numbers-mode 1)
;; (setq display-line-numbers-type 'relative)

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
   '(ox-rss htmlize org-contrib doom-modeline org-roam orderless marginalia vertico alarm-clock helm-lsp flycheck helm-xref helm projectile dap-mode lsp-mode magit gruber-darker-theme dashboard)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
