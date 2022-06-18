;;;; .Emacs[.el] -- My Emacs configuration
;-*-Emacs-Lisp-*-

;;;; Commentary:
;;
;; I have nothing substantial to say here.
;;


;;;; Code:

;;;; Added Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(cond
 ((>= 24 emacs-major-version)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives
           '("melpa-stable" . "http://stable.melpa.org/packages/") t)
  (add-to-list 'package-archives
           '("melpa" . "https://melpa.org/packages/") t)
  (package-refresh-contents)
 )
)

(setq-default buffer-file-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)
(setq locale-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-unix)

;;;; allow tab key
(global-set-key (kbd "TAB") 'self-insert-command)

;;;; Set tab key to four spaces
(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ;; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)

;;;; Disable automatic indentations
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;;;; Allow commenting/uncommenting code
(defun toggle-comment-on-line ()
  "comment or uncomment current line"
  (interactive)
  (comment-or-uncomment-region (line-beginning-position) (line-end-position)))
(global-set-key (kbd "M-/") 'toggle-comment-on-line)

;;;; instead of emacs creating a *~ file in the current directory, create backup file elsewhere
(setq backup-directory-alist `(("." . "~/.saves")))

;;;; do something with #file-being-edited#
;; requires `cd ~/.emacs.d/; git clone https://github.com/emacscollective/no-littering.git`
(add-to-list 'load-path "~/.emacs.d/no-littering/")
(require 'no-littering)

;;;; Add packages repositories
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
 '(package-selected-packages '(go-mode nim-mode move-text haskell-mode nlinum ess)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-highlight-prompt ((t (:foreground "cyan"))))
 '(minibuffer-prompt ((t (:foreground "cyan")))))

;;;; set shell to bash
(setenv "SHELL" "/usr/local/bin/bash")
(setq explicit-shell-file-name "/usr/local/bin/bash")

;;;; find matching parenthesis
(global-set-key "%" 'match-paren)
          
          (defun match-paren (arg)
            "Go to the matching paren if on a paren; otherwise insert %."
            (interactive "p")
            (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
                  ((looking-at "\\s)") (forward-char 1) (backward-list 1))
                  (t (self-insert-command (or arg 1)))))

;;;; Add line numbers
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

;;;; add julia support
;; https://github.com/JuliaEditorSupport/julia-emacs
(add-to-list 'load-path "~/.emacs.d/julia-emacs")
(require 'julia-mode)

;;;; add rust support
;; use MELPA
;; (require 'package)
;; (add-to-list 'package-archives
             ;; '("melpa" . "https://melpa.org/packages/") t)
;; (package-initialize)
;; (package-refresh-contents)
;; M-x package-install rust-mode
;; OR https://github.com/rust-lang/rust-mode
(add-to-list 'load-path "~/.emacs.d/rust-mode/")
(require 'rust-mode)

;;;; add zig support
(unless (version< emacs-version "24")
  (add-to-list 'load-path "~/.emacs.d/zig-mode/")
  (autoload 'zig-mode "zig-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.zig\\'" . zig-mode)))

;;;; Represent whitespace as dots
(setq whitespace-style '(space-mark))
(setq whitespace-display-mappings '((space-mark 32 [183] [46])))

;;;; suppress startup screen
(setq inhibit-startup-screen t
	inhibit-splash-screen t
	inhibit-startup-echo-area-message t)

;;;; hide tool-bar
(menu-bar-mode -1)
(tool-bar-mode -1)

;;;; make window fullscreen (-fs | --fullscreen)
;; must be after the hide toolbar section
;; https://superuser.com/questions/1076443/
(toggle-frame-maximized)
;; https://stackoverflow.com/questions/2151449/
;; (x-display-pixel-width)
;; (x-display-pixel-height)

;;;; use dracula theme
;; brew install emacs-dracula

;;;; adjust scroll mode
;; scroll one line at a time (less "jumpy" than defaults)    
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;;;; add powerline
(add-to-list 'load-path "~/.emacs.d/powerline/")
(require 'powerline)
;; load powerline if we are not using terminal
(when (display-graphic-p)
	(powerline-default-theme))
;; (powerline-center-evil-theme))

;; Highlight matching parenthesis!
(show-paren-mode 1)
(setq show-paren-delay 0)

;; (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
;; (setq-default left-fringe-width nil)
;; (setq-default indicate-empty-lines t)
;; (setq-default indent-tabs-mode nil)


;;;; keep cursor on same line when scrolling
;; https://emacs.stackexchange.com/questions/54710/
;; https://superuser.com/questions/527356/
;; (when (not (display-graphic-p))
	;; (powerline-default-theme))

;;;; TODO: highlighting
;; https://github.com/tarsius/hl-todo
;; https://www.reddit.com/r/emacs/comments/f8tox6/
(add-to-list 'load-path "~/.emacs.d/hl-todo/")
(require 'hl-todo)
;; (use-package! hl-todo
  ;; :hook (prog-mode . hl-todo-mode)
  ;; :config
  ;; (setq hl-todo-highlight-punctuation ":"
        ;; hl-todo-keyword-faces
        ;; '(("TODO"       warning bold)
          ;; ("FIXME"      error bold)
          ;; ("HACK"       font-lock-constant-face bold)
          ;; ("REVIEW"     font-lock-keyword-face bold)
          ;; ("NOTE"       success bold)
          ;; ("DEPRECATED" font-lock-doc-face bold))))
		;; '(("TODO"		 . "#FF0000")
		   ;; ("FIXME"		 . "#FF0000")
		   ;; ("HACK"		 . "#A020F0")
		   ;; ("REVIEW"	 . "#FF4500")
		   ;; ("NOTE"		 . "#1E90FF")
		   ;; ("DEPRECATED" . "#FF0000")));;)
;; (setq hl-todo-keyword-faces
      ;; '(("TODO"   . "#FF0000")
        ;; ("FIXME"  . "#FF0000")
        ;; ("DEBUG"  . "#A020F0")
        ;; ("GOTCHA" . "#FF4500")
        ;; ("STUB"   . "#1E90FF")))


;; enable continuous scrolling
(setq doc-view-continuous t)

;; coloured dots for whitespace
(setq whitespace-style '(space-mark))
(setq whitespace-display-mappings '((space-mark 32 [183] [46])))

;; Moves lines of text
;; by default uses M-up and M-down
(require 'move-text)
(move-text-default-bindings)

;; nim mode
(require 'move-text)

;; Change default compilation for rust
(require 'compile)
(add-hook 'rust-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (format "rustc %s && ./%s" 
					(file-name-nondirectory buffer-file-name)
					(file-name-base buffer-file-name)))))

;; Making regex a little bit easier
(require 're-builder)
;; (setq reb-re-syntax 'string) ;; switch to `string`; there's little reason tu use `read`

;; Relative line numbers
(display-line-numbers-mode)
;; (setq display-line-numbers 'relative)
(setq display-line-numbers-type 'relative)
