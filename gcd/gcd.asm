;Emanuel Brici
;4/22/2015

SECTION	.data

prompt1: db 	"Enter a positive integer: "
plen1:	 equ	$-prompt1

prompt2: db     "Greatest common divisor = "
plen2:   equ       $-prompt2

prompt3: db     "Bad Number ",10
plen3:   equ       $-prompt3

newline: db      "",10				;newline 

SECTION .bss

digits:	equ	21			        ;set digits to 21 permanently 
string:	resb	21				;reserves space for 21 bytes

SECTION	.text

global	_start

_start:
		call    readNumber		;read in first number
		call	getInt			;call getInt on first input number
		push	eax			;push the returned value on stack
		call    readNumber		;read in second number
		call	getInt			;call getInt on second input number
		mov	ebx, eax		;move returned value into ebx
		pop	eax			;pop eax which was the value from the first call to getInt
		call   	gcd			;call gcd on with ebx and eax as values being passed in
		call	printgcd		;print out "Greatest common divisor = "
		mov	edx, 0			;clear out edx register
		mov 	ebx, 0x0		;keep track of digits
		mov   	ecx, 10			;set ecx to 10 to be used in makeDecimal
		call	makeDecimal		;make the value returned from gcd back into a number
		jmp 	done			;program is completed and ready for termination


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;readNumber function;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
readNumber:	
		mov	eax, 4			;write
		mov	ebx, 1			;to standard output
		mov	ecx, prompt1		;the prompt string
		mov	edx, plen1		;of length plen
		int 	80H			;interrupt with the syscall
		mov	eax, 3			;read
		mov	ebx, 0			;from standard input
		mov	ecx, string		;into the input buffer
		mov	edx, digits+1		;up to digits + 1 bytes
		int 	80H			;interrupt with the syscall
		mov     esi, string		;move string to esi register
		ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;getInt function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
getInt:		mov	ebx, 1			;set ebx which is digitValue to 1
		mov 	eax, 0			;set eax which is result to 0
		mov     edx, 0			;clear out edx register
		mov	edi, esi		;set digit = string ///digit is the edi register
while:		
		mov	al,  [edi]		;move the first byte into al 
		cmp     al,  0xa		;check to see if newline
		jne 	increment		;continue with while loop
		je	decrement		;loop is done
increment:
		inc 	edi			;digit++
		jmp     while
decrement:
		dec	edi			;digit--

while1:		
		mov     eax, 0			;move 0 into eax register
		mov    	al, [edi]		;move byte of edi into al
		cmp	al, 0x20		;see if byte is a newline
		je	return			;if so just return
		cmp     al, 0x30		;check less then 0
		jl      error			;if so jump to error to terminate
		cmp 	al, 0x39		;check greater then 9
		jg	error			;if so jump to error to terminate
	
		sub 	al, 0x30		;subtract 30h from the digit
		movzx	eax, al			;then move al into eax
		push    edx			;push edx so nothing gets mucked with when multiplying
		mul     ebx			;multiplying eax by current multiple of 10
		pop  	edx			;pop edx now
		add     edx, eax		;store result into edx 
		push	eax			;push eax for later
		push    edx			;push edx for later
		mov 	eax, ebx		;move current multiple of 10 in eax
		
		mov     ecx, 10			;ecx used to make the correct decimal number
		mul    	ecx			;mul integer in eax by ecx
		mov	ebx, eax		;move new integer into ebx
		pop	edx			
		pop	eax			
		cmp 	edi, esi		;compare if edi and esi are equal to see if complete
		je	return			
		dec	edi			;if not continue going through the digits
		jmp 	while1
error:		
	        mov	eax, 4			;write
		mov	ebx, 1			;to standard output
		mov	ecx, prompt3		;the prompt string
		mov	edx, plen3		;of length plen
		int 	80H			;interrupt with the syscall
		jmp     done			;terminate program
return:
		mov 	eax, edx		;move edx into eax 
		ret				;return back up to the caller

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;gcd function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gcd:		
		cmp	eax, ebx		;check to see if eax is greater the ebx
		jg	greater			;if so jump to greater
		jl	less			;if sot jump to less
		ret				;return the gcd
greater:
		sub 	eax, ebx		;subtract ebx form eax
		call	gcd			;then call gcd again ///recursion
		ret
less:
		sub 	ebx, eax		;subtract eax from ebx
		call	gcd			;then call gcd again ///recursion
		ret	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;prints to terminal "Greatest common divisor =";;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printgcd:
		push    eax
		mov	eax, 4			; write
		mov	ebx, 1			; to standard output
		mov	ecx, prompt2		; the prompt string
		mov	edx, plen2		; of length plen
		int 	80H			; interrupt with the syscall
		pop	eax
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;makeDecimal function;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
makeDecimal:
		mov	edx, 0			;clear out edx with 0 so division works 
		div	ecx			;divide eax by 10 which is in ecx
		push	edx			;push the remainder which is now in edx
		cmp	eax, 0			;compare quotient to 0
		jg	recursion		;if greater recurse 
		je	printDigit		;else print out the digits
recursion:
		call 	makeDecimal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;putchar function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printDigit:
		pop	edx			;pop the most recent digit to be printed
		add	edx, '0'		;add 30h to the digit 
		mov	[string], edx		;move the digit into string
		mov	eax, 4			;write
		mov	ebx, 1			;to standard output
		mov	ecx, string		;the prompt string	
		mov	edx, 1			;of length plen
		int 	80H			;interrupt with the syscall
		ret				;return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;exit call;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
done:
		mov	eax, 4			;write
		mov	ebx, 1			;to standard output
		mov	ecx, newline		;the prompt string
		mov	edx, 1			;of length plen
		int 	80H			;interrupt with the syscall
		mov eax, 1			;set up process exit
		mov ebx, 0			;and
		int	80H			;terminate








