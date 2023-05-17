;;; oak-docker --- A collection of utilities for interacting with Docker
;;; Commentary:

;;; Code:
(defconst oak-docker-build-cmd "build")
(defconst oak-docker-container-cmd "container")


(defun oak-docker/--container-ls ()
  "Return a list of containers."
  (split-string
   (shell-command-to-string
    "docker container ls -a --format \"{{.Names}}\"")))

(defun oak-docker/--cmd (cmd &rest args)
  "Run docker CMD with ARGS."
  (apply 'start-process (concat "docker" " " cmd) "*docker*" "docker" cmd args))

(defun oak-docker/--container-cmd (cmd)
  "Run the docker container command, CMD, on a container read from the minibuffer."
  (let ((containers (oak-docker/--container-ls)))
    (let ((oak-docker-focused-container
           (read-string "Container: " (car containers) 'containers)))
      (oak-docker/--cmd oak-docker-container-cmd cmd oak-docker-focused-container))))

(defun oak-docker/container-stop ()
  "Stop the docker container read from the minibuffer."
  (interactive)
  (set-process-sentinel
   (oak-docker/--container-cmd "stop")
   (lambda (x y) (message (concat "Stopping container " y)))))

(defun oak-docker/container-start ()
  "Start the docker container read from the minibuffer."
  (interactive)
  (set-process-sentinel
   (oak-docker/--container-cmd "start")
   (lambda (x y) (message (concat "Starting container " y)))))

(defun oak-docker/build (dir)
  "Build the docker image in the directory DIR."
  (oak-docker/--cmd oak-docker-build-cmd dir))

(provide 'oak-docker)
;;; oak-docker.el ends here.
