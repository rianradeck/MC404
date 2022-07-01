s = "Digite o primeiro numero\n"
s = "Digite o segundo numero\n"
s = "Resultado: "
s = "OVERFLOW!\n"
s = "################\nProjeto MC404 - Parte 1 - RA 168838 e RA 187793\n\nEscolha uma operacao:\n1 - Hexadecimal para Binario\n2 - Binario para Hexadecimal\n3 - Decimal para Binario\n4 - Binario para Decimal\n5 - Decimal para Hexadecimal\n6 - Hexadecimal para Decimal\n7 - Sair\n################\n"
s = "Resultado:\n"
print(s)

f = lambda x: print(*("\t.word 0x" + x[i:i+4][::-1].encode().hex() for i in range(0, len(x), 4)), sep="\n")

f(s)
print(len(s))