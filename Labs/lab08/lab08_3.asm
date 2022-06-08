.section .text

readN:
    .rodata
.digiteN:
    .word 0x69676944
    .word 0x4e206574
    .word 0x203a

    .text
    addi t0, zero, 3
    lui a0, %hi(.digiteN)
    addi a0, a0, %lo(.digiteN)
    addi a1, zero, 10
    ecall
    
    addi t0, zero, 4
    ecall

    ret

fact: #calculates (a1)!
    #initialize cur
    addi a3, zero, 1

    beq a1, a3, .end

    addi sp, sp, -4
    sw a1, sp, 0
    addi sp, sp, -4
    sw ra, sp, 0
    
    addi a1, a1, -1 # n - 1
    
    call fact
    
    lw a1, sp, 4 # load processing n
    addi a2, zero, 0 
    addi a4, zero, 0 # count

.L1: # mult a1 * a3, a3 is the return of fact(n - 1)
    beq a4, a1, .L2
    addi a4, a4, 1

    add a2, a2, a3

    j .L1

.L2: # end of mult a1 * a3 (stored in a2)
    lw ra, sp, 0 
    addi sp, sp, 8 # remove processing n and ra from stack
    addi a3, a2, 0 # ret = mult val
    ret

.end:
    addi a3, zero, 1 # return 1
    ret


main:
    addi sp, sp, -4
    sw ra, sp, 0
    call readN

    addi a1, a0, 0 # save N in a1

    call fact

    addi t0, zero, 1
    addi a0, a2, 0
    ecall

    lw ra, sp, 0
    addi sp, sp, 4
    ret