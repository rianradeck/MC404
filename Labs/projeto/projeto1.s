.section .text

printDivisionByZero:
    .rodata
.zerodivision: # 15
    .word 0x49564944
    .word 0x204f4153
    .word 0x20524f50
    .word 0x0a2130

    .text
    addi t0, zero, 3
    lui a0, %hi(.zerodivision)
    addi a0, a0, %lo(.zerodivision)
    addi a1, zero, 15
    ecall

printEndl:
    addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    ret

getFirstNum: # asks for a input and saves on a0
    .rodata
.typeFirstNum: # 25 chars
    .word 0x69676944
    .word 0x6f206574
    .word 0x69727020
    .word 0x7269656d
    .word 0x756e206f
    .word 0x6f72656d
    .word 0x0a
    
    .text
    addi t0, zero, 3
    lui a0, %hi(.typeFirstNum)
    addi a0, a0, %lo(.typeFirstNum)
    addi a1, zero, 25
    ecall

    addi t0, zero, 4
    ecall

    ret

getSecondNum: # asks for a input and saves on a1
    .rodata
.typeSecondNum: # 24 chars
    .word 0x69676944
    .word 0x6f206574
    .word 0x67657320
    .word 0x6f646e75
    .word 0x6d756e20
    .word 0x0a6f7265

    .text
    add s11, a0, zero
    addi t0, zero, 3
    lui a0, %hi(.typeSecondNum)
    addi a0, a0, %lo(.typeSecondNum)
    addi a1, zero, 24
    ecall

    addi t0, zero, 4
    ecall
    add a1, a0, zero
    add a0, s11, zero
    
    ret

printResult:
    .rodata
.result: # 11 chars
    .word 0x75736552
    .word 0x6461746c
    .word 0x203a6f

    .text
    addi s10, a0, 0
    addi s11, a1, 0
    addi t0, zero, 3
    lui a0, %hi(.result)
    addi a0, a0, %lo(.result)
    addi a1, zero, 11
    ecall
    add a0, zero, s10
    add a1, zero, s11

    ret

printOverflow:
    .rodata
.overflow: # 10 chars
    .word 0x5245564f
    .word 0x574f4c46
    .word 0x2021

    .text
    addi t0, zero, 3
    lui a0, %hi(.overflow)
    addi a0, a0, %lo(.overflow)
    addi a1, zero, 10
    ecall

    ret

printMenu:
    .rodata
.menu: # 184 chars
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x6f72500a
    .word 0x6f74656a
    .word 0x34434d20
    .word 0x2d203430
    .word 0x72615020
    .word 0x31206574
    .word 0x52202d20
    .word 0x36312041
    .word 0x38333838
    .word 0x52206520
    .word 0x38312041
    .word 0x33393737
    .word 0x73450a0a
    .word 0x686c6f63
    .word 0x6d752061
    .word 0x706f2061
    .word 0x63617265
    .word 0x0a3a6f61
    .word 0x202d2031
    .word 0x616d6f53
    .word 0x2d20320a
    .word 0x62755320
    .word 0x63617274
    .word 0x330a6f61
    .word 0x4d202d20
    .word 0x69746c75
    .word 0x63696c70
    .word 0x6f616361
    .word 0x2d20340a
    .word 0x76694420
    .word 0x6f617369
    .word 0x2d20350a
    .word 0x70784520
    .word 0x63656e6f
    .word 0x61636169
    .word 0x20360a6f
    .word 0x6153202d
    .word 0x230a7269
    .word 0x23232323
    .word 0x23232323
    .word 0x23232323
    .word 0x0a232323

    .text
    addi t0, zero, 3
    lui a0, %hi(.menu)
    addi a0, a0, %lo(.menu)
    addi a1, zero, 184
    ecall

    ret

printInt: # prints the value of a0
    addi s3, a0, 0 # save the original value of a0
    addi s2, zero, 1
    slli s2, s2, 31
    and s2, s2, a0

    beq s2, zero, .positive

.negative:
    addi t0, zero, 2
    addi a0, zero, 45
    ecall #print -
    addi a0, s3, 0

    # invert all and sum 1
    xori a0, a0, 0xffffffff
    addi a0, a0, 1

.positive:
    addi t0, zero, 1
    ecall
    addi a0, s3, 0
    
    ret

printDivision:
    addi sp, sp, -4
    sw ra, sp, 0

    .rodata
.quocient: # 11 chars
    .word 0x636f7551
    .word 0x746e6569
    .word 0x203a65
