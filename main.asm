 .data						#data declaration section
	prompt: 	.asciiz "Enter a string: "
	userInput: 	.space 9
	errorMessage: 	.asciiz "\nInvalid hexadecimal number"
	newLine:	.byte	10
	endOfLine:	.byte	0
	tempByte:	.byte	0
	
.text						#assembly language instructions
	main:
		#dsiplays the prompt saying the user to input data
		li $v0, 4 			#tells the system to be ready for printing string
		la $a0, prompt          	#loads address of prompt to $a0
		syscall				#prints the string
		
		#gets input from the user
		li $v0, 8
		la $a0, userInput
		li $a1, 9			#specifies the number of bytes to read
		syscall
		#calls the fucntion that prints a new line character
		jal printNewLine
		
		#displays the input from the user (userInput)
		#li $v0, 4
		#la $a0, userInput
		#syscall
	
		# ---------------------------------------------------------------------------------------------------------------------------------
		#reading character in a string
		la $t0, userInput
		#li $t1, 0          		 #$t1 is set to 0
		li $t3, 0			 #initializing sum to be 0
		loop:
			lb $t2, 0($t0)   	 #loads the first character in userInput 
			#Fix me 
			beq $t2, $zero, Exit  	 #if current character in $t2 == $zero i.e the char code of endline
			
			li $v0, 11
			sb $t2, tempByte	 #stores $t2 into temporary byte
			lb $a0, tempByte	 #loads the character in temporary byte to $a0
			syscall			 #prints the character
			
			move $a0, $t2
			jal checkChar		 #calls the charChar function
			beq $v0, $zero, Exit	 #calls Exit if the char is invalid
			
			jal printNewLine	 #prints a new line
			
			add $t0, $t0, 1          #incremets the address to get next character #increment offset 
			# add $t1, $t1, 1		 #increments the value of $t1
			j loop 			 #loops again
			
		
		Exit:	
			li $v0, 10
			syscall					 #informs system to end main
		
	#prints a new line character 
	printNewLine:
		li $v0, 11 			
		lb $a0, newLine
		syscall
		jr $ra	
	#checks validity of the characters	
	checkChar:
		#sub $a0, $a0, 48		 #subtracting 48 from $a0 and storing the result in $a0
		bgt $a0, 102, invalid		
		bgt $a0, 96, valid
		bgt $a0, 70, invalid
		bgt $a0, 64, valid
		bgt $a0, 57, invalid
		bgt $a0, 47, valid
		blt $a0, 48, invalid
	#returns 0 if the character is invalid
	invalid:
		li $v0, 0
		jr $ra
	#returns 1 if the character is valid
	valid:
		li $v0, 1
		jr $ra
		
		
		
