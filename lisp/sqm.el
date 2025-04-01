;;; sqm.el --- some square area calc utilities
;;; Commentary:

;;; Code:

(defconst PADDING-DEFAULT 0 "The default padding to be applied to sqm calculations.")

(defun sqm/calc (length width &optional padding-percentage)
  "Calculates the square area given by LENGTH and WIDTH.
PADDING-PERCENTAGE may be provided to pad the area calculated."
  (unless (numberp length) (error "Length must be a number"))
  (unless (numberp width) (error "Width must be a number"))
  (if (and padding-percentage (not (floatp padding-percentage))) (error "Padding percentage must be a %s" 'floatp))
  (unless padding-percentage (setq padding-percentage PADDING-DEFAULT))
  (* (* length width) (+ 1 padding-percentage)))

(defun sqm/calc-many (dimensions &optional padding-percentage)
  ""
  (unless (plistp dimensions) (error "Dimensions provided was not a %s" 'plist))
  (seq-reduce
   (lambda (x y)
     (+ (sqm/calc (alist-get 'length y) (alist-get 'width y) padding-percentage) x))
   dimensions 0))

(provide 'sqm)
;;; sqm.el ends here
