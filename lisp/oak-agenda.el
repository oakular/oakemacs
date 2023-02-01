;;; oak-agenda.el --- Defines custom Org agenda commands -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'org)

(setq org-agenda-custom-commands
      '(("d" "Default"
         ((agenda #1="")
          (tags-todo "TODO=\"TODO\"-work")
          (tags-todo "CATEGORY=\"Waiting\"")))
        ("w" "Work"
         ((tags-todo "+work&TODO=\"TODO\"")
          (tags-todo "CATEGORY=\"Waiting\"")))
        ("e" "Errands"
         ((tags-todo "+@bike|+@car")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

(provide 'oak-agenda)
;;; org-agenda.el ends here
