;;; Startup & Shutdown
(setq
 inhibit-startup-screen t
 initial-scratch-message ""
 confirm-kill-emacs 'y-or-n-p)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode t)
(set-face-attribute 'default nil :height 130)
(setq-default
 indent-tabs-mode nil
 tab-width 8)

;;;; Key Bindings ;;;;
(global-set-key (kbd "<C-return>") 'newline-and-indent)
(global-set-key (kbd "<mouse-3>") 'mouse-popup-menubar)
(global-set-key (kbd "<mouse-8>") 'previous-buffer)
(global-set-key (kbd "<mouse-9>") 'next-buffer)
(global-set-key (kbd "C-x C-M-k") 'kill-matching-buffers)
(global-set-key (kbd "C-h C-M-f") 'find-function)

(define-prefix-command 'user-map)
(global-set-key (kbd "C-z") 'user-map)
(define-key user-map (kbd "C-\\") 'toggle-hiding)
(define-key user-map (kbd "C--") 'toggle-selective-display)
(define-key user-map (kbd "C-z") 'suspend-frame)
(define-key user-map (kbd "M-w") 'clipboard-kill-ring-save)
(define-key user-map (kbd "C-r") 'rename-buffer)
(define-key user-map (kbd "e") 'eval-region)

;; Outline-mode
(require 'outline)
(define-key outline-minor-mode-map (kbd "<C-down>") 'outline-next-visible-heading)
(define-key outline-minor-mode-map (kbd "<C-up>") 'outline-previous-visible-heading)
(define-key outline-minor-mode-map (kbd "<M-down>") 'outline-move-subtree-down)
(define-key outline-minor-mode-map (kbd "<M-up>") 'outline-move-subtree-up)
(define-key outline-minor-mode-map (kbd "<M-left>") 'outline-promote)
(define-key outline-minor-mode-map (kbd "<M-right>") 'outline-demote)
(define-key outline-minor-mode-map (kbd "<C-M-tab>") 'outline-cycle)

;;; Configure Package.el And El-Get ;;;;

;;; Packages
(require 'package)

;; Setup package archives
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("MELPA" . "http://melpa.milkbox.net/packages/")
                         ;("Marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

;; Load packages
(package-initialize)

;;; Setup El-Get
(unless (require 'el-get nil t)
  (package-refresh-contents)
  (package-install 'el-get)
  (require 'el-get))

(require 'el-get-custom)

(setq el-get-verbose t)

(unless (require 'req-package nil t)
  (package-refresh-contents)
  (package-install 'req-package)
  (require 'req-package))

;;;; File-Wide Macros ;;;;

(defmacro add-hook-progn (hook &rest body)
  `(add-hook ,hook
             (lambda () . ,body)))

(defmacro after-init (&rest body)
  `(add-hook 'after-init-hook
             (lambda () ,body)))

;;;; Other Packages ;;;;

(let ((dir (file-name-directory el-get-status-file)))
  (unless (file-exists-p dir)
    (make-directory dir)))

(setq
 pkgs-to-req
 '((ace-jump-mode
    :commands (ace-jump-char-mode
               ace-jump-line-mode
               ace-jump-word-mode)
    :init (progn
            (define-key user-map (kbd "j") 'ace-jump-char-mode)
            (define-key user-map (kbd "l") 'ace-jump-line-mode)
            (define-key user-map (kbd "w") 'ace-jump-word-mode)))
   (adaptive-wrap :defer t)
   (aes :defer t)
   (alpha
    :defer t
    :config (progn
              (add-to-list 'default-frame-alist '(alpha . 100))))
   (ascii :defer t)
   (async
    :init (require 'async-bytecomp))
   (auctex
    :defer t
    :mode "\\.tex\\'"
    :config (progn
              (require 'tex)
              (require 'tex-site)
              (require 'preview)
              (add-hook 'LaTeX-mode-hook 'outline-minor-mode)))
   (auctex-latexmk :defer t)
   (auto-compile :defer t)
   (bash-completion
    :defer t
    :pre-load (add-hook 'term-mode-hook 'bash-completion-setup))
   (browse-kill-ring)
   (charmap :defer t)
   (cl-lib)
   (color-theme)
   (zenburn-theme :require color-theme)
   (company
    :config (progn
              (setq
               ;; Helm-company usually pukes if company
               ;; autocompletion starts after helm-company is
               ;; called.
               company-idle-delay 0

               ;; Get rid of company menu. I'll use helm.
               company-frontends
               (remove 'company-pseudo-tooltip-unless-just-one-frontend
                       company-frontends)

               company-backends
               (append '((company-gtags
                          company-ropemacs
                          company-elisp
                          company-dabbrev-code))
                       ;; I want to use
                       ;; helm-gtags instead.
                       (remove 'company-semantic company-backends)))))
   (concurrent :defer t)
   (crontab-mode :defer t)
   (csv-mode
    :defer t
    :mode "\\.csv\'")
   (ctable :defer t)
   (dash)
   (deferred :defer t)
   (dired+)
   (dired-efap)
   (dired-single)
   (ebib
    :defer t
    :mode "\\.bib\\'")
   (ecb :defer t)
   (erc
    :defer t
    :init (progn
            (defalias 'irc 'erc-tls)
            (define-key user-map (kbd "c j") 'erc-track-switch-buffer))
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

              (add-to-list 'erc-modules 'notifications)
              (add-hook 'erc-mode-hook (erc-log-enable))
              (add-hook 'erc-mode-hook (erc-notifications-enable))
              (add-hook 'erc-mode-hook (erc-track-enable))))
   (erlang-mod
    :defer t
    :mode "\\.erl\\'"
    :config (progn
              (setq
               erlang-root-dir "/usr/lib/erlang"
               exec-path (cons "/usr/lib/erlang/bin" exec-path))))
   (ess
    :defer t
    :config (progn
              (require 'ess-site)
              (setq
               ess-directory "~/.ess/"
               ess-ask-for-ess-directory nil)))
   (evil
    :pre-init (setq evil-toggle-key "C-`")
    :config (progn
              (require 'evil-matchit)
              (require 'evil-surround)
              (require 'evil-nerd-commenter)

              (add-hook 'org-capture-mode-hook 'evil-insert-state)
              (add-hook 'epa-key-list-mode-hook (lambda () (evil-local-mode -1)))
              (add-hook 'git-commit-mode-hook 'evil-insert-state)
              (add-hook 'term-mode-hook 'evil-emacs-state)
              (add-hook 'git-rebase-mode-hook 'evil-emacs-state)
              (add-hook 'julia-post-run-hook 'evil-insert-state)

              (define-key evil-insert-state-map (kbd "C-z") nil)
              (define-key evil-normal-state-map (kbd "C-z") nil)
              (define-key evil-emacs-state-map (kbd "C-z") nil)
              (define-key evil-motion-state-map (kbd "C-z") nil)

              (global-set-key (kbd "TAB") 'evil-indent)
              (define-key evil-normal-state-map (kbd "q") nil)

              (define-key evil-insert-state-map (kbd "C-e") nil)
              (define-key evil-insert-state-map (kbd "C-d") nil)
              (define-key evil-insert-state-map (kbd "C-k") nil)
              (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
              (define-key evil-visual-state-map (kbd "C-c") 'evil-normal-state)

              (define-key evil-motion-state-map (kbd "C-e") nil)
              (define-key evil-visual-state-map (kbd "C-c") 'evil-exit-visual-state)

              ;; For gtags
              (define-key evil-normal-state-map (kbd "M-.") nil)
              (define-key evil-visual-state-map (kbd "M-.") nil)

              ;; For helm
              (define-key evil-motion-state-map (kbd "C-y") nil)
              (define-key evil-insert-state-map (kbd "C-y") nil)))
   (evil-matchit :require evil)
   (evil-nerd-commenter :require evil)
   (evil-surround :require evil)
   (f :defer t)
   (flycheck :defer t)
   (flyspell
    :commands (flyspell-mode flyspell-prog-mode)
    :config (progn
              (add-hook 'org-mode-hook 'flyspell-mode)
              (add-hook 'markdown-mode-hook 'flyspell-mode)
              (add-hook 'fundamental-mode-hook 'flyspell-mode)
              (add-hook 'magit-log-edit-mode-hook 'flyspell-mode)
              (add-hook 'git-commit-mode-hook 'flyspell-mode)

              (add-hook 'asm-mode-hook 'flyspell-prog-mode)
              (add-hook 'python-mode-hook 'flyspell-prog-mode)
              (add-hook 'rust-mode-hook 'flyspell-prog-mode)
              (add-hook 'py-mode-hook 'flyspell-prog-mode)
              (add-hook 'c-mode-hook 'flyspell-prog-mode)
              (add-hook 'scala-mode-hook 'flyspell-prog-mode)
              (add-hook 'sh-mode-hook 'flyspell-prog-mode)
              (add-hook 'erlang-mode-hook 'flyspell-prog-mode)))
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
   (ggtags)
   (julia-mode
    :defer t
    :mode "\\.jl\\'")
   (haskell-mode
    :defer t
    :mode "\\.hs\\'"
    :config (add-hook-progn
             'haskell-mode-hook
             (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
             (add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
             (add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
             (add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)))
   (helm
    :pre-init (setq helm-command-prefix-key "C-z h")
    :init (progn
            (global-set-key (kbd "M-x") 'helm-M-x)
            (global-set-key (kbd "C-y") 'helm-show-kill-ring)
            (global-set-key (kbd "C-x b") 'helm-mini)
            (global-set-key (kbd "C-x C-f") 'helm-find-files)
            (global-set-key (kbd "C-h a") 'helm-apropos)
            (define-key user-map (kbd "<C-SPC>") 'helm-all-mark-rings)
            (define-key user-map (kbd "r") 'helm-regexp)
            (define-key user-map (kbd "o") 'helm-occur))
    :config (progn
              (require 'helm-config)
              (require 'helm-company)

              ;; Swap Tab and C-z in helm-mode, so Tab executes
              ;; persistent actions, and C-z opens the actions
              ;; menu.
              (define-key helm-map (kbd "<Tab>") 'helm-execute-persistent-action)
              (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
              (define-key helm-map (kbd "C-z")  'helm-select-action)

              (define-key helm-command-map (kbd "o") 'helm-occur)
              (define-key helm-command-map (kbd "x") 'helm-register)))
   (helm-company
    :require helm
    :config (global-set-key (kbd "<C-tab>") 'helm-company))
   (helm-gtags
    :require helm
    :config (progn
              (define-minor-mode helm-gtags-auto-update-mode
                "Auto update GTAGS when a file in this mode is saved."
                :init-value nil
                :group 'gtags-update
                (if helm-gtags-auto-update-mode
                    (progn
                      (add-hook 'after-save-hook 'helm-gtags-update-tags nil t))
                  (remove-hook 'after-save-hook 'helm-gtags-update-tags t)))

              (defun enable-helm-gtags-auto-update-mode()
                "Turn on `helm-gtags-auto-update-mode'."
                (interactive)
                (helm-gtags-auto-update-mode 1))

              (add-hook 'python-mode-hook     'enable-helm-gtags-auto-update-mode)
              (add-hook 'py-mode-hook         'enable-helm-gtags-auto-update-mode)
              (add-hook 'c-mode-hook          'enable-helm-gtags-auto-update-mode)
              (add-hook 'c++-mode-hook        'enable-helm-gtags-auto-update-mode)
              (add-hook 'lisp-mode-hook       'enable-helm-gtags-auto-update-mode)
              (add-hook 'sh-mode-hook         'enable-helm-gtags-auto-update-mode)
              (add-hook 'asm-mode-hook        'enable-helm-gtags-auto-update-mode)

              (setq
               helm-gtags-ignore-case t
               helm-gtags-auto-update t
               helm-gtags-use-input-at-cursor t
               helm-gtags-pulse-at-cursor t
               helm-gtags-suggested-key-mapping t)

              ;; Enable helm-gtags-mode in Dired so you can jump to any tag
              ;; when navigate project tree with Dired
              (add-hook 'dired-mode-hook 'helm-gtags-mode)

              ;; Enable helm-gtags-mode in languages that GNU Global supports
              (add-hook 'c-mode-hook 'helm-gtags-mode)
              (add-hook 'c++-mode-hook 'helm-gtags-mode)
              (add-hook 'java-mode-hook 'helm-gtags-mode)
              (add-hook 'asm-mode-hook 'helm-gtags-mode)

              (define-key helm-gtags-mode-map (kbd "M-s") 'helm-gtags-select)
              (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
              (define-key helm-gtags-mode-map (kbd "M-?") 'helm-gtags-find-rtag)
              (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
              (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
              (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)))
   (helm-package :require helm)
   (inline-crypt
    :commands (inline-crypt-decrypt-region
               inline-crypt-decrypt-string
               inline-crypt-encrypt-region
               inline-crypt-encrypt-string)
    :init (progn
            (define-key user-map (kbd "C-c C-d") 'inline-crypt-decrypt-region)
            (define-key user-map (kbd "C-c C-e") 'inline-crypt-encrypt-region)
            (define-key user-map (kbd "C-c d") 'inline-crypt-decrypt-string)
            (define-key user-map (kbd "C-c e") 'inline-crypt-encrypt-string)))
   (ipython :defer t)
   (js2-mode
    :defer t
    :mode "\\.js\\'")
   (json-mode
    :defer t
    :require json-reformat
    :mode "\\.json\\'")
   (json-reformat :defer t)
   (list-packages-ext)
   (list-processes+)
   (list-utils)
   (log4e :defer t)
   (magit
    :defer t
    :commands magit-status
    :init (progn
            (define-key user-map (kbd "v") 'magit-status)
            (setq magit-status-buffer-switch-function 'switch-to-buffer)))
   (markdown-mode
    :defer t
    :mode "\\.md\\'"
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
   (org
    :demand t
    :mode "\\.\\(org\\|org_archive\\)\\'"
    :init (progn
            ;; Global Init Config

            (define-key user-map (kbd "C-o ]") 'outline-next-heading)
            (define-key user-map (kbd "C-o [") 'outline-previous-heading)
            (define-key user-map (kbd "C-o a") 'org-agenda)
            (define-key user-map (kbd "C-o b")
              (lambda ()
                "Call `org-iswitchb' with two prefix args, restricting selection
                        to agenda files."
                (interactive)
                (org-iswitchb 14)))
            (define-key user-map (kbd "C-o c") 'org-capture)
            (define-key user-map (kbd "C-o j") 'org-clock-goto)
            (define-key user-map (kbd "C-o l") 'org-store-link)
            (define-key user-map (kbd "C-o o") 'org-clock-out)
            (define-key user-map (kbd "C-o <C-right>") 'org-demote-subtree)
            (define-key user-map (kbd "C-o <C-left>") 'org-promote-subtree))
    :config (progn
              ;; (require 'org-journal)
              ;; (require 'org-toc)

              ;; For `helm-show-kill-ring'
              (define-key org-mode-map (kbd "C-y") nil)

              ;; Default binding for <C-tab> is dumb. I want
              ;; `helm-company', dammit!
              (define-key org-mode-map (kbd "<C-tab>") nil)
              (define-key org-mode-map (kbd "<C-M-tab>") 'org-force-cycle-archived)

              ;; Make "C-z C-o a <RET>" display an overview of all tasks in my
              ;; agenda files.
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
   ;; (org-journal
   ;;  :defer t
   ;;  :require org)
   ;; (org-toc
   ;;  :defer t
   ;;  :require org)
   (outline-magic)
   (package+)
   (pg :defer t)
   (pkg-info)
   (popup :defer t)
   (pyflakes :defer t)
   (pylint
    :defer t
    :commands pylint
    :config (progn
              (setq
               pylint-command "pylint"
               pylint-options '("-E" "--reports=n" "--output-format=parseable"))))
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
    :commands slime
    :init (setq inferior-lisp-program "/usr/bin/sbcl")
    :require slime-company
    :config (progn
              (slime-setup (cons 'company-slime slime-contribs))
              ;; Key bindings
              (define-key slime-mode-map (kbd "RET") 'newline-and-indent)))
   (slime-company
    :defer t)
   (ssh-config-mode :defer t)
   (tidy
    :defer t
    :commands tidy-buffer
    ;; Tell the tidy command to tidy up XML files; by default,
    ;; it complains about XML being "malformed HTML".
    :config (setq tidy-shell-command "/usr/bin/tidy -xml"))
   (tron-theme :defer t)
   (tronesque-theme :defer t)
   (ucs-utils :defer t)
   (undo-tree)
   (unfill)
   (unicode-fonts)
   (unicode-whitespace)
   (wc-mode :defer t)
   (web-beautify :defer t)
   (web-mode
    :defer t
    :mode "\\.html?\\'"
    :mode "\\.phtml\\'"
    :mode "\\.tpl\\.php\\'"
    :mode "\\.jsp\\'"
    :mode "\\.as[cp]x\\'"
    :mode "\\.erb\\'"
    :mode "\\.mustache\\'"
    :mode "\\.djhtml\\'"
    :mode "\\.html?\\'"
    :config (setq web-mode-disable-auto-pairing nil))
                                        ;(workgroups)
   (wrap-region)
   (xclip)
   (yasnippet)))

(defmacro req-packages (pkg-defs)
  `(progn
     ,@(mapcar (lambda (pkg-def) (cons 'req-package pkg-def))
               (symbol-value pkg-defs))))

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




;;;; Configure Vanilla Emacs ;;;;



;; Disable set-fill-prefix. I have only ever used it by accident, and
;; to my annoyance.
(put 'set-fill-prefix 'disabled t)

;;; Interface
(xterm-mouse-mode t)
(setq doc-view-continuous t)
(show-paren-mode t)

;;; If a file changes on disk, and there are no changes in the buffer,
;;; automatically revert the file.
(global-auto-revert-mode t)

;; delete-trailing-whitespace before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Erc


;;; Asm Mode
(add-hook-progn 'asm-mode-hook
                ;; Make comments work better w/ fill-paragraph
                (set (make-local-variable 'paragraph-start)
                     "^\\s-*;+.*$"))

;;; C Mode
(setq c-default-style "K&R")
(setq c-basic-offset 8)
(setq tab-width 8)
(setq indent-tabs-mode nil)

;;; Python mode
(setq ropemacs-local-prefix "C-z p")
(autoload 'python-mode "python" "Python Mode." t)
(add-to-list 'auto-mode-alist '("/*.\.py$" . python-mode))

;;; Term config
(require 'term)
(define-key user-map (kbd "t")
  (defun user/ansi-term ()
    (interactive)
    (progn (ansi-term "/bin/bash" "shell"))))
(define-key term-raw-escape-map (kbd "C-z") 'user-map)
(define-key term-raw-map (kbd "<C-left>")
  (defun user/term-send-prev-word ()
    (interactive)
    (term-send-raw-string "\eb")))
(define-key term-raw-map (kbd "<C-right>")
  (defun user/term-send-next-word ()
    (interactive)
    (term-send-raw-string "\ef")))
;; Terminals in emacs should be able to run tmux, regardless of
;; whether or not emacs was started within tmux.
(setenv "TMUX" "")

;;; Version Control
(setq vc-follow-symlinks t)

;;; Electric Indent Mode
(electric-indent-mode 1)

;;; Tramp
(require 'tramp)
;; Theoretically, make TRAMP handle /sudo:root@host: paths by logging
;; in via the regular TRAMP ssh method, and then `sudo` to root.
(setq tramp-default-proxies-alist '(((regexp-quote (system-name)) nil nil)
                                    (nil "\\`root\\'" "/ssh:%h:")))

;;; XML
(setq
 ;; Indent children by 2 spaces
 nxml-child-indent 2)

;;; For Time Sheets
(defun tbl-total-hours-to-money(wage original-string)
  (let* ((without-asterisks (replace-regexp-in-string
                             "\*" "" original-string))
         (hours (destructuring-bind (hours-str minutes-str)
                    (split-string without-asterisks ":")
                  (+ (string-to-number hours-str)
                     (/ (string-to-number minutes-str) 60.0)))))
    (format "$%.2d" (* hours wage))))

;;; Sync Packages
(setq user:el-get-packages nil)
(setq user:el-get-packages
      (mapcar 'el-get-source-name el-get-sources))
(el-get 'sync user:el-get-packages)


;;; Enable Global Modes and Settings
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))
(add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))

(load-theme 'zenburn)
(global-company-mode 1)
(helm-mode 1)
(evil-mode 1)
(global-evil-matchit-mode 1)
(evil-surround-mode 1)

;;; Load Private Emacs Config
(when (file-exists-p "~/personal/personal.el")
  (load "~/personal/personal.el"))
