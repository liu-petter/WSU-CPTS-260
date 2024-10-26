.data
    array: .space 40                     # reserve space for 10 integers
    prompt_array: .asciiz "Enter 10 sorted integers in ascending order:\n"
    prompt_search: .asciiz "Enter a number to search for: "
    found_msg: .asciiz "Element found at index: "
    not_found_msg: .asciiz "Element not found.\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    # print prompt for 10 numbers
    li $v0, 4
    la $a0, prompt_array
    syscall

    la $t0, array                      # load base address of array into $t0
    li $t1, 10                         # load size into $t1

input_loop:
    # read numbers
    li $v0, 5
    syscall
    sw $v0, 0($t0)                     # store the integer in array
    addi $t0, $t0, 4                   # move to the next position in array
    addi $t1, $t1, -1                  # decrement the counter
    bgtz $t1, input_loop               # repeat until 10 numbers are entered

    # ask user for number to search for
    li $v0, 4
    la $a0, prompt_search
    syscall

    # store input
    li $v0, 5
    syscall
    move $a0, $v0                      # move input into $a0

    # set up arguments for binary search
    la $a1, array                      # array base address
    li $a2, 10                         # array size
    jal binary_search

    # check result
    bgez $v0, print_found              # if $v0 >= 0, element was found

print_not_found:
    li $v0, 4
    la $a0, not_found_msg
    syscall
    j exit

print_found:
    li $v0, 4
    la $a0, found_msg
    syscall

    # print index
    li $v0, 1
    move $a0, $v0
    syscall

exit:
    li $v0, 10
    syscall


# $a0, target value to search for
# $a1, base address of the array
# $a2, size of the array
# $v0, index of the target in the array or -1 if not found
binary_search:
    li $t2, 0                          # $t2 = left index
    sub $t3, $a2, 1                    # $t3 = right index (size - 1)

binary_search_loop:
    # check left > right
    bgt $t2, $t3, not_found

    # calculate mid index
    # mid = (left + right) / 2
    add $t4, $t2, $t3
    sra $t4, $t4, 1                    # shift right 2 to divide

    # load mid element
    sll $t5, $t4, 2
    add $t5, $a1, $t5
    lw $t6, 0($t5)

    # compare mid element with target
    beq $t6, $a0, found                # if mid == target, found
    blt $t6, $a0, go_right             # if mid < target, go right
    j go_left                          # if mid > target, go left

go_right:
    addi $t2, $t4, 1                   # left = mid + 1
    j binary_search_loop               # repeat loop

go_left:
    addi $t3, $t4, -1                  # right = mid - 1
    j binary_search_loop               # repeat loop

found:
    move $v0, $t4                      # return the index
    jr $ra

not_found:
    li $v0, -1
    jr $ra
