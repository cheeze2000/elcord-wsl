;;; elcord-wsl.el -- Discord RPC for Emacs on WSL

;;; Commentary:
;;; Code:
(require 'json)

(defvar elcord-wsl--assets-alist '(("_default" . "_default"))
  "The rich presence assets used for each buffer name.")

(defvar elcord-wsl--client-id "698809287564328991"
  "The client ID of the application for Rich Presence.")

(defvar elcord-wsl--load-path nil
  "The path where elcord-wsl files are located.")

(defvar elcord-wsl--node-path "/mnt/c/Program Files/nodejs/node.exe"
  "The path where Node.js is installed on Windows.")

(defvar elcord-wsl--timer nil
  "A timer object that updates the activity every 15s.")

(defun elcord-wsl--details-function (buf)
  "Provides the string for the Rich Presence details."
  (concat "Editing " buf))

(defun elcord-wsl--state-function (buf)
  "Provides the string for the Rich Presence state."
  (setq ln (format-mode-line "%l"))
  (concat "Line " ln))

(defun elcord-wsl--connect ()
  (interactive)
  (if (not elcord-wsl--timer)
    (progn
      (setq elcord-wsl--timer
        (run-with-timer 0 15 'elcord-wsl--update-activity))
      (let ((inhibit-message t)
            (message-log-max nil))
        (shell-command
          (concat "pm2 start \"\\\""
            elcord-wsl--node-path
            "\\\" " elcord-wsl--load-path "/index.js\" "
            "--name elcord-wsl"))))))

(defun elcord-wsl--disconnect ()
  (interactive)
  (if elcord-wsl--timer
    (progn
      (cancel-timer elcord-wsl--timer)
      (setq elcord-wsl--timer nil)
      (let ((inhibit-message t)
            (message-log-max nil))
        (shell-command "pm2 stop elcord-wsl")))))

(defun elcord-wsl--update-activity ()
  (setq buf (buffer-name))
  (setq obj (json-new-object))
  (setq obj (json-add-to-object obj
    "assets" elcord-wsl--assets-alist))
  (setq obj (json-add-to-object obj
    "buffer" (buffer-name)))
  (setq obj (json-add-to-object obj
    "clientId" elcord-wsl--client-id))
  (setq obj (json-add-to-object obj
    "details" (elcord-wsl--details-function buf)))
  (setq obj (json-add-to-object obj
    "state" (elcord-wsl--state-function buf)))
  (with-temp-file (concat elcord-wsl--load-path "/config.json")
    (insert (json-encode obj))))

(add-hook 'kill-emacs-hook 'elcord-wsl--disconnect)

(provide 'elcord-wsl)

;;; elcord-wsl.el ends here
