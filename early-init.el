;; Set colours early
(setq initial-frame-alist '((background-color . "black")))

;; Standard config
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)

;; Start maximized
(add-to-list 'initial-frame-alist '(fullscreen . maximized))
