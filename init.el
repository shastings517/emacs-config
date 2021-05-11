;;; package --- Summary:
;;; Commentary:
;;; evil editing with SPC leader key
;;; Code:
;; set up package repositories
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
         '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
        '("gnu" . "http://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
        '("marmalade" . "http://marmalade-repo.org/packages/"))
;; (add-to-list 'package-archives
;;         '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
        '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)
;; https://github.com/jwiegley/use-package
;; better package management
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
;;;;;;;;;;;;;;
;; packages ;;
;;;;;;;;;;;;;;
;; https://github.com/purcell/exec-path-from-shell
;; fix emacs path on mac
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :config
  (exec-path-from-shell-initialize))
;; https://github.com/codesuki/add-node-modules-path/tree/master
;; adds the node_modules/.bin directory to the buffer exec_path. E.g. support project local eslint installations.
(use-package add-node-modules-path
  :ensure t
  :hook ((js2-mode . add-node-modules-path)
         (rjsx-mode . add-node-modules-path)))
;; https://github.com/justbur/emacs-which-key
;; displays available keybindings in popup
(use-package which-key
  :ensure t
  :config
  (which-key-mode))
;; https://github.com/emacs-dashboard/emacs-dashboard
;; custom dashboard
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
;; https://github.com/victorhge/iedit
;; edit multiple regions simultaneously
(use-package iedit
  :ensure t)
;; https://www.gnu.org/software/emacs/manual/html_mono/ido.html
;; find files and directories
(use-package ido
  :ensure t
  :config
  (setq ido-enable-flex-matching t))
;; https://github.com/deb0ch/emacs-winum
;; window numbers for navigation
(use-package winum
  :ensure t
  :init
  (setq-default winum-keymap nil)
  :config
  (winum-mode))
;; https://magit.vc/
;; git porcelain
(use-package magit
  :ensure t)

