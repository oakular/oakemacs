;;; oak-org-sync.el --- Sync the org directory with an rclone remote  -*- lexical-binding: t -*-
;;; Commentary:

(require 'org)

;;; Code:
(defvar oak-org/directory "~/org")
(defvar oak-org/remote "oakorg:org")
(defvar oak-org/buffer "*Org Sync*")

(defun oak-org/sync (push)
  "Sync org directory with cloud storage."
  (interactive)
  (let ((default-directory oak-org/directory))
    (set-process-sentinel
     (if current-prefix-arg
         (oak-org-sync/--pull)
       (oak-org-sync/--push))
     (lambda (_ y)
       (when (equal y "finished\n")
         (org-revert-all-org-buffers))))))

(defun oak-org-sync/push ()
  "Push files from the org sync directory to the remote."
  (interactive)
  (let ((default-directory oak-org/directory))
    (set-process-sentinel (oak-org-sync/--push) nil))
  (with-current-buffer oak-org/buffer
    (setq-local major-mode 'compilation-mode))
  (display-buffer oak-org/buffer))

(defun oak-org-sync/pull ()
  "Pull files from the remote to the org sync directory."
  (interactive)
  (let ((default-directory oak-org/directory))
    (set-process-sentinel
     (oak-org-sync/--pull)
     (lambda (_ y)
       (when (equal y "finished\n")
         (org-revert-all-org-buffers)))))
  (with-current-buffer oak-org/buffer
    (setq-local major-mode 'compilation-mode))
  (display-buffer oak-org/buffer))

(defun oak-org-sync/--pull ()
  "Pull files from the remote to the org sync directory."
  (start-process oak-org/buffer
                 oak-org/buffer
                 "rclone"
                 "sync"
                 "--filter-from"
                 "filter"
                 oak-org/remote
                 "."
                 "-v"))

(defun oak-org-sync/--push ()
  "Push files from the org sync directory to the remote."
  (start-process oak-org/buffer
                 oak-org/buffer
                 "rclone"
                 "sync"
                 "--filter-from"
                 "filter"
                 "."
                 oak-org/remote
                 "-v"))

(provide 'oak-org-sync)
;;; oak-org-sync.el ends here
