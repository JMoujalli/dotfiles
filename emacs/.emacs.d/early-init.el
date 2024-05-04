;; Set colours early
(setq initial-frame-alist '((background-color . "#181818")))

;; Standard config
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(show-paren-mode 1)

;; Start maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
