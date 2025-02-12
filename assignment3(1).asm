;Write a switch case driven X86/64 ALP to perform 64-bit hexadecimal arithmetic operation (+,-,*,/) using suitable macros. Define prosedure for each operation
;Manish Kumar
;7231

%macro io 4
	mov rax,%1
	mov rdi,%2
	mov rsi,%3
	mov rdx,%4
	syscall
%endmacro

%macro exit 0
	mov rax,60
	mov rdi,0
	syscall
%endmacro

section .data

	msg db "7231: Manish Kumar",10,"Write a switch case driven X86/64 ALP to perform 64-bit hexadecimal arithmetic operation (+,-,*,/) using suitable macros. Define prosedure for each operation",10,"Date: 5 feb 2025",10	
	msglen equ $-msg

	msg1 db "Enter your choice: ",10
	msg1len equ $-msg1

	msg2 db "Enter num1: ",10
	msg2len equ $-msg2

	msg3 db "Enter num2: ",10
	msg3len equ $-msg3

	msg4 db "1: Addition ",10,"2: Subtraction ",10,"3: Multiplication",10,"4: Division",10,"5: Exit",10
	msg4len equ $-msg4
	
	msg5 db "Q: ",10
	msg5len equ $-msg5

	msg6 db "D: ",10
	msg6len equ $-msg6

	newline db 10

section .bss
	num1 resq 2
	num2 resq 2
	choice resb 2
	asciinum resb 17
	div32 resb 9
	hexnum resq 5


section .code
global _start
	_start:
		io 1,1,msg,msglen
		io 1,1,msg4,msg4len
		io 1,1,msg1,msg1len
		io 0,0,choice,2
		
		
		case1:
			cmp byte[choice],"1"
			jne case2
			
			io 1,1,msg2,msg2len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num1],rbx
			io 1,1,msg3,msg3len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num2],rbx
			call addition
			;jmp exit
						
		case2:
			cmp byte[choice],"2"
			jne case4
			io 1,1,msg2,msg2len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num1],rbx
			io 1,1,msg3,msg3len
			io 0,0,asciinum,17
			call ascii_hex64
			mov [num2],rbx
			call subtraction
			;jmp exit

		case4:
			cmp byte[choice],"4"
			jne case5

			io 1,1,msg2,msg2len
			io 0,0,asciinum,17

			cld
			mov rsi,asciinum
			mov rdi,div32
			mov rcx,8
			rep movsb
			call ascii_hex32
			mov rdx,0
			mov edx,ebx
			push rdx

			cld
			mov rsi,asciinum+8
			mov rdi,div32
			mov rcx,8
			rep movsb
			call ascii_hex32
			mov rax,0
			mov eax,ebx
			push rax

			io 0,0,div32,9
			call ascii_hex32
			pop rax
			pop rdx
			div ebx                ;Q=eax and R=edx
			push rdx
			push rax

			io 1,1,msg5,msg5len
			pop rax 
			mov rbx,rax
			call hex_ascii32

			io 1,1,msg6,msg6len
			pop rdx
			mov ebx,edx
			call hex_ascii32
			
			;jmp exit
		
		case5:
			cmp byte[choice],"5"
			;jmp exit
		
		exit

addition:
	mov rax,[num1]
	add rax,qword[num2]
	mov rbx,rax
	call hex_ascii64

subtraction:
	mov rax,[num1]
	sub rax,qword[num2]
	mov rbx,rax
	call hex_ascii64



ascii_hex64:
	mov rsi,asciinum

	mov rbx,0
	mov rcx,16

	next5:
		rol rbx,4
		mov al,[rsi]
		cmp al,39h
		jbe subt30h
		sub al,7h

		subt30h:
			sub al,30h
			add bl,al
			inc rsi
	loop next5

	ret	

ascii_hex32:

	mov rsi,div32
	mov rbx,0
	mov rcx,8

	next3:
		rol ebx,4
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
			ADD al,30h
			mov [rsi],al
			inc rsi
	loop next4
		io 1,1,asciinum,16
		io 1,1,newline,1
		ret


hex_ascii32:
	mov rsi,rbx
	mov rcx,8

	next6:
		rol rbx,4
		mov al,bl
		and al,0fh
		cmp al,9
		jbe addi30h
		add al,7h

		addi30h:
			ADD al,30h
			mov [rsi],al
			inc rsi
	loop next6
		io 1,1,rbx,8
		io 1,1,newline,1
		ret













