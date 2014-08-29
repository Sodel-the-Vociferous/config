;;; Add site-lisp to my load path
(add-to-list 'load-path "~/.emacs.d/site-lisp/")

;;; Packages
(require 'package)

;; Setup package archives
(setq package-archives '(("org" . "http://orgmode.org/elpa/")
                         ("MELPA" . "http://melpa.milkbox.net/packages/")
                         ("Marmalade" . "http://marmalade-repo.org/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))

;; Load packages
(package-initialize)


;;; Startup
(setq
 inhibit-startup-screen t
 initial-scratch-message "")

;;; Shutdown
(setq confirm-kill-emacs 'y-or-n-p)

;;; Appearance
(column-number-mode t)
(set-face-attribute 'default nil :height 130)
(setq-default
 indent-tabs-mode nil
 tab-width 8)

;; Disable the X toolbar, the menu bar, and the scroll bar
(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Disable set-fill-prefix. I have only ever used it by accident, and
;; to my annoyance.
(put 'set-fill-prefix 'disabled t)

;;; Interface
(xterm-mouse-mode t)
(setq doc-view-continuous t)
(show-paren-mode t)

;;; Key Bindings
(global-set-key (kbd "<C-return>") 'newline-and-indent)
(global-set-key (kbd "<mouse-3>") 'mouse-popup-menubar)
(global-set-key (kbd "<mouse-8>") 'previous-buffer)
(global-set-key (kbd "<mouse-9>") 'next-buffer)
(global-set-key (kbd "C-x C-M-k") 'kill-matching-buffers)

(define-prefix-command 'user-map)
(global-set-key (kbd "C-z") 'user-map)
(define-key user-map (kbd "C-\\") 'toggle-hiding)
(define-key user-map (kbd "C--") 'toggle-selective-display)
(define-key user-map (kbd "C-z") 'suspend-frame)
(define-key user-map (kbd "p k") 'kill-paragraph)
(define-key user-map (kbd "M-w") 'clipboard-kill-ring-save)
(define-key user-map (kbd "C-r") 'rename-buffer)
(define-key user-map (kbd "t") 'user/ansi-term)
(define-key user-map (kbd "e") 'eval-region)

(define-prefix-command 'user-chat-map)
(define-key user-map (kbd "c") user-chat-map)

;; Org Key bindings
(define-prefix-command 'user-org-outline-map)
(define-key user-map (kbd "C-o") user-org-outline-map)
(define-key user-org-outline-map (kbd "]") 'outline-next-heading)
(define-key user-org-outline-map (kbd "[") 'outline-previous-heading)
(define-key user-org-outline-map (kbd "a") 'org-agenda)
(define-key user-org-outline-map (kbd "b") 'user/org-iswitchb-agenda-only)
(define-key user-org-outline-map (kbd "c") 'org-capture)
(define-key user-org-outline-map (kbd "j") 'org-clock-goto)
(define-key user-org-outline-map (kbd "l") 'org-store-link)
(define-key user-org-outline-map (kbd "o") 'org-clock-out)
(define-key user-org-outline-map (kbd "<C-right>") 'org-demote-subtree)
(define-key user-org-outline-map (kbd "<C-left>") 'org-promote-subtree)

(defun user/org-iswitchb-agenda-only ()
"Call `org-iswitchb' with two prefix args, restricting selection
to agenda files."
  (interactive)
  (let ((current-prefix-arg '(16)))
    (call-interactively 'org-iswitchb t)))

;; Terminal Config
(require 'term)
(defun user/ansi-term () (interactive) (progn (ansi-term "/bin/bash" "shell")))
(defun user/term-send-prev-word () (interactive) (term-send-raw-string "\eb"))
(defun user/term-send-next-word () (interactive) (term-send-raw-string "\ef"))
(define-key term-raw-map (kbd "<C-left>") 'user/term-send-prev-word)
(define-key term-raw-map (kbd "<C-right>") 'user/term-send-next-word)
(define-key term-raw-escape-map (kbd "C-z") 'user-map)

;; Terminals in emacs should be able to run tmux, regardless of
;; whether or not emacs was started within tmux.
(setenv "TMUX" "")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-safe-themes t)
 '(fci-rule-color "#383838")
 '(font-lock-maximum-decoration (quote ((org-mode) (tex-mode) (t . t)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Theme
;; Zenburn
;; Tronesque
(load-theme 'zenburn)
(enable-theme 'zenburn)

;;; Setup saving/restoring list of installed emacs packages
(require 'save-packages)
(setq save-packages-file "~/config/pkgs/emacs-pkgs")
(defadvice install-saved-packages (before refresh-pkgs activate)
  (package-refresh-contents))

;; Set transparency
(require 'alpha)
(add-to-list 'default-frame-alist '(alpha . 100))

;;; Workgroups, i.e. frame layouts; only load if my workgroups file
;;; exists and is readable.
(require 'workgroups)
(define-key user-map (kbd "w") 'wg-map)

(setq user/wg-file "~/.emacs-workgroups")
(if (file-readable-p user/wg-file)
    (progn (workgroups-mode t)
           (wg-load user/wg-file))
  nil)

;;; Don't use Lisp's regex syntax for interactive regexes; too many
;;; backslashes.
(setq reb-re-syntax 'string)

;;; If a file changes on disk, and there are no changes in the buffer,
;;; automatically revert the file.
(global-auto-revert-mode t)

;;; Flyspell mode hooks
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
(add-hook 'erlang-mode-hook 'flyspell-prog-mode)

;;; Electric Indent Mode
(electric-indent-mode 1)

;;; CEDET
(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
(require 'cedet)

;; Semantic
(require 'cc-mode)
(require 'semantic)
(require 'semantic-ia)
(require 'semantic-clang)

(semantic-load-enable-minimum-features)
(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

;; Senator
(require 'senator)

;; EDE
(require 'ede)
(global-ede-mode 1)

;;; Tramp
(require 'tramp)
;; Theoretically, make TRAMP handle /sudo:root@host: paths by logging
;; in via the regular TRAMP ssh method, and then `sudo` to root.
(setq tramp-default-proxies-alist '(((regexp-quote (system-name)) nil nil)
                                    (nil "\\`root\\'" "/ssh:%h:")))

;;; Company Mode
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)
(setq company-frontends '(company-echo-metadata-frontend company-preview-frontend))

;;; ace-jump-mode
(require 'ace-jump-mode)
(define-key user-map (kbd "j") 'ace-jump-mode)

;;; Org
(require 'org)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\)$" . org-mode))

;;; Org Appearance
(setq
 ;; Render special formatting in buffer
 org-pretty-entities t
 org-pretty-entities-include-sub-superscripts t
 org-columns-default-format "%45ITEM %TODO %3PRIORITY %6Effort(Effort){:} %6CLOCKSUM(Time){:}")

;;; Org Capture
(setq
 org-default-notes-file "~/personal/refile.org"
 org-cycle-separator-lines 2)

;;; Org Journal
(setq org-journal-dir "~/org/journal/")

;;; Org Agenda
(setq
 org-agenda-start-on-weekday nil
 org-agenda-start-with-clockreport-mode nil
 org-agenda-start-with-log-mode t
 org-agenda-skip-additional-timestamps-same-entry t
 org-agenda-dim-blocked-tasks nil
 org-agenda-overriding-columns-format "%CATEGORY %45ITEM %TODO %3PRIORITY %6Effort(Effort){:} %6CLOCKSUM(Time){:}"
 org-agenda-remove-tags 'prefix
 org-agenda-sorting-strategy '((agenda time-up priority-down habit-down category-up)
                               (todo priority-down category-up todo-state-up)
                               (tags priority-down category-up todo-state-up)
                               (search priority-down category-up todo-state-up))
 org-agenda-window-setup 'same-window
 org-agenda-custom-commands
 ;; Make "C-c a <RET>" display an overview of all tasks in my
 ;; agenda files.
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
 ;; When prompting for an org-mode path, construct the path
 ;; incrementally.
 org-outline-path-complete-in-steps nil
 org-refile-use-outline-path 'file
 ;; When refiling to a parent node that doesn't exist, prompt to
 ;; create it.
 org-refile-allow-creating-parent-nodes 'confirm
 org-completion-use-ido t
 ido-everywhere t
 ido-max-directory-size 100000)

;;; Org Tags
(setq
;; Don't make children inherit "prj" tag from parent items
 org-tags-exclude-from-inheritance '("prj"))

;;; Org State Workflow
(setq org-todo-keywords
      '(;; Work Statuses
        (sequence "FUTURE(f)" "OnHOLD(h@/!)" "TODO(t@)" "NEXT(n@)" "WIP(w@)" "|" "DONE(d@)")
        ;; Extraordinary Statuses
        (sequence "|" "CANCELLED(c@)")))

;;; Org Export
(setq
 org-latex-pdf-process '("latexmk -bibtex -pdf %f && latexmk -c")
 org-export-creator-info nil
 org-export-with-sub-superscripts t
 ;; When exporting to ODT, convert it to a PDF, too
 org-export-odt-preferred-output-format "pdf"
 ;; Remove logfiles after exporting a PDF
 org-export-pdf-remove-logfiles t)

;;; Org Time/Clocking
(setq
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
 org-time-clocksum-format '(:hours "%d" :require-hours t :minutes ":%02d" :require-minutes t))

;;; Outline
(define-key outline-minor-mode-map (kbd "<C-down>") 'outline-next-visible-heading)
(define-key outline-minor-mode-map (kbd "<C-up>") 'outline-previous-visible-heading)
(define-key outline-minor-mode-map (kbd "<M-down>") 'outline-move-subtree-down)
(define-key outline-minor-mode-map (kbd "<M-up>") 'outline-move-subtree-up)
(define-key outline-minor-mode-map (kbd "<M-left>") 'outline-promote)
(define-key outline-minor-mode-map (kbd "<M-right>") 'outline-demote)
(define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)


;;; Version Control
(setq vc-follow-symlinks t)

;;; Inline encryption
(require 'inline-crypt)
(define-key user-map (kbd "C-c C-d") 'inline-crypt-decrypt-region)
(define-key user-map (kbd "C-c C-e") 'inline-crypt-encrypt-region)
(define-key user-map (kbd "C-c d") 'inline-crypt-decrypt-string)
(define-key user-map (kbd "C-c e") 'inline-crypt-encrypt-string)

;;; Magit
(require 'magit)
(define-key user-map (kbd "v") 'magit-status)
(setq magit-status-buffer-switch-function 'switch-to-buffer)

;;; Python mode
(require 'python)
(add-to-list 'auto-mode-alist '("/*.\.py$" . python-mode))

(require 'pylint)
(setq
 pylint-command "pylint"
 pylint-options '("-E" "--reports=n" "--output-format=parseable"))

;;; IPython
(require 'ein)
(setq ein:use-auto-complete-superpack t)

;;; Erlang Mode
(setq erlang-root-dir "/usr/lib/erlang")
(setq exec-path (cons "/usr/lib/erlang/bin" exec-path))
(require 'erlang)
(add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))

;;; C Mode
(setq c-default-style "K&R")
(setq c-basic-offset 8)
(setq tab-width 8)
(setq indent-tabs-mode nil)

;;; Scala Mode
(require 'scala-mode-auto)
(add-hook 'scala-mode-hook
          '(lambda ()
             (scala-mode-feature-electric-mode)))
(require 'scala-mode)
(add-to-list 'auto-mode-alist '("\\.scala$" . scala-mode))

;;; Asm Mode
(add-hook 'asm-mode-hook
          ;; Make comments work better w/ fill-paragraph
          (lambda () (set (make-local-variable 'paragraph-start)
                          "^\\s-*;+.*$")))

;;; C# Mode
(require 'csharp-mode)
(require 'flymake)
(setq csharp-want-flymake-fixup nil)

;;; Haskell Mode
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)

;; ;;; Slime
;; (require 'slime)
;; (setq inferior-lisp-program "/usr/bin/sbcl")
;; (slime-setup)
;; ;; Key bindings
;; (define-key slime-mode-map (kbd "RET") 'newline-and-indent)

;;; XML Stuff
(setq
;; Indent children by 2 spaces
 nxml-child-indent 2
;; Tell the tidy command to tidy up XML files; by default, it
;; complains about XML being "malformed HTML".
 tidy-shell-command "/usr/bin/tidy -xml")

;;; Web-Mode
(require 'web-mode)
(setq web-mode-disable-auto-pairing nil)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;; CSV Mode
(require 'csv-mode)

;;; Misc.
;; delete-trailing-whitespace before saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;; Hide-Show Mode
(defun toggle-selective-display (column)
  (interactive "P")
  (set-selective-display
   (or column
       (unless selective-display
         (1+ (current-column))))))

(defun toggle-hiding (column)
      (interactive "P")
      (if hs-minor-mode
          (if (condition-case nil
                  (hs-toggle-hiding)
                (error t))
              (hs-show-all))
        (toggle-selective-display column)))

(add-hook 'c-mode-common-hook   'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook       'hs-minor-mode)
(add-hook 'python-mode-hook     'hs-minor-mode)
(add-hook 'sh-mode-hook         'hs-minor-mode)
(add-hook 'perl-mode-hook       'hs-minor-mode)
(add-hook 'java-mode-hook       'hs-minor-mode)

;;; ERC IRC Client
(require 'tls)
(require 'erc)
(defalias 'irc 'erc-tls)
(define-key user-chat-map (kbd "j") 'erc-track-switch-buffer)

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

(add-hook 'erc-hooks 'erc-track-mode)
(add-to-list 'erc-modules 'notifications)

;;; Evil
(setq evil-toggle-key "C-`")
(require 'evil)
(require 'evil-matchit)
(global-evil-matchit-mode 1)

;;; Load Private Emacs Config
(when (file-exists-p "~/personal/personal.el")
  (load "~/personal/personal.el"))

(evil-mode)
(global-surround-mode 1)
(add-hook 'org-capture-mode-hook 'evil-insert-state)
(add-hook 'epa-key-list-mode-hook (lambda () (evil-local-mode -1)))
(add-hook 'git-commit-mode-hook 'evil-insert-state)
(add-hook 'term-mode-hook 'evil-emacs-state)
(add-hook 'git-rebase-mode-hook 'evil-emacs-state)
(add-hook 'julia-post-run-hook 'evil-insert-state)

(global-set-key (kbd "TAB") 'evil-indent)
(define-key evil-normal-state-map (kbd "q") nil)
(define-key evil-normal-state-map (kbd "M-.") nil)
(define-key evil-visual-state-map (kbd "M-.") nil)

(define-key evil-insert-state-map (kbd "C-e") nil)
(define-key evil-insert-state-map (kbd "C-d") nil)
(define-key evil-insert-state-map (kbd "C-k") nil)
(define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
(define-key evil-visual-state-map (kbd "C-c") 'evil-normal-state)

(define-key evil-motion-state-map (kbd "C-e") nil)
(define-key evil-visual-state-map (kbd "C-c") 'evil-exit-visual-state)

;;; LaTeX
(require 'tex)
(require 'tex-site)
(require 'preview)
(require 'auctex-latexmk)
(add-hook 'LaTeX-mode-hook 'outline-minor-mode)

(require 'julia-mode)
(add-to-list 'load-path "~/.emacs.d/site-lisp/ESS/lisp")
(require 'ess-site)
(require 'ess)
(setq ess-ask-for-ess-directory nil)

(setq ess-directory "~/.ess/")

;;; Markdown-Mode
(require 'markdown-mode)
(setq markdown-enable-math t) ; LaTeX math
;; Electric-indent buggers indentation up in markdown-mode
(add-hook 'markdown-mode-hook
          (lambda ()
            (add-hook 'electric-indent-functions
                      (lambda (_unused) 'no-indent) nil 'local)))

;;; Helm
(require 'helm)
(setq helm-command-prefix-key "C-z h")
(require 'helm-config)
(helm-mode 1)

(define-key helm-map (kbd "<Tab>") 'helm-execute-persistent-action) ; rebind tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h a") 'helm-apropos)
(define-key user-map (kbd "<C-SPC>") 'helm-all-mark-rings)
(define-key user-map (kbd "r") 'helm-regexp)
(define-key user-map (kbd "o") 'helm-occur)

(define-key helm-command-map (kbd "o") 'helm-occur)
(define-key helm-command-map (kbd "x") 'helm-register)

(require 'helm-company)
(global-set-key (kbd "<C-tab>") 'helm-company)

;;; Helm Gtags
(require 'helm-gtags)
(require 'ctags-auto-update-mode)
(add-hook 'python-mode-hook     'ctags-auto-update-mode)
(add-hook 'py-mode-hook         'ctags-auto-update-mode)
(add-hook 'c-mode-common-hook   'ctags-auto-update-mode)
(add-hook 'emacs-lisp-mode-hook 'ctags-auto-update-mode)
(add-hook 'lisp-mode-hook       'ctags-auto-update-mode)
(add-hook 'sh-mode-hook         'ctags-auto-update-mode)
(add-hook 'asm-mode-hook        'ctags-auto-update-mode)

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
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)
