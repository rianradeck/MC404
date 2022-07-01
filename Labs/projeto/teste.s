.section .text

decToBin:
    addi a0, zero, 32
    addi t0, zero, 7
    ecall
    add a1, a0, zero  

    addi t0, zero, 4
    ecall
    add a2, zero, a0

    addi s1, zero, 1
    slli s1, s1, 30

    addi t1, zero, 1
    add s3, zero, zero

    add a0, zero, a1

.loopDB:
    beq s1, zero, endLoopDB
    addi a3, zero, 48

    blt a2, s1, conDB
    addi s3, zero, 1
    sub a2, a2, s1

    addi a3, zero, 49

.conDB:
    
    beq s3, zero, con2DB
    sb a3, a0, 0
    addi a0, a0, 1
        
.con2DB:

    srli s1, s1, 1
    j loopDB

.endLoopDB:

    addi t0, zero, 3
    add a0, zero, a1
    ecall

    jr ra

binToDec:
    addi a0,zero,32
    addi t0,zero,7
    ecall

    addi a1,zero,32
    addi t0,zero,6
    ecall

    add s1, zero, a0

    add a1, zero, zero
    addi s2, zero, 48
    addi s3, zero, 32
    addi a0, a0, 31

.loopBD:
    lb a2, s1, 0
    andi a2, a2,0xff
    beq a2, s3, endLoopBD
    slli a1, a1, 1
    beq a2, s2, conBD
    addi a1, a1, 1

.conBD:

    beq s1, a0, endLoopBD
    addi s1, s1, 1
    j LoopBD
    
.endLoopBD:
    ret

printHex:

    add t4, a0, zero
    addi t5, zero, 10 

    blt a1,t5, .hexNumber

.hexLetter:
    addi a0, a1, 55
    j .pHcontinue

.hexNumber:    
    addi a0, a1, 48

.pHcontinue:

    addi t0, zero, 2
    ecall

    add a0, zero, t4

    ret

decToHex: # prints a0 in hex
    addi t4, a0, 0
    addi t0, zero, 2
    addi a0, zero, 48
    ecall
    addi a0, zero, 120
    ecall
    addi a0, t4, 0
    # (2 ^ 28) = 16 ^ 7
    addi s2, zero, 1
    slli s2, s2, 28

.loopExponent:
    beq s2, zero, .endLoopExponent 

    addi s3, zero, 15
.loopConstant:
    blt s3, zero, .endLoopConstant
    addi s4, zero, 0
    add s5, zero, s3 # cont

.loopMult:
    beq s5, zero, .endLoopMult
    add s4, s4, s2

    addi s5, s5, -1
    j .loopMult
.endLoopMult:
    # s4 = s3 * 16 ^ (7, 6, ...)

    bltu a0, s4, .endIfs4
.ifs4lessthana0:
    sub a0, a0, s4
    addi a1, s3, 0
    addi sp, sp, -4
    sw ra, sp, 0
    call printHex
    lw ra, sp, 0
    addi sp, sp, 4
    j .endLoopConstant

.endIfs4:

    addi s3, s3, -1
    j .loopConstant

.endLoopConstant:
    
    srli s2, s2, 4 # 16 ^ (7, 6, 5 ...)
    j .loopExponent

.endLoopExponent:
    ret

hexToDec: # takes a string in s1 and converts to decimal (a0)
    addi s2, zero, 0 # counter
    addi s3, zero, 0 # result
    addi s11, zero, 8 # limit

.loopHexToDecStack:
    bge s2, s11, .endLoopHexToDecStack

    srli s5, s2, 2 # s2 over 4 (adress of the packet of th s2-th letter)
    beq s5, zero, .ifs5is0
.ifs5is1: # second part of packet
    lw s4, s1, 4 # packet
    j .endif
.ifs5is0: # first part of packet
    lw s4, s1, 0 # packet
.endif:

    addi t1, zero, 0xff # t1 is the selector of the char
    slli s6, s2, 3 # shift amount = s2 * 8
    sll t1, t1, s6 # have to shift s2(i) * 8 to the left to and with the packet 
    and s5, s4, t1
    srl s5, s5, s6 # shift back 

    addi t1, zero, 32
    beq s5, t1, .skip

    addi sp, sp, -4
    sw s5, sp, 0 # place the value of the hex on stack

    addi s2, s2, 1
    j .loopHexToDecStack
.skip:
    
.endLoopHexToDecStack:

    # here s3 is the size of the string
    addi s3, s2, 0
    addi s2, zero, 0 # cont
    addi s1, zero, 1
    addi s4, zero, 0 # result
.loopCalcHexToDec:
    beq s2, s3, .endHextoDec

    lw a0, sp, 0
    addi s9, zero, 65
    blt a0, s9, .ifIsNum
.ifIsletter:
    addi a0, a0, -55
    j .ifsSKip
.ifIsNum:
    addi a0, a0, -48
.ifsSKip:

    addi sp, sp, 4

    slli s5, s2, 2 # 0, 4, 8, 12
    sll a0, a0, s5 # s0 * 2 ^ (0, 4, 8, 12) (1, 16, 16^2, 16^3)...
    add s4, s4, a0 # add to answer

    addi s2, s2, 1
    j .loopCalcHexToDec

.endHextoDec:
    addi a0, s4, 0
    ret

main:

    addi sp, sp, -4
    sw ra, sp, 0
    addi t0, zero, 4
    ecall
    
    call decToHex
    lw ra, sp, 0
    addi sp, sp, 4

    
.endMain:
    ret