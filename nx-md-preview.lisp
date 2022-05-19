;;;; nx-md-preview.lisp

(in-package #:nx-md-preview)
;;; Markdown Preview
(setf 3bmd-code-blocks:*code-blocks* t)
(setf 3bmd-tables:*tables* t)
(setf 3bmd:*smart-quotes* t)

(defvar *mdpath* nil
  "Stores the current file name for the watcher thread to pay attention
to")

(defun %md-buffer ()
  "Find the markdown review buffer and return it"
  (find "*Markdown Preview*" (buffer-list)
        :key #'title :test #'equal))

(defun %watch-file (file)
  "Watches for changes to FILE and reloads the markdown preview buffer
when the file is changed"
  (watch file :events t)
  (with-events (file change :timeout t)
    (declare (ignorable file change))
    (when-let ((buf (%md-buffer)))
      (reload-buffers (list buf)))))

;;;; Creating The Markdown Buffer
(defun md-path ()
  "Checks if the global variable mdpath has been set otherwise it
prompts the user to set it"
  (when (null *mdpath*)
    ;; Set the global file to preview
    (setf *mdpath*
          (car (prompt
                :input (uiop:native-namestring
                        *default-pathname-defaults*)
                :prompt "Open file"
                :sources (list (make-instance
                                'file-source)))))

    ;; File watching
    (bt:make-thread (lambda () (%watch-file *mdpath*))
                    :name "md-file-watcher"))
  *mdpath*)


(define-internal-page-command-global markdown-preview nil
    (output-buffer "*Markdown Preview*" 'base-mode)
  "List all things in a new buffer."
  (let ((file (md-path)))
    (cond ((pathnamep file) (spinneret:with-html-string
                              (:html
                               (:body
                                (parse-and-print-to-stream
                                 file spinneret:*html*)))))
          (t (echo "Failed to find file ~a" file)))))
