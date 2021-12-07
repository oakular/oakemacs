;;; oak-youtube-dl.el --- An interface to youtube-dl for media download -*- lexical-binding: t -*-

(require 'oak-shell)

(defconst oak-youtube-dl-executable "yt-dlp")

(defun oak/read-url ()
  (read-string "URL: "))

(defun oak/download-from-url-at-point ()
  "Downloads the media at the URL at point."
  (interactive)
  (start-process
   "*download*"
   "*download*"
   oak-youtube-dl-executable
   "-o"
   "$HOME/Videos/yt/%(uploader)s/%(title)s.%(ext)s"
   (shr-url-at-point nil)))

(defun oak/download-from-url ()
  "Downloads the media at the given URL."
  (interactive)
  (start-process
   "*download*"
   "*download*"
   oak-youtube-dl-executable
   "-o"
   "$HOME/Videos/yt/%(uploader)s/%(title)s.%(ext)s"
   (oak/read-url)))

(defun oak/download-album-from-url ()
  "Downloads the album at the URL."
  (interactive)
  (start-process "*download-album*"
                 "*download-album*"
                 oak-youtube-dl-executable
                 (oak/read-url)
                 "-x"
                 "--audio-format"
                 "mp3"
                 "--embed-thumbnail"
                 "-o"
                 "$HOME/Music/%(channel)s/%(album)s/%(playlist_index)s_%(title)s.%(ext)s"))

(defun oak/download-song-from-url ()
  "Downloads the song at the given URL."
  (interactive)
  (start-process "*download-song*"
                 "*download-song*"
                 oak-youtube-dl-executable
                 (oak/read-url)
                 "-x"
                 "--audio-format"
                 "mp3"
                 "--embed-thumbnail"
                 "-o"
                 "$HOME/Music/%(channel)s/%(album)s/%(title)s.%(ext)s"
                 "--no-playlist"))

(defun oak/stream-video-from-url ()
  "Streams the video at the URL to MPV."
  (interactive)
  (async-shell-command (oak/build-shell-cmd (list oak-youtube-dl-executable
                                                      "-o"
                                                      "-"
                                                      (oak/read-url)
                                                      "|"
                                                      "mpv"
                                                      "-"))))

(provide 'oak-youtube-dl)
