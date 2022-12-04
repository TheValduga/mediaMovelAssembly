# Lucas Gusmão Valduga
# Filtro média móvel

.data
	.align 2
	nLonga:		.ascii "\nDigite o maior N: "
	
	.align 2
	nCurta:		.ascii "\nDigite o menor N: "
	
	.align 2
	nEntradas:	.ascii "\nDigite o número de entradas: "
	
	.align 2
	entraXa:	.ascii "\nDigite a entrada "
	
	.align 2
	entraXb:	.ascii ": "
	
	.align 2
	arrayEntradas:	.float
	
	.align 2
	saidasA:	.float
	
	.align 2
	saidasB:	.float
	
.text

main:
	la $s0, arrayEntradas 	# ponteiro para array de entradas
	move $t2, $s0		# ponteiro auxiliar para entradas
	
	la $a0, nEntradas	
	li $v0, 4		# print para input de quantidade de entradas
	syscall
	
	li $v0, 5		# lendo INT de número de entrdas
	syscall
	move $t0, $v0		# Movendo INT de entradas para $t0
	
	li $t1, 0		# Valor para comparar quando ja foram todas as entradas
	
loopEntradas:
	beq $t1, $t0, endEntradas # if $t1 = $t2 finaliza o laço
	
 	addi $t1, $t1, 1	# Soma até chegar ao numero de entradas definido
	
	la $a0, entraXa		
	li $v0, 4		# print para entrada x parte 1
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

endEntradas:	
	la $a0, nCurta
	li $v0, 4 		# print de entrada do N com menor valor
	syscall
	li $v0, 5		# lendo do teclado N com menor valor
	syscall
	mtc1 $v0, $f3		# $f3 = N curta em FLOAT para fazer a divisão
	cvt.s.w $f3, $f3	# convertendo de inteiro para float
	move $s3, $v0		# $s3 = N curta em INT para comparar o laço
	li $t3, 0		# contador para o laço de curta
				
	la $a0, nLonga
	li $v0, 4 		# print de entrada do N com maior valor
	syscall
	li $v0, 5		# lendo do teclado N com maior valor
	syscall
	mtc1 $v0, $f4		# $f4 = N longa em FLOAT para fazer a divisão
	cvt.s.w $f4, $f4	# convertendo de inteiro para float
	move $s4, $v0		# $s4 = N longa em INT para comparar o laço
	li $t4, 0		# contador para o laço de longa
	
	move $t2, $s0		# resetando ponteiro auxiliar para entradas
	li $t1, 0		# resetando variavel de loop de numero de entradas

# calculo Curta ------------------------------------------------------------------------- #
	mtc1 $zero, $f2		# $f2 começa em zero
	cvt.s.w $f2, $f2	# convertendo para single precision
	la $t5, saidasA		# carregando endereço do array saidasA
	move $t6, $s0		# ponteiro auxiliar para entradas
loopCurta1:
	l.s $f1, 0($t2)		# carrega de arrayEntradas
	add.s $f2, $f1, $f2	
	div.s $f5, $f2, $f3		
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasA 
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t3, $t3, 1	# soma contador do laço curta
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	blt $t3, $s3, loopCurta1 # if $t3 <= $s3 jump para loopCurta1

loopCurta2:	
	beq $t1, $t0, endCurta
	
	l.s $f6, 0($t6)		# carregando posição de entrada que saiu do bloco N
	sub.s $f2, $f2, $f6	# subtraindo do somatorio entrada q saiu do bloco N
	l.s $f1, 0($t2)		
	add.s $f2, $f1, $f2	
	div.s $f5, $f2, $f3		
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasA 
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t6, $t6, 4	# proxima posição a ser subtraida
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	j loopCurta2
	
endCurta:

	li $t1, 0
	la $t5, saidasA
	
loopTeste:
	l.s $f12, 0($t5)
	li $v0, 2
	syscall
	
	la $a0, 10
	li $v0, 11
	syscall
	
	addi $t5, $t5, 4
	addi $t1, $t1, 1
	
	blt $t1, $t0, loopTeste
	
	
	
	
	

	
	
	

	
		
	
