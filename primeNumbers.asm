;Write code that on screen prints first n prime numbers, n is user input in range [1-50].In case that user 
;give invalid input user should be informed. Use C functions.

SECTION .data
format_s	db	'%d',0
message		db	'Invalid input.',10,0
current		dd	1
format_p	db	'%d',10,0
SECTION .bss
n		resb	1
counter		resb	1
smaller		resb	1

SECTION .text
global main	
extern	scanf,printf
main:

push	ebp	;store values of reg.
mov	ebp,esp
push	ebx
push	esi
push	edi

get_n:	
    push	n	;n = user_input
    push	format_s
    call	scanf
    add		esp,8

validate:
    mov		al,[n]
    cmp		al,1
    jl		error
    cmp		al,50
    ja		error
jmp write_prime		;if user input is valid (first prime = 1)

iterate:
      cmp 	byte[n],0 	;condition for exit
      je	end
      check_if_prime:
	mov	byte[smaller],1		;start with 1
	mov	byte[counter],1		;(include current)
	iterate_div:
	    mov 	ax,word[current]	
	    div		byte[smaller]	;look for ah
	    cmp		ah,0	;check what's left after div
	    je		match
	    inc		byte[smaller]
	    mov 	dl,[smaller]
	    cmp		dl,[current]
	    jb		iterate_div  
	    
label_b:      
      cmp	byte[counter],2
      je	write_prime
label_a:      
      inc 	byte[current]
      jmp	iterate

match:
      inc 	byte[counter]	;inc counter
      inc	byte[smaller]
      mov 	dl,[smaller]
      cmp 	dl,[current]
      jb	iterate_div
      jmp 	label_b

write_prime:   
    push	dword[current]
    push	format_p
    call	printf
    add		esp,8
    dec 	byte[n]
    jmp 	label_a
    
error:
    push	message
    call	printf
    add		esp,4	

end:	;load reg. values
  pop	edi
  pop	esi
  pop	ebx
  mov 	esp,ebp
  pop	ebp
  ret