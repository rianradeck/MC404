.section .data
    vector:
        .word 0
        .word 0
        .word 0
        .word 0
        .word 0

.section .text

readInput:
    .rodata
.digite:
    .word 0x69676944
    .word 0x35206574
    .word 0x6d756e20
    .word 0x736f7265

    .text
    addi t0, zero, 3
    lui a0, %hi(.digite)
    addi a0, a0, %lo(.digite)
    addi a1, zero, 16
    ecall

    addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    addi a1, zero, 0
    addi a2, zero, 5

.loop:
    beq a1, a2, .end
    addi a1, a1, 1

    addi t0, zero, 4
    ecall
    sw a0, a3, 0
    addi a3, a3, 4
    j .loop
.end:
    ret

sort:
    addi a1, zero, 5
.do:
    beq a1, zero, .endDo
    addi a1, a1, -1

    addi a2, zero, %lo(vector) # i (start of vector)
    addi a4, a2, 16 # last adress of vector
.for:
    beq a2, a4, .endFor

    lw a5, a2, 0 # v[i]
    lw a6, a2, 4 # v[i + 1]
    blt a5, a6, .notSwap
    # swap a5, a6
    addi a7, a6, 0 
    addi a6, a5, 0
    addi a5, a7, 0
    # replace values in vector adress
    sw a5, a2, 0
    sw a6, a2, 4

.notSwap:
    addi a2, a2, 4
    j .for
.endFor:
    j .do
.endDo:
    ret 

print:
    .rodata
.ordenado:
    .word 0x6f746556
    .word 0x726f2072
    .word 0x616e6564
    .word 0x3a6f64

    .text
    addi t0, zero, 3
    lui a0, %hi(.ordenado)
    addi a0, a0, %lo(.ordenado)
    addi a1, zero, 15
    ecall

    addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    addi a1, zero, 0
    addi a2, zero, 5
    addi a3, zero, %lo(vector)

.loopP:
    beq a1, a2, .endP
    addi a1, a1, 1

    addi t0, zero, 1
    lw s2, a3, 0
    addi a0, s2, 0
    addi a3, a3, 4

    srli a4, s2, 31
    addi a5, zero, 1
    bne a4, a5, .positive

.negative:
    #print -
    addi t0, zero, 2
    addi a0, zero, 45
    ecall

    # invert all and sum 1
    xori s2, s2, 0xffffffff
    addi a0, s2, 1
    addi t0, zero, 1

.positive:    
    ecall
    
    j .loopP
.endP:
    ret

main:
    addi sp, sp, -4
    sw ra, sp, 0
    
    addi a3, zero, %lo(vector)
    call readInput
    call sort
    call print

    lw ra, sp, 0
    addi sp, sp, 4

    ret