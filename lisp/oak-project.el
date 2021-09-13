;;; oak-project.el --- Functions providing extensions to the built-in project.el -*- lexical-binding: t -*-

(require 'project)

(defvar oak-project-run-command nil
  "The command to executing when running a project.")

(defun oak/configure-project () "Setup project.el"
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
  (oak/exec-fun-project-root
   (compile
    (if (eq (read-multiple-choice "Run or compile: "
                                  '((?c "compile")
                                    (?r "run"))) "compile")
        (compile)
      (compile oak-project-run-command)))))

(provide 'oak-project)
