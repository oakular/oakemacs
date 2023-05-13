;;; oak-docker --- A collection of utilities for interacting with Docker
;;; Commentary:

;;; Code:
(defun oak-docker/container/ls ()
  "Return a list of containers."
  (split-string
   (shell-command-to-string
    "docker container ls -a --format \"{{.Names}}\"")))

(defun oak-docker/container/cmd (cmd)
  (let ((containers (oak-docker/container/ls)))
    (let ((oak-docker-focused-container
           (read-string "Container: " (car containers) 'containers)))
      (start-process (concat "docker " cmd) "*docker*" "docker" "container" cmd oak-docker-focused-container))))

(defun oak-docker/container/stop ()
  (interactive)
  (oak-docker/container/cmd "stop")
  (message "Container stopped successfully"))

(defun oak-docker/container/start ()
  (interactive)
  (oak-docker/container/cmd "start"))

(provide 'oak-docker)
;;; oak-docker.el ends here.
