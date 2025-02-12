;Write a Switch Case driven X86/64 ALP to perform 64-bit hexadecimal arithmetic operations(+,-,*,/) using  suitable macros . Define procedure for each opeartion
; Date : 5/2/25

;macro for reading and writing
%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

;macro for exit
%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro

;intiallized message
section .data
	newline db 10
	msg1 db "Write a Switch Case driven X86/64 ALP to perform 64-bit hexadecimal arithmetic operations(+,-,*,/) using  suitable macros . Define procedure for each opeartion",10,"Date: 5/2/25",10
	msg1len equ $-msg1
	msg2 db "Enter number1: ",10
	msg2len equ $-msg2
	msg3 db "Enter number2: ",10
	msg3len equ $-msg3
	menu db "1. Addition ",10,"2. Subtraction",10,"3. Multiplication ",10,"4. Division ",10,"5. exit",10
	menulen equ $-menu
	msg4 db "Enter choice : ",10
	msg4len equ $-msg4

section .bss
	num1 resq 1
	num2 resq 2
	asciinum resb 17
	div32 resb 9
	choice resb 2

section .code 
global _start
	_start:

		io 1,1,menu,menulen ;display menu
		io 1,1,msg4,msg4len
		io 0,0,choice,2 ;enter choice from user

		
		case1: 
			cmp byte[choice],"1"
			jne case2
			
			io 1,1,msg1,msg1len
			io 1,1,msg2,msg2len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num1],rbx
			io 1,1,msg3,msg3len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num2],rbx
			
			
			call addition
			io 1,1,newline,1
			jmp case5
		
		case2:
			
			cmp byte[choice],"2"
			jne case3			
		
			io 1,1,msg1,msg1len
			io 1,1,msg2,msg2len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num1],rbx
			io 1,1,msg3,msg3len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num2],rbx
			
			call subtraction
			io 1,1,newline,1
			jmp case5
		
		case3:
			cmp byte[choice],"3"
			jne case4
			
			io 1,1,msg1,msg1len
			io 1,1,msg2,msg2len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num1],rbx
			io 1,1,msg3,msg3len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num2],rbx
						
			call multiplication
			io 1,1,newline,1
			jmp case5
		
		case4: 
			
			jmp case5		

		case5:
			exit
	
ascii_hex64:
    mov rsi, asciinum
    mov rbx,0
    mov rcx,16
            next3:
                rol rbx,4
                mov al,[rsi]
                cmp al,39h
                jbe sub30h
                sub al,7h
                sub30h:
                    sub al,30h
                add bl,al
                inc rsi
                loop next3
            ret

	addition:
		mov rax,[num1]
		add rax,qword[num2]	
		mov rbx,rax
		call hex_ascii64
		ret
	
	subtraction:
		mov rax,[num1]
		sub rax,qword[num2]	
		mov rbx,rax
		call hex_ascii64
		ret

	multiplication:
		mov rax,[num1]
		mul qword[num2]
		mov rbx,rax
		call hex_ascii64
		ret	

	divide:
			

	 hex_ascii64:
            mov rsi,asciinum
            mov rcx,16
            next4:
                rol rbx,4
                mov al,bl
                and al,0fh
                cmp al,9
                jbe add30h
                add al,7h
                add30h:
                    add al,30h
                mov [rsi],al
                inc rsi
                loop next4
            io 1,1,asciinum,16
            
            ret


