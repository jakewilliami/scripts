;;;  text segment is used to store the code
;;;  data segment used to store initialised variables
;;;  bss segment used to store uninitialised variables
segment .text
;;; _start is the entry point
;;; need to globally initialise it first
global _start
_start:	
	ret
