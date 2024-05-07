;; Setting these values early to prevent flashes or drastic movements.
(setq initial-frame-alist '((background-color . "#181818")))
(setq mode-line-format nil)

(add-to-list 'default-frame-alist '(font . "IosevkaTerm Nerd Font-12"))
(set-face-attribute 'default t :font "IosevkaTerm Nerd Font-12")

;; WARNING: Chang the following at your own risk.
(defvar old-file-name-handler file-name-handler-alist)
(defvar old-vc-handeled-backends vc-handled-backends)
(setq file-name-handler-alist nil
      vc-handled-backends nil
      gc-cons-threshold most-positive-fixnum)

(add-hook 'after-init-hook
	  (lambda nil
	    (setq gc-cons-threshold     16777216
		  gc-cons-percentage   0.1
		  file-name-handler-alist old-file-name-handler
		  vc-handled-backends old-vc-handeled-backends)))

;; Standard config
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(show-paren-mode 1)

;; Start maximized
;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))
