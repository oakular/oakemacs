(require 'request)

(defconst sburl-domain "https://api.starlingbank.com")
(defconst sburl-domain-suffix "/api/v2")

(defconst pat "")

(defun sburl/build-endpoint (endpoint-suffix)
  "Returns the full endpoint URL for the API call for the ENDPOINT-SUFFIX."
  (concat sburl-domain sburl-domain-suffix endpoint-suffix))

(defun sburl/get-path (&optional file-path)
  "Get the configuration file from FILE-PATH, falling back to the default location."
  (with-temp-buffer
    (insert-file-contents (or file-path "~/.config/sburl/config"))))

(defun sburl/get-transactions (start-date end-date)
  "Get the transactions lised between the START-DATE and END-DATE."
  (request (sburl/build-endpoint (concat "/accounts/" account-uid "/statement/downloadForRange"))
           :headers '(("Authorization" . (concat "Bearer " pat))
           :parser 'json-read)))

(defun sburl/get-accounts ()
  "Get the accounts for the configured personal access token."
      (request (sburl/build-endpoint "/accounts")
        :headers '(("Authorization" . "Bearer pat"))
        :parser 'json-read
        :success
        (cl-function
         (lambda (&key data)
           (when data
             (with-current-buffer (get-buffer-create "*starling accounts")
               (erase-buffer)
               (insert data)
               (pop-to-buffer (current-buffer))))))))

(provide 'sburl)

;;; sburl.el ends here
