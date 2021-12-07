(require 'sburl)
(require 'org)
(require 'url)
(require 'oak-shell)

(defvar starl-default-account-name nil)

(defun starl/format-transactions-for-ledger (buffer)
  "Format the transactions in BUFFER for import into ledger."
  (with-current-buffer buffer
    (delete-region (point-min) (+ url-http-end-of-headers 1))
    (goto-char (point-min))
    (kill-line 1)
    (move-beginning-of-line nil)
    (insert "date,payee,,,amount,,note\n"))
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

(defun starl/import-transactions-to-ledger ()
  "Import the transactions for the account and date range prompted for to the file at the LEDGER_FILE envvar."
  (interactive)
  (with-current-buffer
      (starl/format-transactions-for-ledger (starl/get-transactions))
    (let ((transactions-location "/tmp/starl-transaction-download.csv"))
      (write-file transactions-location)
      (shell-command (oak/build-shell-cmd (list "ledger"
                                                "convert"
                                                transactions-location
                                                "--input-date-format \"%d/%m/%Y\""
                                                "--invert"
                                                "--account Assets:Current:Joint"
                                                "--file $LEDGER_FILE"
                                                "--rich-data"
                                                ">> $LEDGER_FILE")))
      (kill-buffer))))

(provide 'starl)

;; starl.el ends here
