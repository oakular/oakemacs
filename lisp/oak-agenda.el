;;; oak-agenda.el --- Defines custom Org agenda commands -*- lexical-binding: t -*-
;;; Commentary:

;;; Code:
(require 'org)

(defvar oak-agenda-next-actions-header "Next Actions\n")
(defvar oak-agenda-inbox-header "Inbox\n")
(defvar oak-agenda-waiting-header "Waiting\n")
(defvar oak-agenda-default-header "Agenda\n")
(setq org-agenda-block-separator 45)
(setq org-agenda-todo-ignore-scheduled 'future)
(setq org-agenda-tags-todo-honor-ignore-options t)

(setq org-agenda-custom-commands
      '(("i" "Inbox"
         ((tags "CATEGORY=\"Inbox\""
                 ((org-agenda-overriding-header oak-agenda-inbox-header)))))
        ("h" "Home"
         ((tags-todo "+TODO=\"TODO\"&+@home&+CATEGORY=\"Next\"&(SCHEDULED=\"\"|SCHEDULED=\"<today>\")"
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "CATEGORY=\"Waiting\"+@home"
                ((org-agenda-overriding-header oak-agenda-waiting-header)))))
        ("c" "@Computer"
         ((tags-todo "TODO=\"TODO\"+@computer"
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "CATEGORY=\"Waiting\"+@computer"
                ((org-agenda-overriding-header oak-agenda-waiting-header)))))
        ("w" "Work"
         ((tags-todo "+work&TODO=\"TODO\""
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "+work+CATEGORY=\"Waiting\""
                ((org-agenda-overriding-header oak-agenda-waiting-header)))))
        ("e" "Errands"
         ((tags-todo "+@bike|+@car|+@walk")))
        ("o" "Other"
         ((tags-todo "TODO=\"TODO\"-work-@home-@computer"
                     ((org-agenda-overriding-header oak-agenda-next-actions-header)))
          (tags "CATEGORY=\"Waiting\"-work-@home-@computer"
                ((org-agenda-overriding-header oak-agenda-waiting-header)))
          (agenda ""
                  ((org-agenda-overridng-header oak-agenda-default-header)))))
        ("l" "Locale Change"
         ((tags-todo "+LocaleChange"
                     ((org-agenda-overridng-header "Locale Change")))))))

;; Local Variables:
;; byte-compile-warnings: (not free-vars)
;; End:

(provide 'oak-agenda)
;;; oak-agenda.el ends here.

