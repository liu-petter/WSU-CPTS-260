.data

msg1: .asciiz "Enter a number\n"

msg2: .asciiz "The factorial is = "
nl: .asciiz "\n"



.text

.globl main

main: 	

# Take argument from the user. First print the message and then accept the argument
#print mesg
    li $v0, 4
    la $a0, msg1
    syscall
    
    li $v0, 5 # system call for reading an integer from user
    syscall
    
    add $a0, $v0, $zero # move argument
    jal fact #jumps to equation and saves the return in $ra
    
    
    add $s1, $v0, $zero # Move result to register S1
    
    
    #print mesg
    li $v0, 4
    la $a0, msg2
    syscall
    
    #print the integer
    
    li $v0, 1
    add $a0, $s1, $zero
    syscall
    
    #print the new line
    li $v0, 4
    la $a0, nl
    syscall

    #exit
    li $v0, 10
    syscall

fact:
    addi $sp, $sp, -8
    sw $ra, 4($sp) # save return address
    sw $a0, 0($sp) # save argument
    slti $t0, $a0, 1 # test for n < 1
    beq $t0, $zero, L1
	addi $v0, $zero, 1 # if so, result is 1
    addi $sp, $sp, 8 # pop 2 items from stack
    jr $ra # and return
L1: addi $a0, $a0, -1 # else decrement n
    jal fact # recursive call
    lw $a0, 0($sp) # restore original n
    lw $ra, 4($sp) #   and return address
    addi $sp, $sp, 8 # pop 2 items from stack
    mul $v0, $a0, $v0 # multiply to get result
    jr $ra # and return

