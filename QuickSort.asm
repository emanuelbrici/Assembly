#Emanuel Brici
#12/10/2014


		.data
			
filePrompt:	.asciiz "Enter file name: "
fileError:	.asciiz "Error opening file \n"
fileName:	.space 80
nlChar:		.asciiz "\n"	
fileDescr:	.word -1
sTable:		.space 2000
buffer:		.space 10000
strCount:	.word -1


		.text

main:		
		jal	openFile	        #open file that has text to be read
		
		move	$a0, $v0		#address of table
		la	$a1, buffer		#address of buffer
		li	$a2, 10000		#lenght of buffer
		jal	readFile		#readFile
		
		la	$a0, sTable		#address of sTable
		la	$a1, buffer		#address of buffer
		move 	$a2, $v0		#move $v0 into $a2
		jal	makeTable		#makeTable out of words from file
		
		
		sw	$v0, strCount($0)	#$v0 has the number of strings found
		move	$a0, $v0		#move word count to $a1 to be printed
		li	$v0, 1			#print integer
		syscall	
				
		la	$a0, nlChar		#load new line to be printed
		li	$v0, 4			#print new line
		syscall
		
		la	$a0, sTable		#load address of stable
		lw	$a1, strCount		#load word count
		addi	$a1, $a1, -1		#subtract one from size of the array
		sll 	$a1, $a1, 2		#multiply by 4
		add	$a1, $a1, $a0		#address of last array element
		jal	quicksort		#jump to quicksort
		
		la	$a0, sTable		#load address of sTable
		lw	$a1, strCount($0)	#load the count of strings in array
		
		jal	printTable		#pirnt new sorted table
		
		li	$v0, 10			#quit quicksort
		syscall
		
		########## OpenFile ##########
		
		
openFile:	addi	$sp, $sp, -16		#make stack with 4 spots	
		sw	$a0, 0($sp)		#save $a0 on stack
		sw	$a1, 4($sp)		#save $a1 on stack
		sw	$a2, 8($sp)		#save $a2 on stack
		sw	$a3, 12($sp)		#save $a3 on stack
		
		la	$a0, filePrompt		#asks for what file it will be opening
		li	$v0, 4
		syscall				#prints out- Enter File Name:  
		
		la	$a0, fileName		#loads file that user has given to open
		li	$a1, 80			#file is saved in $a1 in space of 80
		li	$v0, 8			
		syscall				#opens file given
		

		la	$t0, fileName		#temp $t0 is fileName
fixLoop:	lb	$t1, 0($t0)		#loads byte of first word from file
		subi	$t1, $t1, '\n'		#checks to see if there is a \n
		beq 	$t1, $0, fixNL		#if byte is zero go to fixNL
		addi	$t0, $t0, 1		#if not increment byte count by one
		j	fixLoop			#contiune to load the first word
		
fixNL:		sb  	$0, 0($t0)		#store byte into $0 

		la	$a0, fileName		#Set fileName to argument $a0
		move	$a1, $0			#move $0 into  $a1
		move	$a2, $0			#move $0 into  $a2
		li	$v0, 13			#open the file
		syscall
		
		
		blt	$v0, $0, badOpen	#check to see if file given is a valid one
		j	openRet			#if so close stack
		
badOpen:	la	$a0, fileError		#loads prompt- Error opening file
		li	$v0, 4					
		syscall				#print out Error opening file
		

openRet:		
		lw	$a0, 0($sp)		#retore  saved $a0 
		lw	$a1, 4($sp)		#retore  saved $a1
		lw	$a2, 8($sp)		#retore  saved $a2 
		lw	$a3, 12($sp)		#retore  saved $a3 
		addi	$sp, $sp, 16		#take off 4 spots from stack
		jr	$ra			#return

	        ########## readFile ##########

readFile:	li	$v0, 14			#read from the file
		syscall				
		jr	$ra			#return
		
	        ########## MakeTable ##########	

makeTable:	move	$t0, $a0		#address of table now $t0
		move	$t1, $a1		#address of buffer is now $t0
		move	$t2, $a2  		#$a2 moved into $t2
		move	$v0, $0			#$v0 is now zeroed out again
		
		sw 	$t1, ($t0)		#store the fisrt word into the table
sLoop:		beq	$t2, $0, sDone		#if no more words to store done
		lb	$t3, ($t1)		#load the first byte of the first word
		subi	$t3, $t3, '\n'		#check to see if new line
		beq	$t3, $0, gotNL		#if new line fix
		addi	$t1, $t1, 1		#if not new line go to next byte in word
		addi	$t2, $t2, -1		#subtract onr from $t2
		j	sLoop			#continue going through word
		
gotNL:		sb	$0, ($t1)		#store $t1 in $0
		addi	$t1, $t1, 1		#go to next spot in buffer
		addi	$t2, $t2, -1		#shorten the buffer by one spot
		addi	$t0, $t0, 4		#go to next word in table
		sw	$t1, ($t0)		#t1 is now the next word in table
		addi	$v0, $v0, 1		#increment word count
		j	sLoop			#continue with next word
		
sDone:		jr	$ra			#return to main

	
		########## PrintTable ##########
			
printTable:	addi	$sp, $sp, -4		#make stack
		sw	$a0, 0($sp)		#save address of sTable

		move	$t0, $a0		#move $a0 to tmp
		move	$t1, $a1		#move word count to tmp
