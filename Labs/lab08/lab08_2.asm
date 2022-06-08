.section .text

read_string:
    .rodata
.digiteN:
    .word 0x69676944
    .word 0x4e206574
    .word 0x203a

    .text
    addi a4, a1, 0; # save a1
    addi t0, zero, 3
    lui a0, %hi(.digiteN)
    addi a0, a0, %lo(.digiteN)
    addi a1, zero, 10
    ecall
    addi a1, a4, 0 # get a1 back

    addi t0, zero, 4 # read integer ecall
    ecall
    add a1, zero, a0 # save read integer in a1 (size)
    add a2, zero, zero

.loop1:
    beq a2, a1, .end2
    addi a2, a2, 1

    .rodata
.digiteLetra:
    .word 0x69676944
    .word 0x75206574
    .word 0x6c20616d
    .word 0x61727465
    .word 0x203a

    .text
    addi a4, a1, 0; # save a1
    addi t0, zero, 3
    lui a0, %hi(.digiteLetra)
    addi a0, a0, %lo(.digiteLetra)
    addi a1, zero, 18
    ecall
    addi a1, a4, 0 # get a1 back

    addi t0, zero, 5 # read char
    ecall
    addi sp, sp, -4
    sw a0, sp, 0
    j .loop1

.end2:
    ret

print_string:
    .rodata
.inverso:
    .word 0x65766e49
    .word 0x3a6f7372
    .word 0x20

    .text
    addi a4, a1, 0; # save a1
    addi t0, zero, 3
    lui a0, %hi(.inverso)
    addi a0, a0, %lo(.inverso)
    addi a1, zero, 9
    ecall
    addi a1, a4, 0 # get a1 back

    slli a1, a1, 2
    add a3, sp, a1
    # start of string

.loop2:  
    beq a3, sp, .end2
    lw a0, sp, 0
    addi sp, sp, 4

    
    addi t0, zero, 2 # print char ecall
    ecall
    j .loop2
.end2:
    ret

main:
    addi sp, sp, -4
    sw ra, sp, 0
    call read_string
    call print_string
    lw ra, sp, 0
    addi sp, sp, 4

    ret