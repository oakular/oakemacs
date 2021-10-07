;;; oak-shell.el --- Functions providing interaction with shell commands -*- lexical-binding: t -*-

(defvar oak-shell "/bin/bash" "The default shell to be used.")

(defun oak/term () "Opens an ansi-term buffer using the shell set by oak-shell"
       (interactive)
       (ansi-term oak-shell))

(defun oak/build-shell-cmd (cmd-elements)
  "Build a command string from the elements passed as parameter."
  (mapconcat 'identity cmd-elements " "))

(provide 'oak-shell)
