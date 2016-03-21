;Emanuel Brici
;4/7/2015
 
SECTION	.data

prompt:	db		"Enter 10 digits: "
plen:	equ		$-prompt

SECTION	.bss
	
digits:	equ		10      		;set digits to 10 permanently 
inbuf:	resb	digits + 2			;resevse space for 12 bytes

SECTION	.text

global	_start

_start:
		nop
		mov	eax, 4			; write
		mov	ebx, 1			; to standard output
		mov	ecx, prompt		; the prompt string
		mov	edx, plen		; of length plen
		int 	80H			; interrupt with the syscall

		mov	eax, 3			; read
		mov	ebx, 0			; from standard input
		mov	ecx, inbuf		; into the input buffer
		mov	edx, digits+1		; upto digits + 1 bytes
		int 	80H			; interrupt with the syscall

		cld 
		mov     esi, inbuf
		mov     ecx, digits
		mov     dx, 0

;This block of code takes in 10 digits and does ;calculations on each digit to come up with an 11th digit;that is tacked on to the original 10 digits and  ;and then prints them out. The loop at the beginning;of top: goes through the loop for each digit and ;subtracts 0x30 to get the integer value. ;At first 10 gets added to the first digit and ;as the loop continues that number is decremented by one;until the loop is finished. All of those numbers are;added up and then that number is divided by 11.;0x30 is added to the remainder and that is what is;tacked onto the end of the 10 digits.
top:
		lodsb				;loads single byte
		sub     al, '0'			;subtract from loaded byte 0x30 leaving behind integer value
		mul	cl			;cl gets set to 10 and as you go through the loop it is decremented by 1
		add	dx, ax			;ax is equal to al times cl, which then gets added to dx 
		loop    top			;loop is gone through for as many digits there are
		mov     ax, dx			;contents of dx get moved to ax
		mov     cl, 11			;11 gets moved into cl
		div     cl			;cl divides ax and then the remainder is stored in ah
		mov     al, ah			;the remainder that is in ah then gets moved into al
		add	al, '0'			;0x30 is then added to al to get hex number of remainder
		mov	[inbuf+10], al		;puts the remainder that is stored in al at the end of the initial 10 digits
		mov	byte [inbuf+11], 10	;then puts a newline char at the end of the buffer

		mov	eax, 4			; write
		mov	ebx, 1			; to standard output
		mov	ecx, inbuf		; the string in the buffer
		mov	edx, digits+2		; of length plen
		int 	80H			; interrupt with the syscall

		mov eax, 1			; set up process exit
		mov ebx, 0			; and
		int	80H			; terminate


