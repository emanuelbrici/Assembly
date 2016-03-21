#Emanuel Brici
#10/22/14
#String Comparison

	.data

stringAddress1: .asciiz "Enter first string:  "
stringAddress2: .asciiz "\nEnter string to compare:  "
stringBuffer1: .space 80
stringBuffer2: .space 80
ifsame: 	.asciiz  "\nThe Strings do Match: "	
notsame: 	.asciiz  "\nThe Strings do not Match: "	
	.text


main:	la $a0, stringAddress1	# put a string ptr in $a0
	li $v0, 4 		# code 4 means print a string
	syscall 		# have the OS do it
	
	li $v0, 8 		# code for read a string
	la $a0, stringBuffer1 	# address to store string
 	li $a1, 80 		# max characters to read
	syscall
	
	la $a0, stringAddress2	# put a string ptr in $a0
	li $v0, 4 		# code 4 means print a string
	syscall 		# have the OS do it
	
	li $v0, 8 		# code for read a string
	la $a0, stringBuffer2 	# address to store string
 	li $a1, 80 		# max characters to read
	syscall

	la $a0,stringBuffer1    #pass address of str1  
	la $a1,stringBuffer2    #pass address of str2  
	
	add $s0, $0, $a0	#put the first string to compare into $s0 
	add $s1, $0, $a1	#put the second string to compare into $s1
	
	addi $s2,$0, 0		#compare if same bit
	addi $s3,$0, -1		#compare if greater
	addi $s4,$0, 1		#compare if less
	
	
cmpstr: 
	lb   	$t0($s0)			#load first bit of first string into tmp1
	lb   	$t1($s1)			#load first bit of second string into tmp2 
	sub  	$t2, $t0, $t1			#subtract bits from eachother
	beqz  	$t2, same			#bracnh if the same
	blt    	$t0, $t1, lessthen		#branch if less
	bgt    	$t0, $t1, greaterthen		#branch if greater
	j	cmpstr
	
lessthen:
	la   $a0, notsame 	# load address of notsame to print
      	li   $v0, 4          	
      	syscall
	move $a0, $s3     	# load address of spacer to print
      	li   $v0, 1         	
     	syscall 
     	jal done

greaterthen:
	la   $a0, notsame 	# load address of notsame to print
      	li   $v0, 4          	
      	syscall 
	move $a0, $s4      	# load address of spacer to print
      	li   $v0, 1          	
     	syscall 
     	jal done
same:
	addi 	$s0,$s0,1 	#increment 1 bit
	addi 	$s1,$s1,1	#increment 1 bit
	beqz 	$t0 secondcheck #check if first sting is empty
	j	cmpstr

secondcheck:
	beqz $t1 printzero	#check if second sting is empty
	jr   $ra

printzero:
	la   $a0, ifsame 	# load address of ifsame to print
      	li   $v0, 4          	
      	syscall 
	move $a0, $s2      	# load address of spacer to print
      	li   $v0, 1          	
     	syscall
	j	done
done:
	li   $v0, 10            # system call for exit
      	syscall
	
