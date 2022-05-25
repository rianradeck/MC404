.section .text

main:
	.rodata
.msg:
	.word 0x49474944 # DIGI
	.word 0x35204554 # TE 5
	.word 0x4D554E20 #  NUM
	.word 0x534F5245 # EROS

	.text
	addi t0, zero, 3
	lui a0, %hi(.msg)
	addi a0, a0, %lo(.msg)
	addi a1, zero, 16
	ecall

	# print endl
	addi t0, zero, 2
    addi a0, zero, 13 
    ecall

    # alocate array memory
    addi a0, zero, 32
    addi t0, zero, 7
    ecall

    # save adress of array in t1
    add t1, a0, zero

    # read all 5 integers
    addi t0, zero, 4
    ecall
    sw a0, t1, 0
    ecall
    sw a0, t1, 4
    ecall
    sw a0, t1, 8
    ecall
    sw a0, t1, 12
    ecall
    sw a0, t1, 16

    #print "MENOR: "
   	.rodata
.menor:
	.word 0x4F4E454D # MENO
	.word 0x00203a52 # "R: "

	.text
	addi t0, zero, 3
	lui a0, %hi(.menor)
	addi a0, a0, %lo(.menor)
	addi a1, zero, 7
	ecall

	# inicializar loop mn
	addi a1, zero, 0 #contador
	addi a2, zero, 20 #limite x4
	addi a3, zero, 2147483647 # resposta
	j loopmn

attmn:
	add a3, a4, zero
	addi a1, a1, 4
loopmn:
	beq a1, a2, fimmn

	add a5, t1, a1 # a5 = adress(t1[a1 sobre 4])
	lw a4, a5, 0 # a4 = val(a5)
	blt a4, a3, attmn # se a4 menor q a3, a3 = a4
	addi a1, a1, 4

	j loopmn
fimmn:

	#print mn (a3)
	addi t0, zero, 1
	add a0, zero, a3
	ecall


#print "MAIOR: "
   	.rodata
.maior:
	.word 0x4F49414D # MAIO
	.word 0x00203a52 # "R: "

	.text
	addi t0, zero, 3
	lui a0, %hi(.maior)
	addi a0, a0, %lo(.maior)
	addi a1, zero, 7
	ecall

	# inicializar loop mx
	addi a1, zero, 0 #contador
	addi a2, zero, 20 #limite x4
	addi a3, zero, -2147483648 # resposta
	j loopmx

attmx:
	add a3, a4, zero
	addi a1, a1, 4
loopmx:
	beq a1, a2, fimmx

	add a5, t1, a1 # a5 = adress(t1[a1 sobre 4])
	lw a4, a5, 0 # a4 = val(a5)
	bge a4, a3, attmx # se a4 maior ou igual q a3, a3 = a4
	addi a1, a1, 4

	j loopmx
fimmx:

	#print mx (a3)
	addi t0, zero, 1
	add a0, zero, a3
	ecall

#print "SOMA: "
   	.rodata
.soma:
	.word 0x414D4F53 # SOMA
	.word 0x0000203A # ": "

	.text
	addi t0, zero, 3
	lui a0, %hi(.soma)
	addi a0, a0, %lo(.soma)
	addi a1, zero, 6
	ecall

	# inicializar loop sum
	addi a1, zero, 0 #contador
	addi a2, zero, 20 #limite x4
	addi a3, zero, 0 # resposta

loopsum:
	beq a1, a2, fimsum
	add a5, t1, a1 # a5 = adress(t1[a1 sobre 4])
	lw a4, a5, 0 # a4 = val(a5)
	add a3, a3, a4 # a3 aumenta de a4
	addi a1, a1, 4

	j loopsum

fimsum:
	
	#print sum (a3)
	addi t0, zero, 1
	add a0, zero, a3
	ecall