;;; oak-common.el --- A collection of common functions for use in other oak modules -*- lexical-binding: t -*-

(defun oak-common/use-package (package-name)
        (unless (package-installed-p package-name)
        (package-refresh-contents)
        (package-install package-name)))

(defun oak-common/run-function-display-buffer (fun buffer)
  "Run the function FUN passed as argument and displays the BUFFER."
  (progn
    (funcall fun)
    (display-buffer (get-buffer buffer))))

(provide 'oak-common)
