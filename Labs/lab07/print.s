.section .text

main:

    .rodata
.MC404:
    # MC40 04CM 30, 34, 43, 4D
    .word 0x3034434D 
    # 4!00 00!4
    .word 0x00002134

    .text
    addi t0, zero, 3
    lui a0, %hi(.MC404)
    addi a0, a0, %lo(.MC404)
    addi a1, zero, 6
    ecall
    jr ra