#!/usr/local/bin/sbcl --script
;;; run using `clisp ~/scripts/pdfsearches/pdfsearch.lisp`
;; (or `sbcl --script ~/scripts/pdfsearches/pdfsearch.lisp`)

;;; run the following on the command line:
; $ brew install clisp sbcl asdf
; $ mkdir ~/.commonlisp
; $ cd ~/.commonlisp/
; $ curl -O https://beta.quicklisp.org/quicklisp.lisp
; $ sbcl --load quicklisp.lisp
; * (quicklisp-quickstart:install)
; * (ql:quickload "vecto")
; * (ql:quickload "cl-pdf")
; * (ql:add-to-init-file)
; * (exit)
;;; now you can load your quicklisp installation (https://www.quicklisp.org/beta/#loading):
; (load "~/quicklisp/setup.lisp")


;;; OUTDATED METHOD:
; $ mkdir ~/.commonlisp
; $ cd ~/.commonlisp/
; $ wget http://www.fractalconcept.com/download/cl-pdf-current.tgz
; $ tar xvzf cl-pdf-current.tgz
; $ cd cl-pdf/
; $ sbcl
; * (require 'asdf)
; * (require 'asdf-install)
; * (asdf-install:install "/Users/jakeireland/cl-pdf-current.tgz")
; * (exit)


; (format t "Hello, World!")

(load "~/quicklisp/setup.lisp")
(ql:quickload "cl-pdf")

(pdf:with-document ()
   (pdf:with-page ()
     (let ((helvetica (make-instance 'pdf:font)))
       (pdf:add-fonts-to-page helvetica)
       (pdf:in-text-mode
         (pdf:set-font helvetica 36.0)
         (pdf:move-text 100 800)
         (pdf:draw-text "CL-PDF: Example 1"))
       (pdf:translate 230 500)
       (loop repeat 101
         for i = 0.67 then (* i 1.045)
         do (pdf:in-text-mode
           (pdf:set-font helvetica i)
           (pdf:move-text (* i 3) 0)
           (pdf:draw-text "rotation"))
         (pdf:rotate 18))))
   (pdf:write-document #P"ex1.pdf"))
