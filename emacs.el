;;;; File-Wide Macros ;;;;

(defmacro add-hook-progn (hook &rest body)
  `(add-hook ,hook
             (lambda () . ,body)))

(defmacro after-init (&rest body)
  `(add-hook 'after-init-hook
             (lambda () ,body)))

(defmacro req-packages (pkg-defs)
  `(progn
     ,@(mapcar (lambda (pkg-def) (cons 'req-package pkg-def))
               (symbol-value pkg-defs))))

;; Startup & Shutdown
(setq
 inhibit-startup-screen t
 initial-scratch-message ""
 confirm-kill-emacs 'y-or-n-p)

(ignore-errors
  (scroll-bar-mode 0)
  (tool-bar-mode 0))
(menu-bar-mode 0)
(column-number-mode t)
(set-face-attribute 'default nil :height 130)
(setq-default
 indent-tabs-mode nil
 tab-width 8)

(setq recentf-save-file "~/.emacs.d/recentf")

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;; Key Bindings ;;;;


;;; Configure Package.el And El-Get ;;;;

;;; Packages
(require 'package)

;; Setup package archives
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("MELPA" . "http://melpa.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

;; Load packages
(package-initialize)

;;; Setup Req-Package

(unless (require 'req-package nil t)
  (package-refresh-contents)
  (package-install 'req-package)
  (require 'req-package))

(setq
 init-pkgs-to-req
 '((el-get
    :defer t
    :config (progn
              (require 'el-get-custom)
              (setq el-get-verbose t)

              (let ((dir (file-name-directory el-get-status-file)))
                (unless (file-exists-p dir)
                  (make-directory dir)))

              ;; Sync El-Get Packages
              (setq el-get-sources
                    '((:name cedet :lazy t)
                      (:name bbdb
                             :branch "bbdb_2.35"
                             :info nil
                             :features bbdb-autoloads
                             :build '("autoconf" "./configure" "make all"))))
              (setq user/el-get-packages
                    (mapcar 'el-get-source-name el-get-sources))
              (el-get 'sync user/el-get-packages)))
   (bind-key
    :config (progn
              (unbind-key "C-z")
              (bind-key "<C-return>" 'newline-and-indent)
              (bind-key "<mouse-3>" 'mouse-popup-menubar)
              (bind-key "<mouse-8>" 'previous-buffer)
              (bind-key "<mouse-9>" 'next-buffer)
              (bind-key "C-x C-M-k" 'kill-matching-buffers)
              (bind-key "C-h C-M-f" 'find-function)
              (bind-key "C-h C-M-v" 'find-variable)
              (bind-key "C-z C-\\" 'toggle-hiding)
              (bind-key "C-z C--" 'toggle-selective-display)
              (bind-key "C-z C-z" 'suspend-frame)
              (bind-key "C-z M-w" 'clipboard-kill-ring-save)
              (bind-key "C-z C-r" 'rename-buffer)
              (bind-key "C-z e" 'eval-region)))
   (benchmark-init
    :init (benchmark-init/activate))
   (auto-compile
    :config (progn
              (auto-compile-on-save-mode)
              (auto-compile-on-load-mode)))))

(req-packages init-pkgs-to-req)
(req-package-finish)

(setq
 pkgs-to-req
 '((ace-jump-mode
    :commands (ace-jump-char-mode
               ace-jump-line-mode
               ace-jump-word-mode)
    :bind (("C-z j" . ace-jump-char-mode)
           ("C-z l" . ace-jump-line-mode)
           ("C-z w" . ace-jump-word-mode)))
   (adaptive-wrap :defer t)
   (aes :defer t)
   (alpha
    :defer t
    :config (progn
              (add-to-list 'default-frame-alist '(alpha . 100))))
   (ansi-term-command
    :config (progn

              (defun user/ansi-term-sudo-shell ()
                (interactive)
                (ansi-term-command "sudo" "-i"))

              (ansi-term-command-setup-atc-alias)))
   (ascii :defer t)
   (asm-mode
    ;; Make comments work better w/ fill-paragraph
    :config (add-hook-progn 'asm-mode-hook
                            (set (make-local-variable 'paragraph-start)
                                 "^\\s-*;+.*$")))
   (async)
   (async-bytecomp :require async)
   (auctex
    :defer t
    :mode "\\.tex\\'"
    :config (progn
              (require 'tex)
              (require 'tex-site)
              (require 'preview)
              (add-hook 'LaTeX-mode-hook 'outline-minor-mode)))
   (auctex-latexmk :defer t)
   (auto-dim-other-buffers
    :diminish auto-dim-other-buffers-mode
    :config (auto-dim-other-buffers-mode))
   (autorevert
    :init (global-auto-revert-mode t))
   (auto-compile)
   (bash-completion
    :init (bash-completion-setup))
   (browse-kill-ring)
   (charmap :defer t)
   (cl-lib)
   (color-theme)
   (color-theme-sanityinc-tomorrow
    :defer t
    :require color-theme
    :config (load-theme 'sanityinc-tomorrow-blue))
   (cc-mode
    :defer t
    :config (progn
              (setq c-default-style "K&R")
              (setq c-basic-offset 8)
              (setq tab-width 8)
              (setq indent-tabs-mode nil)))
   (company
    :diminish company-mode
    :init (global-company-mode t)
    :config (progn
              ;; I HATE it when <return> selects the current
              ;; autocompletion candidate when I just want to start a
              ;; new line. Unbinding <return> means I can still use
              ;; <tab> for that purpose.
              (unbind-key (kbd "RET") company-active-map)
              (unbind-key "<return>" company-active-map)

              (setq
               ;; Helm-company usually pukes if company autocompletion
               ;; starts after helm-company is called.
               company-idle-delay 0
               ;; Get rid of company menu. I'll use helm.
               company-frontends
               (remove 'company-pseudo-tooltip-unless-just-one-frontend
                       company-frontends)

               company-elisp-detect-function-context nil
               company-backends '((company-gtags
                                   ;; company-etags
                                   company-elisp
                                   company-files
                                   company-dabbrev
                                   company-dabbrev-code
                                   company-ropemacs)
                                  ;; company-bbdb
                                  ;; company-nxml
                                  ;; company-css
                                  ;; company-clang
                                  ;; company-cmake
                                  company-dabbrev))))
   (concurrent :defer t)
   (crontab-mode :defer t)
   (csv-mode
    :defer t
    :mode "\\.csv\'")
   (ctable :defer t)
   (dash)
   (deferred :defer t)
   (dired+ :defer t)
   (dired-efap)
   (dired-single)
   (doc-view
    :defer t
    :mode ("\\.pdf\\'" . doc-view-mode)
    :mode ("\\.ps\\'" . doc-view-mode)
    :config (setq doc-view-continuous t))
   (ebib
    :defer t
    :mode "\\.bib\\'")
   (eldoc
    :defer t
    :init (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode))
   (electric
    :init (electric-indent-mode 1))
   (elfeed
    :config (progn
              (elfeed-org)

              (defun user/elfeed-search-mark-as-read-and-next ()
                (interactive)
                (elfeed-search-untag-all 'unread))
              (bind-key "N" 'user/elfeed-search-mark-as-read-and-next elfeed-search-mode-map)

              (setq elfeed-sort-order 'ascending)
              (setq-default elfeed-search-filter "@2-weeks-ago +unread +daily ")))
   (elfeed-org
    :defer t
    :require elfeed)
   (erc
    :defer t
    :bind ("C-z c j" . erc-track-switch-buffer)
    :init (defalias 'irc 'erc-tls)
    :config (progn
              (setq
               erc-port 6697
               erc-prompt-for-password t
               erc-mode-line-format "%t %a"
               erc-kill-queries-on-quit t
               erc-kill-buffer-on-part t
               erc-enable-logging t
               erc-log-write-after-insert t
               erc-log-write-after-send t
               erc-log-channels-directory "~/org/chats/irc/"
               erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"))

              (add-to-list 'erc-modules 'hl-nicks)
              (add-to-list 'erc-modules 'notifications)
              (add-to-list 'erc-modules 'track)
              (add-to-list 'erc-modules 'log)
              (add-to-list 'erc-modules 'spelling)))
   (erc-hl-nicks
    :defer t)
   (erlang-mod
    :defer t
    :mode "\\.erl\\'"
    :config (progn
              (setq
               erlang-root-dir "/usr/lib/erlang"
               exec-path (cons "/usr/lib/erlang/bin" exec-path))))
   (eshell
    :defer t
    :idle (require 'eshell)
    :bind ("C-z s" . eshell)
    :config (progn
              (setq eshell-cmpl-cycle-completions t)

              (add-hook-progn
               'eshell-mode-hook

               (evil-local-mode -1)
               (company-mode -1)

               (bind-key "TAB" 'helm-esh-pcomplete eshell-mode-map)
               (bind-key "<tab>" 'helm-esh-pcomplete eshell-mode-map))))
   (ess
    :defer t
    :commands julia
    :config (progn
              (require 'ess-site)
              (setq
               ess-directory "~/.ess/"
               ess-ask-for-ess-directory nil)))
   (evil
    :bind ("TAB" . evil-indent)
    :pre-load (setq evil-toggle-key "C-`")
    :init (evil-mode 1)
    :config (progn
              (unbind-key "q" evil-normal-state-map)

              (unbind-key "C-e" evil-insert-state-map)

              (unbind-key "C-d" evil-insert-state-map)
              (unbind-key "C-k" evil-insert-state-map)
              (bind-key "C-g" 'evil-normal-state evil-insert-state-map)
              (bind-key "C-c" 'evil-normal-state evil-visual-state-map)

              (unbind-key (kbd "C-e") evil-motion-state-map)

              (bind-key (kbd "C-c") 'evil-exit-visual-state evil-visual-state-map)
              (unbind-key (kbd "M-.") evil-normal-state-map)

              ;; For gtags
              (unbind-key (kbd "M-.") evil-visual-state-map)
              (unbind-key (kbd "C-y") evil-motion-state-map)

              ;; For helm
              (unbind-key (kbd "C-y") evil-insert-state-map)

              (set-default 'evil-symbol-word-search t)
              (setq evil-emacs-state-modes (append '(term-mode
                                                     elfeed-search-mode
                                                     elfeed-show-mode
                                                     epa-key-list-mode
                                                     git-rebase-mode
                                                     magit-blame-mode
                                                     magit-key-mode
                                                     magit-status-mode)
                                                   evil-emacs-state-modes)

                    evil-insert-state-modes (append '(org-capture-mode
                                                      git-commit-mode
                                                      inferior-ess-mode)
                                                    evil-insert-state-modes)

                    evil-move-cursor-back nil
                    evil-want-C-i-jump nil)))
   (evil-matchit
    :require evil
    :init (evil-matchit-mode 1))
   (evil-leader :require evil)
   (evil-org
    :defer t
    :require (evil evil-leader)
    :init (add-hook-progn 'org-mode-hook
                          (require 'evil-org)))
   (evil-nerd-commenter :require evil)
   (evil-surround
    :require evil
    :init (global-evil-surround-mode 1))
   (expand-region
    :bind ("C-=" . er/expand-region))
   (f :defer t)
   (flycheck
    :init (global-flycheck-mode 1))
   (flycheck-rust
    :defer t
    :require (rust-mode flycheck)
    :init (add-hook 'rust-mode-hook 'flycheck-rust-setup))
   (flylisp
    :defer t
    :commands flylisp-mode
    :pre-load (defun enable-flylisp-mode ()
                (interactive)
                (flylisp-mode 1))
    :init (progn
            (add-hook 'emacs-lisp-mode-hook 'enable-flylisp-mode)
            (add-hook 'lisp-mode-hook 'enable-flylisp-mode)))
   (flyspell
    :diminish flyspell-mode
    :commands (flyspell-mode flyspell-prog-mode)
    :init (progn
            (add-hook 'text-mode-hook 'flyspell-mode)
            (add-hook 'prog-mode-hook 'flyspell-prog-mode)))
   (function-args :defer t)
   (furl :defer t)
   (ghc :defer t) ;?????
   (git-blame :defer t)
   (git-commit-mode :defer t)
   ;; (git-modeline
   ;;  :config (setq git-state-modeline-decoration 'git-state-decoration-letter))
   (git-rebase-mode :defer t)
   (gitconfig-mode :defer t)
   (gitignore-mode :defer t)
   (ggtags
    :bind ("M-r" . ggtags-query-replace))
   (julia-mode
    :defer t
    :commands julia-mode
    :mode "\\.jl\\'")
   (haskell-mode
    :defer t
    :mode "\\.hs\\'"
    :config (progn
              (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
              (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
              (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
              (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)))
   (helm
    :diminish helm-mode
    :bind (("C-x d" . helm-find-files)
           ("M-x" . helm-M-x)
           ("C-y" . helm-show-kill-ring)
           ("C-x b" . helm-mini)
           ("C-x C-b" . helm-mini)
           ("C-x C-f" . helm-find-files)
           ("C-h a" . helm-apropos)
           ("C-z <C-SPC>" . helm-all-mark-rings)
           ("C-z r" . helm-regexp)
           ("C-z o" . helm-occur))
    :pre-load (setq helm-command-prefix-key "C-z h")
    :init (helm-mode 1)
    :config (progn
              (require 'helm-config)
              ;; Swap Tab and C-z in helm-mode, so Tab executes
              ;; persistent actions, and C-z opens the actions
              ;; menu.
              (bind-key "<tab>" 'helm-execute-persistent-action helm-map)
              (bind-key "<C-tab>" 'helm-select-action helm-map)

              (bind-key "g" 'helm-google-suggest helm-command-map)
              (bind-key "o" 'helm-occur helm-command-map)
              (bind-key "x" 'helm-register helm-command-map)

              (setq
               helm-google-suggest-use-curl-p t)))
   (helm-company
    :require (helm company)
    :bind ("<C-tab>" . helm-company))
   (helm-gtags
    :require (helm)
    :commands helm-gtags-mode
    :init (progn
            (defun helm-gtags-update-tags-quietly ()
              (flet ((message (&rest _) nil))
                (helm-gtags-update-tags)))

            (define-minor-mode helm-gtags-auto-update-mode
              "Auto update GTAGS when a file in this mode is saved."
              :init-value nil
              :group 'helm-gtags-update
              (if helm-gtags-auto-update-mode
                  (progn
                    (add-hook 'after-save-hook 'helm-gtags-update-tags-quietly nil :local))
                (remove-hook 'after-save-hook 'helm-gtags-update-tags-quietly t)))

            (defun enable-helm-gtags-auto-update-mode()
              "Turn on `helm-gtags-auto-update-mode'."
              (interactive)
              (helm-gtags-auto-update-mode 1))

            (add-hook 'dired-mode-hook 'helm-gtags-mode)
            (add-hook 'prog-mode-hook 'helm-gtags-mode)
            (add-hook 'prog-mode-hook 'enable-helm-gtags-auto-update-mode))
    :config (progn
              (require 'ggtags)

              (setq
               helm-gtags-ignore-case t
               helm-gtags-auto-update t
               helm-gtags-use-input-at-cursor t
               helm-gtags-pulse-at-cursor t
               helm-gtags-suggested-key-mapping t)

              (bind-key "M-." 'helm-gtags-dwim helm-gtags-mode-map)
              (bind-key "M-?" 'helm-gtags-find-pattern helm-gtags-mode-map)))
   (helm-package :require helm)
   (helm-projectile
    :require projectile
    :init (helm-projectile-on))
   (inline-crypt
    :commands (inline-crypt-decrypt-region
               inline-crypt-decrypt-string
               inline-crypt-encrypt-region
               inline-crypt-encrypt-string)
    :bind (("C-z C-c C-d" . inline-crypt-decrypt-region)
           ("C-z C-c C-e" . inline-crypt-encrypt-region)
           ("C-z C-c d" . inline-crypt-decrypt-string)
           ("C-z C-c e" . inline-crypt-encrypt-string)))
   (js2-mode
    :defer t
    :mode "\\.js\\'")
   (json-mode
    :defer t
    :require json-reformat
    :mode "\\.json\\'")
   (json-reformat :defer t)
   (list-packages-ext :defer t)
   (list-processes+)
   (list-utils)
   (log4e :defer t)
   (magit
    :defer t
    :diminish magit-auto-revert-mode
    :commands (magit-blame-mode magit-status)
    :bind (("C-z v" . magit-status)
           ("C-z m a" . magit-commit-amend)
           ("C-z m b" . magit-blame-mode))
    :init (setq magit-status-buffer-switch-function 'switch-to-buffer))
   (markdown-mode
    :defer t
    :mode "\\.md\\'"
    :require electric
    :config (progn
              (require 'markdown-mode+)
              (setq markdown-enable-math t) ; LaTeX math
              ;; Electric-indent buggers indentation up in markdown-mode
              (add-hook 'electric-indent-functions
                        (lambda (_unused) 'no-indent) nil 'local)))
   (markdown-mode+
    :defer t
    :require markdown-mode)
   ;; (marmalade)
   (notmuch :defer t)
   (notmuch-labeler :defer t)
   (nxml
    :defer t
    :mode "\\.xml'"
    :config (setq nxml-child-indent 2))
   (org
    :defer t
    :mode ("\\.\\(org\\|org_archive\\)\\'" . org-mode)
    :commands (org-agenda org-iswitchb)
    :bind (("C-z C-o ]" . outline-next-heading)
           ("C-z C-o [" . outline-previous-heading)
           ("C-z C-o a" . org-agenda)
           ("C-z C-o b" . user/org-iswitchb-agenda)
           ("C-z C-o j" . org-clock-goto)
           ("C-z C-o l" . org-store-link)
           ("C-z C-o o" . org-clock-out)
           ("C-z C-o <C-right>" . org-demote-subtree)
           ("C-z C-o <C-left>" . org-promote-subtree))
    :idle (require 'org)
    :pre-load (defun user/org-iswitchb-agenda ()
                "call `org-iswitchb' with two prefix args, restricting selection
                              to agenda files."
                (interactive)
                (org-iswitchb 14))
    :config (progn
              ;; (require 'org-journal)
              ;; (require 'org-toc)

              ;; For `helm-show-kill-ring'
              (unbind-key "C-y" org-mode-map)

              ;; Default binding for <C-tab> is dumb. I want
              ;; `helm-company', dammit!
              (unbind-key "<C-tab>" org-mode-map)
              (bind-key "<C-M-tab>" 'org-force-cycle-archived org-mode-map)

              ;; Make "C-z C-o a <RET>" display an overview of all
              ;; tasks in my agenda files.
              (setq
               org-agenda-custom-commands
               '(("" "Agenda Tasks"
                  ((agenda "" ((org-agenda-overriding-header "== Agenda ==")))
                   (tags-todo "/+WIP" ((org-agenda-overriding-header "Tasks In Progress")
                                       (org-agenda-todo-ignore-deadlines t)
                                       (org-tags-match-list-sublevels t)))
                   (tags-todo "-meta/NEXT" ((org-agenda-overriding-header "Next Tasks")
                                            (org-tags-match-list-sublevels t)))
                   (tags-todo "/+OnHOLD" ((org-agenda-overriding-header "Tasks On Hold")))
                   (tags-todo "/+TODO" ((org-agenda-overriding-header "Tasks")
                                        (org-agenda-skip-function '(org-agenda-skip-entry-if
                                                                    'scheduled 'deadline))))
                   (tags-todo "/FUTURE" ((org-agenda-overriding-header "Future Tasks")
                                         (org-agenda-todo-ignore-scheduled t)
                                         (org-agenda-todo-ignore-deadlines t)))
                   (tags "+REFILE/" ((org-agenda-overriding-header "Tasks to Refile")
                                     (org-tags-match-list-sublevels nil)))
                   (tags "-archived-event/DONE|CANCELLED" ((org-agenda-overriding-header "Tasks to Archive"))))
                  nil)))

              (setq

               ;; Render special formatting in buffer
               org-pretty-entities t
               org-pretty-entities-include-sub-superscripts t
               org-columns-default-format (concat "%45ITEM "
                                                  "%TODO "
                                                  "%3PRIORITY "
                                                  "%6Effort(Effort){:} "
                                                  "%6CLOCKSUM(Time){:}")

               ;; Org Capture
               org-default-notes-file "~/personal/refile.org"
               org-cycle-separator-lines 2

               ;; Org Journal
               org-journal-dir "~/org/journal/"

               ;; Org Agenda
               org-agenda-start-on-weekday nil
               org-agenda-start-with-clockreport-mode nil
               org-agenda-start-with-log-mode t
               org-agenda-skip-additional-timestamps-same-entry t
               org-agenda-dim-blocked-tasks nil
               org-agenda-overriding-columns-format (concat "%CATEGORY "
                                                            "%45ITEM "
                                                            "%TODO "
                                                            "%3PRIORITY "
                                                            "%6Effort(Effort){:} "
                                                            "%6CLOCKSUM(Time){:}")
               org-agenda-remove-tags 'prefix
               org-agenda-sorting-strategy '((agenda time-up priority-down habit-down category-up)
                                             (todo priority-down category-up todo-state-up)
                                             (tags priority-down category-up todo-state-up)
                                             (search priority-down category-up todo-state-up))
               org-agenda-window-setup 'same-window

               ;; When prompting for an org-mode path, construct the path
               ;; incrementally.
               org-outline-path-complete-in-steps nil
               org-refile-use-outline-path 'file
               ;; When refiling to a parent node that doesn't exist, prompt to
               ;; create it.
               org-refile-allow-creating-parent-nodes 'confirm
               org-completion-use-ido t
               ido-everywhere t
               ido-max-directory-size 100000

               ;; Tags

               ;; Don't make children inherit "prj" tag from parent items
               org-tags-exclude-from-inheritance '("prj")

               ;; State Workflow
               org-todo-keywords '(;; Work Statuses
                                   (sequence "FUTURE(f)"
                                             "OnHOLD(h@/!)"
                                             "TODO(t@)"
                                             "NEXT(n@)"
                                             "WIP(w@)"
                                             "|"
                                             "DONE(d@)")
                                   ;; Extraordinary Statuses
                                   (sequence "|" "CANCELLED(c@)"))

               ;; Export

               org-latex-pdf-process '("latexmk -bibtex -pdf %f && latexmk --bibtex -c")
               org-export-creator-info nil
               org-export-with-sub-superscripts t
               ;; When exporting to ODT, convert it to a PDF, too
               org-export-odt-preferred-output-format "pdf"
               ;; Remove logfiles after exporting a PDF
               org-export-pdf-remove-logfiles t

               ;; Time/Clocking

               ;; Don't prompt for a note when clocking out
               org-log-note-clock-out nil
               org-clock-clocktable-default-properties '(:maxlevel 4 :scope file)
               ;; Don't always default to dates in the future
               org-read-date-prefer-future nil
               org-clock-out-remove-zero-time-clocks t
               org-clock-persist t
               ;; Do not prompt to resume an active clock
               org-clock-persist-query-resume nil
               ;; Include current clock task in clock reports
               org-clock-report-include-clocking-task t
               org-edit-timestamp-down-means-later nil
               org-log-done 'time
               org-log-into-drawer t
               org-time-clocksum-format (list :hours "%d"
                                              :require-hours t
                                              :minutes ":%02d"
                                              :require-minutes t))))
   (org-capture
    :defer t
    :bind ("C-z C-o C-c" . org-capture))
   ;; (org-journal
   ;;  :defer t
   ;;  :require org)
   ;; (org-toc
   ;;  :defer t
   ;;  :require org)
   (outline-magic)
   (outline-mode
    :defer t
    :config (progn
              (bind-key "<C-down>" 'outline-next-visible-heading outline-minor-mode-map)
              (bind-key "<C-up>" 'outline-previous-visible-heading outline-minor-mode-map)
              (bind-key "<M-down>" 'outline-move-subtree-down outline-minor-mode-map)
              (bind-key "<M-up>" 'outline-move-subtree-up outline-minor-mode-map)
              (bind-key "<M-left>" 'outline-promote outline-minor-mode-map)
              (bind-key "<M-right>" 'outline-demote outline-minor-mode-map)
              (bind-key "<C-M-tab>" 'outline-cycle outline-minor-mode-map)))
   (package+)
   (paren
    :init (show-paren-mode t))
   (pg :defer t)
   (pkg-info)
   (popup :defer t)
   (projectile
    :bind ("s-%" . projectile-replace)
    :pre-load (setq projectile-keymap-prefix (kbd "C-z p"))
    :init (projectile-global-mode 1)
    :config (setq projectile-switch-project-action 'projectile-dired))
   (pyflakes :defer t)
   (pylint
    :defer t
    :commands pylint
    :config (progn
              (setq
               pylint-command "pylint"
               pylint-options '("-E" "--reports=n" "--output-format=parseable"))))
   (python
    :defer t
    :commands python-mode
    :mode ("\\.py\\'" . python-mode))
   (python-pep8 :defer t)
   (regex-dsl)
   (request :defer t)
   (rust-mode
    :defer t
    :mode "\\.rs\\'")
   (s)
   (scala-mode
    :defer t
    :mode "\\.scala\\'"
    :config (scala-mode-feature-electric-mode))
   (scala-mode2 :defer t)
   ;; (shell-command :type elpa)
   (slime
    :defer t
    :require slime-company
    :commands slime
    :init (setq inferior-lisp-program "/usr/bin/sbcl")
    :config (progn
              (slime-setup (cons 'slime-company slime-contribs))
              ;; Key bindings
              (bind-key "RET" 'newline-and-indent slime-mode-map)))
   (slime-company
    :defer t)
   (ssh-config-mode :defer t)
   (term
    :bind ("C-z t" . user/ansi-term)
    :pre-load (progn
                (defun user/ansi-term ()
                  (interactive)
                  (ansi-term "/bin/bash" "shell"))

                (defun user/term-send-prev-word ()
                  (interactive)
                  (term-send-raw-string "\eb"))

                (defun user/term-send-next-word ()
                  (interactive)
                  (term-send-raw-string "\ef")))
    :config (progn
              (bind-key "C-z" 'term-stop-subjob term-raw-escape-map)
              (bind-key "<C-left>" 'user/term-send-prev-word term-raw-map)
              (bind-key "<C-right>" 'user/term-send-next-word term-raw-map)

              (add-hook-progn 'term-mode-hook (evil-local-mode -1))
              ;; TODO: make a term-exit-hook instead
              (defadvice term-handle-exit
                (after bind-q-to-kill-dead-term activate)
                (read-only-mode)
                (local-set-key (kbd "q") 'kill-this-buffer))

              ;; Terminals in emacs should be able to run tmux, regardless of
              ;; whether or not emacs was started within tmux.
              (setenv "TMUX" "")))
   (tidy
    :defer t
    :commands tidy-buffer
    ;; Tell the tidy command to tidy up XML files; by default,
    ;; it complains about XML being "malformed HTML".
    :config (setq tidy-shell-command "/usr/bin/tidy -xml"))
   (tramp
    ;; Theoretically, make TRAMP handle /sudo:root@host: paths by logging
    ;; in via the regular TRAMP ssh method, and then `sudo` to root.
    :config (setq tramp-default-proxies-alist '(((regexp-quote (system-name)) nil nil)
                                                (nil "\\`root\\'" "/ssh:%h:"))))
   (tron-theme
    :defer t
    :require color-theme
    :config (load-theme 'tron-theme t))
   (tronesque-theme
    :defer t
    :require color-theme
    :config (load-theme 'tronesque t))
   (ucs-utils :defer t)
   (undo-tree
    :diminish undo-tree-mode
    :init (global-undo-tree-mode 1))
   (unfill)
   (unicode-fonts)
   (unicode-whitespace)
   (vc
    :config (setq vc-follow-symlinks t))
   (wc-mode :defer t)
   (web-beautify :defer t)
   (web-mode
    :defer t
    :mode "\\.\\(p?html?\\|tpl\\|php\\|jsp\\|as[cp]x\\|erb\\)\\'"
    :config (setq web-mode-disable-auto-pairing nil))
   (window-jump
    :bind (("C-z <C-down>" . window-jump-down)
           ("C-z <down>" . window-jump-down)
           ("C-z <C-up>" . window-jump-up)
           ("C-z <up>" . window-jump-up)
           ("C-z <C-left>" . window-jump-left)
           ("C-z <left>" . window-jump-left)
           ("C-z <C-right>" . window-jump-right)
           ("C-z <right>" . window-jump-right)))
   (wrap-region)
   (xclip)
   (xt-mouse
    :if (not window-system)
    :defer t
    :init (xterm-mouse-mode t))
   (yasnippet :defer t)
   (zenburn-theme
    :require color-theme
    :config (progn
              (load-theme 'zenburn t)
              (set-face-background 'region "dark slate gray")))))

(req-packages pkgs-to-req)
(req-package-finish)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-safe-themes t)
 '(fci-rule-color "#383838")
 '(font-lock-maximum-decoration (quote ((org-mode) (tex-mode) (t . t))))
 '(safe-local-variable-values (quote ((eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook" (add-hook (quote write-contents-functions) (lambda nil (delete-trailing-whitespace) nil)) (require (quote whitespace)) "Sometimes the mode needs to be toggled off and on." (whitespace-mode 0) (whitespace-mode 1)) (whitespace-line-column . 80) (whitespace-style face tabs trailing lines-tail) (require-final-newline . t) (company-clang-arguments "-I/home/dralston/src/navsim/RG5/bootloader/include/")))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )





;;; For Time Sheets
(defun tbl-total-hours-to-money(wage original-string)
  (let* ((without-asterisks (replace-regexp-in-string
                             "\*" "" original-string))
         (hours (destructuring-bind (hours-str minutes-str)
                    (split-string without-asterisks ":")
                  (+ (string-to-number hours-str)
                     (/ (string-to-number minutes-str) 60.0)))))
    (format "$%.2d" (* hours wage))))

;; I want to start with an ielm buffer open
(save-window-excursion
  (ielm))

;;; Load Private Emacs Config
(when (file-exists-p "~/personal/personal.el")
  (load "~/personal/personal.el"))
