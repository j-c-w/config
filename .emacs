;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d91ef4e714f05fff2070da7ca452980999f5361209e679ee988e3c432df24347" default)))
 '(package-selected-packages
   (quote
    (org-alert alert-termux evil-commentary evl-commentary mu4e-alert mu4e doom-modeline solarized-theme telephone-line evil-surround pdf-tools ##))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Install packages automatically.
(setq package-list '(evil evil-surround pdf-tools key-chord telephone-line solarized-theme doom-modeline mu4e-alert all-the-icons evil-commentary org-alert alert))

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
	(package-install package)))

;; Load solarized.  Alternative is 'solarized-dark.
(load-theme 'solarized-light t)

;; Allows things to show alerts.
(require 'alert)
(add-to-list 'load-path "~/.emacs.d/evil")
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e")
(require 'evil)
(evil-mode 1)

(require 'evil-surround)
(require 'evil-commentary)
(evil-commentary-mode)
(require 'key-chord)
(key-chord-mode 1)

;; Move over my favorite vim mappings.
(key-chord-define evil-insert-state-map (kbd "jk") 'evil-normal-state)
(key-chord-define evil-insert-state-map (kbd "kj") 'evil-normal-state)
(key-chord-define evil-insert-state-map (kbd "JK") 'evil-normal-state)
(key-chord-define evil-insert-state-map (kbd "KJ") 'evil-normal-state)

(key-chord-define evil-normal-state-map (kbd "SPC w") 'evil-write)
(defun list-buffer-then-open ()
  (funcall 'list-buffers ())
  (interactive)
  (message "Buffer name")
  (funcall switch-to-buffer (read-file-name))
  )
(key-chord-define evil-normal-state-map (kbd "gb") 'list-buffer)

;; Add the PDF tool to enable PDF editing.
(pdf-loader-install)

(global-linum-mode t)
(global-undo-tree-mode 1)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Set up the mode line
(require 'doom-modeline)

(doom-modeline-mode 1)

;; How tall the mode-line should be. It's only respected in GUI.
;; If the actual char height is larger, it respects the actual height.
(setq doom-modeline-height 25)
;; How wide the mode-line bar should be. It's only respected in GUI.
(setq doom-modeline-bar-width 3)
;; Whether display icons in mode-line or not.
(setq doom-modeline-icon t)
;; Whether display the icon for major mode. It respects `doom-modeline-icon'.
(setq doom-modeline-major-mode-icon t)
;; Whether display color icons for `major-mode'. It respects
;; `doom-modeline-icon' and `all-the-icons-color-icons'.
(setq doom-modeline-major-mode-color-icon t)
;; Whether display icons for buffer states. It respects `doom-modeline-icon'.
(setq doom-modeline-buffer-state-icon t)
;; Whether display buffer modification icon. It respects `doom-modeline-icon'
;; and `doom-modeline-buffer-state-icon'.
(setq doom-modeline-buffer-modification-icon t)
;; Whether display minor modes in mode-line or not.
(setq doom-modeline-minor-modes nil)
;; If non-nil, a word count will be added to the selection-info modeline segment.
(setq doom-modeline-enable-word-count nil)
;; Whether display buffer encoding.
(setq doom-modeline-buffer-encoding t)
;; If non-nil, only display one number for checker information if applicable.
(setq doom-modeline-checker-simple-format t)
;; Whether display perspective name or not. Non-nil to display in mode-line.
(setq doom-modeline-persp-name t)
;; Whether display `lsp' state or not. Non-nil to display in mode-line.
(setq doom-modeline-lsp t)
;; Whether display mu4e notifications or not. Requires `mu4e-alert' package.
(setq doom-modeline-mu4e t)
;; Whether display irc notifications or not. Requires `circe' package.
(setq doom-modeline-irc t)
;; Function to stylize the irc buffer names.
(setq doom-modeline-irc-stylize 'identity)
;; Whether display environment version or not
(setq doom-modeline-env-version t)
;; What to dispaly as the version while a new one is being loaded
(setq doom-modeline-env-load-string "...")

;; Setup mu4e:
(require 'mu4e)
(setq mail-user-agent 'mu4e-user-agent)
(setq mu4e-get-mail-command "~/.scripts/updateofflineimap"
	  mu4e-update-interval 300) ;; Update every 300 seconds.
(setq mu4e-user-mail-addresses '(("woodruff.jackson@gmail.com" "j.c.woodruff@sms.ed.ac.uk")))
;; (setq mu4e-maildir "~/Mail/Gmail")
;; (setq mu4e-drafts-folder "/[Gmail].Drafts")
;; (setq mu4e-sent-folder "/[Gmail].Sent Mail")
;; (setq mu4e-trash-folder "/[Gmail].Trash")

;; (setq mu4e-sent-messages-behaviour 'delete)
;; (setq user-mail-address "woodruff.jackson@gmail.com"
      ;; user-full-name "Jackson Woodruff")
;; (setq message-send-mail-function 'smtpmail-send-it
      ;; starttls-use-gnutls t
      ;; smtpmail-starttls-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
	  ;; smtpmail-auth-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
      ;; smtpmail-smtp-server "smtp.gmail.com"
      ;; smtpmail-smtp-service 587)
(setq message-send-mail-function 'smtpmail-send-it
	starttls-use-gnutls t
	smtpmail-starttls-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
	smtpmail-auth-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
	smtpmail-smtp-server "smtp.gmail.com"
	smtpmail-smtp-service 587)
(setq mu4e-context-policy 'always-ask
      mu4e-compose-context-policy 'always-ask)

(setq mu4e-maildir "~/Mail"
      message-send-mail-function 'smtpmail-send-it
      mu4e-contexts
      `( ,(make-mu4e-context
	   :name "Edinburgh"
	   ;; :enter-func (lambda() (color-theme-buffer-local 'color-theme-robin-hood (current-buffer)))
	   :leave-func (lambda() (mu4e-message "Leaving Edinburgh"))
	   :match-func (lambda (msg) t)
	   :vars '(( user-mail-address . "J.C.Woodruff@sms.ed.ac.uk")
		   (user-full-name . "Jackson Woodruff")
		   (setq mu4e-drafts-folder "Edinburgh/Drafts")
		   (setq mu4e-sent-folder "Edinburgh/Sent Items")
		   (setq mu4e-trash-folder "Edinburgh/Archive")
		   (setq message-send-mail-function 'smtpmail-send-it
			 smtpmail-stream-type 'starttls
			 smtpmail-default-smtp-server "smtp.office365.com"
			 smtpmail-smtp-server "smtp.office365.com"
			 smtpmail-smtp-service 587
			 smtpmail-smtp-user "J.C.Woodruff@sms.ed.ac.uk")
		   )
	   )
	 ,(make-mu4e-context
	   :name "Gmail"
	   ;; :enter-func (lambda() (mu4e-message (color-theme-buffer-local 'color-theme-dark-blue2 (current-buffer))))
	   :leave-func (lambda() (mu4e-message "Leaving Gmail"))
	   :match-func (lambda (msg) t)
	   		 ;; (when msg
	   		 ;;   (mu4e-message-contact-field-matches msg (:from :to :cc :bcc) "woodruff.jackson@gmail.com")))
	   :vars '(( user-mail-address . "woodruff.jackson@gmail.com" )
		   ( user-full-name . "Jackson Woodruff" )
		   (setq mu4e-drafts-folder "Gmail/[Gmail].Drafts")
		   (setq mu4e-sent-folder "Gmail/[Gmail].Sent Mail")
		   (setq mu4e-trash-folder "Gmail/[Gmail].Trash")
		   (setq mu4e-sent-messages-behaviour 'delete)
		   (setq user-mail-address "woodruff.jackson@gmail.com"
		         user-full-name "Jackson Woodruff")
		   (setq message-send-mail-function 'smtpmail-send-it
			 starttls-use-gnutls t
			 smtpmail-starttls-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
			 smtpmail-auth-credentials '(("smtp.gmail.com" 587 "woodruff.jackson@gmail.com" nil))
			 smtpmail-smtp-server "smtp.gmail.com"
			 smtpmail-smtp-service 587)
		   )
	   )
	 
	 )
      )

;; Make Chromium the default browswer that opens
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")

;; Make the font a bit bigger by default.  The size is the last element / 10.
(set-face-attribute 'default nil :height 140)

;; Setup mu4e alerts.
(require 'mu4e-alert)
(mu4e-alert-set-default-style 'libnotify)
(add-hook 'after-init-hook #'mu4e-alert-enable-mode-line-display)

;; Get all the icons:
(require 'all-the-icons)

;; Alerts for org mode
(require 'org-alert)
(setq alert-default-style 'libnotify)
