;;; oak-org-sync.el --- Sync the org directory with an rclone remote  -*- lexical-binding: t -*-
;;; Commentary:

(require 'org)

;;; Code:
(defvar oak-org/directory "~/org")
(defvar oak-org/remote "oakorg:org")
(defvar oak-org/buffer "*Org Sync*")

(defun oak-org/sync ()
  "Sync org directory with cloud storage."
  (interactive)
  (let ((default-directory oak-org/directory))
    (if current-prefix-arg
        (oak-org/do-pull)
      (oak-org/do-push))
    (org-revert-all-org-buffers)))

(defun oak-org/do-pull ()
  "Pull files from the remote to the org sync directory."
  (call-process "rclone"
                nil
                oak-org/buffer
                nil
                "sync"
                oak-org/remote
                "."
                "-v"))

(defun oak-org/do-push ()
  "Push files from the org sync directory to the remote."
  (call-process "rclone"
                nil
                oak-org/buffer
                nil
                "sync"
                "--filter-from"
                "filter"
                "."
                oak-org/remote
                "-v"))

(provide 'oak-org-sync)
;;; oak-org-sync.el ends here
