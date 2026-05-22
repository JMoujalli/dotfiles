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
(setq auto-save-default nil)

;; Disables the dialog UI elements that pop up.
(setq use-dialog-box nil)

;; Start Emacs in a scratch buffer.
(setq inhibit-splash-screen t)

;; Elfeed for RSS feeds and YouTube videos. Great for keeping up to date without the google data mining.
;; Maybe want to configure elfeed-dashboard to help with managing what is being looked at. May also want to add elfeed-goodies to get split pane setup.
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
  (setq rmh-elfeed-org-files (list "~/Documents/org/elfeed.org")))

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

;; Spelling and Grammar check
;; To have langtool working the .jar needs to be downloaded and Java installed.
(use-package langtool
  :ensure t
  :config
  (setq langtool-language-tool-jar "~/dotfiles/emacs/.emacs.d/LanguageTool-6.6/languagetool-commandline.jar")
  (setq langtool-default-language "en-AU")
  (setq langtool-mother-tongue "en"))

;; Buffer local variable to identify whether langtool is on or off.
(defvar-local langtool-value nil)

;; Function to toggle langtool on or off.
(defun langtool-toggle ()
  "Toggle langtool on or off. No distinction is made between code and text"
  (interactive)
  (if langtool-value
      (progn ; Langtool is on. Turn it off.
	(setq langtool-value nil)
	(langtool-check-done))
    (setq-local langtool-value 1)
    (langtool-check)))

(global-set-key (kbd "C-'") 'langtool-toggle)

;; Removes the C-' binding from org mode so it can be used for langtool.
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

;; Fix LaTeX compiler options
;; (setq org-latex-pdf-process (quote ("texi2dvi -p -b -V %f")))
(setq org-latex-pdf-process (list "latexmk -f -pdf %f"))

;; Denote
(use-package denote
  :ensure t)

(setq denote-directory "~/Documents/org/")

(setq denote-templates
      '((biblio . "%^{doi-url}")
        (plain . nil))
      citar-denote-template 'biblio)

;; Citar
(use-package citar
  :ensure t
  :bind ("C-c x n" . citar-open))

(setq citar-bibliography "~/Documents/org/Bibliography/global.bib")
(setq citar-open-always-create-notes nil)

;; Open pdf files with Zathura. This is outside of Emacs because I prefer this.
(setq citar-file-open-functions
      '(("pdf" . (lambda (file)
                   (call-process "zathura" nil 0 nil file)))
        (t . find-file)))

(global-unset-key (kbd "C-x C-c"))

;; Global bibliography
;; Will setting the org-cite global bib conflict with the citar bibliography?  
(setq org-cite-global-bibliography '("~/Documents/org/Bibliography/global.bib"))

;; Citar-denote
(use-package citar-denote
  :ensure t
  :demand t ;; Ensure minor mode loads
  :after (:any citar denote)
  :custom
  ;; Package defaults
  (citar-denote-file-type 'org)
  (citar-denote-keyword "bib")
  (citar-denote-signature nil)
  (citar-denote-subdir "Bibliography")
  (citar-denote-title-format "author-year-title")
  (citar-denote-title-format-andstr "")
  (citar-denote-title-format-authors 1)
  (citar-denote-use-bib-keywords nil)
  :preface
  (bind-key "C-c x o" #'citar-denote-open-note)
  :init
  (citar-denote-mode)
  ;; Bind all available commands
  :bind (("C-c x d" . citar-denote-dwim)
	 ("C-c x e" . citar-denote-open-reference-entry)
	 ("C-c x a" . citar-denote-add-reference)
	 ("C-c x k" . citar-denote-remove-citekey)
	 ("C-c x r" . citar-denote-find-reference)
	 ("C-c x l" . citar-denote-link-reference)
	 ("C-c x f" . citar-denote-find-citation)
	 ("C-c x x" . citar-denote-nocite)
	 ("C-c x y" . citar-denote-cite-nocite)
	 ("C-c x z" . citar-denote-nobib)))

(defun open-citar-bibliography ()
  "Open the bibliography file associated with citar. Useful for creating new bibliography entries."
  (interactive)
  (find-file citar-bibliography)
  (goto-char (point-max))
  (point)
  (switch-to-buffer (find-buffer-visiting citar-bibliography)))

;; Set to "showeverything" to have all headings shown.
;; (setq org-startup-folded showeverything)

;; org-agenda
(global-set-key (kbd "C-c a") 'org-agenda)

;; NOTE: Need to re-evaluate the following in order for new org files to be added to the agenda files.
(defun refresh-init ()
  "Re-evaluate the Emacs init.el file."
  (interactive)
  (load-file user-init-file))
(global-set-key (kbd "C-x C-r") 'refresh-init)

(setq org-agenda-files (directory-files-recursively "~/Documents/org/Agenda/" "\\.org$"))

;; org-capture
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-directory "~/Documents/org/")
(setq org-default-notes-file "~/Documents/org/Agenda/refile.org")

;; Capture templates.
(setq org-capture-templates
      (quote (("t" "To do" entry (file org-default-notes-file)
	       "* TODO %?\n%U\n%a\n")
	      ("m" "Meeting" entry (file org-default-notes-file)
	       "* MEETING with %? :MEETING:\n%U")
	      ("r" "Reference" plain (file org-default-notes-file)
	       ""
	       :immediate-finish t
	       :after-finalize open-citar-bibliography)
	      ("n" "Note" plain (file denote-last-path)
               (function
                (lambda ()
                  (denote-org-capture-with-prompts :title :keywords :subdirectory)))
               :no-save t
               :immediate-finish nil
               :kill-buffer t
               :jump-to-captured t)
	      ("j" "Journal" plain
                 (file denote-last-path)
                 (function
                  (lambda ()
                    ;; The "journal" subdirectory of the `denote-directory'---this must exist!
                    (let* ((denote-use-directory (expand-file-name "Journal" (denote-directory)))
                           ;; Use the existing `denote-prompts' as well as the one for a date.
                           (denote-prompts (denote-add-prompts '(date))))
                      (denote-org-capture))))
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t))))

(setq org-refile-targets (quote ((nil :maxlevel . 9)
                                 (org-agenda-files :maxlevel . 9))))
;; Keywords
(setq org-use-fast-todo-selection t)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	      (sequence "WAITING(w)" "INACTIVE(i)" "|" "CANCELLED(c)")
	      (type "MEETING(m)"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "salmon" :weight bold)
	      ("NEXT" :foreground "deep sky blue" :weight bold)
	      ("MEETING" :foreground "salmon" :weight bold)
	      ("DONE" :foreground "green" :weight bold)
	      ("WAITING" :foreground "orange" :weight bold)
	      ("CANCELLED" :foreground "dim gray" :weight bold)
	      ("INACTIVE" :foreground "dim gray" :weight bold)
	      )))

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
	      ("DONE" ("WAITING") ("CANCELLED") ("INACTIVE")))))

