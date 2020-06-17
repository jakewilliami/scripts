#!/usr/local/bin/sbcl --script

; ensure you have `brew install clisp sbcl asdf` to run in command line
; run using `clisp ~/scripts/pdfsearches/pdfsearch.lisp`
; (or `sbcl --script ~/scripts/pdfsearches/pdfsearch.lisp`)
; cd /tmp/; wget http://www.fractalconcept.com/download/cl-pdf-current.tgz; tar xvzf cl-pdf-current.tgz; cd cl-pdf
; cd /tmp/; `curl -O https://beta.quicklisp.org/quicklisp.lisp`
; `sbcl --load quicklisp.lisp`
; `(quicklisp-quickstart:install)`
; `(ql:quickload "cl-pdf")`
; `(ql:add-to-init-file)`

; https://stackoverflow.com/questions/3970001/cl-pdf-output-error

(load "~/scripts/pdfsearches/pdfsearch.lisp/config.lisp")

(format t "Hello, World!")

(in-package #:pdf)
