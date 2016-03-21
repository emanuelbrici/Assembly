;Emanuel Brici
;4/15/2015

global stringgt

SECTION .text

stringgt:
        push  ebp		;push registers that will be used
        mov   ebp,esp
	push  ebx
	push  edx
	push  edi
	push  esi
	mov   esi,[ebp + 8]    	;place first arg in esi   
	mov   edi,[ebp + 12]	;place second arg in edi
        mov   edx, 0

compare:
        mov   al, [esi + edx]   ;moves the first byte in al from esi register                           
        mov   bl, [edi + edx]   ;moves the first byte in bl from edi register                           
        inc   edx               ;increment counter edx if loop if gone through again                    
        cmp   bl, 0xa           ;test to see if second word is shorter then the first                   
        jz    true              ;if byte is equal to '\n' go to true                                    
        cmp   al, 0xa           ;test test to see if first word is shorter the the second               
        jz    false             ;if byte is equal to '\n' go to false                                   
        cmp   bl,al             ;test bytes in al and bl                                                
        jz    compare           ;if same go through loop agian                                          
        jg    false             ;if bl byte is greater then al byte its false                           
        jl    true              ;if bl byte is less then al byte its true                               

false:
        mov   eax, 0		;set return value to Zero for false
        jmp   done
true:
	cmp   al, 0xa		;check to see if the words are the same
	jz    false		;if they are not true by false
        mov   eax, 1		;set return value to one for true

done:	
        pop   esi		;pop all registers that were used
	pop   edi
	pop   edx
	pop   ebx	
        mov   esp,ebp
        pop   ebp
        ret


