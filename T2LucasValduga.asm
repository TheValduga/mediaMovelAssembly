# Lucas Gusmão Valduga
# Filtro média móvel

.data
	.align 2
	nLonga:		.ascii "\nDigite o maior N: "
	
	.align 2
	nCurta:		.ascii "\nDigite o menor N: "
	
	.align 2
	nEntradas:	.ascii "\n\nDigite o número de entradas: "
	
	.align 2
	entraXa:	.ascii "\nDigite a entrada "
	
	.align 2
	entraXb:	.ascii ": "
	
	.align 2
	tableHeader: 	.ascii "\nValor     	MMcurta     	MMlonga     	Tendência"
	
	.align 2
	espaco: 	.asciiz  "     "
	
	.align 2
	alta:		.asciiz "Alta"
	
	.align 2
	queda:		.asciiz "Queda"
	
	.align 2
	constante:	.asciiz "Constante"
			
	.align 2
	arrayEntradas:	.float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
	.align 2
	saidasA:	.float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
	.align 2
	saidasB:	.float	0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
	
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
	add.s $f2, $f1, $f2	# soma proxima entrada
	div.s $f5, $f2, $f3	# divide por Ncurta para obter a media	
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasA 
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t3, $t3, 1	# soma contador do laço curta
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	blt $t3, $s3, loopCurta1 # if $t3 <= $s3 jump para loopCurta1

loopCurta2:	
	beq $t1, $t0, endCurta 	# finaliza curta quando ja foram calculadas todas entradas
	
	l.s $f6, 0($t6)		# carregando posição de entrada que saiu do bloco N
	sub.s $f2, $f2, $f6	# subtraindo do somatorio entrada que saiu do bloco N
	l.s $f1, 0($t2)		# carregando posição de entrada que entrada no bloco N
	add.s $f2, $f1, $f2	# somando nova entrada do bloco N
	div.s $f5, $f2, $f3	# dividindo por Ncurta para obter a media
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasA 
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t6, $t6, 4	# proxima posição a ser subtraida
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	j loopCurta2	
	
endCurta:

# calculo Longa ------------------------------------------------------------------------------------ #

	move $t2, $s0		# resetando ponteiro auxiliar para entradas
	li $t1, 0		# resetando variavel de loop de numero de entradas
	
	mtc1 $zero, $f2		# $f2 começa em zero
	cvt.s.w $f2, $f2	# convertendo para single precision
	la $t5, saidasB		# carregando endereço do array saidasB
	move $t6, $s0		# ponteiro auxiliar para entradas

loopLonga1:
	l.s $f1, 0($t2)		# carrega de arrayEntradas
	add.s $f2, $f1, $f2	# soma valor de nova entrada
	div.s $f5, $f2, $f4	# divide por Nlonga para obter a média
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasB
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t4, $t4, 1	# soma contador do laço longa
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	blt $t4, $s4, loopLonga1 # if $t4 <= $s4 jump para loopLonga1

loopLonga2:	
	beq $t1, $t0, endLonga
	
	l.s $f6, 0($t6)		# carregando posição de entrada que saiu do bloco N
	sub.s $f2, $f2, $f6	# subtraindo do somatorio entrada q saiu do bloco N
	l.s $f1, 0($t2)		# carregando posição de entrada que entrada no bloco N
	add.s $f2, $f1, $f2	# somando nova entrada do bloco N
	div.s $f5, $f2, $f4	# dividindo por Nlonga para obter a media
	
	s.s $f5, 0($t5)		# armazena resultado
	
	addi $t5, $t5, 4	# proximo endereço de saidasA 
	addi $t2, $t2, 4	# proximo endereço de entradas
	addi $t6, $t6, 4	# proxima posição a ser subtraida
	addi $t1, $t1, 1	# contador de entradas, para finalizar a media
	
	j loopLonga2
	
endLonga:

# imprimindo resultados --------------------------------------------------- #	
	la $a0, tableHeader 
	li $v0, 4		# Imprime header da tabela
	syscall
		
	la $t1, arrayEntradas 	# ponteiro para entradas
	la $t2, saidasA		# ponteiro para MMcurta
	la $t3, saidasB		# ponteiro para MMlonga
	li $t4, 0		# valor para contador finalizador do laço tabela
	li $t5, 2		# 0 para ultimo cruzamento de Queda, 1 para Alta, 
	
loopTabela:
	la $a0, 10		# ascii para quebra de linha
	li $v0, 11		# imprime caractere ascii carregado em $a0 
	syscall
	
	l.s $f1, 0($t1)		# entrada a ser impressa
	l.s $f2, 0($t2)		# valor MMcurta a ser impresso
	l.s $f3, 0($t3)		# valor MM longa a ser impresso
	
	mov.s $f12, $f1
	li $v0, 2		# imprime float de entrada
	syscall
	
	la $a0, espaco		
	li $v0, 4		# string com espaços para alinhamento da tabela
	syscall
	
	la $a0, 9		# ascii para caractere tab
	li $v0, 11		# imprime tab para alinhamento da tabela
	syscall
	
	mov.s $f12, $f2
	li $v0, 2		# imprime float MMcurta
	syscall
	
	la $a0, espaco		
	li $v0, 4		# string com espaços para alinhamento da tabela
	syscall
	
	la $a0, 9		# ascii para caractere tab
	li $v0, 11		# imprime tab para alinhamento da tabela
	syscall
	
	mov.s $f12, $f3
	li $v0, 2		# imprime float MMlonga
	syscall
	
	la $a0, espaco		
	li $v0, 4		# string com espaços para alinhamento da tabela
	syscall
	
	la $a0, 9		# ascii para caractere tab
	li $v0, 11		# imprime tab para alinhamento da tabela
	syscall
	
	addi $t1, $t1, 4	# proximo endereço de arrayEntradas
	addi $t2, $t2, 4	# proximo endereço de saidasA
	addi $t3, $t3, 4	# proximo endereço de saidasB
	addi $t4, $t4, 1	# incrementa contador para finalizar o loopTabela
	
	
	c.eq.s $f2, $f3		# testa igualdade de MMcurta e MMlonga
	bc1t Constante		# se iguais entao imprime "constante"
	
	c.lt.s $f2, $f3		# testa se MMcurta menor que MMlonga
	bc1f Alta		# se MMcurta > MMlonga vai para Alta
	
Queda:	
	beq $t5, 0, Constante	# vai para constante se ultimo cruzamente de valores foi Queda
	
	la $a0, queda
	li $v0, 4		# imprime Queda
	syscall
	
	li $t5, 0		# $t5 = 0 representa ultimo cruzamento de valores de Queda
	
	j branchTabela		# jump para finalizador do loop
	
Alta:
	beq $t5, 1, Constante	# vai para constante se ultimo cruzamento de valores foi Alta
	
	la $a0, alta
	li $v0, 4		# imprime Alta
	syscall

	li $t5, 1		# $t5 = 1 representa ultimo cruzamento de valores de Alta
	
	j branchTabela		# jump para finalizador do loop
	
Constante:
	la $a0, constante 
	li $v0, 4		# imprime Constante
	syscall

branchTabela:
	blt $t4, $t0, loopTabela # if $t4 < $t0 vai para loopTabela
	
	j main			# nova execução do programa
	
	

	
		
	
