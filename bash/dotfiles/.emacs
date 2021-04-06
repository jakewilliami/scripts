;; Added Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; allow tab key
(global-set-key (kbd "TAB") 'self-insert-command)

;; Set tab key to four spaces
(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ;; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)

;; Disable automatic indentations
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Allow commenting/uncommenting code
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "M-/") 'toggle-comment-on-line)

;; instead of emacs creating a *~ file in the current directory, create backup file elsewhere
(setq backup-directory-alist `(("." . "~/.saves")))

;; do something with #file-being-edited#
;; requires `cd ~/.emacs.d/; git clone https://github.com/emacscollective/no-littering.git`
(add-to-list 'load-path "~/.emacs.d/no-littering/")
(require 'no-littering)

;; packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; M-x package-refresh-contents ENTER
;; run M-x package-install ENTER ess ENTER
;; namely for R syntax highlighting
;; The following 12 lines are machine-generated
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes '(tsdh-dark))
 '(package-selected-packages '(haskell-mode nlinum ess)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "cyan"))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

;; set shell to bash
(setenv "SHELL" "/usr/local/bin/bash")
(setq explicit-shell-file-name "/usr/local/bin/bash")

;; set colour of shell
  


;; find matching parenthesis
(global-set-key "%" 'match-paren)
          
          (defun match-paren (arg)
            "Go to the matching paren if on a paren; otherwise insert %."
            (interactive "p")
            (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
                  ((looking-at "\\s)") (forward-char 1) (backward-list 1))
                  (t (self-insert-command (or arg 1)))))


;; Add line numbers
(global-display-line-numbers-mode)
;; Preset `nlinum-format' for minimum width.
;; (defun my-nlinum-mode-hook ()
  ;; (when nlinum-mode
    ;; (setq-local nlinum-format
                ;; (concat "%" (number-to-string
                             ;; Guesstimate number of buffer lines.
                             ;; (ceiling (log (max 1 (/ (buffer-size) 80)) 10)))
                        ;; "d"))))
;; (add-hook 'nlinum-mode-hook #'my-nlinum-mode-hook)

;; add julia support
;; https://github.com/JuliaEditorSupport/julia-emacs
(add-to-list 'load-path "~/.emacs.d/julia-emacs")
(require 'julia-mode)

;; (require 'package)
;; (add-to-list 'package-archives
             ;; '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)
;; (package-refresh-contents)
;; M-x package-install rust-mode
(require 'rust-mode)

;; Represent whitespace as dots
(setq whitespace-style '(space-mark))
(setq whitespace-display-mappings '((space-mark 32 [183] [46])))
