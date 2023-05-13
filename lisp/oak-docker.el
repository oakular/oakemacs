;;; oak-docker --- A collection of utilities for interacting with Docker
;;; Commentary:

;;; Code:
(defun oak-docker/containers/ls ()
  "Return a list of containers."
  (split-string
   (shell-command-to-string
    "docker container ls -a --format \"{{.Names}}\"")))

(defun oak-docker/containers/choices ()
  "Return a list of containers, as choice options."
  (let ((containers (oak-docker/containers/ls)))
  (mapcar (lambda (x) (cons (make-symbol x) (seq-position containers x))) containers)))

(defun oak-docker/container/stop ()
  (interactive)
  (let ((containers (oak-docker/containers/ls)))
    (let ((oak-docker-focused-container
           (read-string "Container: " (car containers) 'containers)))
      (async-shell-command (concat "docker container stop " oak-docker-focused-container)))))
(provide 'oak-docker)
;;; oak-docker.el ends here.
