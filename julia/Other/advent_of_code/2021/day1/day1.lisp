;; See ../../../../../pdfsearches/pdfsearch.cl/pdfsearch.lisp for my first attempt at CL
;; <https://github.com/jakewilliami/scripts/blob/master/pdfsearches/pdfsearch.cl/pdfsearch.lisp>'
;; 
;; For compiling this file, see Buildapp
;; <https://www.xach.com/lisp/buildapp/>
;; <https://stackoverflow.com/a/14182986/12069968>

;; (in-package :str)
(require :uiop)

;; Initialise input data
(defvar data nil)

(defun main (argv) 
	(declare (ignore argv))
	
	;; Read input data
    ;; (setq data 
		;; https://stackoverflow.com/a/64530084/12069968
		;; (mapcar #'parse-integer (uiop:read-file-string "data1.txt")))
	;; (setq data (parse-list))
	(setq data (parse-input))
	
	;; Part 1
	;; Part 2
	(write-line "Hello, World!")
)

(defun parse-input (filename)
	(count 't (map 'list '< filename (cdr filename)))
)

