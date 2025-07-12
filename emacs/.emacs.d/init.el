;; Use-package setup
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

(setq package-install-upgrade-built-in t)

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
;; (setq ispell-program-name "hunspell")
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

;; Set to "showeverything" to have all headings shown.
(setq org-startup-folded t)

;; org-agenda
(global-set-key (kbd "C-c a") 'org-agenda)

;; I am uncertain with the best method to add directories. For now I will take every org file in my Syncthing folder to be an agenda file. In the future it may prove best to just add the folders I need manually, for example:
;; (setq org-agenda-files (quote ("~/Documents/org"
;;                                "~/Projects"
;;                                "~/etc")))

;; NOTE: Need to re-evaluate the following in order for new org files to be added to the agenda files.
(defun refresh-init ()
  "Re-evaluate the Emacs init.el file."
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-x C-r") 'refresh-init)

(setq org-agenda-files (directory-files-recursively "~/Sync/" "\\.org$"))

;; These keys are unbound based on the recommendation from Bernt Hansen.
;; http://doc.norang.ca/org-mode.html#OrgFileStructure
(add-hook 'org-mode-hook
          (lambda ()
            (keymap-unset org-mode-map "C-[")
	    (keymap-unset org-mode-map "C-]")))

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-directory "~/Sync/")
(setq org-default-notes-file "~/Sync/org/refile.org")

;; Keywords
(setq org-use-fast-todo-selection t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w)" "INACTIVE(i)" "|" "CANCELLED(c)")
	      (type "PROJECT(p)" "MEETING(m)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "salmon" :weight bold)
	      ("NEXT" :foreground "deep sky blue" :weight bold)
	      ("PROJECT" :foreground "yellow" :weight bold)
	      ("MEETING" :foreground "salmon" :weight bold)
	      ("DONE" :foreground "green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("CANCELLED" :foreground "dim gray" :weight bold)
	      ("INACTIVE" :foreground "dim gray" :weight bold)
	      )))

;; Capture templates.
(setq org-capture-templates
      (quote (("t" "todo" entry (file org-default-notes-file)
	       "* TODO %?\n%U\n%a\n")
	      ("m" "Meeting" entry (file org-default-notes-file)
	       "* MEETING with %? :MEETING:\n%U")
	      ("p" "Project" entry (file org-default-notes-file)
	       "* PROJECT %?")
	      ("i" "Idea" entry (file org-default-notes-file)
	       "* %? :IDEA:\n%U"))))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))

;; Using a more readable, for me, time format. 
(custom-set-variables
 '(org-display-custom-times t)
 '(org-time-stamp-custom-formats (quote ("%d/%m/%y %a" . "%d/%m/%y %a %H:%M"))))

;; Tags for when in states other than TODO and NEXT as these don't need to be visible.
;; NOTE: Waiting and inactive tags can only be removed if moving to todo, next, or done.
(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
	      ("WAITING" ("WAITING" . t))
	      ("INACTIVE" ("WAITING" . t) ("INACTIVE" . t))
	      (done ("WAITING") ("INACTIVE"))
	      ("TODO" ("WAITING") ("CANCELLED") ("INACTIVE"))
	      ("NEXT" ("WAITING") ("CANCELLED") ("INACTIVE"))
	      ("DONE" ("WAITING") ("CANCELLED") ("INACTIVE"))
	      ("PROJECT" ("WAITING") ("CANCELLED") ("INACTIVE")))))