.remainder: # 7 cahrs
    .word 0x74736552
    .word 0x203a6f

    .text
    addi s10, a0, 0
    addi s11, a1, 0

    addi t0, zero, 3
    lui a0, %hi(.quocient)
    addi a0, a0, %lo(.quocient)
    addi a1, zero, 11
    ecall
    addi a0, s10, 0
    addi a1, s11, 0

    call printInt

    addi t0, zero, 3
    lui a0, %hi(.remainder)
    addi a0, a0, %lo(.remainder)
    addi a1, zero, 7
    ecall
    addi a1, s10, 0
    addi a0, s11, 0

    call printInt

    lw ra, sp, 0
    addi sp, sp, 4

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

sum: # returns is a0, the value of a0 plus a1 (at the end a1 = 1 if we had overflow, else a1 = 0)
    addi t5, zero, 1
    slli t5, t5, 31
    addi t6, zero, 1
    slli t6, t6, 31

    and t5, t5, a0 # signal of a0
    and t6, t6, a1 # signal of a1
    xor t4, t5, t6 # signal of a0 * a1
    
    beq t4, zero, .checkSumOverflow # if its 0 (both a0 and a1 have the same signal)

    j .endSum

.checkSumOverflow:
    add a3, a0, a1
    addi t5, zero, 1
    slli t5, t5, 31
    addi t6, zero, 1
    slli t6, t6, 31

    and t5, t5, a0 # signal of a0
    and t6, t6, a3 # signal of a3 (a0 + a1)

    beq t5, t6, .endSum # if they have the same signal its ok

    j .sumOverflow

.endSum:
    add a0, a1, a0
    ret

.sumOverflow:
    add a0, a1, a0
    addi a1, zero, 1

    addi sp, sp, -4
    sw ra, sp, 0
    call printOverflow
    lw ra, sp, 0
    addi sp, sp, 4

    ret

subt: # inverts the signal of a1 and call sum
    xori a1, a1, 0xffffffff
    addi a1, a1, 1
    addi sp, sp, -4
    sw ra, sp, 0
    call sum
    lw ra, sp, 0
    addi sp, sp, 4

    ret

mult: # returns in a0 the value of a0 times a1 (at the end a1 = 1 if we had overflow, else a1 = 0)
    addi sp, sp, -4
    sw ra, sp, 0
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
    

    add a3, a0, zero
    call abs
    add a0, a3, zero

    add a3, a1, zero
    call abs
    add a1, a3, zero


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
    lw ra, sp, 0
    addi sp, sp, 4
    ret

.multOverflow:
    call printOverflow
    add a0, zero, zero
    addi a1, zero, 1
    lw ra, sp, 0
    addi sp, sp, 4
    ret

division: # return a0 divided by a1 (at the end the value of a0 is the quotient and a1 the remainder) a1 is the divisor
    addi s2, zero, 0 # quotient
    addi s3, zero, 0 # dividend until now
    addi s4, zero, 31 # the dividend bit im looking now

.loopDiv:
    blt s4, zero, .endDiv # if the dividend bit is less than 0 i have finished the algorithm

    srl s5, a0, s4
    andi s5, s5, 1 # the s4-th bit of the dividend

    slli s3, s3, 1
    add s3, s3, s5

    bge s3, a1, .subtractDiv
    j .notSubtractDiv

.subtractDiv:
    slli s2, s2, 1
    addi s2, s2, 1 # put 1 in the quotient
    sub s3, s3, a1 

    addi s4, s4, -1 # go to next bit
    j .loopDiv

.notSubtractDiv:
    slli s2, s2, 1 # put 0 in the quotient

    addi s4, s4, -1 # go to next bit
    j .loopDiv

.endDiv:
    addi a0, s2, 0
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

getNums:
    addi sp, sp, -4
    sw ra, sp, 0
    call getFirstNum
    call getSecondNum
    lw ra, sp, 0
    addi sp, sp, 4

    ret

getSum:
    call printResult
    call sum
    call printInt

    j .startMain

getSub:
    call printResult
    call subt
    call printInt

    j .startMain

getMult:
    call printResult
    call mult
    call printInt

    j .startMain

getDiv:
    beq a1, zero, .divisionByZero

    call division
    call printDivision

    j .startMain

.divisionByZero:
    call printDivisionByZero

    j .startMain
getExpo:
    call printResult
    call fastExponentiation
    call printInt

    j .startMain

main:
    addi sp, sp, -4
    sw ra, sp, 0

.startMain:
    call printEndl
    call printMenu
    addi t0, zero, 4
    ecall
    addi t4, zero, 6
    beq a0, t4, .endMain
    addi t3, a0, 0
    addi t4, zero, 1

    call getNums

    beq t3, t4, getSum
    addi t4, t4, 1
    beq t3, t4, getSub
    addi t4, t4, 1
    beq t3, t4, getMult
    addi t4, t4, 1
    beq t3, t4, getDiv
    addi t4, t4, 1
    beq t3, t4, getExpo

    j .startMain

.endMain:
    lw ra, sp, 0
    addi sp, sp, 4
    ret