;; https://github.com/syohex/emacs-anzu
;; minor mode that provides search matches
(use-package anzu
  :ensure t
  :config
  (global-anzu-mode 1)
  (global-set-key [remap query-replace-regexp] 'anzu-query-replace-regexp)
  (global-set-key [remap query-replace] 'anzu-query-replace))

;; https://github.com/bbatsov/zenburn-emacs
;; zenburn color theme
;; (use-package zenburn-theme
;;   :ensure t
;;   :config
;;   (load-theme 'zenburn t))
;; doom themes
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  ;; (doom-themes-treemacs-config)
  
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;; https://github.com/flycheck/flycheck
;; on the fly syntax checking
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))
;; https://github.com/TheBB/spaceline
;; powerline theme
;; (use-package spaceline
;;   :demand t
;;   :init
;;   (setq powerline-default-separator 'wave)
;;   :config
;;   (require 'spaceline-config)
;;   (spaceline-spacemacs-theme))
(use-package spaceline
  :ensure t
  :init
  (require 'spaceline-config)
  (setq spaceline-highlight-face-func 'spaceline-highlight-face-evil-state)
  :config
  (progn
    (spaceline-define-segment buffer-id
      (if (buffer-file-name)
          (let ((project-root (projectile-project-p)))
            (if project-root
                (file-relative-name (buffer-file-name) project-root)
              (abbreviate-file-name (buffer-file-name))))
        (powerline-buffer-id)))
    (spaceline-spacemacs-theme)
    (spaceline-toggle-minor-modes-off)))

;; (use-package spaceline-all-the-icons
;;   :after spaceline
;;   :config (spaceline-all-the-icons-theme))
;; https://github.com/emacs-helm/helm
;; incremental completion and selection narrowing framework
(use-package helm
  :ensure t
  :init
  
  ; (defun helm-hide-minibuffer-maybe ()
  ;   (when (with-helm-buffer helm-echo-input-in-header-line)
  ;     (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
  ;       (overlay-put ov 'window (selected-window))
  ;       (overlay-put ov 'face (let ((bg-color (face-background 'default nil)))
  ;                               `(:background ,bg-color :foreground ,bg-color)))
  ;       (setq-local cursor-type nil))))
  ; (add-hook 'helm-minibuffer-set-up-hook 'helm-hide-minibuffer-maybe)
  :config
  (setq helm-M-x-fuzzy-match t
    helm-mode-fuzzy-match t
    helm-buffers-fuzzy-matching t
    helm-recentf-fuzzy-match t
    helm-locate-fuzzy-match t
    helm-semantic-fuzzy-match t
    helm-imenu-fuzzy-match t
    helm-completion-in-region-fuzzy-match t
    helm-candidate-number-list 80
    ; helm-mode-line-string nil
    ; helm-display-header-line nil
    helm-split-window-in-side-p t
    helm-move-to-line-cycle-in-source nil
    ; helm-echo-input-in-header-line t
    helm-autoresize-max-height 0
    helm-autoresize-min-height 20)
  (helm-mode 1))
;; https://github.com/cosmicexplorer/helm-rg
;; ripgrep helm interface
(use-package helm-rg :ensure t)
;; https://github.com/bbatsov/projectile
;; project interaction framework
(use-package projectile
  :ensure t
  :init
  (setq projectile-require-project-root nil)
  :config
  (projectile-mode 1))
;; https://github.com/bbatsov/helm-projectile
;; projectile helm interface
(use-package helm-projectile
  :ensure t
  :init
  (setq helm-projectile-fuzzy-match t)
  :config
  (helm-projectile-on))
;; https://github.com/syohex/emacs-helm-ag
;; silver searcher helm interface
(use-package helm-ag
  :ensure t)
;; https://github.com/mooz/js2-mode
;; major mode for editing .js files
(use-package js2-mode
    :ensure t
    :mode "\\.js\\'"
    :config
    (setq-default js2-ignored-warnings '("msg.extra.trailing.comma")
                  js-indent-level 2))
;; https://github.com/magnars/js2-refactor.el
;; js refactoring library
;; (use-package js2-refactor
;;     :ensure t
;;     :config
;;     (js2r-add-keybindings-with-prefix "C-c C-m")
;;     (add-hook 'js2-mode-hook 'js2-refactor-mode))
;; https://github.com/felipeochoa/rjsx-mode
;; major mode for editing .jsx files
; (use-package rjsx-mode
;   :ensure t
;   :init
;   (add-to-list 'auto-mode-alist '("components\\/.*\\.js\\'" . rjsx-mode)))
(use-package rjsx-mode
  :ensure t
  :mode(("\\.js\\'" . rjsx-mode)
        ("\\.jsx\\'" . rjsx-mode)))
  ;; :init
  ;; (add-hook 'rjsx-mode-hook 'prettier-js-mode))
;; https://github.com/prettier/prettier-emacs
;; minor mode that formats js on save
;; (use-package prettier-js
;;     :ensure t
;;     :config
;;     (setq prettier-js-args '(
;;                           "--trailing-comma" "es5"
;;                           "--single-quote" "true"
;;                           "--print-width" "100"
;;                           ))
;;     (add-hook 'js2-mode-hook 'prettier-js-mode)
;;     (add-hook 'rjsx-mode-hook 'prettier-js-mode))
;; https://github.com/fxbois/web-mode
;; major mode for editing html/css

(use-package web-mode
  :ensure t
  :mode ("\\.html\\'")
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-engines-alist
        '(("django" . "focus/.*\\.html\\'")
          ("ctemplate" . "realtimecrm/.*\\.html\\'"))))

;; show argument list/type information in the modeline
(use-package eldoc
  :ensure t
  :diminish eldoc-mode)

;; in-buffer completion
(use-package company
  :ensure t
  :diminish company-mode
  :init
  (setq company-minimum-prefix-length 2
        company-selection-wrap-around t
        company-tooltip-align-annotations t)
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package company-box
  :ensure t
  :after company
  :diminish
  :hook (company-mode . company-box-mode))

(use-package lsp-mode
  :ensure t
  :init (add-to-list 'company-backends 'company-capf)
  :hook ((rjsx-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp
  :ensure t
  :commands helm-lsp-workspace-symbol)

;; `company' backend for `lsp-mode'
;; (use-package company-lsp
;;   :ensure t
;;   :after company lsp-mode
;;   :init
;;   (push 'company-lsp company-backends))

;; (use-package company-lsp
;;   :ensure t
;;   :config
;;   (add-to-list 'company-backends 'company-lsp))
;; https://github.com/company-mode/company-mode
;; in-buffer completion framework
;; (use-package company
;;   :ensure t
;;   :diminish company-mode
;;   :init
;;   (setq company-dabbrev-ignore-case t
;;         company-dabbrev-downcase nil)
;;   (add-hook 'after-init-hook 'global-company-mode)
;;   :config
;;   (use-package company-tern
;;     :ensure t
;;     :init (add-to-list 'company-backends 'company-tern)))
;; https://orgmode.org/
;; org mode
(use-package org
  :mode (("\\.org$" . org-mode))
  ;; :ensure org-plus-contrib
  :config
  (progn
    ;; config stuff
    ))
;; https://github.com/Somelauw/evil-org-mode
;; evil org mode
(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme)))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
;; https://github.com/louietan/anki-editor
;; build anki cards with org mode
;; (use-package anki-editor
;;   :ensure t)
;; https://github.com/syohex/emacs-git-gutter-fringe
;; adds indicators of changed code
(use-package git-gutter-fringe
  :ensure t
  :disabled t
  :diminish git-gutter-mode
  :init (setq git-gutter-fr:side 'right-fringe)
  :config (global-git-gutter-mode t))
;; https://github.com/smihica/emmet-mode
;; abbreviations for html and css
;; (use-package emmet-mode
;;   :ensure t
;;   :commands (emmet-mode
;;              emmet-next-edit-point
;;              emmet-prev-edit-point)
;;   :init
;;   (setq emmet-indentation 2)
;;   (setq emmet-move-cursor-between-quotes t)
;;   :config
;;   ;; Auto-start on any markup modes
;;   (add-hook 'sgml-mode-hook 'emmet-mode)
;;   (add-hook 'web-mode-hook 'emmet-mode)
;;   (add-hook 'rjsx-mode-hook 'emmet-mode))
;; https://github.com/joaotavora/yasnippet
;; add code templates from abbreviations
;; (use-package yasnippet
;;   :ensure t
;;   :disabled t
;;   :diminish yas-minor-mode
;;   :config
;;   (yas-global-mode 1))
;; https://github.com/Fuco1/smartparens
;; minor mode that auto inserts pairs of parens
(use-package smartparens
    :ensure t
    :diminish smartparens-mode
    :config
    (add-hook 'prog-mode-hook 'smartparens-mode))
;; https://github.com/Fanael/rainbow-delimiters
;; different colors for highlighting delimiters
(use-package rainbow-delimiters
    :ensure t
    :config
    (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))
;; https://github.com/emacsmirror/rainbow-mode
;; colorize color names in buffers
(use-package rainbow-mode
    :ensure t
    :config
    (setq rainbow-x-colors nil)
    (add-hook 'prog-mode-hook 'rainbow-mode))
;; https://github.com/Malabarba/aggressive-indent-mode
;; minor mode that keeps code indented automatically
(use-package aggressive-indent
      :ensure t)

;; https://github.com/emacs-evil/evil
;; vim keybindings for editing
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))
;; https://github.com/emacs-evil/evil-collection
;; keybindings for evil-mode
(use-package evil-collection
  :after evil
  :ensure t
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))
;; https://github.com/syl20bnr/evil-escape
;; customizable key sequence to escape states
(use-package evil-escape
  :after evil
  :ensure t
  :config
  (progn
    (evil-escape-mode)
    (setq-default evil-escape-key-sequence "fd")))
;; https://github.com/linktohack/evil-commentary
;; comment stuff out
(use-package evil-commentary
  :after evil
  :ensure t
  ; :defer t
  :config
  (evil-commentary-mode))
;; https://github.com/emacs-evil/evil-surround
;; surround stuff
(use-package evil-surround
  :after evil
  :ensure t
  :config
  (global-evil-surround-mode 1))
;; https://github.com/syl20bnr/evil-iedit-state
;; evil state for iedit
(use-package evil-iedit-state
  :after evil
  :ensure t)
 

;; macro below used for auto-indent after paste
(defun undo-collapse-begin (marker)
  "Mark the beginning of a collapsible undo block.
This must be followed with a call to undo-collapse-end with a marker
eq to this one."
  (push marker buffer-undo-list))

(defun undo-collapse-end (marker)
  "Collapse undo history until a matching marker."
  (cond
    ((eq (car buffer-undo-list) marker)
     (setq buffer-undo-list (cdr buffer-undo-list)))
    (t
     (let ((l buffer-undo-list))
       (while (not (eq (cadr l) marker))
         (cond
           ((null (cdr l))
            (error "undo-collapse-end with no matching marker"))
           ((null (cadr l))
            (setf (cdr l) (cddr l)))
           (t (setq l (cdr l)))))
       ;; remove the marker
       (setf (cdr l) (cddr l))))))


(defmacro with-undo-collapse (&rest body)
  "Execute body, then collapse any resulting undo boundaries."
  (declare (indent 0))
  (let ((marker (list 'apply 'identity nil)) ; build a fresh list
        (buffer-var (make-symbol "buffer")))
    `(let ((,buffer-var (current-buffer)))
       (unwind-protect
           (progn
             (undo-collapse-begin ',marker)
             ,@body)
         (with-current-buffer ,buffer-var
           (undo-collapse-end ',marker))))))

;; functions below for auto-indent after paste
(defun paste-and-indent-after ()
  (interactive)
  (with-undo-collapse
    (evil-paste-after 1)
    (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\]))))
(defun paste-and-indent-before ()
  (interactive)
  (with-undo-collapse
    (evil-paste-before 1)
    (evil-indent (evil-get-marker ?\[) (evil-get-marker ?\]))))

;; https://github.com/noctuid/general.el
;; convenient custom keybinging
(use-package general
  :ensure t
  :init
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  normal
                                  visual
                                  motion
                                  operator
                                  replace))
  :config (general-define-key
    :states '(normal visual insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC"
    "/"   '(helm-projectile-rg :which-key "ripgrep")
    "TAB" '(evil-prev-buffer :which-key "previous buffer")
    "SPC" '(helm-M-x :which-key "M-x")
    ; ";;"  '(evil-commentary-line :which-key "comment line")
    ;; Projects
    "pf"  '(helm-projectile-find-file :which-key "find files")
    "pp"  '(helm-projectile-switch-project :which-key "switch project")
    "pb"  '(helm-projectile-switch-to-buffer :which-key "switch buffer")
    "pr"  '(helm-show-kill-ring :which-key "show kill ring")
    ;; Buffers
    "bb"  '(helm-mini :which-key "buffers list")
    "bd"  '(kill-buffer :which-key "buffer delete")
    ;; Files
    "fs" '(save-buffer :which-key "file save")
    "ff" '(helm-find-files :which-key "file find")
    ;; Window
    "0" 'winum-select-window-0-or-10
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "7" 'winum-select-window-7
    "8" 'winum-select-window-8
    "9" 'winum-select-window-9
    "w/"  '(split-window-right :which-key "split right")
    "w-"  '(split-window-below :which-key "split bottom")
    "wv"  '(evil-window-vnew :which-key "new vertical window")
    "wh"  '(evil-window-new :which-key "new horizontal window")
    "wd"  '(delete-window :which-key "delete window")
    "qz"  '(delete-frame :which-key "delete frame")
    "qq"  '(kill-emacs :which-key "quit")
    ;; Search
    "sp"  '(helm-projectile-ag :which-key "search project")
    "se"  '(evil-iedit-state/iedit-mode :which-key "evil iedit")
    ;; Errors
    "en"  '(flycheck-next-error :which-key "next error")
    "ep"  '(flycheck-previous-error :which-key "previous error")
    "el"  '(flycheck-list-errors :which-key "list errors")
    "ev"  '(flycheck-verify-setup :which-key "flycheck verify setup")
    ;; eshell
    "sh"  '(eshell-here :which-key "open eshell")
    "sr"  '(eshell-here-project-root :which-key "open eshell in project root")
    "sd"  '(kill-buffer-and-window :which-key "kill eshell window and buffer")
    ;; bookmarks
    "rm" '(bookmark-set :whick-key "bookmark current file")
    "rb" '(bookmark-jump :whick-key "jump to bookmark")
    "rl" '(bookmark-bmenu-list :whick-key "list bookmarks")
    ;; magit
    "gs" '(magit-log-buffer-file :which-key "commit history for buffer")
    ;; Others
    "at"  '(ansi-term :which-key "open terminal")
)(general-define-key
    :states '(normal)
    ;; :keymaps 'override
    "p"  '(paste-and-indent-after :which-key "paste-after with indent")
    "P"  '(paste-and-indent-before :which-key "paste-before with indent")
))

(use-package eshell
  :ensure t
  :init
  (setq ;; eshell-buffer-shorthand t ...  Can't see Bug#19391
        eshell-scroll-to-bottom-on-input 'all
        eshell-error-if-no-glob t
        eshell-hist-ignoredups t
        eshell-save-history-on-exit t
        eshell-prefer-lisp-functions nil
        eshell-destroy-buffer-when-process-dies t)
  (add-hook 'eshell-mode-hook
            (lambda ()
              (add-to-list 'eshell-visual-commands "ssh")
              (add-to-list 'eshell-visual-commands "tail")
              (add-to-list 'eshell-visual-commands "top")))
  (add-hook 'eshell-mode-hook
            (lambda ()
              (eshell/alias "e" "find-file $1")
              (eshell/alias "ff" "find-file $1")
              (eshell/alias "emacs" "find-file $1")
              (eshell/alias "ee" "find-file-other-window $1")

              (eshell/alias "gd" "magit-diff-unstaged")
              (eshell/alias "gds" "magit-diff-staged")
              (eshell/alias "d" "dired $1")

              ;; The 'ls' executable requires the Gnu version on the Mac
              (let ((ls (if (file-exists-p "/usr/local/bin/gls")
                            "/usr/local/bin/gls"
                          "/bin/ls")))
                (eshell/alias "ll" (concat ls " -AlohG --color=always"))))))

(defun eshell/gst (&rest args)
    (magit-status (pop args) nil)
    (eshell/echo))   ;; The echo command suppresses output

(defun pwd-replace-home (pwd)
  "Replace home in PWD with tilde (~) character."
  (interactive)
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun pwd-shorten-dirs (pwd)
  "Shorten all directory names in PWD except the last two."
  (let ((p-lst (split-string pwd "/")))
    (if (> (length p-lst) 2)
        (concat
         (mapconcat (lambda (elm) (if (zerop (length elm)) ""
                               (substring elm 0 1)))
                    (butlast p-lst 2)
                    "/")
         "/"
         (mapconcat (lambda (elm) elm)
                    (last p-lst 2)
                    "/"))
      pwd)))  ;; Otherwise, we just return the PWD

(defun split-directory-prompt (directory)
  (if (string-match-p ".*/.*" directory)
      (list (file-name-directory directory) (file-name-base directory))
    (list "" directory)))

(defun curr-dir-git-branch-string (pwd)
  "Returns current git branch as a string, or the empty string if
PWD is not in a git repo (or the git command is not found)."
  (interactive)
  (when (and (not (file-remote-p pwd))
             (eshell-search-path "git")
             (locate-dominating-file pwd ".git"))
    (let* ((git-url (shell-command-to-string "git config --get remote.origin.url"))
           (git-repo (file-name-base (s-trim git-url)))
           (git-output (shell-command-to-string (concat "git rev-parse --abbrev-ref HEAD")))
           (git-branch (s-trim git-output))
           (git-icon  "\xe0a0")
           (git-icon2 (propertize "\xf020" 'face `(:family "octicons"))))
      (concat git-repo " " git-icon2 " " git-branch))))

(defun python-prompt ()
  "Returns a string (may be empty) based on the current Python
   Virtual Environment. Assuming the M-x command: `pyenv-mode-set'
   has been called."
  (when (fboundp #'pyenv-mode-version)
    (let ((venv (pyenv-mode-version)))
      (when venv
        (concat
         (propertize "\xe928" 'face `(:family "alltheicons"))
         (pyenv-mode-version))))))


