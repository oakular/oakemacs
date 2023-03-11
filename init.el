(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp")))
(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/bicep-mode")))
	
(require 'oak-package)

(org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))
