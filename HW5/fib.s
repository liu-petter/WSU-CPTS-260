.data
    msg1: .asciiz "Enter a number: "
    msg2: .asciiz "Fib: "
    newline: .asciiz "\n"

.text

.globl main

main:
    # print out msg1
    li $v0, 4
    la $a0, msg1
    syscall

    # reads input     
    li $v0, 5
    syscall

    # store input
    add $a0, $v0, $zero

    # jump to fib function
    jal fib 

    # print out msg2
    li $v0, 4
    la $a0, msg2
    syscall

    #print the integer
    li $v0, 1
    add $a0, $a0, $zero
    syscall
    
    #print the new line
    li $v0, 4
    la $a0, newline
    syscall

    #exit
    li $v0, 10
    syscall

fib: 
    addi    $sp, $sp, -8    # Allocate space on stack 
    sw      $ra, 4($sp)     # Save return address
    sw      $a0, 0($sp)     # Save the value of n
    
    