ploop:		beq	$t1, $0, pExit		#if word count nothing else to print
		
		lw   	$a0, 0($t0)      	#load first word in sTable
		li	$v0, 4			#print first word
		syscall
		
		la	$a0, nlChar		#load new line
		li	$v0, 4			#print new line
		syscall
		
		addi	$t0, $t0, 4		#go to next word in table
		addi	$t1, $t1, -1		#subract open from table becasue one has been printed
		j	ploop			#continue untill all words are printed
		
pExit:		lw	$a0, 0($sp)		#restore saves $a0
		addi	$sp, $sp, 4		#pop stack back
		jr	$ra			#return to main
					
		########## quicksort ##########
	
quicksort:	addi	$sp, $sp, -32 		#make stack
		sw	$ra, 0($sp)		#save $ra on stack
		sw	$a0, 4($sp)		#save $a0 on stack  address of first array element
		sw	$a1, 8($sp)		#save $a1 on stack  address of last array element
		sw	$s0, 12($sp)		#save $s0 on stack  
		sw	$s1, 16($sp)		#save $s1 on stack  
		sw	$s2, 20($sp)		#save $s2 on stack  
		sw	$s3, 24($sp)		#save $s3 on stack  
		sw	$s4, 28($sp)		#save $s4 on stack  		
		
		move	$s0, $a0 		#$s0 - left pointer
		move	$s1, $a1		#$s1 - right pointer
		move	$s3, $a0		#$s3 - iElement
		move	$s4, $a1		#$s4 - jElement
		
		# get pivot string
		add	$t0, $a0, $a1		#add first and last elements
		srl	$t0, $t0, 3		#shifts 3 bits right 
		sll	$t0, $t0, 2		#then shifts 2 bits left to not be in the middle of an address
		lw	$s2, ($t0)		#pivot is now $s2
			
		
partLoop:	#begin partitioning 

		#for iElement
advi:		lw	$a0, ($s3)  		#load iElement in $a0
		move	$a1, $s2		#move pivot into $a1
		jal	strcmp			#compare the two strings
		slt   	$v0, $v0, $0		#if $v0 is less then 0 set $v0 to 1 else set to 0
		beq	$v0, $0, advj		#if $v0 is 0 then go to advance j element
		addi	$s3, $s3, 4		#iElemnt moves down
		j	advi			#repeat
		
		#for jElement
advj:		lw	$a0, ($s4)		#load jElement in $a0
		move	$a1, $s2		#move pivot into $a1
		jal	strcmp			##ompare the two strings
		slt	$v0, $0, $v0		#if $0 is less then $v0 set $v0 to 1 else set to 0
		beq	$v0, $0, testij		#if $v0 is zero jump to testij
		addi	$s4, $s4, -4		#jElement moves up
		j	advj			#repeat
		
testij:		slt	$v0, $s4, $s3		#if $s4 is less then $s3 set $v0 to 1 else set to 0
		bne	$v0, $0, loopTest 	#if $v0 not equal to 0 branch to looptest
						#if they are then swap the strings
		lw	$t0, ($s3)		#load iElement into $t0
		lw	$t1, ($s4)		#load jElement into $t1
		sw 	$t0, ($s4)		#now $s4 is $t0 which was the iElement
		sw	$t1, ($s3)		#now $s3 is $t1 which was the jElement
		
		addi	$s3, $s3, 4		#iElemnt moves down
		addi	$s4, $s4, -4		#jElement moves up
		
		
loopTest:	slt  	$v0, $s4, $s3		#check to see if they pass eachother in array
		beq 	$v0, $0, partLoop	#if iE less the jE continue with partLoop
		
		slt	$v0, $s0, $s4		#compare jElement with left pointer
		beq	$v0, $0, skipPart	#if same test iElement
		move	$a0, $s0		#set $a0 t0 left pointer or array
		move	$a1, $s4		#set $a1 to jElement
		jal	quicksort		#recurse over top half of array
		
skipPart:	slt	$v0, $s3, $s1		#compare iElement with right pointer
		beq	$v0, $0, qReturn	#return if the same
		move	$a0, $s3		#set $a0 t0 iElement
		move	$a1, $s1		#set $a1 to right pointer of array
		jal	quicksort		#recurse over bottom half of array
		
qReturn:	lw	$ra, 0($sp)		#retore saved $ra
		lw	$a0, 4($sp)		#retore saved $a0
		lw	$a1, 8($sp)  		#retore saved $a1
		lw	$s0, 12($sp)		#retore saved $s0
		lw	$s1, 16($sp)		#retore saved $s1
		lw	$s2, 20($sp)		#retore saved $s2
		lw	$s3, 24($sp)		#retore saved $s3
		lw	$s4, 28($sp)		#retore saved $s4
		addi	$sp, $sp, 32		#pop items off stack
		jr	$ra			#return to main


		########## string compare ########## 

strcmp:		move 	$t0, $a0       		# $a0 address of first string
		move	$t1, $a1		# $a1 address of second string

scLoop:		lb	$t2, ($t0)		#load fist byte of first word into $t2
		lb	$t3, ($t1)		#load fist byte of second word into $t3
		sub	$v0, $t2, $t3		#checks to see if they are the same byte
		addi	$t0, $t0, 1		#increment to next byte of string one
		addi	$t1, $t1, 1		#increment to next byte of string two
		bne	$v0, $0, scDiff		#if they are differnt return value in $v0 back to quciksort
		bne	$t2, $0, scLoop		#if the same contine checking the rest of the bits

scDiff:		jr	$ra			#return to quicksort
