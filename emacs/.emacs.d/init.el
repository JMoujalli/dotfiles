;; Package Repositories
(require 'package)
(add-to-list 'package-archives '("gnu-devel"   . "https://elpa.gnu.org/devel/"))
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
(setq backup-inhibited nil)
(setq create-lockfiles nil)

;; Disables the dialog UI elements that pop up.
(setq use-dialog-box nil)

;; Startup
(setq inhibit-splash-screen t)

;; Obtained from someone on the Internet. Can't recall exactly who.
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
;; Need to install en_AU in hunspell with sudo pacman -S hunspell-en_AU (Depending on OS).
(setq flyspell-issue-message-flag nil)
(setq ispell-program-name "hunspell")
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
  :defer t)
(global-set-key (kbd "C-c m") 'notmuch)

;; NOTE: Configure this at a later date. 
;; (use-package notmuch-indicator :ensure t)

;; Git
(use-package magit :ensure t)

;; Org
(use-package org :ensure t)

;; NOTE: Maybe worth configuring org-modern to improve the look of org-agenda.
;; (use-package org-modern :ensure t)
;; (with-eval-after-load 'org (global-org-modern-mode))

;; org-agenda
(global-set-key (kbd "C-c a") 'org-agenda)

;; NOTE: Stores links that can be called in org files with C-c C-l.
(global-set-key (kbd "C-c l") 'org-store-link)
 
;; org-mode notes
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/org/Notes/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
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

;; If spacious-padding is not high enough in the init file there are visual bugs. Must be before all those below this position.
(use-package spacious-padding
  :ensure t
  :config
  (setq spacious-padding-subtle-mode-line
      `( :mode-line-active 'default
         :mode-line-inactive vertical-border)))
;; Disabled for now as it causes visual bugs when using transparency.
(spacious-padding-mode 0)


;; Modeline customisation
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Completion
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.snippets/"))
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

(use-package olivetti :ensure t)

(global-set-key (kbd "C-z") 'eshell)

;; Appearance
;; NOTE: This is now set in the early-init-file to prevent a change in size on startup.
;; (add-to-list 'default-frame-alist '(font . "IosevkaTerm Nerd Font-12"))
;; (set-face-attribute 'default t :font "IosevkaTerm Nerd Font-12")

;; Truncated lines. Trying to force line wrapping.
(set-default 'truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; NOTE: org-mode files prevent changing line truncation settings. This is so that tables are not displayed incorrectly. I am turning this off because I don't use tables yet.
(add-hook 'org-mode-hook
      (lambda ()
        (toggle-truncate-lines nil) ))

;; May want to enable whitespace at a later date so I am keeping this here.
;; NOTE: When disabling whitespace mode buffers need to be updated to change the whitespaces.
;; (global-whitespace-mode 0)
;; (setq-default whitespace-style
	      ;; '(face spaces empty tabs newline trailing space-mark tab-mark))

;; Should create a keybinding or a hook to enable/disable line numbers in various modes (i.e. When editing files line numbers should be enabled. When reading files line numbers should be disabled.) When in a Python file for example line numbers and whitespace-mode should both be enabled.
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Transparency
;; Only works with a compositor enabled (e.g. Picom).
(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))

;; Theme
;; NOTE: When making changes to init.el sometimes init.elc (byte compiled version of init.el?) exists and overrides any changes. Delete this file and the changes will take effect. 
;; Puts the custom-file in /tmp. This removes the part the is automatically generated by Emacs and placed at the end of the init file. This prevents conflicts with custom and init configuration.
(setq custom-file (make-temp-file "emacs-custom-"))

(setq custom-safe-themes t)
(use-package gruber-darker-theme :ensure t)
;; (load-theme 'gruber-darker t)
;; (global-set-key (kbd "C-x t") 'modus-themes-toggle)
(load-theme 'modus-vivendi t)
