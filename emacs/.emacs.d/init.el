;; Package Repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Emacs backups
(setq make-backup-files nil)
(setq backup-inhibited nil)
(setq create-lockfiles nil)

;; Disables the dialog UI elements that pop up.
(setq use-dialog-box nil)

;; Start Emacs in a scratch buffer.
(setq inhibit-splash-screen t)

;; Elfeed for RSS feeds and YouTube videos. Great for keeping up to date without the google data mining. 
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
;; Need to install hunspell and en_AU dictionary for hunspell (sudo pacman -S hunspell hunspell-en_AU).
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

;; Removes the C-' binding from org mode so it can be used for flyspell.
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

;; org-agenda
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-agenda-files (quote ("~/Documents/org/")))

;; These keys are unbound based on the recommendation from Bernt Hansen.
;; http://doc.norang.ca/org-mode.html#OrgFileStructure
(add-hook 'org-mode-hook
          (lambda ()
            (keymap-unset org-mode-map "C-[")
	    (keymap-unset org-mode-map "C-]")))

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-directory "~/Documents/org/")
(setq org-default-notes-file "~/Documents/org/refile.org")

;; Keywords
(setq org-use-fast-todo-selection t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w)" "INACTIVE(i)" "|" "CANCELLED(c)" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "salmon" :weight bold)
	      ("NEXT" :foreground "deep sky blue" :weight bold)
	      ("MEETING" :foreground "salmon" :weight bold)
	      ("DONE" :foreground "green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("CANCELLED" :foreground "dim gray" :weight bold)
	      ("INACTIVE" :foreground "dim gray" :weight bold))))

;; Capture templates.
(setq org-capture-templates
      (quote (("t" "todo" entry (file org-default-notes-file)
	       "* TODO %?\n%U\n%a\n")
	      ("m" "Meeting" entry (file org-default-notes-file)
	       "* MEETING with %? :MEETING:\n%U")
	      ("i" "Idea" entry (file org-default-notes-file)
	       "* %? :IDEA:\n%U"))))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; Using a more readable, for me, time format. 
(custom-set-variables
 '(org-display-custom-times t)
 '(org-time-stamp-custom-formats (quote ("%d/%m/%y %a" . "%d/%m/%y %a %H:%M"))))

;; NOTE: Stores links that can be called in org files with C-c C-l. It is recommended to have this set to a keybinding, thus it is here. I have yet to use it for anything...
(global-set-key (kbd "C-c l") 'org-store-link)
 
;; Org roam config based on suggested config. For note taking.
(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/org/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode))

;; Editing
(use-package move-text
  :ensure t
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))

(defun delete-other-buffers ()
  "Delete all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;; If spacious-padding is not high enough in the init file there are visual bugs. Must be before all those below this position.
(use-package spacious-padding
  :ensure t
  :config
  (setq spacious-padding-subtle-mode-line
      `( :mode-line-active 'default
         :mode-line-inactive vertical-border)))
(spacious-padding-mode 1)

;; Modeline customisation
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

;; Completion
(use-package yasnippet
  :ensure t
  :config
  (setq yas-snippet-dirs '("~/.emacs.d/.emacs.snippets/"))
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

(global-set-key (kbd "C-z") 'eshell)

;; Appearance

;; Truncated lines. Trying to force line wrapping.
(set-default 'truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; NOTE: org-mode files prevent changing line truncation settings. This is so that tables are not displayed incorrectly. I am turning this off because I don't use tables yet.
(add-hook 'org-mode-hook
      (lambda ()
        (toggle-truncate-lines nil) ))

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; Theme
;; Puts the custom-file in /tmp. This removes the part the is automatically generated by Emacs and placed at the end of the init file. This prevents conflicts with custom and init configuration.
(setq custom-file (make-temp-file "emacs-custom-"))

(setq custom-safe-themes t)
(use-package gruber-darker-theme :ensure t)
(load-theme 'gruber-darker t)
;; (global-set-key (kbd "C-x t") 'modus-themes-toggle)
;; (load-theme 'modus-vivendi t
