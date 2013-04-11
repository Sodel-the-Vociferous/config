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
(setq inhibit-startup-screen t)

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
(define-key user-map (kbd "r") 'rename-buffer)
(define-key user-map (kbd "t") 'user/ansi-term)

(define-prefix-command 'user-chat-map)
(define-key user-map (kbd "c") user-chat-map)

;; Org Key bindings
(define-prefix-command 'user-org-outline-map)
(define-key user-map (kbd "o") user-org-outline-map)
(define-key user-org-outline-map (kbd "]") 'outline-next-heading)
(define-key user-org-outline-map (kbd "[") 'outline-previous-heading)
(define-key user-org-outline-map (kbd "a") 'org-agenda)
(define-key user-org-outline-map (kbd "b") 'org-iswitchb)
(define-key user-org-outline-map (kbd "c") 'org-capture)
(define-key user-org-outline-map (kbd "j") 'org-clock-goto)
(define-key user-org-outline-map (kbd "l") 'org-store-link)
(define-key user-org-outline-map (kbd "o") 'org-clock-out)
(define-key user-org-outline-map (kbd "<C-right>") 'org-demote-subtree)
(define-key user-org-outline-map (kbd "<C-left>") 'org-promote-subtree)

;; Terminal Config
(require 'term)
(defun user/ansi-term () (interactive) (progn (ansi-term "/bin/bash" "shell")))
(defun user/term-send-prev-word () (interactive) (term-send-raw-string "\eb"))
(defun user/term-send-next-word () (interactive) (term-send-raw-string "\ef"))
(define-key term-raw-map (kbd "<C-left>") 'user/term-send-prev-word)
(define-key term-raw-map (kbd "<C-right>") 'user/term-send-next-word)
(define-key term-raw-escape-map (kbd "C-z") 'user-map)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#3f3f3f" "#cc9393" "#7f9f7f" "#f0dfaf" "#8cd0d3" "#dc8cc3" "#93e0e3" "#dcdccc"])
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes (quote ("405c5240a912732cac2b373354729594c56d6edee0962d5a848429a4e4e3edef" "84c93dd294de8d877259fe2a4ab6540aaadbba3fbeb466692187f7a265c41203" "1df4f61bb50f58d78e88ea75fb8ce27bac04aef1032d4ea6dafe4667ef39eb41" "4e72cb2841e4801ba202a120c1cffdf88f5512536e557d03b3626d890b52f201" "f5e56ac232ff858afb08294fc3a519652ce8a165272e3c65165c42d6fe0262a0" "36a309985a0f9ed1a0c3a69625802f87dee940767c9e200b89cdebdb737e5b29" "0bac11bd6a3866c6dee5204f76908ec3bdef1e52f3c247d5ceca82860cccfa9d" "27470eddcaeb3507eca2760710cc7c43f1b53854372592a3afa008268bcf7a75" default)))
 '(fci-rule-color "#383838")
 '(font-lock-maximum-decoration (quote ((org-mode) (tex-mode) (t . t)))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Setup saving/restoring list of installed emacs packages
(require 'save-packages)
(setq save-packages-file "~/config/pkgs/emacs-pkgs")
(defadvice install-saved-packages (before refresh-pkgs activate)
  (package-refresh-contents))

;; Set transparency
(require 'alpha)
(add-to-list 'default-frame-alist '(alpha . 90))

;;; Workgroups, i.e. frame layouts; only load if my workgroups file
;;; exists and is readable.
(require 'workgroups)
(define-key user-map (kbd "w") 'wg-map)

(setq user/wg-file "~/.emacs-workgroups")
(if (file-readable-p user/wg-file)
    (progn (workgroups-mode t)
           (wg-load user/wg-file))
  nil)

;;; Don't quote regex special chars when yanking into isearch-regexp
;;; buffers. BLOODY ANNOYING, THAT.
(require 'isearch+)
(setq isearchp-regexp-quote-yank-flag nil)

;;; Don't use Lisp's regex syntax for interactive regexes; too many
;;; backslashes.
(setq reb-re-syntax 'string)

;;; If a file changes on disk, and there are no changes in the buffer,
;;; automatically revert the file.
(global-auto-revert-mode t)

;;; Flyspell mode hooks
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'fundamental-mode-hook 'flyspell-mode)
(add-hook 'magit-log-edit-mode-hook 'flyspell-mode)
(add-hook 'git-commit-mode-hook 'flyspell-mode)
(add-hook 'erc-mode-hook 'flyspell-mode)

(add-hook 'asm-mode-hook 'flyspell-prog-mode)
(add-hook 'python-mode-hook 'flyspell-prog-mode)
(add-hook 'py-mode-hook 'flyspell-prog-mode)
(add-hook 'c-mode-hook 'flyspell-prog-mode)
(add-hook 'scala-mode-hook 'flyspell-prog-mode)
(add-hook 'sh-mode-hook 'flyspell-prog-mode)
(add-hook 'erlang-mode-hook 'flyspell-prog-mode)

;;; CEDET
(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
(require 'cedet)
(require 'semantic)
(require 'semantic-ia)
(require 'semantic-gcc)
(semantic-load-enable-code-helpers)

;;; Tramp
(require 'tramp)
;; Theoretically, make TRAMP handle /sudo:root@host: paths by logging
;; in via the regular TRAMP ssh method, and then `sudo` to root.
(setq tramp-default-proxies-alist '(((regexp-quote (system-name)) nil nil)
                                    (nil "\\`root\\'" "/ssh:%h:")))

;;; Ido-Mode
(require 'ido)
(setq
 ido-ignore-buffers '(".*Completion" "^\*Ido" "^\*trace")
 ido-case-fold t
 ido-use-filename-at-point nil
 ido-use-url-at-point nil
 ido-enable-flex-matching nil
 ido-max-prospects 8
 confirm-nonexistent-file-or-buffer nil
 ;; Don't search through my history, just this directory. Jumping to a
 ;; completely different dir is ANNOYING.
 ido-enable-last-directory-history nil
 ido-record-commands nil
 ido-max-work-directory-list 0
 ido-max-work-file-list 0)
(ido-mode 'both)

;;; Idomenu (imenu integration, for jumping to symbols)
(require 'icomplete+)
(icomplete-mode 1)

;;; Ctags
(require 'ctags)
(require 'ctags-update)

;; Hooks
(add-hook 'python-mode-hook     'ctags-auto-update-mode)
(add-hook 'py-mode-hook         'ctags-auto-update-mode)
(add-hook 'c-mode-common-hook   'ctags-auto-update-mode)
(add-hook 'emacs-lisp-mode-hook 'ctags-auto-update-mode)
(add-hook 'lisp-mode-hook       'ctags-auto-update-mode)
(add-hook 'sh-mode-hook         'ctags-auto-update-mode)
(add-hook 'asm-mode-hook        'ctags-auto-update-mode)

;;; Auto-Complete
(require 'auto-complete)
(require 'auto-complete-config)

(global-set-key (kbd "<C-tab>") 'auto-complete)
(add-to-list 'ac-modes 'asm-mode)
(add-to-list 'ac-modes 'org-mode)
(ac-config-default)

;;; ace-jump-mode
(require 'ace-jump-mode)
(define-key user-map (kbd "C-SPC") 'ace-jump-mode)

;;; Org
(require 'org)
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;;; Org Appearance
(setq
 ;; Render special formatting in buffer
 org-pretty-entities t
 ;; Don't render subscripts/superscripts in-buffer
 org-pretty-entities-include-sub-superscripts nil
 org-columns-default-format "%36ITEM %TODO %3PRIORITY %6Effort(Effort){:} %6CLOCKSUM(Time){:}")

;;; Org Capture
(setq
 org-default-notes-file "~/personal/refile.org"
 org-cycle-separator-lines 2)

;;; Org Agenda
(setq
 org-agenda-start-on-weekday nil
 org-agenda-start-with-clockreport-mode t
 org-agenda-start-with-log-mode t
 org-agenda-skip-additional-timestamps-same-entry t
 org-agenda-dim-blocked-tasks nil
 org-agenda-overriding-columns-format "%CATEGORY %40ITEM(Task) %8Effort{:} %5CLOCKSUM(Time){:}"
 org-agenda-remove-tags 'prefix
 org-agenda-sorting-strategy '((agenda time-up priority-down habit-down category-up)
                               (todo priority-down category-up todo-state-up)
                               (tags priority-down category-up todo-state-up)
                               (search priority-down category-up todo-state-up)))
(setq org-agenda-custom-commands
      ;; Make "C-c a <space>" display an overview of all tasks in my
      ;; agenda files.
      '((" " "Agenda Tasks"
         ((agenda "" ((org-agenda-overriding-header "== Agenda ==")))
          (tags "+REFILE/" ((org-agenda-overriding-header "Tasks to Refile")
                            (org-tags-match-list-sublevels nil)))
          (tags-todo "/+STARTED" ((org-agenda-overriding-header "Tasks In Progress")
                                  (org-agenda-todo-ignore-deadlines t)
                                  (org-tags-match-list-sublevels t)))
          (tags-todo "-meta/NEXT" ((org-agenda-overriding-header "Next Tasks")
                                   (org-agenda-todo-ignore-deadlines t)
                                   (org-tags-match-list-sublevels t)))
          (tags-todo "/+TODO" ((org-agenda-overriding-header "Tasks")
                               (org-agenda-todo-ignore-scheduled t)
                               (org-agenda-todo-ignore-deadlines nil)))
          (tags-todo "/WAITING" ((org-agenda-overriding-header "Waiting Tasks")
                                 (org-agenda-todo-ignore-scheduled t)
                                 (org-agenda-todo-ignore-deadlines nil)))
          (tags-todo "/FUTURE" ((org-agenda-overriding-header "Future Tasks")
                                (org-agenda-todo-ignore-scheduled t)
                                (org-agenda-todo-ignore-deadlines t)))
          (tags "-archived/DONE|CANCELLED" ((org-agenda-overriding-header "Tasks to Archive")))) nil)))

(setq
 ;; When prompting for an org-mode path, construct the path
 ;; incrementally.
 org-outline-path-complete-in-steps nil
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
        (sequence "FUTURE(f)" "WAITING(w@/!)" "TODO(t@)" "NEXT(n@)" "STARTED(s@)" "|" "DONE(d@)")
        ;; Extraordinary Statuses
        (sequence "|" "CANCELLED(c@)")))

;;; Org Export
(setq
 org-export-creator-info nil
 org-export-with-sub-superscripts nil
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
 org-log-into-drawer t)

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

;;; Git Gutter: show lines that have been added/removed/changed
;;; compared to files as stored in git.
(require 'git-gutter)
(setq
 git-gutter:always-show-gutter t
 git-gutter:diff-option "-w")
(global-git-gutter-mode t)

;;; Python mode
(require 'python-mode)
(add-to-list 'auto-mode-alist '("/*.\.py$" . python-mode))

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

;;; Slime
(require 'slime)
(setq inferior-lisp-program "/usr/bin/sbcl")
(slime-setup)
;; Key bindings
(define-key slime-mode-map (kbd "RET") 'newline-and-indent)

;;; XML Stuff
(setq
;; Indent children by 2 spaces
 nxml-child-indent 2
;; Tell the tidy command to tidy up XML files; by default, it
;; complains about XML being "malformed HTML".
 tidy-shell-command "/usr/bin/tidy -xml")

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
(define-key user-chat-map (kbd "j") 'erc-track-switch-buffer)

(setq
 erc-port 6697
 erc-prompt-for-password t
 erc-mode-line-format "%t %a"
 erc-kill-queries-on-quit t
 erc-kill-buffer-on-part t
 erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"))

(add-hook 'erc-hooks 'erc-track-mode)
(defalias 'irc 'erc-tls)

;;; Load Private Emacs Config
(when (file-exists-p "~/personal/personal.el")
  (load "~/personal/personal.el"))
