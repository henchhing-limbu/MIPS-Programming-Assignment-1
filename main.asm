.data
	prompt: .asciiz "Enter a string: "
	userInput: .space 9
.text
	main:
		#dsiplays the prompt saying the user to input data
		li $v0, 4 		#tells the system to be ready for printing string
		la $a0, prompt          #loads address of prompt to $a0
		syscall			#prints the string
		
		#gets input from the user
		li $v0, 8
		la $a0, userInput
		li $a1, 9		#specifies the number of bytes to read
		syscall

		#displays the input from the suer (userInput)
		li $v0, 4
		la $a0, userInput
		syscall
		
	#informs system to end main
	li $v0, 10
	syscall
	
	
