;;; This value (defined using a macro) is defined by
;;; the assembly gods.  Remember computers sometimes
;;; work with registers
%define SYS_EXIT 60
;;;  text segment is used to store the code
;;;  data segment used to store initialised variables
;;;  bss segment used to store uninitialised variables
segment .text
;;; _start is the entry point
;;; need to globally initialise it first
global _start
_start:
	mov rax, SYS_EXIT
	mov rdi, 0					; special error code 69
	syscall
	ret
