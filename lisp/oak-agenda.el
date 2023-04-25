;;; oak-agenda.el --- Defines custom Org agenda commands -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'org)

(defvar oak-agenda-next-actions-header "Next Actions\n")
(defvar oak-agenda-waiting-header "Waiting\n")
(defvar oak-agenda-default-header "Agenda\n")

(setq org-agenda-custom-commands
      '(("d" "Default"
         ((tags-todo "TODO=\"TODO\"-work"
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "CATEGORY=\"Waiting\"-work"
                     ((org-agenda-overriding-header oak-agenda-waiting-header)))
          (agenda ""
                  ((org-agenda-overridng-header oak-agenda-default-header)))))
        ("w" "Work"
         ((tags-todo "+work&TODO=\"TODO\""
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "+work+CATEGORY=\"Waiting\""
                     ((org-agenda-overriding-header oak-agenda-waiting-header)))))
        ("e" "Errands"
         ((tags-todo "+@bike|+@car")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

(provide 'oak-agenda)
;;; org-agenda.el ends here
