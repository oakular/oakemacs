;;; Definition stored by Calc on Mon Oct  4 15:28:44 2021
(put 'calc-define 'calc-oak-wrate '(progn
 (defun calc-oak-wrate nil (interactive) (calc-wrapper (calc-enter-result 1 "oakw" (cons 'calcFunc-oakwrate (calc-top-list-n 1)))))
 (put 'calc-oak-wrate 'calc-user-defn 't)
 (defun calcFunc-oakwrate (v) (math-check-const v t) (math-normalize
  (list '* (list 'calcFunc-mrow v 1) (list 'calcFunc-rate (list
  'calcFunc-mrow v 2) (list 'calcFunc-mrow v 3) (list 'calcFunc-mrow v
  4)))))
 (put 'calcFunc-oakwrate 'calc-user-defn '(* (calcFunc-mrow (var v
  var-v) 1) (calcFunc-rate (calcFunc-mrow (var v var-v) 2)
  (calcFunc-mrow (var v var-v) 3) (calcFunc-mrow (var v var-v) 4))))
 (define-key calc-mode-map "zw" 'calc-oak-wrate)
))
