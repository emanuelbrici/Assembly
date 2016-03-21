#Emanuel Brici
#10/20/14
#Hailstone


	.data
	
num:    .word 7	#number that hailstone will run
count:  .word 0	#numer of times hailstone ran
space: 	.asciiz  " "          # space to insert between numbers
head: 	.asciiz  "The HailStone numbers are:\n"	
newLine: .asciiz "\n"
secondHead: 	.asciiz  "Number of iterations:"	
	
	.text 
	 
	la   $a0, head        # load address of print heading
      	li   $v0, 4           # specify Print String service
      	syscall               # print heading
      	
      	
main:	lw $s0, num($0)   	#sets $s0 to num
	lw $s1, count($0) 	#sets $s1 to count
	
	#add $t0, $0, $s0  	#temp is now num

while:	
	beq  $s0, 1, done	
	jal print
	andi $t1, $s0, 1	#addi $t1 ,$0, 1 
	bne  $t1, 0, isodd	#check is even if so contine, if not jump to odd
	srl  $s0, $s0, 1
	addi $s1, $s1, 1
	j while
	
isodd: 	sll  $t1, $s0, 1 	#add to it self
	add  $t2, $s0, $t1	#after shift add num to shift
	addi $s0, $t2, 1	#add 1 to N*3
	addi $s1, $s1, 1	#increment counter
	j while		#jump back
	
done: 	move $a0, $s0     
       	li   $v0, 1          
       	syscall
       	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
     	syscall 
     	la   $a0, newLine       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
     	syscall 
       	la   $a0, secondHead        # load address of print secondheading
      	li   $v0, 4           # specify Print String service
      	syscall 
      	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
     	syscall 
       	move $a0, $s1     
       	li   $v0, 1         
       	syscall
      	li   $v0, 10          # system call for exit
      	syscall
   

	
print: 	move $a0, $s0     
       	li   $v0, 1          
       	syscall
       	la   $a0, space       # load address of spacer for syscall
      	li   $v0, 4           # specify Print String service
     	syscall 
	jr $ra
#	add $t0, $0, $t1
#	la $a0, ($t1)
#	li   $v0, 4  
#	la $a0, ($s1)
#	syscall 
