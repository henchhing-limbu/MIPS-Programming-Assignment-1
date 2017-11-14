.data						#data declaration section
	prompt: 	.asciiz "Enter a string: "
	userInput: 	.space 9
	errorMessage: 	.asciiz "\nInvalid hexadecimal number"
	newLine:	.byte	10
	
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
		li $v0, 4
		la $a0, userInput
		syscall
		
		#reading character in a string
		la $t0, userInput
		li $t1, 0          		 #$t1 is set to 0
		loop:
			lb $t2, 0($t0)   	 #loads the first character in userInput 
			#Fix me 
			add $t0, $t0, 1          #incremets the address to get next character
			beq $t1, 8, end		 #if $t1 is equal to 8 then go to end 
			add $t1, $t1, 1		 #increments the value of $t1
			j loop 			 #loops again
		exit:
			li $v0, 4
			la $a0, errorMessage
			syscall 		 #prints the error message
			li $v0, 10
			syscall
		end:				 #this is where we start converting hexadecimal to decimal	
	li $v0, 10
	syscall					 #informs system to end main
	
	#prints a new line character 
	printNewLine:
		li $v0, 11 			
		lb $a0, newLine
		syscall
		jr $ra	
