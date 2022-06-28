.section .text

fastExponentiation:
	add s8, zero, a0
	add s9, zero, a1
	addi s10, zero, 1

.ExpLoop:
	addi s6, zero, 1
	andi s7, s9, 1
	beq s7, s6, .oddA1
	bne s7, s6, .evenA1 

.evenA1:
	addi sp, sp, -4
	sw ra, sp, 0

	add a0, zero, s8
	add a1, zero, s8

	call mult

	add s8, zero, a0
	srli s9, s9, 1

	lw ra, sp, 0
	addi sp, sp, 4

	j .loopContinue


.oddA1:
	addi sp, sp, -4
	sw ra, sp, 0

	add a0, zero, s8
	add a1, zero, s10

	call mult

	add s10, zero, a0
	addi s9, s9, -1

	lw ra, sp, 0
	addi sp, sp, 4

.loopContinue:
	blt zero, s9, .ExpLoop

.endExponentiation:
	add a0, zero, s10
	jr ra

division: # return a0 divided by a1 (at the end the value of a0 is the quocient and a1 the remainder)
	addi s2, zero, 0
	add s7, zero, zero

.checkNegative:
	bge a0, zero, .endNegA0

	.negativeA0:
		add s3, zero, a0
		sub a0, a0, s3
		sub a0, a0, s3
		addi s7, s7, 1
	.endNegA0:

	bge a1, zero, .endNegA1

	.negativeA1:
		add s3, zero, a1
		sub a1, a1, s3
		sub a1, a1, s3
		addi s7, s7, 1
	.endNegA1:

	j .getMaxSBa0

.getMaxSB:
	beq s3, zero, .endMaxSB
	srli s3, s3, 1
	addi s6, s6, 1
	j .getMaxSB
.endMaxSB:
	jr ra

.getMaxSBa0:
	addi sp, sp, -4
	sw ra, sp, 0

	add s6, zero, zero
	add s3, zero, a0
	addi s2, zero, -1
	jal .getMaxSB
	add s4,zero,s6

	lw ra, sp, 0
	addi sp, sp, 4

.getMaxSBa1:
	addi sp, sp, -4
	sw ra, sp, 0

	add s6, zero, zero
	add s3, zero, a1
	addi s2, zero, -1
	call .getMaxSB
	add s5,zero,s6

	lw ra, sp, 0
	addi sp, sp, 4

.getEqual:
	sub s2, s4, s5
	add s3, zero, a1
	add s4, zero, a0
	addi s5, zero, 0
	blt s2, zero, .endEqual	
	sll s3, s3, s2
.endEqual:

.loopDivision:
	blt s2, zero, .endLoopDivision
	addi s2, s2, -1
	slli s5, s5, 1

	blt s4, s3, .add0Division
	sub s4, s4, s3 
	addi s5, s5, 1

.add0Division:
	srli s3, s3, 1
	j .loopDivision

.endLoopDivision:
	add a0, zero, s5
	addi s3, zero, 1
	add a1, zero, s4
	bne s7, s3, .endDivision
	add s3, zero, a0
	sub a0, a0, s3
	sub a0, a0, s3

.endDivision:
	jr ra

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
	#addi sp, sp, -4
    #sw ra, sp, 0

	#addi t0, zero, 4
	#ecall
	#add a1, zero, a0
	#ecall

	#call mult

    #lw ra, sp, 0
    #addi sp, sp, 4
    #ret

    addi sp, sp, -4
    sw ra, sp, 0

	addi t0, zero, 4
	ecall
	add a1, zero, a0
	ecall

	call division

    lw ra, sp, 0
    addi sp, sp, 4
    ret
