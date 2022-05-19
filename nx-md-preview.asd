;;;; nx-md-preview.asd

(asdf:defsystem #:nx-md-preview
  :description "Describe nx-md-preview here"
  :author "Gavin Jaeger-Freeborn"
  :license  "BSD 2-clause"
  :version "0.0.1"
  :serial t
  :depends-on (#:nyxt
               #:3bmd
               #:3bmd-ext-code-blocks
               #:3bmd-ext-tables
               #:file-notify
               #:alexandria
               #:spinneret
               #:bordeaux-threads)
  :components ((:file "package")
               (:file "nx-md-preview")))