(defun eshell/eshell-local-prompt-function ()
  "A prompt for eshell that works locally (in that is assumes
that it could run certain commands) in order to make a prettier,
more-helpful local prompt."
  (interactive)
  (let* ((pwd        (eshell/pwd))
         (directory (split-directory-prompt
                     (pwd-shorten-dirs
                      (pwd-replace-home pwd))))
         (parent (car directory))
         (name   (cadr directory))
         (branch (curr-dir-git-branch-string pwd))
         ;; (ruby   (when (not (file-remote-p pwd)) (ruby-prompt)))
         (python (when (not (file-remote-p pwd)) (python-prompt)))

         (dark-env (eq 'dark (frame-parameter nil 'background-mode)))
         (for-bars                 `(:weight bold))
         (for-parent  (if dark-env `(:foreground "dark orange") `(:foreground "blue")))
         (for-dir     (if dark-env `(:foreground "orange" :weight bold)
                        `(:foreground "blue" :weight bold)))
         (for-git                  `(:foreground "green"))
         ;; (for-ruby                 `(:foreground "red"))
         (for-python               `(:foreground "#5555FF")))

    (concat
     (propertize "⟣─ "    'face for-bars)
     (propertize parent   'face for-parent)
     (propertize name     'face for-dir)
     (when branch
       (concat (propertize " ── "    'face for-bars)
               (propertize branch   'face for-git)))
     ;; (when ruby
     ;;   (concat (propertize " ── " 'face for-bars)
     ;;           (propertize ruby   'face for-ruby)))
     (when python
       (concat (propertize " ── " 'face for-bars)
               (propertize python 'face for-python)))
     (propertize "\n"     'face for-bars)
     (propertize (if (= (user-uid) 0) " #" " $") 'face `(:weight ultra-bold))
     ;; (propertize " └→" 'face (if (= (user-uid) 0) `(:weight ultra-bold :foreground "red") `(:weight ultra-bold)))
     (propertize " "    'face `(:weight bold)))))

(setq-default eshell-prompt-function #'eshell/eshell-local-prompt-function)
(setq eshell-highlight-prompt nil)

(defun eshell-here ()
  "Opens up a new shell in the directory associated with the
    current buffer's file. The eshell is renamed to match that
    directory to make multiple eshell windows easier."
  (interactive)
  (let* ((height (/ (window-total-height) 3)))
    (split-window-vertically (- height))
    (other-window 1)
    (eshell "new")
    (insert (concat "ls"))
    (eshell-send-input)))

(defun eshell-here-project-root ()
  "Opens up a new shell in the directory associated with the
    current buffer's file. The eshell is renamed to match that
    directory to make multiple eshell windows easier."
  (interactive)
  (let* ((height (/ (window-total-height) 3)))
    (split-window-vertically (- height))
    (other-window 1)
    (projectile-run-eshell)
    (insert (concat "ls"))
    (eshell-send-input)))

;; (defun delete-single-window (&optional window)
;;   "Remove WINDOW from the display.  Default is `selected-window'.
;; If WINDOW is the only one in its frame, then `delete-frame' too."
;;   (interactive)
;;   (save-current-buffer
;;     (setq window (or window (selected-window)))
;;     (select-window window)
;;     (kill-buffer)
;;     (if (one-window-p t)
;;         (delete-frame)
;;       (delete-window (selected-window)))))

;; (defun eshell/x (&rest args)
;;   (delete-single-window))

(use-package eshell-git-prompt
  :ensure t
  ;; :after eshell
  :init (eshell-git-prompt-use-theme 'robbyrussell))

;;;;;;;;;;;;;;
;; defaults ;;
;;;;;;;;;;;;;;
;; interactive shell so we load .bashrc
;; (setq shell-command-switch "-ic")
;; switch meta to mac command
;; (setq mac-command-modifier 'control)
(setq mac-option-key-is-meta nil
      mac-command-key-is-meta t
      mac-command-modifier 'meta
      mac-option-modifier 'control)
;; for lsp performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
;; smoother scrolling
(setq redisplay-dont-pause t
  scroll-margin 1
  scroll-step 1
  scroll-conservatively 10000
  scroll-preserve-screen-position 1)
;; set highlight color
;; https://stackoverflow.com/questions/18684579/how-do-i-change-the-highlight-color-for-selected-text-with-emacs-deftheme
;; should use customize-face
(set-face-attribute 'region nil :background "#666" :foreground "#ffffff")
;; set font size
(set-face-attribute 'default nil :height 150)
;; open new files in same frame when opening gui from terminal
(setq ns-pop-up-frames nil)
;; stop startup msg
(setq inhibit-startup-message t)
;; set flycheck executable
(setq flycheck-python-flake8-executable "flake8")
;; list all buffers in ibuffer
(defalias 'list-buffers 'ibuffer)
;; (defalias 'list-buffers 'ibuffer-other-window)
;; disable toolbar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode 0))
;; disable scrollbar
(scroll-bar-mode -1)
;; disable emacs bell
(setq ring-bell-function 'ignore)
;; enable linum mode
(if (fboundp 'global-display-line-numbers-mode)
    (global-display-line-numbers-mode t)
    (global-linum-mode))
;; enable narrowing
(put 'narrow-to-region 'disabled nil)
;; enable paren matching mode
(show-paren-mode t)
;; enable electric pair mode
(electric-pair-mode t)
;; enable electric indent mode
(electric-indent-mode t)
;; set frame width
(set-frame-height
 (selected-frame)
 (/ (display-pixel-height) (frame-char-height)))
(set-frame-width
 (selected-frame)
 (/ (/ (display-pixel-width) 3) (frame-char-width)))
;; (add-to-list 'initial-frame-alist '(fullscreen . fullheight)(width . (/ display-pixel-width 2)))
;; (add-to-list 'default-frame-alist '(fullscreen . fullheight))
;; (setq frame-resize-pixelwise t)
;; (let ((frame (selected-frame))
;;       ;; (one-half-display-pixel-width))
;;   (one-half-display-pixel-width (/ (display-pixel-width) 2)))
;;   (set-frame-width frame one-half-display-pixel-width nil 'pixelwise)
;;   (set-frame-height frame display-pixel-height nil 'pixelwise)
;;   (set-frame-position frame 0 0))
;; use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq css-indent-offset 2)
;; ;; indent 2 spaces in python-mode
;; (add-hook 'python-mode-hook '(lambda ()
;;                                (setq python-indent 2)))
;; set default directory
(setq default-directory "~/")
;; run check-parens after saving any file
(add-hook 'after-save-hook 'check-parens nil t)
;; propogate git changes to open files
(global-auto-revert-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-collection-setup-minibuffer t)
 '(helm-minibuffer-history-key "M-p")
 '(org-export-backends '(ascii html icalendar latex md odt))
 '(package-selected-packages
   '(anki-editor helm-lsp lsp-ui lsp-mode magit evil-org general flycheck evil-escape zenburn-theme evil-collection evil dashboard which-key try use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(markdown-code-face ((t (:inherit consolas)))))
;;; init.el ends here
