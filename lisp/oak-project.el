;;; oak-project.el --- Functions providing extensions to the built-in project.el -*- lexical-binding: t -*-

(require 'project)

(defvar oak-project-run-command nil
  "The command to execute when running a project.")

(defun oak-project/configure ()
  "Setup project.el."
  (oak/define-global-keymap '("C-x p C" . oak-project/do-run-project))
  (add-to-list 'project-switch-commands '(magit-status "Magit status"))
  (setq project-prefix-map '(keymap
                             (120 . project-execute-extended-command)
                             (114 . project-query-replace-regexp)
                             (71 . project-or-external-find-regexp)
                             (103 . project-find-regexp)
                             (112 . project-switch-project)
                             (107 . project-kill-buffers)
                             (101 . project-eshell)
                             (99 . project-compile)
                             (118 . magit-status)
                             (100 . project-dired)
                             (115 . project-shell)
                             (98 . project-switch-to-buffer)
                             (70 . project-or-external-find-file)
                             (102 . project-find-file)
                             (38 . project-async-shell-command)
                             (33 . project-shell-command)))
    (setq project-vc-merge-submodules nil))

(defun oak/shell-command-project-root (cmd)
  "Run a shell command in the root of the current project."
  (oak/exec-fun-project-root (shell-command cmd)))

(defun oak/make-process-project-root (&rest args)
  "Run a command as a new process in the project root."
  (let ((name (plist-get args :name))
        (buffer (plist-get args :buffer))
        (command (plist-get args :command)))
    (oak/exec-fun-project-root (lambda ()
                                 (make-process :name name
                                               :buffer buffer
                                               :command command)))))

(defun oak/exec-fun-project-root (fun)
  "Execute a function in the context of the project root."
  (let ((default-directory (project-root (project-current t))))
    (funcall fun)))

(defun oak-project/do-run-project ()
  "Run the current project using the defined oak-project-run-command."
  (interactive)
  (compile oak-project-run-command))

(provide 'oak-project)
