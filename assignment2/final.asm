.text
.globl main

main:
    la $a0, msg1    #Loads input message            
    li $v0, 4       #For displaying string
    syscall
    li $t3, 0    # counter which takes care of how many integers are available for computation
    j input

input:
    li $v0, 12    # read the character
    syscall
    beq $v0, 10, exit    # if the character is newline character, go to the exit function
    move $t0, $v0       # else store this in t0 for analysis
    beq $t0, 43, addition 	# ascii for '+'
	beq $t0, 45, subtract	# ascii for '-'
	beq $t0, 42, multiply	# ascii for '*'

	blt $t0, 48, error_msg	# throw exception for ascii value below '0'
	bgt	$t0, 57, error_msg 	# throw exception for ascii value above '9'

    addi $t3, $t3, 1            # increase the number of available numbers for computation by 1
	sub $t0, $t0, 48			# reduce to number
    sub $sp, $sp, 4             # push in the stack
    sw $t0, 4($sp)
    j input

addition:
    blt		$t3, 2, error_msg   # if the available numbers are less than 2, throw an error
    addi	$t3, $t3, -1        # decrease the available numbers by 1 as we perform operation on 2 numbers to generate 1 number
    addiu $sp,$sp,4             # pop 1st number
    lw $t1,($sp)
    addiu $sp,$sp,4             # pop 2nd number
    lw $t0,($sp)
    add $t0, $t0, $t1           # 2nd + 1st
    sub $sp, $sp, 4             # push back again
    sw $t0, 4($sp)              
    j input

subtract:
    blt		$t3, 2, error_msg   # if the available numbers are less than 2, throw an error
    addi	$t3, $t3, -1        # decrease the available numbers by 1 as we perform operation on 2 numbers to generate 1 number
    addiu $sp,$sp,4             # pop 1st number
    lw $t1,($sp)
    addiu $sp,$sp,4             # pop 2nd number
    lw $t0,($sp)
    sub $t0, $t0, $t1           # 2nd - 1st
    sub $sp, $sp, 4             # push back again
    sw $t0, 4($sp)
    j input

multiply:
    blt		$t3, 2, error_msg   # if the available numbers are less than 2, throw an error
    addi	$t3, $t3, -1        # decrease the available numbers by 1 as we perform operation on 2 numbers to generate 1 number
    addiu $sp,$sp,4             # pop 1st number
    lw $t1,($sp)
    addiu $sp,$sp,4             # pop 2nd number
    lw $t0,($sp)
    mul $t0, $t0, $t1           # 2nd - 1st
    sub $sp, $sp, 4             # push back again
    sw $t0, 4($sp)
    j input

exit:
    bne		$t3, 1, error_msg   # If we are not at a single number in the end, means that the input was invalid with incorrect number of operations
    addi	$t3, $t3, -1        # Just for fun!
    addiu $sp,$sp,4             # pop the number from stack to t0
    lw $t0,($sp)
    la $a0, msg                 #Loads input message            
    li $v0, 4                   #For displaying string
    syscall
    li $v0, 1                   # print the number
    move $a0, $t0       
    syscall
    la  $a0, lf                 # add a line-break
    li  $v0, 4
    syscall
    li $v0, 10                  # end program
    syscall

error_msg:
	la 	$a0, msg2               # show the user that input is invalid
	li 	$v0, 4                  # print the message
	syscall
    la  $a0, lf                 # add line break
    li  $v0, 4          
    syscall
	li 	$v0, 10		            # end program
	syscall


.data        
msg1: .asciiz "Enter the postfix expression: \n"
msg2: .asciiz "\nIncorrect Input\n"
msg: .asciiz "\nThe answer of the expression is: "
lf: .asciiz "\n"