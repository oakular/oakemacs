(require 'epa)
(require 'url)

(defconst sburl-domain "https://api.starlingbank.com")
(defconst sburl-domain-suffix "/api/v2")

(defun sburl/get-pat ()
  "Return the personal access token stored in the configuration folder."
  (when (file-exists-p (expand-file-name "~/.config/sburl/config.gpg"))
    (epa-decrypt-file (expand-file-name "~/.config/sburl/pat.gpg")
                      (expand-file-name "~/.config/sburl/pat")))
  (with-temp-buffer
    (insert-file-contents "~/.config/sburl/pat")
    (buffer-string)))

(defvar sburl-auth-header (concat "Bearer " (sburl/get-pat)))

(defconst sburl-headers `(("Authorization" . ,sburl-auth-header)
                        ("Content-Type" . "application/json")))

(defun sburl/build-endpoint (endpoint-suffix)
  "Return the full endpoint URL for the API call for the ENDPOINT-SUFFIX."
  (concat sburl-domain sburl-domain-suffix endpoint-suffix))

(defun sburl/decode-response (response-buffer)
      (with-current-buffer response-buffer
      (goto-char url-http-end-of-headers)
      (json-read)))

(defun sburl/get-transactions (account start-date end-date)
  "Get the transactions logged for the ACCOUNT between START-DATE and END-DATE."
  (let ((request-url (sburl/build-endpoint (concat "/accounts/"
                                                   (cdr (assoc 'accountUid account))
                                                   "/statement/downloadForDateRange?"
                                                   "start=" start-date
                                                   "&"
                                                   "end=" end-date)))
        (url-request-extra-headers (append sburl-headers '(("Accept" . "text/csv")))))
    (url-retrieve-synchronously request-url)))
  
(defun sburl/get-accounts ()
  "Get the accounts for the configured personal access token."
  (let ((request-url (sburl/build-endpoint "/accounts"))
        (url-request-extra-headers sburl-headers))
        (assoc 'accounts (sburl/decode-response (url-retrieve-synchronously request-url)))))

(defun sburl/get-account-by-name (account-name)
  "Return the account details by the ACCOUNT-NAME given."
  (seq-find
   (lambda (elt) (string-equal account-name (cdr (assoc 'name elt))))
   (cdr (sburl/get-accounts))))

(provide 'sburl)

;;; sburl.el ends here
