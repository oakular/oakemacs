;;; oak-dotnet.el --- Functions providing interaction with the .NET framework -*- lexical-binding: t -*-

(require 'oak-common)
(require 'oak-project)

(defconst oak-dotnet-command "dotnet")
(defconst oak-dotnet-process-name "dotnet-process")

(defconst oak-dotnet-process-name-as-buffer-name (concat "*" oak-dotnet-process-name "*"))

(defvar oak-dotnet-migration-project nil
  "The project directory (relative or absolute) containing project migrations.")

(defvar oak-dotnet-startup-project nil
  "The startup project directory, to be ran when executing a solution.")

(defvar oak-dotnet-prompt-for-context nil
  "Determine whether the user should be prompted for the context name when running migration commands.")

(defun oak-dotnet/get-migration-project ()
  "Gets the migration project if set as a variable, and fallsback to user input."
  (expand-file-name
   (or oak-dotnet-migration-project (read-directory-name "Project directory: "))))


(defun oak-dotnet/get-startup-project ()
  "Gets the startup project if set as a variable, and fallsback to user input."
  (expand-file-name
   (or oak-dotnet-startup-project (read-directory-name "Project: "))))

(defun oak-dotnet/get-context-name ()
  "Gets the name of the context if \"oak-dotnet-prompt-for-context\" is set."
  (when oak-dotnet-prompt-for-context (read-string "Context: ")))

(defun oak-dotnet/migration-add (migration-name project &optional context)
  "Add a migration called MIGRATION-NAME to the given PROJECT and CONTEXT."
  (oak/make-process-project-root :name (concat oak-dotnet-process-name "-migration-add")
                                 :buffer oak-dotnet-process-name-as-buffer-name
                                 :command (list "dotnet" "ef" "migrations" "add" "-p" project
                                                (when context "-c")
                                                (when context context)
                                                migration-name)))

(defun oak-dotnet/migration-remove (project &optional context)
  "Remove the latest migration from the PROJECT and CONTEXT."
  (oak/make-process-project-root
   :name (concat oak-dotnet-process-name "-migration-remove")
   :buffer oak-dotnet-process-name-as-buffer-name
   :command (list "dotnet" "ef" "migrations" "remove"
                  "-p" project
                  (when context "-c" )
                  (when context context))))

(defun oak-dotnet/update-database (project &optional context)
  "Update the database for the PROJECT and CONTEXT."
  (oak/make-process-project-root
   :name (concat oak-dotnet-process-name "-update-database")
   :buffer oak-dotnet-process-name-as-buffer-name
   :command (list "dotnet" "ef" "database" "update"
                  "-p" project
                  (when context "-c")
                  (when context context))))

(defun oak-dotnet/drop-database (project &optional context)
  "Drop the database for the PROJECT and CONTEXT."
  (oak/make-process-project-root
   :name (concat oak-dotnet-process-name "-update-database")
   :buffer oak-dotnet-process-name-as-buffer-name
   :command (list "dotnet" "ef" "database" "drop"
                  "-p" project
                  (when context "-c")
                  (when context context))))

(defun oak-dotnet/do-migration-add ()
  "Interactively add a migration."
  (interactive)
  (oak-common/run-function-display-buffer
   (lambda ()
     (oak-dotnet/migration-add (read-string "Migration name: ")
                               (oak-dotnet/get-migration-project)
                               (oak-dotnet/get-context-name)))
   oak-dotnet-process-name-as-buffer-name))

(defun oak-dotnet/do-migration-remove ()
  "Interactively remove the latest migration."
  (interactive)
  (oak-common/run-function-display-buffer
   (lambda ()
    (oak-dotnet/migration-remove (oak-dotnet/get-migration-project)
                                 (oak-dotnet/get-context-name)))
    oak-dotnet-process-name-as-buffer-name))

(defun oak-dotnet/do-update-database ()
  "Interactively update the database."
  (interactive)
  (oak-common/run-function-display-buffer
   (lambda ()
     (oak-dotnet/update-database (oak-dotnet/get-migration-project)
                                 (oak-dotnet/get-context-name)))
   oak-dotnet-process-name-as-buffer-name))

(defun oak-dotnet/do-drop-database ()
  "Interactively drop the database."
  (interactive)
  (oak-common/run-function-display-buffer
   (lambda ()
     (oak-dotnet/drop-database (oak-dotnet/get-migration-project)
                               (oak-dotnet/get-context-name)))
   oak-dotnet-process-name-as-buffer-name))

(defun oak-dotnet/add-package (project package-name)
  "Add the given package to the given project."
  (oak/shell-command-project-root
   (oak/build-shell-cmd
    (list oak-dotnet-command "add"
          project
          "package"
          package-name))))

(defun oak-dotnet/remove-package (project package-name)
  "Remove the given package from the given project."
  (oak/shell-command-project-root
   (oak/build-shell-cmd
    (list oak-dotnet-command "remove"
          project
          "package"
          package-name))))

(defun oak-dotnet/do-add-package ()
  "Add a package to a project."
  (interactive)
  (oak/exec-fun-project-root
   (oak-dotnet/add-package (read-directory-name "Project: ")
                           (read-string "Package: "))))

(defun oak-dotnet/do-remove-package ()
  "Remove a package from a project."
  (interactive)
  (oak/exec-fun-project-root
   (oak-dotnet/remove-package (read-directory-name "Project: ")
                              (read-string "Package: "))))

(defun oak-dotnet/clean-project ()
  "Clean the current project."
  (oak/make-process-project-root
   :name (concat oak-dotnet-process-name "-clean-project")
   :buffer oak-dotnet-process-name-as-buffer-name
   :command (list oak-dotnet-command "clean")))

(defun oak-dotnet/do-clean-project ()
  "Clean the current project."
  (interactive)
  (oak-common/run-function-display-buffer
   (lambda ()
     (oak-dotnet/clean-project))
   oak-dotnet-process-name-as-buffer-name))

(provide 'oak-dotnet)
