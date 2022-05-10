.section .text

main:
	addi a0, zero, 11 # primeiro num
	addi a1, zero, 0 # segundo num
	addi a2, zero, 0

.L1:
	beq a2, a1, .L2

	add a3, a3, a0
	addi a2, a2, 1

	j .L1

.L2:
	addi t0, zero, 1
	add a0, zero, a3
	ecall

	jr ra