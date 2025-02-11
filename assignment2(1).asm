; Write an X68/64 ALP to accept a string and to display its length
; Manish Kumar
; 7231
; Date: 29 january 2025

%macro io 4
	; Macro for performing system calls for input/output
	; %1: syscall number (rax)
	; %2: file descriptor (rdi)
	; %3: buffer (rsi) - address of the data to be written/read
	; %4: length of data (rdx) - number of bytes to write/read
	mov rax, %1         ; Load syscall number (1 for write, 0 for read) into rax
	mov rdi, %2         ; Load file descriptor (1 for stdout, 0 for stdin) into rdi
	mov rsi, %3         ; Load buffer address into rsi
	mov rdx, %4         ; Load buffer length into rdx
	syscall             ; Perform the syscall (write or read)
%endmacro

%macro exit 0
	; Macro to exit the program
	mov rax, 60        ; Syscall number for exit
	mov rdi, 0         ; Exit status 0
	syscall            ; Make system call to exit
%endmacro

section .data
	; Predefined messages and other static data
	msg db "7231: Manish Kumar", 10, "Write X86/64 ALP to accept five 64-bit hexadecimal numbers from user and store them in an array and display the accepted number.", 10, "Date: 29 January 2025", 10
	msglen equ $-msg        ; Calculate the length of 'msg'

	msg1 db "Enter Your String:", 10
	msg1len equ $-msg1      ; Calculate the length of 'msg1'

	msg2 db "Method 1 (without loop):", 10
	msg2len equ $-msg2      ; Calculate the length of 'msg2'

	msg3 db "Method 2 (with loop):", 10
	msg3len equ $-msg3      ; Calculate the length of 'msg3'

	count db 5              ; A counter value (for potential use later)
	newline db 10           ; Newline character (ASCII 10)

	len2 db 0               ; To store the length of the string entered by the user

section .bss
	; Variables for runtime data
	string resb 30          ; Reserve 30 bytes for the string input
	asciinum resb 2         ; Reserve 2 bytes for ASCII representation of the length

section .code
global _start
	_start:
		; Display the initial message to the user
		io 1, 1, msg, msglen   ; Write 'msg' to stdout (file descriptor 1)
		io 1, 1, msg1, msg1len ; Write 'msg1' to prompt for string input

		; Read the string input from the user
		io 0, 0, string, 30    ; Read up to 30 characters into 'string' buffer from stdin

		; Demonstrating "Method 1: Without loop"
		dec rax                ; Decrement rax (rax contains the number of bytes read)
		mov rbx, rax           ; Move the string length into rbx
		io 1, 1, msg2, msg2len ; Write 'msg2' to show the method type
		call hex_ascii8        ; Call the subroutine to convert length to ASCII and display

		; Demonstrating "Method 2: With loop"
		io 1, 1, msg3, msg3len ; Write 'msg3' to show the method type
		mov rsi, string        ; Load the address of 'string' into rsi (to iterate through the string)

		; Start a loop to count the length of the string (ignoring newline)
	back:
		mov al, [rsi]          ; Load the next character from 'string' into al
		cmp al, 10             ; Compare with newline (ASCII 10)
		je skip                ; If it's newline, skip the rest of the loop
		inc byte [len2]        ; Increment len2 to keep track of the string length
		inc rsi                ; Move to the next character in the string
		loop back              ; Repeat until all characters are checked

	skip:
		mov bl, [len2]         ; Move the final string length into bl
		call hex_ascii8        ; Call the subroutine to convert length to ASCII and display

		; Exit the program
		exit

	; Subroutine: Convert an 8-bit number in bl to a 2-character hexadecimal ASCII string
	hex_ascii8:
		mov rsi, asciinum      ; Load address of 'asciinum' buffer into rsi
		mov rcx, 2             ; We need to convert 2 hexadecimal digits (1 byte)

	next2:
		rol bl, 4              ; Rotate bl left by 4 bits to isolate the next hex digit
		mov al, bl             ; Move the lowest 4 bits of bl into al
		and al, 0Fh            ; Mask the upper bits of al to isolate the hex digit
		cmp al, 9              ; Check if the digit is between 0-9
		jbe add30h             ; If yes, jump to add '0'
		add al, 7h             ; Otherwise, convert to 'A'-'F' by adding 7h

	add30h:
		add al, 30h            ; Convert to ASCII by adding 30h ('0')
		mov [rsi], al          ; Store the ASCII character in the 'asciinum' buffer
		inc rsi                ; Move to the next position in the buffer
		loop next2             ; Repeat for both hex digits

		; Output the hexadecimal number as ASCII
		io 1, 1, asciinum, 2   ; Write the 2-digit ASCII number to stdout
		io 1, 1, newline, 1    ; Write a newline
	ret                        ; Return from subroutine
