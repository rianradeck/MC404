.section .text

printMenu:
    .rodata
.menu:
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x6f72500a
    .word 0x6f74656a
    .word 0x34434d20
    .word 0x2d203430
    .word 0x20415220
    .word 0x38383631
    .word 0x65203833
    .word 0x20415220
    .word 0x37373831
    .word 0x0a0a3339
    .word 0x6f637345
    .word 0x2061686c
    .word 0x20616d75
    .word 0x7265706f
    .word 0x6f616361
    .word 0x20310a3a
    .word 0x6f53202d
    .word 0x320a616d
    .word 0x53202d20
    .word 0x72746275
    .word 0x6f616361
    .word 0x2d20330a
    .word 0x6c754d20
    .word 0x6c706974
    .word 0x63616369
    .word 0x340a6f61
    .word 0x44202d20
    .word 0x73697669
    .word 0x350a6f61
    .word 0x45202d20
    .word 0x6e6f7078
    .word 0x61696365
    .word 0x0a6f6163
    .word 0x202d2036
    .word 0x206e6942
    .word 0x48203e2d
    .word 0x370a7865
    .word 0x48202d20
    .word 0x2d207865
    .word 0x6942203e
    .word 0x20380a6e
    .word 0x6544202d
    .word 0x3e2d2063
    .word 0x78654820
    .word 0x2d20390a
    .word 0x78654820
    .word 0x203e2d20
    .word 0x0a636544
    .word 0x2d203031
    .word 0x6e694220
    .word 0x203e2d20
    .word 0x0a636544
    .word 0x2d203131
    .word 0x63654420
    .word 0x203e2d20
    .word 0x0a6e6942
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x0a

    .text
    addi t0, zero, 3
    lui a0, %hi(.menu)
    addi a0, a0, %lo(.menu)
    addi a1, zero, 289
    ecall

    ret

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

fastExponentiation: # returns a0 ^ a1 (in the end a0 = a0 ^ a1)
    add t0, zero, a0 # t0 is initialy a0
    add t1, zero, a1 # t1 is initialy a1
    addi t2, zero, 1 # t2 will contain our answer in the end (initilay its 1)

.ExpLoop:
    # checking weather t1 is even or odd, and jumping to the respective label
    addi t3, zero, 1 
    andi t4, t1, 1
    beq t4, t3, .oddA1
    bne t4, t3, .evenA1 

.evenA1:
    # When t1 is even, we can see that t0 ^ t1 is equal to (t0 ^ 2) ^ (t1 divided by 2)
    addi sp, sp, -4
    sw ra, sp, 0

    add a0, zero, t0
    add a1, zero, t0

    # calling mult function to multiply t0 by t0 (t0 ^ 2)
    call mult

    add t0, zero, a0 # t0 = t0 ^ 2
    srli t1, t1, 1 # t1 = t1 divided by 2 (to do that we can just shift t1 one bit to the right)

    lw ra, sp, 0
    addi sp, sp, 4

    j .loopContinue


.oddA1:
    # When t1 is odd, we can multiply the register that respresents our answer by t0 (since a0 ^ a1 = t2 * (t0 ^ t1)) and subtract 1 from t1
    addi sp, sp, -4
    sw ra, sp, 0

    add a0, zero, t0
    add a1, zero, t2

    # calling function mult to multiply t2 (answer) by t0
    call mult

    add t2, zero, a0 # t2 = t2 * t0
    addi t1, t1, -1 # subtracting 1 from t1

    lw ra, sp, 0
    addi sp, sp, 4

.loopContinue:
    blt zero, t1, .ExpLoop

.endExponentiation:
    add a0, zero, t2 # a0 receives the value of t2 (answer)
    jr ra

division: # return a0 divided by a1 (at the end the value of a0 is the quocient and a1 the remainder)
    addi s2, zero, 0 # set s2 to zero
    add s7, zero, zero # set s7 to zero (s7 represents how many values between a0 and a1 are negative values)

.checkNegative:
    # in this label we deal with the cases where the values are negative (doing that we dont have to deal with negative numbers in the future)
    bge a0, zero, .endNegA0 # if a0 bigger than or equals to 0 we dont have to turn a0 into -a0

    .negativeA0:
        # if a0 is a negative value we set a0 = -a0
        add s3, zero, a0
        sub a0, a0, s3
        sub a0, a0, s3
        addi s7, s7, 1 # adding up 1 in the counter of how many values between a0 and a1 are negative values
    .endNegA0:

    bge a1, zero, .endNegA1 # if a1 bigger than or equal 0 we dont have to turn a1 into -a1

    .negativeA1:
        # if a1 is a negative value we set a1 = -a1
        add s3, zero, a1
        sub a1, a1, s3
        sub a1, a1, s3
        addi s7, s7, 1 # adding up 1 in the counter of how many values between a0 and a1 are negative values
    .endNegA1:

    j .getMaxSBa0

