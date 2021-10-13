(defmacro oak-package/require-local (package-name &rest body)
  "Load the local PACKAGE-NAME with rest BODY."
  (declare (indent 1))
  `(progn
     (unless (require ,package-name nil 'noerror)
       (display-warning 'oak-package (format "Loading `%s' failed" ,package-name) :warning))
     ,@body))

(defmacro oak-package/require (package-name &rest body)
  `(progn
     (unless (package-installed-p ,package-name)
       (package-refresh-contents)
       (package-install ,package-name))
     (require ,package-name)
     ,@body))

(provide 'oak-package)
