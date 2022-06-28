.section .text

abs: # return the abs value of a3 in a3
    addi t5, zero, 1
    slli t5, t5, 31
    and t5, t5, a3 # signal of a3

    beq t5, zero, .returnAbs

    xori a3, a3, 0xffffffff # else turn to positive
    addi a3, a3, 1

.returnAbs:
    ret

mult: # returns in a0 the value of a0 times a1 (at the end a1 = 1 if we had overflow, else a1 = 0)
    addi s2, zero, 0 # initialize the return value

    addi s3, zero, 0 # s3 is the counter
    addi s4, zero, 32 # s4 is the limit
    addi s5, zero, 1 # s5 is the auxiliar variable to check if the s3-th bit is 0 or 1
    addi s8, zero, 30 # the msb of a1

    addi t5, zero, 1
    slli t5, t5, 31
    addi t6, zero, 1
    slli t6, t6, 31

    and t5, t5, a0 # signal of a0
    and t6, t6, a1 # signal of a1
    xor s11, t5, t6 # signal of a0 * a1
    
    addi sp, sp, -4
    sw ra, sp, 0

    add a3, a0, zero
    call abs
    add a0, a3, zero

    add a3, a1, zero
    call abs
    add a1, a3, zero

    lw ra, sp, 0
    addi sp, sp, 4

.loopMult:
    bge s3, s4, .endMult

    and s6, s5, a0 # s6 is the s3-th bit
    slli s5, s5, 1

.ifMultBit:
    beq s6, zero, .skipIfMultBit # if the s3-th bit is 0, we do nothing
    

    sll s7, a1, s3 # what ill sum in this iterarion
    add s2, s2, s7 # sum the result of the shift

    andi s9, s2, 0x10000000
    bne s9, zero, .multOverflow

.skipIfMultBit:
    addi s3, s3, 1 # add counter
    j .loopMult
    
.endMult:
    add a0, zero, s2 # place the return value in a0
    add a1, zero, zero

    beq s11, zero, .positiveMult

.negativeMult:
    xori a0, a0, 0xffffffff
    addi a0, a0, 1

.positiveMult:
    ret

.multOverflow:
    add a0, zero, zero
    addi a1, zero, 1
    ret

printInt: # prints the value of a1
    addi s3, a1, 0 # save the original value of a1
    addi s2, zero, 1
    slli s2, s2, 31
    and s2, s2, a1

    beq s2, zero, .positive

.negative:
    addi t0, zero, 2
    addi a0, zero, 45
    ecall #print -

    # invert all and sum 1
    xori a1, a1, 0xffffffff
    addi a0, a1, 1

.positive:
    addi t0, zero, 1
    ecall
    addi a1, s3, 0
    
    ret

main:
    addi sp, sp, -4
    sw ra, sp, 0

    addi t0, zero, 4
    ecall
    add a1, zero, a0
    ecall

    call mult
    add a1, zero, a0
    call printInt

    lw ra, sp, 0
    addi sp, sp, 4
    ret
