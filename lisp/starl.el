(require 'sburl)
(require 'org)

(defvar starl-default-account-name nil)

(defun starl/get-transactions ()
  (interactive)
  (with-current-buffer (sburl/get-transactions (sburl/get-account-by-name (or starl-default-account-name (read-string "Account name: ")))
                                               (org-read-date nil nil nil "Start date")
                                               (org-read-date nil nil nil "End date"))
    (delete-region (point-min) (+ url-http-end-of-headers 1))
    (csv-mode)
    (csv-align-fields nil (point-min) (point-max))
    (display-buffer (current-buffer))))

(provide 'starl)

;; starl.el ends here