;; These functions were necessary as the "org-agenda-filter-by-tag" function showed days in the agenda view even if they had no items.
;; Functions from:
;; https://stackoverflow.com/questions/10074016/org-mode-filter-on-tag-in-agenda-view/33444799#33444799
(defun my/org-match-at-point-p (match)
  "Return non-nil if headline at point matches MATCH.
Here MATCH is a match string of the same format used by
`org-tags-view'."
  (funcall (cdr (org-make-tags-matcher match))
           (org-get-todo-state)
           (org-get-tags-at)
           (org-reduced-level (org-current-level))))

(defun my/org-agenda-skip-without-match (match)
  "Skip current headline unless it matches MATCH.

Return nil if headline containing point matches MATCH (which
should be a match string of the same format used by
`org-tags-view').  If headline does not match, return the
position of the next headline in current buffer.

Intended for use with `org-agenda-skip-function', where this will
skip exactly those headlines that do not match." 
  (save-excursion
    (unless (org-at-heading-p) (org-back-to-heading)) 
    (let ((next-headline (save-excursion
                           (or (outline-next-heading) (point-max)))))
      (if (my/org-match-at-point-p match) nil next-headline))))


;; Custom agenda views. Good luck understanding this...
;; TODO Add documentation for this section specifically! <2024-10-18 Fri>
(setq org-agenda-custom-commands
      (quote ((" " "Agenda"
	       ((agenda ""
			;; Press j to go to a specific date to see what items are scheduled.
		      ((org-agenda-overriding-header "Today:")
		       (org-agenda-span 1)
		       (org-deadline-warning-days 0)))
		(tags "REFILE"
		      ((org-agenda-overriding-header "Refile:")
		       (org-tags-match-list-sublevels nil)))
		(agenda ""
		      ((org-agenda-start-on-weekday nil)
		       (org-agenda-span 3)
		       (org-agenda-show-all-dates nil)
		       (org-deadline-warning-days 0)
		       (org-agenda-start-day "+1d")
		       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
		       (org-agenda-overriding-header "Upcoming (+3d)")))
		(agenda ""
		      ((org-agenda-start-on-weekday nil)
		       (org-agenda-span 14)
		       (org-agenda-show-all-dates nil)
		       (org-deadline-warning-days 0)
		       (org-agenda-start-day "+4d")
		       ;; (org-agenda-block-separator nil)
		       (org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))
		       (org-agenda-overriding-header "Upcoming Deadlines (+14d):")))
		(tags-todo "-PROJECT-DONE-CANCELLED-WAITING-INACTIVE"
		      ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
		       (org-agenda-overriding-header "Unscheduled Tasks:")))
		(tags "WAITING"
		      (
		       ;; (org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
		       (org-agenda-overriding-header "Waiting and Inactive Tasks:")))
		(todo "PROJECT"
		      ((org-tags-match-list-sublevels nil)
		       (org-agenda-overriding-header "Projects:")))
		))
	      ("p" "Projects"
	       ((agenda ""
		      ((org-agenda-overriding-header "Deadlines and Scheduled Events:")
		       (org-deadline-warning-days 0)
		       (org-agenda-span 'month 2)
		       (org-agenda-skip-function '(my/org-agenda-skip-without-match "+PROJECT"))
		       (org-agenda-show-all-dates nil)
		       (org-agenda-start-on-weekday nil)
		       (org-agenda-time-grid nil)
		       (org-agenda-start-day "+0d")))
		;; (todo "PROJECT"
		;;       ((org-tags-match-list-sublevels nil)
		;;        (org-agenda-overriding-header "Projects:")))
		(tags "PROJECT"
		      ((org-agenda-overriding-header "Projects:")
		       (org-tags-match-list-sublevels 'indented)
		       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE" "CANCELLED")))
		       ))
		))
)))

;; What happens when org agenda starts and stops:
(setq org-agenda-window-setup 'only-window)
(setq org-agenda-restore-windows-after-quit t)

;; NOTE: Stores links that can be called in org files with C-c C-l. It is recommended to have this set to a keybinding, thus it is here. I have yet to use it for anything...
;; Maybe can be used with pdftools to have a link for notes on a particular point.
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

;; Disable line numbers only when in pdf view mode.
;; NOTE: I think this may be built in now?
;; https://github.com/minad/consult/discussions/853
(require 'display-line-numbers)
(defun display-line-numbers--turn-on ()
  "Turn on `display-line-numbers-mode'."
  (unless (or (minibufferp) (eq major-mode 'pdf-view-mode))
    (display-line-numbers-mode)))

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
;; (load-theme 'modus-vivendi t)
