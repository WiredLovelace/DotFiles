(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs
					   helm-lsp projectile
					   hydra flycheck company
					   avy which-key helm-xref
					   dap-mode lsp-ui treemacs
					   magit treemacs-magit
					   treemacs-projectile
					   use-package dashboard
					   spacemacs-theme
					   all-the-icons elcord exwm org-roam
					   treemacs-all-the-icons))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; Helm mode
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

;; Which key
(which-key-mode)

;; lsp
(use-package lsp-mode
  :config
  (setq lsp-enable-snippet nil)

  ;; clangd
  (setq lsp-clients-clangd-args '(
                                  "--all-scopes-completion"
                                  "--background-index"
                                  "--clang-tidy"
                                  "--completion-parse=auto"
                                  "--completion-style=detailed"
                                  "--fallback-style=GNU"
                                  "--function-arg-placeholders"
                                  "--header-insertion=iwyu"
                                  "--index"
                                  "--suggest-missing-includes"
                                  "-j=2"
                                  ))
  :hook
  (
   (c-mode . lsp))
  :commands lsp)

(setq gc-cons-treshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.3)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (setq lsp-modeline-diagnostics-scope :workspace)
  (require 'dap-cpptools)
  (yas-global-mode))

(defun my-c-mode-before-save-hook ()
  (when (eq major-mode 'c-mode)
    (lsp-format-buffer)))

(add-hook 'before-save-hook #'my-c-mode-before-save-hook)

;; use-package
(require 'use-package)

;; ;; lsp-ui
(use-package lsp-ui)

(setq lsp-ui-sideline-show-diagnostics t
      lsp-ui-sideline-show-hover t
      lsp-ui-sideline-show-code-actions t
      lsp-ui-sideline-update-mode t
      lsp-ui-sideline-delay 0.5)

(setq lsp-ui-doc-enable t
      lsp-ui-doc-delay 1
      lsp-ui-doc-show-with-cursor t)

;; Magit
(require 'magit)
(global-set-key (kbd "<f9>") 'magit-status)

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                5000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always))

  :bind
  (:map global-map
	("<f8>" . treemacs)))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

;; The 80 characters rule
(setq display-fill-column-indicator-column 80)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; Show line and column number
(setq column-number-mode t)
(global-display-line-numbers-mode)

;; Theme
(load-theme 'spacemacs-dark t)

;; Hide toolbar and top menu
(tool-bar-mode -1)
(toggle-scroll-bar -1)
(menu-bar-mode -1)

(add-to-list 'default-frame-alist ; Hide the scrollbar
             '(vertical-scroll-bars . nil))

;; Change backup files
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

;; all-the-icons
(when (display-graphic-p)
  (require 'all-the-icons)

  (require 'treemacs-all-the-icons)
  (treemacs-load-theme "all-the-icons"))

;; elcord
(require 'elcord)
(elcord-mode)

;; Some other configs
(setq-default tab-width 2
	          c-basic-offset 2
	          kill-whole-line t
	          indent-tabs-mode nil)

(setq mouse-autoselect-window t
      focus-follow-mouse t)

;; EXWM
(defun exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun exwm-init-hook ()
  (display-battery-mode 1)

  (setq display-time-and-date t)
  (display-time-mode 1))

(use-package exwm
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspace-number 10)

  ;; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'exwm-update-class)

  ;; When EXWM starts up, do some extra configuration
  (add-hook 'exwm-init-hookj #'exwm-init-hook)

  ;; Rebind CapsLock to Ctrl
  (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

  ;; Set the screen resolution (update this to be the correct resolution for your screen!)
  (require 'exwm-randr)
  (exwm-randr-enable)
  (start-process-shell-command "xrandr" nil "xrandr --output eDP1 --primary --mode 1366x768 --pos 0x0 --rotate normal")
  (start-process-shell-command "xrandr" nil "xrandr --output DP-1 --mode 1600x900 --right-of eDP1")

  ;; Assign workspaces to second monitor
  (setq exwm-randr-workspace-monitor-plist '(1 "DP-1" 3 "DP-1" 5 "DP-1" 7 "DP-1" 9 "DP-1"))

  ;; Load the system tray before exwm-init
  (require 'exwm-systemtray)
  (setq exwm-systemtray-height 32)
  (exwm-systemtray-enable)

  ;; Automatically send the mouse cursor to the selected workspace's display
  (setq exwm-workspace-warp-cursor t)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
        '(?\C-x
          ?\C-u
          ?\C-h
          ?\M-x
          ?\M-`
          ?\M-&
          ?\M-:
          ?\C-\M-j  ;; Buffer list
          ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
        `(
          ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
          ([?\s-r] . exwm-reset)

          ;; Move between windows
          ([s-left] . windmove-left)
          ([s-right] . windmove-right)
          ([s-up] . windmove-up)
          ([s-down] . windmove-down)

          ;; Launch applications via shell command
          ([?\s-&] . (lambda (command)
                       (interactive (list (read-shell-command "$ ")))
                       (start-process-shell-command command nil command)))

          ;; Switch workspace
          ([?\s-w] . exwm-workspace-switch)
          ([?\s-`] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

          ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
          ,@(mapcar (lambda (i)
                      `(,(kbd (format "s-%d" i)) .
                        (lambda ()
                          (interactive)
                          (exwm-workspace-switch-create ,i))))
                    (number-sequence 0 9))))

  (exwm-enable))

;; Dashboard
(require 'dashboard)
(dashboard-setup-startup-hook)

(setq dashboard-banner-logo-title "Editor MACroS")
(setq dashboard-startup-banner 'logo)
(setq dashboard-center-content nil)
(setq dashboard-show-shortcuts nil)

(setq dashboard-items '((projects . 5)
                        (agenta . 5)
                        (registers . 5)))

;; Org Roam
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

(setq org-startup-indented t)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))