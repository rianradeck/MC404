.section .text

mult: # returns in a0 the value of a0 times a1 (at the end a1 = 1 if we had overflow, else a0 = 0)
	addi s2, zero, 0 # initialize the return value

	addi s3, zero, 0 # s3 is the counter
	addi s4, zero, 32 # s4 is the limit
	addi s5, zero, 1 # s5 is the auxiliar variable to check if the s3-th bit is 0 or 1
	addi s8, zero, 31 # the msb of a1

.loopMsb:
	sll s10, s5, s8
	and s9, s10, a1
	bne s9, zero, .endMsb
	addi s8, s8, -1

	j .loopMsb
.endMsb:

.loopMult:
	bge s3, s4, .endMult

	and s6, s5, a0 # s6 is the s3-th bit
	slli s5, s5, 1

.ifMultBit:
	beq s6, zero, .skipIfMultBit # if the s3-th bit is 0, we do nothing
	add s9, s8, s3 # s9 will be the position of the msb of the sum part this iterarion
	bge s9, s4, .multOverflow

	sll s7, a1, s3 # what ill sum in this iterarion
	add s2, s2, s7 # sum the result of the shift

.skipIfMultBit:
	addi s3, s3, 1 # add counter
	j .loopMult
	
.endMult:
	add a0, zero, s2 # place the return value in a0
	add a1, zero, zero
	ret
.multOverflow:
	add a0, zero, zero
	addi a1, zero, 1
	ret

main:
	addi sp, sp, -4
    sw ra, sp, 0

	addi t0, zero, 4
	ecall
	add a1, zero, a0
	ecall

	call mult

    lw ra, sp, 0
    addi sp, sp, 4
    ret
