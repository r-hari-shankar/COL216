.text
.globl main

main:
	la $a0, msg1	#Loads input message			
	li $v0, 4		#For displaying string
	syscall

	la 	$t0, freelist
	lw	$t0, ($t0)				# Loads array into $t0
	lw 	$t2, character
	jal arr_initialization		#initialize array for stack operation

	
	la $a0, array_size	
	li $v0, 8		#read the postfix expression (string)		
	syscall
	jal evaluate

	move $a0, $v0
	li 	$v0, 1		#print the expected answer
	syscall
	jal system_exit	#close the program

evaluate:
	addi $sp, -4 			#save return address
	sw 	$ra,($sp)
	move $t7, $a0

parser:
	lb	$t0, ($t7)
	beq $t0, 10, exit 	# ascii for new line
	
	beq $t0, 43, addition 	# ascii for '+'
	beq $t0, 45, subtract	# ascii for '-'
	beq $t0, 42, multiply	# ascii for '*'
	beq $t0, 47, divide		# ascii for '/'

	blt $t0, 48, error_msg	# throw exception for ascii value below '0'
	bgt	$t0, 57, error_msg 	# throw exception for ascii value above '9'

	sub $t0, $t0, 48			# reduce to number
	
	la	$a0, head
	sw	$t0, ($a0)
	jal stack_push

	addi $t7, $t7, 1 	
	j parser

# Initialize array and allocate memory	
arr_initialization:
	beq $t1, $t2, return	# $t1 = i
	addi $t3, $t0, 8			# 8 bytes for character and pointing to the next element
	sw $t3, 4($t0)
	addi $t0, $t0, 8
	addi $t1, $t1, 1
	j arr_initialization
	
	
malloc:
	la $t0, freelist
	bne	$t0, $0, next
	sub $v0, $0, 1	# throw exception in postfix (part 4)
	j return
	
next:
	lw $v0, ($t0)			# $a1 = $t0's first element
	lw $t1, 4($v0)			# $t1 = next element from $a1
	sw $t1, ($t0)			# Update current pointer as next pointer
	sw $0, 4($v0)			# Clear old pointer
	
return:
	jr	$ra

# Stack Data Structure

stack_push:	
	sub $sp, 8
	sw 	$ra, ($sp) 		# variables to stack
	sw 	$a0, 4($sp)
	jal malloc
	
	move $t0, $v0 		# pointer to t0
	lw 	$ra, ($sp) 		# variables from stack
	lw 	$a0, 4($sp)

	lw 	$t1, ($a0)		 # int from pointer
	sw 	$t1, ($t0) 		 # store int
	la 	$t1, Top

	lw 	$t2, ($t1)		 # t2 is pointer 
	sw 	$t2, 4($t0) 
	sw 	$t0, ($t1)		 # Top to a new block

	addi $sp, 8			 # pointer to origin
	jr 	$ra

# Stack Data Structure 


	
stack_pop:
	addi $sp, -4		 # save return address
	sw 	$ra, ($sp)
	
	la 	$t0, Top 
	lw 	$t1, ($t0) 
	beqz $t1, stack_ex	 # check for null character
	
	lw	$t3, ($t1) 
	la	$v0, head
	sw 	$t3, ($v0) 		 # save data value
	
	lw 	$t2, 4($t1) 	 # save value
	sw 	$t2, ($t0)		 # next pointer
	
	move $a0, $t1
	jal clean_memory
	
	la	$v0, head		 # Pass items in stack
	lw 	$ra, ($sp)
	addi $sp, 4
	jr 	$ra

clean_memory:
	move $t0, $a0
	bnez $t0, dealloc_next
	li $t0, -1
	
	j dealloc_return
	
dealloc_next:
	la 	$t1, freelist
	lw $t2, ($t1)	# p->next = FL
	sw $t2, 4($t0)	
	sw $0, ($t0)	
	sw $t0, ($t1)	# FL = p
	
dealloc_return:
	jr $ra

stack_exit:				# Return to operand routine
	la $t0, Top
	lw $t1, ($t0)
	slt $v0, $0, $t1
	jr $ra

stack_ex:				 # stack exception
	la $a0, msg2
	li $v0, 4
	syscall

	lw $ra, ($sp)
	addi $sp, 4
	li $v0, 10
	syscall
	jr 	$ra




addition:
	jal stack_pop
	addi $sp, -4
	lw 	$t4 ,($v0)	#save return value
	sw	$t4, ($sp)
	
	jal stack_pop
	lw	$t4, ($sp)
	addi $sp, 4
	lw 	$t3 ,($v0)	# get last 2 digits from stack
	
	add $t3, $t3, $t4 
	la 	$a0, head
	sw	$t3, ($a0)	
	jal stack_push	# put sum back on stack
	
	addi $t7, $t7, 1
	j parser		# jump back for next character

subtract:
	jal stack_pop
	lw 	$t4 ,($v0)
	addi $sp, -4
	sw	$t4, ($sp)
	
	jal stack_pop
	lw	$t4, ($sp)
	addi $sp, 4
	lw 	$t3 ,($v0)	# get last 2 digits from stack
	
	
	sub $t3, $t3, $t4 # subtract operation t3-t4 order matters!
	la	$a0, head
	sw	$t3, ($a0)
	jal	stack_push	# put difference back on stack
	
	addi $t7, $t7, 1
	j parser			# jump back for next character
	
multiply:
	jal stack_pop
	lw 	$t4 ,($v0)
	addi $sp, -4
	sw	$t4, ($sp)	# get last 2 digits from stack
	
	jal stack_pop
	lw	$t4, ($sp)
	addi $sp, 4
	lw $t3 ,($v0) 	# get last 2 digits from stack
	
	mult $t3, $t4
	mflo $t3
	la	$a0, head	
	sw	$t3, ($a0)
	jal	stack_push	# put product back on stack
	
	addi $t7, $t7, 1
	j parser			# jump back for next character

divide:
	jal stack_pop
	lw 	$t4 ,($v0)
	addi $sp, -4
	sw	$t4, ($sp)
	
	jal stack_pop
	lw	$t4, ($sp)
	addi $sp, 4
	lw $t3 ,($v0)	# get last 2 digits from stack
	
	div $t3, $t4
	mflo $t3
	la 	$a0, head
	sw	$t3, ($a0)
	jal	stack_push	# put quotient back on stack
	
	addi $t7, $t7, 1
	j parser			# jump back for next character

error_msg:
	la 	$a0, msg2
	li 	$v0, 4
	syscall

	lw 	$ra, ($sp)
	addi $sp, 4
	li 	$v0, 10		
	syscall

exit:
	jal stack_pop	
	lw 	$v0, ($v0)	# final result is put into $v0
	addi $sp, -4
	sw 	$v0, ($sp)
	jal	stack_exit
	li	$t6, 1
	beq	$t6, $v0, msg2

	lw	$v0, ($sp)	
	lw 	$ra, 4($sp)
	addi $sp, 8
	jr 	$ra

system_exit:
	li	$v0, 10
	syscall

.data        
zero: .double 0.0
double: .double 0.5
array: .space 256
freelist: .word array
array_size: .space 256
character: .word 32
Top: .word 0 	#Top of stack
head: .word 0 
msg1: .asciiz "Enter the postfix expression: \n"
msg2: .asciiz "Incorrect Input\n"
msg: .asciiz "The answer of the expression is: \n"
lf: .asciiz "\n"