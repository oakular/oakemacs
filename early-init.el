;; Remove UI elements before they flash onscreen
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)


;; --- optimisations ---
;; Prevent frame resizing on font size change to reduce startup time
(setq frame-inhibit-implied-resize t)

(setq inhibit-splash-screen t
      inhibit-startup-message t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)

(defconst WINDOWS (memq system-type '(cygwin windows-nt ms-dos)))
(defconst MACOS (eq system-type 'darwin))

(when WINDOWS
  (setq w32-get-true-file-attributes nil
	w32-pipe-read-delay 0
	w32-pipe-buffer-size (* 64 1024)))


;; Remove superfluous UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq use-file-dialog nil)

