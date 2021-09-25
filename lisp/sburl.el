(require 'request)

(defconst sburl-domain "https://api.starlingbank.com")
(defconst sburl-domain-suffix "/api/v2")

(defconst sburl-pat "eyJhbGciOiJQUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAC1QSW4DMQz7SuFzFHhf5tZbP9AHyLJSGJl6grFTFCj69zqdHEmJFKkfUXsXi8BbPfeB-1rbR8Z2PdP2KU6i3_McZn8J2bODFKUB662BbIwGF1MMuaTsvZzL_H0Tiw3BqqStVydRcYhFeRWdivFBINF2b-NtWwvv77VMb-mTtFkGQOMc2BgcxGAc5ET2IqNnzjy9x3bldihwpnGaHEhHGqx2HrK0Adi7khOix6KmYjZ6JeLeD5UqxkvrCJgDgiUTIErlQWvlFClMRptHYdpu_DhyJF12xvLyBLDW_mTGjq0jjbq1g8i4YiM-wHzk4E-eCupf_5T4_QOqR2rgaQEAAA.maFzsEPPluhSamzRPh71oGOZFAkAIimH4wzV-Cx3eoC4w06Zr7XFrnDzpfocaXAtxynflXO37LVVgN7JgB4HvynuIiONjuj6rKxAYyiZv-xgHxzqYNngtQNic25KlpVsqu2ZAu7QHgHe6lkruKKRRVs9dpU4-qwteBy5A_vkWA53txFic9TJKBpViG1AsXHibhuBTU4uycyqNbiabUKoGqRZf9KOIfDtXbJ-cS5g4LPrR-VkXaWFv7CoKpG2NRm9eIePITVcknl9u3SNqv3uG6Rik5g7YY7QnvqUyetIT1zrDjnEISSfP_zvaUDINFQyzQvrrSRbRsDq-F0hvhmhtuNH3KgyCDf77qI5-cYpNs9TnvROJCfILPc0GpSqANjnuR3nKmOybNmhOLpt4YzHIQdd_z7595UqHE8Tuc9N-RE4jAbP770mzW7Hmu-NboaN9gZ5nbFMceanaGsLqdYHXe1wd5VldproxrFvwMQIIJ4hPTSlc-hH2zX3Q1XtNLxcVNmEf1O5Wi5pYlpzTgDznZNmKjRIWI_9ETWrQ-dC4Us94C3ff5aNxxwDNSHiIba8NHw5kM_7bxlo7uI4rPcFjWCN_YgCRqK0pfbkF4EjOXn-uZDSdP25Ly8BKYN_SxViE8x8Xn0UjsEYMGj3alx0S0taCUdCbViG7kIPoaf9_M4")

(defvar account-uid nil)

(defvar sburl-auth-header (concat "Bearer " sburl-pat))

(defun sburl/build-endpoint (endpoint-suffix)
  "Return the full endpoint URL for the API call for the ENDPOINT-SUFFIX."
  (concat sburl-domain sburl-domain-suffix endpoint-suffix))

(defun sburl/get-path (&optional file-path)
  "Get the configuration file from FILE-PATH, falling back to the default location."
  (with-temp-buffer
    (insert-file-contents (or file-path "~/.config/sburl/config"))))

(defun sburl/decode-response (response-buffer)
      (with-current-buffer response-buffer
      (goto-char url-http-end-of-headers)
      (json-read)))

(defun sburl/get-transactions (start-date end-date)
  "Get the transactions lised between the START-DATE and END-DATE."
  (request (sburl/build-endpoint (concat "/accounts/" account-uid "/statement/downloadForRange"))
           :headers '(("Authorization" . (concat "Bearer " pat))
           :parser 'json-read)))

(defun sburl/get-accounts ()
  "Get the accounts for the configured personal access token."
  (let ((url-request-extra-headers
         `(("Authorization" . ,sburl-auth-header)
           ("Content-Type" . "application/json")))
        (request-url (sburl/build-endpoint "/accounts")))
    (assoc 'accounts (sburl/decode-response (url-retrieve-synchronously request-url)))))

(defun sburl/get-account-by-name (account-name)
  "Return the account details by the ACCOUNT-NAME given."
  (seq-find
   (lambda (elt) (string-equal account-name (cdr (assoc 'name elt))))
   (cdr (sburl/get-accounts))))

(provide 'sburl)

;;; sburl.el ends here
