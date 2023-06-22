.text
.globl main

# registers where my values are stored will be as:
# f2 => area
# f4 => x1 coordinate, after this it contains x2-x1 (since it will be overrided again anyways)
# f6 => y1 coordinate
# f8 => x2 coordinate
# f10 => y2 coordinate
# t0 => storing my total number of points
# t1 => counter for my loop
# f12 => absolute value of y1
# f14 => x2 - x1
# f16 => the constant 0.5
# f18 => absolute value of y2
# f20 => used to store abs(y2)+abs(y1)
# t2 => contains the flag that abs(y1) = y1
# t3 => contains the flag that abs(y2) = y2
# t7 => 1
# f22 => zero


main:
        l.d		$f16,double 		# storing 0.5 in a float register
        # first taking n as input
        li		$v0,5		        # Setting up for integer input
        syscall
        l.d     $f22,zero

        li      $t2, 0              #initially set y1 != abs(y1)
        li		$t3, 0 		        #initially set y2 != abs(y2)
        
        move 	$t0, $v0		    # Storing n in t0

        li		$t1,0 		        # Initializing my counter to 0
        l.d		$f2,zero	        # Setting the intial value of area to 0

        # getting ready to take x1, y1 as input
        # This part of code is necessary to start my loop
        beq		$t0, $t1, exit	    # if $t0 == $t1 then target
        addi	$t1, $t1, 1			# increment my counter
        li		$v0,7 		        # setting up to take x1 as input
        syscall
        mov.d	$f4, $f0		    # store the x1-coord
        li		$v0,7 		        # setting up to take y1 as input
        syscall
        mov.d 	$f6, $f0	 	    # store the y1-coord
    

loop:     

        beq		$t0, $t1, exit	    # checking when to end the loop
        addi	$t1, $t1, 1			# increment my counter
        li		$v0,7 		        # setting up to take x2 as input
        syscall
        mov.d 	$f8, $f0		    # store the x2-coord
        li		$v0,7 		        # setting up to take y2 as input
        syscall
        mov.d 	$f10, $f0		    # store the y2-coord
        sub.d	$f4, $f8, $f4		# $s1 = $t1 - $t2
        abs.d   $f12, $f6           # store absolute value of y1
        abs.d   $f18, $f10          # store absolute value of y2
        c.lt.d  0,$f6, $f22         # compare y1 and abs(y1) to check whether y1 is positive or negative
        li	   $t7,1 		        # set the flag to true
        movt   $t2, $t7, 0          # move 1 into t2 if comparison was true
        c.le.d  0,$f22, $f6         # this is the else block for y1
        li	   $t7,0	            # set flag to false
        movt   $t2, $t7, 0          # move 0 if else condition is true
        c.lt.d  0,$f10,$f22         # comparing y2 and abs(y2)
        li	   $t7,1 	            # set the flag to true
        movt   $t3, $t7, 0          # move 1 into t3 if comparison was true
        c.le.d 0, $f22, $f10        # else condition
        li	   $t7,0 	            # set flag to 0
        movt   $t3, $t7, 0          # move 0 if else condition is true
        xor    $t4, $t2, $t3        # If both are positive or negative, store 0 in t4
        li	   $t7,1 	            # setting the flag back to true
        beq		$t4, $t7, area1	    # if $t4 == $t7, $t7 stores 1 then we compute area1 where both y are on opposite side
        j		area2				# ease jump to area2 where both y's are on same side

        
area1:
        add.d  $f20, $f12, $f18     # $f20 = |y1| + |y2|
        mul.d  $f12, $f12, $f12     # $f12 = y1^2
        mul.d  $f18, $f18, $f18     # $f18 = y2^2
        add.d  $f12, $f12, $f18     # $f12 = y1^2 + y2^2
        mul.d  $f12, $f12, $f4      # (y1^2 + y2^2) * (x2 - x1)
        mul.d  $f12, $f12, $f16     # 0.5 * (y1^2 + y2^2) * (x2 - x1)
        div.d  $f12, $f12, $f20     # 0.5 * (y1^2 + y2^2) * (x2 - x1) / (|y1| + |y2|)
        add.d  $f2, $f2, $f12       # Total area += ...
        mov.d  $f4, $f8             # moving current x2 to next x1
        mov.d  $f6, $f10            # moving current y2 to next y1
        j       loop                # jump back to loop

area2:
        add.d  $f12, $f12, $f18     # |y1 + y2|
        mul.d  $f12, $f12, $f4      # |y1 + y2| * (x2 - x1)
        mul.d  $f12, $f12, $f16     # 0.5 * |y1 + y2| * (x2 - x1)
        add.d  $f2, $f2, $f12       # Total area += ...
        mov.d  $f4, $f8             # Move current x2 coordinate to the x1 for the next area
        mov.d  $f6, $f10            # Move current y2 coordinate to the y1 for the next area
        j		loop				# jump to loop
        
        
exit:
        li		$v0,4 		    # Getting ready to print out the area
        la		$a0, msg		# setting the pointer to msg
        syscall                 # print
        li		$v0,3 		    # getting ready to print a double 
        mov.d 	$f12, $f2		# move the double to f12 because f12 is the one printed out
        syscall                 # print
        li		$v0,4 		    # adding a newline
        la		$a0, lf		    # seting the pointer to EOL
        syscall                 # print
        li		$v0,10 		    # getting ready to close out my program
        syscall                 # end the program

.data        
zero: .double 0.0
double: .double 0.5
msg1: .asciiz "\nEnter the x-coordinate: "
msg2: .asciiz "\nEnter the y-coordinate: "
msg: .asciiz "\nThe area computed is: "
lf: .asciiz "\n"