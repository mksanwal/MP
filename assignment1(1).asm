; Write X86/64 ALP to accept five 64 bit hexadecimal number from user and store it in an array and display the accepted number.
; Manish Kumar
; 7231
; Date: 22 January 2025

%macro io 4
	; Macro for syscall to interact with input/output
	; %1: system call number (rax)
	; %2: file descriptor (rdi) - 1 for stdout, 0 for stdin
	; %3: buffer (rsi) - where the data is stored or read
	; %4: length of buffer (rdx) - size of the data
	mov rax, %1        ; Load syscall number (1 for write, 0 for read) into rax
	mov rdi, %2        ; Load file descriptor (1 for stdout, 0 for stdin) into rdi
	mov rsi, %3        ; Move buffer address to rsi
	mov rdx, %4        ; Move length of buffer to rdx
	syscall            ; Make system call
%endmacro

%macro exit 0
	; Macro to exit the program
	mov rax, 60        ; Syscall number for exit
	mov rdi, 0         ; Exit status 0
	syscall            ; Make system call to exit
%endmacro


section .data
	; Define constant strings in the data section
	msg1 db "7231: Manish Kumar", 10, "Write X86/64 ALP to accept five 64-bit hexadecimal numbers from user and store them in an array, then display the accepted numbers.", 10, "Date: 22 January 2025", 10
	msg1len equ $ - msg1    ; Length of msg1

	msg2 db "Enter 5 64bit hexadecimal numbers:", 10
	msg2len equ $ - msg2    ; Length of msg2

	msg3 db "5 64bit hexadecimal numbers are: ", 10
	msg3len equ $ - msg3    ; Length of msg3

	newline db 10            ; Newline character (ASCII code for a new line)

section .bss
	; Reserve memory in the BSS section for runtime data
	asciinum resb 17         ; Buffer to store ASCII input (16 characters + 1 for null-terminated input)
	hexnum resq 5            ; Array to store 5 64-bit hexadecimal numbers (5 quad words, 8 bytes each)

section .code
global _start
	_start:
		; Display initial message to the user
		io 1, 1, msg1, msg1len   ; Write msg1 to stdout
		io 1, 1, msg2, msg2len   ; Write msg2 to prompt for hexadecimal input

		; Input loop to accept 5 hexadecimal numbers
		mov rcx, 5               ; Initialize counter for 5 numbers
		mov rsi, hexnum          ; Set rsi to point to the hexnum array

	next1:
		push rsi                 ; Save the current hexnum array address
		push rcx                 ; Save the loop counter
		io 0, 0, asciinum, 17    ; Read up to 16 characters from stdin into asciinum buffer
		call ascii_hex64         ; Convert the ASCII input to a 64-bit hexadecimal number
		pop rcx                  ; Restore the loop counter
		pop rsi                  ; Restore the hexnum array address
		mov [rsi], rbx           ; Store the converted 64-bit hexadecimal number into the array
		add rsi, 8               ; Move to the next position in the array (64-bit = 8 bytes)
		loop next1               ; Loop 5 times to input all numbers

		; Output loop to display the 5 hexadecimal numbers
		io 1, 1, msg3, msg3len   ; Write msg3 to stdout to indicate the start of the output
		mov rsi, hexnum          ; Reset rsi to the start of the hexnum array
		mov rcx, 5               ; Set counter to 5

	next2:
		push rsi                 ; Save the current hexnum array address
		push rcx                 ; Save the loop counter
		mov rbx, [rsi]           ; Load the next 64-bit hexadecimal number from the array
		call hex_ascii64         ; Convert the number to an ASCII string
		pop rcx                  ; Restore the loop counter
		pop rsi                  ; Restore the hexnum array address
		add rsi, 8               ; Move to the next position in the array
		loop next2               ; Loop 5 times to output all numbers

		exit                     ; Exit the program using the exit macro

	; Function to convert ASCII input (hexadecimal string) to 64-bit hexadecimal number
	ascii_hex64:
		mov rsi, asciinum        ; Set rsi to point to the input buffer (asciinum)
		mov rbx, 0               ; Clear rbx to store the 64-bit result
		mov rcx, 16              ; We need to process 16 characters for a 64-bit number

	next3:
		rol rbx, 4               ; Rotate rbx left by 4 bits to make space for the next hex digit
		mov al, [rsi]            ; Load the next character from the input buffer
		cmp al, 39h              ; Check if the character is between '0' and '9'
		jbe sub30h               ; If it's a digit, jump to sub30h
		sub al, 7h               ; If it's 'A'-'F', subtract 7h to convert it to the appropriate hex value

	sub30h:
		sub al, 30h              ; Convert ASCII digit to its numeric value (subtract '0')
		add bl, al               ; Add the numeric value to the result stored in rbx
		inc rsi                  ; Move to the next character in the buffer
		loop next3               ; Repeat for all 16 characters

	ret                         ; Return from the function

	; Function to convert 64-bit hexadecimal number to ASCII string
	hex_ascii64:
		mov rsi, asciinum        ; Set rsi to point to the output buffer (asciinum)
		mov rcx, 16              ; We need to process 16 characters for a 64-bit number

	next4:
		rol rbx, 4               ; Rotate rbx left by 4 bits to get the next hex digit
		mov al, bl               ; Extract the least significant 4 bits (current hex digit)
		and al, 0fh              ; Mask out the other bits, keeping only the last 4
		cmp al, 9                ; Check if the digit is less than or equal to 9
		jbe add30h               ; If it's a digit, jump to add30h
		add al, 7h               ; If it's 'A'-'F', add 7h to convert it to the appropriate ASCII value

	add30h:
		add al, 30h              ; Convert the digit to ASCII ('0'-'9' or 'A'-'F')
		mov [rsi], al            ; Store the ASCII character in the output buffer
		inc rsi                  ; Move to the next position in the buffer
		loop next4               ; Repeat for all 16 characters

		io 1, 1, asciinum, 16    ; Output the converted ASCII string
		io 1, 1, newline, 1      ; Output a newline character
	ret                         ; Return from the function



	
