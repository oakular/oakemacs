;; -*- lexical binding: -*-

(defgroup oak/csharp ()
  "Functions to aid development in C#.")

(defun oak/csharp-insert-class (&optional access-modifier)
  "Inserts basic class syntax at point."
  (when access-modifier
    (insert access-modifier " "))
  (insert "class")
  (newline)
  (oak/csharp-insert-curly-braces))

(defun oak/csharp-insert-curly-braces ()
  "Inserts curly braces, on one each line."
  (insert "{")
  (newline 2)
  (insert "}"))

(defun oak/csharp-insert-parens ()
  "Inserts parentheses at point."
  (insert "(" ")"))

(defun oak/csharp-read-access-modifier ()
  "Prompt for an access modifier."
  (read-multiple-choice "Access modifier:"
   '((?u "public")
     (?i "internal")
     (?p "private")
     (?d "default (none)"))))

(defun oak/csharp-insert-method (access-modifier return-type name)
  "Inserts a method at point."
  (insert access-modifier " " return-type " " name)
  (oak/csharp-insert-parens)
  (newline)
  (oak/csharp-insert-curly-braces))

(defun oak/do-csharp-insert-method ()
  "Insert a method with the prompted criteria at point."
  (interactive)
  
  (oak/csharp-insert-method
   (read-string "Access modifier: ")
   (read-string "Return type: ")
   (read-string "Name: "))

  (forward-line -1))

(defun oak/do-csharp-insert-class ()
  "Insert a class definition at point."
  (interactive)
  (let (access-modifier (oak/csharp-read-access-modifier))
    (if (eq (cdr access-modifier) "default")
      ((oak/csharp-insert-class))
      (oak/csharp-insert-class (car (cdr access-modifier)))))
  
  (forward-line -1))
