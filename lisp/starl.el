(require 'sburl)
(require 'org)
(require 'url)

(defvar starl-default-account-name nil)

(defun starl/format-transactions-for-ledger (buffer)
  "Format the transactions in BUFFER for import into ledger."
  (with-current-buffer buffer
    (delete-region (point-min) (+ url-http-end-of-headers 1))
    (kill-line 1)
    (move-beginning-of-line nil)
    (insert "date,payee,note,,amount,,desc\n"))
  buffer)

(defun starl/format-transactions-for-display (buffer)
  "Format the transactions in BUFFER for display"
  (with-current-buffer buffer
    (delete-region (point-min) (+ url-http-end-of-headers 1))
    (csv-mode)
    (csv-align-fields nil (point-min) (point-max)))
  buffer)

(defun starl/get-transactions ()
  "Get transactions for the account and date range prompted for."
  (sburl/get-transactions (sburl/get-account-by-name
                           (or starl-default-account-name (read-string "Account name: ")))
                          (org-read-date nil nil nil "Start date")
                          (org-read-date nil nil nil "End date")))

(defun starl/display-transactions ()
  "Display transactions for the account and date range prompted for."
  (interactive)
  (display-buffer
   (starl/format-transactions-for-display
    (starl/get-transactions))))

(provide 'starl)

;; starl.el ends here