.getMaxSB:
    # this function returns in s6 which is the most significant bit of s3
    beq s3, zero, .endMaxSB
    srli s3, s3, 1 # shifting s3 1 bit to the right
    addi s6, s6, 1 # adding up 1 to s6
    j .getMaxSB
.endMaxSB:
    jr ra

.getMaxSBa0:
    # here we store in s4 the most significant bit of a0
    addi sp, sp, -4
    sw ra, sp, 0

    add s6, zero, zero
    add s3, zero, a0 # set s3 to a0 (so we can call .getMaxSB function)
    addi s2, zero, -1
    jal .getMaxSB # calling .getMaxSB function
    add s4,zero,s6 # set s4 to s6 (most significant bit of a0)

    lw ra, sp, 0
    addi sp, sp, 4

.getMaxSBa1:
    # here we store in s5 the most significant bit of a1 
    addi sp, sp, -4
    sw ra, sp, 0

    add s6, zero, zero
    add s3, zero, a1 # set s3 to a1 (so we can call .getMaxSB function)
    addi s2, zero, -1
    call .getMaxSB # calling .getMaxSB function
    add s5,zero,s6 # set s5 to s6 (most significant bit of a1)

    lw ra, sp, 0
    addi sp, sp, 4

.getEqual:
    # here we shift a1 to the left so that the most significant bit of a0 and a1 are equal (in the same position)
    sub s2, s4, s5 # s2 is the difference of the positions of the most significant bits from a0 and a1
    add s3, zero, a1 # set s3 to a1
    add s4, zero, a0 # set s4 to a0
    addi s5, zero, 0
    blt s2, zero, .endEqual # if the most significant bit of a1 is already greater the a0 our anser will be zero, so we dont have to shift anything
    sll s3, s3, s2 # shifting the value of s3, the value of s2 bits to the left 
.endEqual:

.loopDivision:
    # here we trie to subtract the value of s3 in s4 and then shift the value of s3, 1 bit to the right
    blt s2, zero, .endLoopDivision # if we cant shift s3 to the right our algorithm is finished
    addi s2, s2, -1 # subtract 1 from s2
    slli s5, s5, 1 # s5 represents the answer of the division and in each iteration we have to shift the value of s5 1 bit to the left

    blt s4, s3, .add0Division # if we cant subtract s3 from s4 we jump to .add0Division label
    sub s4, s4, s3 # otherwise we subtract 
    addi s5, s5, 1 # add 1 to s5 (update our answer)

.add0Division:
    srli s3, s3, 1 # shift the value of s3 1 bit to the right
    j .loopDivision

.endLoopDivision:
    # Set a0 to the value of s5 (s5 is the floor of the division of a0 by a1), and set a1 to the remainder of that division (represented by s4)

    add a0, zero, s5 # set a0 to s5
    addi s3, zero, 1
    add a1, zero, s4 # set a1 to s4
    bne s7, s3, .endDivision # if s7 is different from 1, our answer (a0) will be a postive number so we can jump to .endDivision, otherwise will be negative
    # turn a0 into -a0
    add s3, zero, a0
    sub a0, a0, s3
    sub a0, a0, s3

.endDivision:
    jr ra

main:
    addi sp, sp, -4
    sw ra, sp, 0

.startMain:
    call printMenu
    addi t0, zero, 4
    ecall
    addi a1, zero, 0
    addi a1, a1, 1

    beq a0, a1, getSum
    addi a1, a1, 1
    beq a0, a1, getSub
    addi a1, a1, 1
    beq a0, a1, getMult
    addi a1, a1, 1
    beq a0, a1, getDiv
    addi a1, a1, 1
    beq a0, a1, getExpo
    addi a1, a1, 1
    beq a0, a1, binToHex
    addi a1, a1, 1
    beq a0, a1, hexToBin
    addi a1, a1, 1
    beq a0, a1, decToHex
    addi a1, a1, 1
    beq a0, a1, hexToDec
    addi a1, a1, 1
    beq a0, a1, binToDec
    addi a1, a1, 1
    beq a0, a1, decToBin
    
    addi a1, a1, 1
    beq a0, a1, .startMain

    lw ra, sp, 0
    addi sp, sp, 4
    ret
