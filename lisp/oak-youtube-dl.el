;;; oak-youtube-dl.el --- An interface to youtube-dl for media download -*- lexical-binding: t -*-

(defun oak/download-from-url-at-point ()
  "Downloads the media at the URL at point."
  (interactive)
  (start-process
   "*download*"
   "*download*"
   "youtube-dl"
   "-o"
   "$HOME/Videos/yt/%(uploader)s/%(title)s.%(ext)s"
   (shr-url-at-point nil)))

(defun oak/download-album-from-url ()
  "Downloads the album at the URL."
  (interactive)
  (start-process "*download-album*"
                 "*download-album*"
                 "youtube-dl"
                 (read-string "URL: ")
                 "-x"
                 "--audio-format"
                 "mp3"
                 "--embed-thumbnail"
                 "-o"
                 "$HOME/Music/%(channel)s/%(album)s/%(playlist_index)s_%(title)s.%(ext)s"))

(defun oak/download-song-from-url ()
  (interactive)
  (start-process "*download-song*"
                 "*download-song*"
                 "youtube-dl"
                 (read-string "URL: ")
                 "-x"
                 "--audio-format"
                 "mp3"
                 "--embed-thumbnail"
                 "-o"
                 "$HOME/Music/%(channel)s/%(album)s/%(title)s.%(ext)s"
                 "--no-playlist"))

(provide 'oak-youtube-dl)
