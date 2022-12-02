# Lucas Gusmão Valduga
# Filtro média móvel

.data
	
	nMaior:		.ascii "\nDigite o maior N: "
	
	nMenor:		.ascii "\nDigite o menor N: "
	
	.align 2
	nEntradas:	.ascii "\nDigite o número de entradas: "
	
	.align 2
	entraXa:	.ascii "\nDigite a entrada "
	
	.align 2
	entraXb:	.ascii ": "
	
	.align 2
	arrayEntradas:	.float
	
	.align 2
	SaidasA:	.float
	
	.align 2
	SaidasB:	.float
	
.text

main:	la $s0, arrayEntradas 	# ponteiro para array de entradas
	move $t2, $s0		# ponteiro auxiliar para entradas
	
	la $a0, nEntradas	
	li $v0, 4		# print para input de quantidade de entradas
	syscall
	
	li $v0, 5		# lendo INT de número de entrdas
	syscall
	move $t0, $v0		# Movendo INT de entradas para $t0
	
	li $t1, 0		# Valor para comparar quando ja foram todas as entradas
	
loopEntradas:
	beq $t1, $t0, calculo 	# if $t1 = $t2 finaliza o laço
	
 	addi $t1, $t1, 1	# Soma até chegar ao numero de entradas definido
	
	la $a0, entraXa		
	li $v0,4		# print para entrada x parte 1
	syscall 
	
	move $a0, $t1 
	li $v0, 1 		# print do numero da entrada atual
	syscall
	
	la $a0, entraXb
	li $v0,4		# print para entrada x parte 2
	syscall
			
	li $v0, 6		# lendo FLOAT do teclado
	syscall
	
	s.s $f0, 0($t2)		# armazenando float lido na memoria 
	addi $t2, $t2, 4	# aponta para a proxima posição do array entradas
	
	j loopEntradas 		# proxima iteração do laço de entradas

calculo:
	
	
	
	
	
