;;; oak-agenda.el --- Defines custom Org agenda commands -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'org)

(defvar oak-agenda-next-actions-header "Next Actions\n")
(defvar oak-agenda-waiting-header "Waiting\n")
(defvar oak-agenda-default-header "Agenda\n")

(setq org-agenda-custom-commands
      '(("d" "Default"
         ((agenda ""
                  ((org-agenda-overridng-header oak-agenda-default-header)))
          (tags-todo "TODO=\"TODO\"-work"
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags-todo "CATEGORY=\"Waiting\"-work"
                     ((org-agenda-overriding-header oak-agenda-waiting-header)))))
        ("w" nil
         ((tags-todo "+work&TODO=\"TODO\""
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags-todo "+work+CATEGORY=\"Waiting\""
                     ((org-agenda-overriding-header oak-agenda-waiting-header)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-overriding-header "Today\n")
                   (org-agenda-filter-apply "+work" 'tag 'expand)))))

        ("e" "Errands"
         ((tags-todo "+@bike|+@car")))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

(provide 'oak-agenda)
;;; org-agenda.el ends here
