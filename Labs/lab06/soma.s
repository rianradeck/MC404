.section .text

main:
	addi a0, zero, 11 # primeiro num
	addi a1, zero, 23 # segundo num
	add a0, a0, a1

	addi t0, zero, 1
	ecall
	jr ra