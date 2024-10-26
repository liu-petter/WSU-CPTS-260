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
    move $a0, $v0

    # jump to fib function
    jal fib 
    move $t0, $v0        # store result of fib in $t0

    # print out msg2
    li $v0, 4
    la $a0, msg2
    syscall

    # print the integer
    li $v0, 1
    move $a0, $t0
    syscall
    
    # print the newline
    li $v0, 4
    la $a0, newline
    syscall

    # exit
    li $v0, 10
    syscall

fib: 
    slti $t0, $a0, 2          # base case, if n < 2, $t0 = 1, else $t0 = 0
    bne $t0, $zero, base_case # if n < 2, go to base case

    addi $sp, $sp, -16        # allocate space on stack 
    sw $ra, 4($sp)            # save return address
    sw $a0, 0($sp)            # save n

    # recursive case
    addi $a0, $a0, -1         # n = n - 1
    jal fib                   # call fib(n - 1)
    sw $v0, 8($sp)            # save fib(n - 1)

    lw $a0, 0($sp)            # restore original n
    addi $a0, $a0, -2         # n = n - 2
    jal fib                   # call fib(n - 2)
    sw $v0, 12($sp)           # save fib(n - 2)

    lw $ra, 4($sp)            # load return address
    lw $t0, 8($sp)            # load fib(n - 1)
    lw $t1, 12($sp)           # load fib(n - 2)
    addi $sp, $sp, 16         # restore stack
    add $v0, $t0, $t1         # add fib(n - 1) + fib(n - 2)
    jr $ra

base_case:
    move $v0, $a0             # return n if n < 2 (base case result)
    jr $ra