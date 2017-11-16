 .data							 #data declaration section
	userInput: 	.space 9
	errorMessage: 	.asciiz "Invalid hexadecimal number"
	
.text							 #assembly language instructions
	main:
		#gets input from the user
		li $v0, 8				 #system call for getting input from the user
		la $a0, userInput			 #loads the address of userInput into $a0
		li $a1, 9				 #specifies the number of bytes to read
		syscall
		
		#reading character in a string
		la $s1, userInput			 
		li $t3, 0				 #initializing sum to be 0
		lb $t2, 0($s1)			 	 #loads the first character in userInput to $t2
		beq $t2, 10, invalidMessage		 #if the first character is newLine, then go to invalidMessage
		
		#checks for spaces at the front and end of string and removes it
		li $t6, 0				 #initializing $t7 to be 0
		loopTempEnd:
			add $t0, $s1, $t6
			lb $t2, 0($t0)   	 	 #loads the first character in userInput to $t2
			beq $t2, $zero, continue
			li $s2, 10
			beq $t2, $s2, continue
			addi $t6, $t6, 1
			j loopTempEnd		 	
		#tempEnd is in $t6
		
		continue:
		
		li $s2, 0 
		loopStartIndex:
			add $t0, $s1, $s2
			lb $t2, 0($t0)
			bne $t2, ' ', loopEndIndex
			addi $s2, $s2, 1
			j loopStartIndex
  
  		#startIndex is in $s2
  		
  		loopEndIndex:
  			add $t0, $s1, $t6
			lb $t2, 0($t0)
			bne $t2, ' ', continue1 
			addi $t6, $t6, -1
			j loopEndIndex
		#endIndex is in $t6			 
		
		continue1:
					
			
		#addi $t8, $zero, 0			 #initializing $t8 to be 0
		loop:
			add $t0, $s1, $s2
			lb $t2, 0($t0)   	 	 #loads the first character in userInput to $t2
 
			#beq $t2, $zero, output 	 	 #if current character in $t2 == $zero i.e the char code of endline
			#beq $t2, 10, output		 #if $t2 == newline character then go to signedToUnsigned

			jal checkChar		 	 #calls the checkChar function
			beq $v1, $zero, invalidMessage	 #calls Exit if the char is invalid
			
			jal conversion		 	 #calls conversion function to convert hex to dec
			
			sll $t3, $t3, 4		 	 #shifts $t3 left by 4 bits
			add $t3, $t3, $t2	 	 #adds $t5 to $t3 and stores the result in $t3
			addi $s2, $s2, 1		 #incrementing $t1 by 1
			beq $s2, $t6, output
			#add $t0, $t0, 1          	 #incremets the address to get next character #increment offset 
			j loop 			 	 #loops again
			
		Exit:	
			li $v0, 10			 
			syscall				 #informs system to end program
		
		#loop1:
			#sll $t0, $t0, 1
			#jr $ra
			
		#prints an error message
		invalidMessage:
			li $v0, 4			 #system call code for printing string
			la $a0, errorMessage 		 #loads address of errorMessage to $a0
			syscall				 #syscall to print
			j Exit				 #jumps to Exit
		
					
		#outputs the unsigned or signed decimal value to the screen
		output:
			blt $t3, $zero, signedToUnsigned #branch to signedToUnsigned if $t3 < $zero
			li $v0, 1			 #syscall for printing integer
			addi $a0, $t3, 0		 #adds contents of $t3 and 0 and stores in $a0
			syscall
			j Exit				 #jumps to Exit
			
			signedToUnsigned:
				li $t1, 10			 #initiates $t1 = 10
				divu $t3, $t1			 #divides $t4 by $t1
				mflo $t2			 #contents of $LO are moved to $t2
				move $a0, $t2 			 #moves contents of $a0 to $t2
				li $v0, 1			 #system call code for printing integer
				syscall

				mfhi $t2			 #contents of $HI are moved to $t2
				move $a0, $t2 			 #moves contents of $t2 to $a0
				li $v0, 1			 #system call code for priting integer
				syscall
				j Exit
		
	#checks validity of the characters	
	checkChar:
		bgt $t2, 102, invalid		 	 #jumps to invalid if value at $t5 > 102
		bgt $t2, 96, valid		 	 #jumps to valid if value at $t5 > 96
		bgt $t2, 70, invalid		 	 #jumps to invalid if value at $t5 > 70
		bgt $t2, 64, valid		 	 #jumps to valid if value at $t5 > 57
		bgt $t2, 57, invalid		 	 #jumps to invalid if value at $t5 > 57
		bgt $t2, 47, valid		 	 #jumps to valid if value at $t5 > 47
		j invalid			 	 #jumps to invalid
		
		invalid:
			li $v1, 0			 #initiates $v1 to be 0
			jr $ra
			
		valid:
			li $v1, 1			 #inititates $v1 to be 1
			jr $ra
			
	#converts hexadecimal number to its decimal value
	conversion: 
		#addi $t6, $t6, 1			 
		blt $t2, 58, conv1		 	 #branches to conv1 if value at $t5 < 58
		blt $t2, 71, conv2		 	 #branches to conv2 if value at $t5 < 71
		blt $t2, 103, conv3		 	 #branches to conv3 if value at $t5 < 103
		
		#converts hexadecimal values from 0-9 into decimal
		conv1:
			addi $t2, $t2, -48	 	 #adds -48 to  $t5 and stores it in $t5
			jr $ra	 			 #jumps to statements whose address is $ra
		
		#converts hexadecimal values from A-F into decimal values	
		conv2:
			addi $t2, $t2, -55	 	 #addis -55 to $t5 and stores it in $t5
			jr $ra
			
		#converts hexadecimal values from a-f into decimal values
		conv3:
			addi $t2, $t2, -87	 	 #adds -87 to $t5 and stores it in $t5
			jr $ra