;; Custom agenda views. Good luck understanding this...
;; TODO Add documentation for this section specifically! <2024-10-18 Fri>
(setq org-agenda-custom-commands
      (quote ((" " "Agenda"
	       ((agenda ""
		       ;; Press j to go to a specific date to see what items are scheduled.
		      ((org-agenda-overriding-header "")
		       (org-agenda-span 1)
		       (org-deadline-warning-days 0)))
		(tags "REFILE"
		      ((org-agenda-overriding-header "Refile:")
		       (org-tags-match-list-sublevels nil)))
		(agenda ""
		      ((org-agenda-start-on-weekday nil)
		       (org-agenda-span 365)
		       (org-agenda-show-future-repeats nil)
		       (org-agenda-show-all-dates nil)
		       (org-deadline-warning-days 0)
		       (org-agenda-start-day "+1d")
		       (org-agenda-skip-function '(org-agenda-skip-entry-if 'todo '("DONE")))
		       (org-agenda-overriding-header "Scheduled Tasks and Deadlines:")))
		(tags-todo "-DONE-CANCELLED-WAITING-INACTIVE"
		      ((org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
		       (org-agenda-overriding-header "Unscheduled Tasks:")))
		(tags "WAITING"
		      (
		       (org-agenda-skip-function '(org-agenda-skip-if nil '(timestamp)))
		       (org-agenda-overriding-header "Waiting and Inactive Tasks:")))
		))
)))

;; What happens when org agenda starts and stops:
(setq org-agenda-window-setup 'only-window)
(setq org-agenda-restore-windows-after-quit t)

;; NOTE: Stores links that can be called in org files with C-c C-l. It is recommended to have this set to a keybinding, thus it is here. I have yet to use it for anything...
(global-set-key (kbd "C-c l") 'org-store-link)

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
;; (use-package yasnippet
;;   :ensure t
;;   :config
;;   (setq yas-snippet-dirs '("~/.emacs.d/.emacs.snippets/"))
;;   (yas-global-mode 1))

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

(global-set-key (kbd "C-z") 'eshell)

;; Appearance
(global-set-key (kbd "C-x t l") 'global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

;; Truncated lines. Trying to force line wrapping.
(set-default 'truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; NOTE: org-mode files prevent changing line truncation settings. This is so that tables are not displayed incorrectly. I am turning this off because I don't use tables yet.
(add-hook 'org-mode-hook
      (lambda ()
        (toggle-truncate-lines nil)))

;; Puts the custom-file in /tmp. This removes the part the is automatically generated by Emacs and placed at the end of the init file. This prevents conflicts with custom and init configuration.
(setq custom-file (make-temp-file "emacs-custom-"))

(setq custom-safe-themes t)

(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("C-x t s" . modus-themes-select))
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)

  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  (modus-themes-load-theme 'ef-bio))

;; NOTE: May want to set a dark theme and a light theme default. Have "C-x t t" toggle the theme between light and dark.
;; May want to add parity between emacs themes and the i3/GTK/Qt themes at a later point. In the mean time probably just have the default themes match i3.
