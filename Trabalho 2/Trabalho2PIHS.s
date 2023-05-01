/* ENUNCIADO

Implementar em linguagem Gnu Assembly para plataforma 32bits, um programa de Controle de Cadastro de Imobiliário para locação,
usando exclusivamente as instruções e recursos de programação passados durante as aulas. O programa deve executar as funcionalidades de cadastro de uma imobiliária.
As seguintes funcionalidades devem ser implementadas: inserção, remoção, consulta, gravar cadastro, recuperar cadastro e relatório de registros.
Deve-se usar uma lista encadeada dinâmica (com malloc) para armazenar os registros dos imóveis ordenados por número de cômodos.

Para cada registro de imóvel deve-se ter as seguintes informações: nome completo, CPF e celular do proprietário, tipo do imóvel (casa ou apartamento), endereço do imóvel
(cidade, bairro, rua e número),número de quartos simples e de suites, se tem banheiro social, cozinha, sala e garagem, metragem total e valor do aluguel. As consultas de
registros devem ser feitas por faixa de valor de aluguel. O relatório deve mostrar todos os registros cadastrados de forma ordenada. A remoção deve liberar o espaço de memória
alocada (pode-se usar a função free(), empilhando o endereço antes de chamá-la com call).

A lista encadeada será manipulada em memoria e disco, devendo os dados serem digitados a cada execução ou lidos/gravados no inicio/final da execução.
Os trabalhos devem ser feitos em grupos de no máximo 2 alunos. O código fonte deve ser entregue juntamente com um relatório contendo: identificação dos participantes,
descrição dos principais módulos desenvolvidos e auto-avaliação do funcionamento (elencar as partes que funcionam corretamente, as partes que não funcionam corretamente e sob 
quais circunstancias, bem como as partes que não foram implementadas). O programa deve ser estruturado em procedimentos/funções Deve-se utilizar menu de opções.
O código deve ser comentado. Entregar o código fonte. 

*/

/*  ORGANIZAÇÃO DOS DADOS
	
	NOME DO CAMPO 				TIPO 		QTD. CARAC    QTD. BYTES
	NOME 						str 			30			  32	# pos_ini = 0
	CPF 						str 			14			  16	# pos_ini = 32
	CELULAR DO PROPRIETARIO
		DDD 					str             6 			  8 	# pos_ini = 48
		TELEFONE 				str 			10            12    # pos_ini = 56

	TIPO IMOVEL
		CASA OU APARTAMENTO     str  			1             4 	# pos_ini = 68

	ENDEREÇO DO IMOVEL
		CIDADE 					str 			18			  20 	# pos_ini = 72
		BAIRRO 					str 			30            32   	# pos_ini = 92
		RUA 					str 			38            40    # pos_ini = 124
		NÚMERO 					int 			-			  4 	# pos_ini = 164

	NUMERO DE QUARTOS
		SIMPLES 				int 			- 			  4 	# pos_ini = 168
		SUITES 					int 			- 			  4 	# pos_ini = 172
	
	SE TEM (Usar logica Boleana)
		BANHEIRO SOCIAL 		int 			1 			  4 	# pos_ini = 176
		COZINHA 				int 			1 			  4 	# pos_ini = 180
		SALA 					int             1             4 	# pos_ini = 184
		GARAGEM 				int             1             4 	# pos_ini = 188
	
	METRAGEM TOTAL 				float           -             8 (Double) # pos_ini = 192
	VALOR DO ALUGUEL 			float           -             8 (Double) # pos_ini = 200
	NUM DE COMODOS  			int 			- 			  4 # pos_ini = 208
	PONTEIRO PARA ANTES         -               -             4 # pos_ini = 212
	PONTEIRO PARA PROXIMO       -               -             4 # pos_ini = 216
	TOTAL                                       151           220 (Arredondar para multiplo de 8)                   
*/


.section .data

	txtAbertura: 	 .asciz 	"\n*** Programa de Controle de Cadastro de Imobiliário para Locação (RA107115) ***\n"
	menu: 			 .asciz "\nMenu Principal:\n1- Inserção\n2- Remoção\n3- Consulta\n4- Gravar Cadastro\n5- Recuperar Cadastro\n6- Relatório de Registros\n7- Sair\n-> "

	# Pedindo Informações
	txtPedeNome: 	 		.asciz	"\nDigite o Nome: "
	txtPedeCPF:		 		.asciz	"Digite o CPF: "
	txtPedeTelefone: 		.asciz	"\nTelefone do Proprietario."
	txtPedeDDD: 	 		.asciz	"\nNumero DDD: "
	txtPedeTelefoneSemDDD:  .asciz	"Numero de Telefone: "
	txtPedeTipoImovel: 		.asciz "\nEscolha um Tipo de Imovel:\n<C> para Casa\n<A> para Apartamento\n-> "
	txtPedeEI:				.asciz	"\nEndereço do imóvel:\n"
	txtPedeCidade:			.asciz	"Cidade: "
	txtPedeBairro:			.asciz	"Bairro: "
	txtPedeRua:				.asciz	"Rua: "
	txtPedeNumero:			.asciz	"Número: "

	txtPedeNumeroQuartos:	.asciz	"\nNúmero de Quartos: "	
	txtPedeNumeroSuites:	.asciz	"Número de Suites: "

	txtPedeBanheiroSocial: 	.asciz "Possui Banheiro Social ? <1>Sim ou <0>Não: "
	txtPedeCozinha: 	   	.asciz "Possui Cozinha ? <1>Sim ou <0>Não: "
	txtPedeSala: 		   	.asciz "Possui Sala ? <1>Sim ou <0>Não: "
	txtPedeGaragem: 	   	.asciz "Possui Garagem ? <1>Sim ou <0>Não: "

	txtPedeMetragemTotal:  	.asciz "Qual a Metragem Total ? (Número Float Single): "
	txtPedeValorAluguel:   	.asciz "Qual o Valor do Aluguel ? (Número Float Single): "

	# Pedindo informações para consulta
	pedeNumComodosConsulta:	.asciz "\nQual é o número de Cômodos da casa ? Considerando ele igual á:\n(Num. Quartos + Num. Suites + BanheiroSocial + Cozinha + Sala + Garagem)\n=> "
	
	# Mostrando Informações
	txtMostraReg:			 .asciz	"\n///////Registro Lido n° %d///////\n"
	txtMostraRegConsult:	 .asciz	"\n///////Registro Consultado n° %d///////\n"
	txtMostraNome:			 .asciz	"Nome: %s"
	txtMostraCPF:			 .asciz	"CPF: %s"
	txtMostraDDDTelefone:	 .asciz	"\nTelefone com DDD: (%s) %s"
	txtMostraTipoImovel: 	 .asciz "\nTipo de Imovel: %s"
	txtMostraEI: 			 .asciz "\nCidade: %sBairro: %sRua: %s, N° %d"
	txtMostraNumeroQuartos:	 .asciz	"\nNúmero de Quartos: %d"	
	txtMostraNumeroSuites:	 .asciz	"\nNúmero de Suites: %d"
	txtMostraBanheiroSocial: .asciz "\nPossui Banheiro Social ?: %s"
	txtMostraCozinha: 	   	 .asciz "\nPossui Cozinha ?: %s"
	txtMostraSala: 		     .asciz "\nPossui Sala ?: %s"
	txtMostraGaragem: 	     .asciz "\nPossui Garagem ?: %s"
	txtMostraMetragemTotal:  .asciz "\nMetragem Total: %.4lf"
	txtMostraValorAluguel:   .asciz "\nValor do Aluguel: %.4lf"
	txtMostraNumeroComodos:  .asciz "\nNúmero de Cômodos: %d\n"

	# Para a Remoção
	txtPosicaoRemocao: 		.asciz "\nDigite a posição a ser removida\n=>"
	txtNaoAcheiPos: 		.asciz "\nPosição não encontrada\n"

	# Para o Relatorio
	txtMostraRelatorio:		.asciz	"\n////////////////////////////////////////////////////\n///////   INICIANDO IMPRESSÃO DO RELATÓRIO   ///////\n////////////////////////////////////////////////////\n"

	txtRegAnt: 	.asciz "\nRegAnt: %d\n"
	txtRegProx: .asciz "RegProx: %d\n"

	# Tratando caso 0
	txtZeroRemocao: 	.asciz "\nNão há registros para remover!\n"
	txtZeroConsulta: 	.asciz "\nNão há registros para consultar!\n"
	txtZeroRelatorio: 	.asciz "\nNão há registros para fazer um relatório!\n"
	
	# Para escrever o texto 'Sim' ou o texto 'Não'
	txtSim: .asciz "Sim"
	txtNao: .asciz "Nao"

	# Formato dos Tipos
	tipoNum: 		.asciz 	"%d"
	formatoFloatD: 	.asciz 	"%lf"
	pulaLinha: 		.asciz 	"\n"

	# Variaveis de controle
	escolha: 			.int 0
	numComodosAtual: 	.int 0
	possuiComodo: 		.int 0
	numComodosConsulta: .int 0
	posRemocao: 		.int 0

	# Controle dos registros, seu numero atual e contador
	numReg: 	.int    0
	countReg: 	.int    0

	# Salva o Endereço do Registrador que ele recebe de eax
	reg:		.space 	4 # Atual
	reg_ini:	.space 	4 # Inicial
	reg_ant:	.space 	4 # Elemento Anterior 
	reg_prox:	.space 	4 # Elemento Proximo 

	# Tamanho do registrador
	tamReg:  	.int 	220

	# Para apontar pra NULL
	NULL:		.int 	0

	
.section .text
.globl _start
_start:
	finit

	pushl	$txtAbertura
	call	printf
	addl	$4, %esp

_start_loop:

	pushl $menu
	call  printf

	pushl $escolha
	pushl $tipoNum
	call  scanf
	addl  $12, %esp

	# inserção
	cmpl $1, escolha
	je   _insercao

	# remoção
	cmpl $2, escolha
	je   _remocao

	# consulta
	cmpl $3, escolha
	je   _consulta

	# gravar cadastro
	cmpl $4, escolha
	je   _gravar_cadasdro

	# recuperar cadastro
	cmpl $5, escolha
	je   _recuperar_cadastro

	# relatório de registros
	cmpl $6, escolha
	je   _relatorio

	# finalizar
	cmpl $7, escolha
	je   fim

	jmp _start_loop

fim:
	pushl $0
	call  exit

_insercao:
	call leReg
	jmp  _start_loop

_remocao:
	# Primeiramente compara se o número de registros é
	# diferente de 0, se for 0 não há o que fazer 
	movl numReg, %eax
	cmpl $0, %eax
	je 	 _remove0
	call remocao
	jmp  _start_loop

_remove0:
	# Mostra mensage que não há registros para remover
	pushl $txtZeroRemocao
	call  printf
	addl  $4, %esp
	jmp   _start_loop

_consulta:
	# Primeiramente compara se o número de registros é
	# Diferente de 0, se for 0 não há o que fazer 
	movl numReg, %eax
	cmpl $0, %eax
	je 	 _consulta0
	call consulta
	jmp  _start_loop

_consulta0:
	# Mostra mensage que não há registros para consultar
	pushl $txtZeroConsulta
	call  printf
	addl  $4, %esp
	jmp   _start_loop

_gravar_cadasdro:
	# Não implementado :(
	jmp _start_loop

_recuperar_cadastro:
	# Não implementado :(
	jmp _start_loop

_relatorio:
	# Primeiramente compara se o número de registros é
	# Diferente de 0, se for 0 não há o que fazer 
	movl numReg, %eax
	cmpl $0, %eax
	je 	 _relatorio0
	call mostraReg
	jmp  _start_loop

_relatorio0:
	# Mostra mensage que não há registros para fazer relatorio
	pushl $txtZeroRelatorio
	call  printf
	addl  $4, %esp
	jmp   _start_loop

leReg:
	# Alocando o tamanho Necessario para o registro
	pushl	tamReg
	call	malloc
	movl	%eax, reg
	addl	$4, %esp

	cmpl 	$0, numReg # Compara para ver se é o primeiro registro
	jne 	leRegLoop
	movl	%eax, reg_ini # Se for o primeiro, salva em reg_ini para fazer a leitura depois

leRegLoop:
	# Nome, pos 0
	pushl	$txtPedeNome
	call	printf
	addl	$4, %esp

	pushl	stdin
	pushl	$32 # Enter + \0 = 30 caracteres no max 30
	movl	reg, %edi
	pushl	%edi
	call	fgets # Para tirar o enter da opção do menu
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp
	
	# Avança o tam de Nome
	addl	$32, %edi
	pushl	%edi

	# CPF, pos 32
	pushl	$txtPedeCPF
	call	printf
	addl	$4, %esp

	popl 	%edi
	pushl	stdin
	pushl	$16
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de CPF
	addl	$16, %edi
	pushl	%edi

	# pos 48
	# Celular do Proprietario, com DDD separado, depois da idade: 2+9 caracteres
	# consumindo  8(DDD) + 12(Telefone) = 20
	pushl	$txtPedeTelefone
	call	printf

	# DDD
	pushl	$txtPedeDDD
	call	printf
	addl	$8, %esp

	popl 	%edi
	pushl	stdin
	pushl	$8
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de DDD
	addl	$8, %edi
	pushl	%edi

	# Telefone, pos 56
	pushl	$txtPedeTelefoneSemDDD
	call	printf
	addl	$4, %esp

	popl	%edi
	pushl	stdin
	pushl	$12
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp
	
	# Avança o tam de Telefone
	addl	$12, %edi
	pushl	%edi

	# Tipo Imovel, , pos 68
	pushl	$txtPedeTipoImovel
	call	printf
	addl	$4, %esp

    popl	%edi
	pushl	stdin
	pushl	$4
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de Tipo Imovel
	addl	$4, %edi
	pushl	%edi

	# Endereço Imovel, pos 72
	pushl	$txtPedeEI
	call	printf

	# Cidade
	pushl	$txtPedeCidade
	call	printf
	addl	$8, %esp # Avança 8 por causa do push do txtPedeEI

	popl	%edi
	pushl	stdin
	pushl	$20
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de Cidade
	addl	$20, %edi
	pushl	%edi

	# Bairro, pos 92
	pushl	$txtPedeBairro
	call	printf
	addl	$4, %esp

	popl	%edi
	pushl	stdin
	pushl	$32
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de Bairro
	addl	$32, %edi
	pushl	%edi

	# Rua, pos 124
	pushl	$txtPedeRua
	call	printf
	addl	$4, %esp

	popl	%edi
	pushl	stdin
	pushl	$40
	pushl	%edi
	call	fgets

	# Desempilha %edi e limpa a pilha 
	popl	%edi
	addl	$8, %esp

	# Avança o tam de Rua
	addl	$40, %edi
	pushl	%edi

	# Número da Casa, pos 164
	pushl	$txtPedeNumero
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	addl	$4, %esp

	# Avança o tam de Número da Casa
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Número de Quartos, pos 168
	pushl	$txtPedeNumeroQuartos
	call	printf
	addl	$4, %esp

	# Pegando número de cômodos
	# número de quartos simples e de suites, se tem banheiro social, cozinha, sala e garagem,
	pushl	$numComodosAtual 
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Escreve em %edi o número de quartos
	movl 	numComodosAtual, %ebx
	movl 	%ebx, (%edi)

	# Avança o tam do número de Quartos
	popl	%edi
	addl	$4, %edi
	pushl	%edi
	
	# Número de Suites, pos 172
	pushl	$txtPedeNumeroSuites
	call	printf
	addl	$4, %esp

	# Backupando número de cômodos
	movl 	numComodosAtual, %eax
	pushl 	%eax

	pushl	$numComodosAtual
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Escreve em %edi o número de suites, utilizando numComodosAtual
	movl 	numComodosAtual, %ebx
	movl 	%ebx, (%edi)

	# Atualizando número de comodos
	popl 	%eax
	addl 	%eax, numComodosAtual 

	# Avança o tam do número de suites
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Banheiro Social, pos 176
	pushl	$txtPedeBanheiroSocial
	call	printf
	addl	$4, %esp

	# Armazena resposta de banheiro social em variavel .int para incrementar número de cômodos caso haja o cômodo
	pushl	$possuiComodo
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Por padrão ele não tem banheiro
	movl 	txtNao, %ebx

	# Se tiver banheiro social incrementa o numero de cômodos e escreve sim ao invés de não em %edi
	cmpl 	$0, possuiComodo
	je  	leReg_part2

	incl 	numComodosAtual
	movl 	txtSim, %ebx

leReg_part2:
	movl 	%ebx, (%edi) # Escreve sim ou não em %edi pra banheiro social

	# Avança o tam de Banheiro Social
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Cozinha, pos 180
	pushl	$txtPedeCozinha
	call	printf
	addl	$4, %esp

	# Armazena resposta de cozinha em variavel .int para incrementar número de cômodos caso haja o cômodo
	pushl	$possuiComodo
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Por padrão ele não tem cozinha
	movl 	txtNao, %ebx

	# Se tiver incrementa o numero de cômodos e escreve sim ao invés de não em %edi
	cmpl 	$1, possuiComodo
	jne  	leReg_part3

	incl 	numComodosAtual
	movl 	txtSim, %ebx

leReg_part3:
	movl 	%ebx, (%edi) # Escreve sim ou não em %edi pra cozinha

	# Avança o tam de Cozinha
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Sala, pos 184
	pushl	$txtPedeSala
	call	printf
	addl	$4, %esp

	# Armazena resposta de sala em variavel .int para incrementar número de cômodos caso haja o cômodo
	pushl	$possuiComodo
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Por padrão ele não tem sala
	movl 	txtNao, %ebx

	# Se tiver incrementa o numero de cômodos e escreve sim ao invés de não em %edi
	cmpl 	$1, possuiComodo
	jne  	leReg_part4

	incl 	numComodosAtual
	movl 	txtSim, %ebx

leReg_part4:
	movl 	%ebx, (%edi) # Escreve sim ou não em %edi pra sala
 
	# Avança o tam de Sala
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Garagem, pos 188
	pushl	$txtPedeGaragem
	call	printf
	addl	$4, %esp

	# Armazena resposta de garagem em variavel .int para incrementar número de cômodos caso haja o cômodo
	pushl	$possuiComodo
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	# Por padrão ele não tem garagem
	movl 	txtNao, %ebx

	# Se tiver incrementa o numero de cômodos e escreve sim ao invés de não em %edi
	cmpl 	$1, possuiComodo
	jne  	leReg_part5

	incl 	numComodosAtual
	movl 	txtSim, %ebx

leReg_part5:
	movl 	%ebx, (%edi) # Escreve sim ou não em %edi pra garagem
 
	# Avança o tam de Garagem
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Metragem Total, pos 192
	pushl	$txtPedeMetragemTotal
	call	printf

	pushl 	%edi 			# Aplica diretamente o valor em no endereço %edi
	pushl 	$formatoFloatD
	call 	scanf 			# le um valor em dupla precisao (8 bytes)
	addl 	$12, %esp 		# limpa a Pilha do Sistema de 3 pushls

	# Avança o tam de Metragem Total
	popl	%edi
	addl	$8, %edi
	pushl	%edi

	# Valor Aluguel, pos 200
	pushl	$txtPedeValorAluguel
	call	printf

	pushl 	%edi			# Aplica diretamente o valor em no endereço %edi
	pushl 	$formatoFloatD
	call 	scanf 			# le um valor em simples precisao (4 bytes)
	addl 	$12, %esp 		# limpa a Pilha do Sistema de 3 pushls

	# Avança o tam de Valor Aluguel
	popl	%edi
	addl	$8, %edi
	pushl	%edi

	# Escreve o numero de comodos total no registo, pos 208
	movl 	numComodosAtual, %ebx
	movl 	%ebx, (%edi)

	# Avança o tam de numero de comodos
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	cmpl 	$0, numReg 			# Compara para ver se é o primeiro registro
	je 		leReg_primeiraVez 	# Se for trata como a primeira vez
	jmp 	leReg_segundaOuMais # Se não trata como a segunda

leReg_primeiraVez:
	# pos 212
	# Escreve NULL que é .int 0 só para preencher algo no espaço do ponteiro, como é a primeira vez ele vai estar vazio
	movl 	$NULL, %ebx
	movl 	%ebx, (%edi)

	# Avança o tam do campo "ponteiro para o endereço anterior" 
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# pos 216
	# Escreve NULL que é .int 0 só para preencher algo no espaço do ponteiro, como é a primeira vez ele vai estar vazio
	#movl 	$NULL, %ebx
	movl 	%ebx, (%edi)

	# Avança o tam do campo "ponteiro para o proximo endereço" 
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# TOTAL = 220
	jmp 	leReg_partFinal

leReg_segundaOuMais:
	#/* TRECHO LEMBRETE     
	#208 -> Posição do campo "Número de Cômodos"
	#212 -> Posição do campo "Ponteiro Anterior"
	#216 -> Posição do campo "Ponteiro Proximo"
	#EDI -> ponteiro para o registro criado atualmente
	#EDX -> registro da fila
	#*/

	# AQUI %edi já está backupado na pilha
	# Vamos comparar o numero de comodos para poder inserir de forma ordenada
	# Lembrando que quando o programa chega aqui pelo menos 1 registro além do atual já foi inserido
	# a primeira vez já foi comparada acima de "leReg_primeiraVez"

	# O reg_ini é o primeiro registro, ele tem o menor numero de cômodos !
	movl	reg_ini, %edx

leReg_segOuMais_loop:
	
	# Avança direto para a posição de número dos cômodos
	addl 	$208, %edx

	# Transfere o valor do número de cômodos do registro criado atualmente para %eax e compara com
	# o valor do registro atual da fila para inseri-lo de forma crescente
	movl 	numComodosAtual, %eax 
	cmpl 	(%edx), %eax 		# %eax(é numComodosAtual) - (%edx)(é o registro da fila), ou seja entra em "leReg_CasoMaior" se o atual tiver mais comodos
	jg 	 	leReg_CasoMaior	

leReg_CasoMenor:
	# Quando o programa descobre que o numero do cômodos do registro criado atualmente é menor que
	# que o numero do cômodos do registro lido na fila, o programa irá inseri-lo na posição antecessor
	# a desse registro da fila.

	# Avança 4 para ir na posição do campo "ponteiro anterior" do registro da fila lido atualmente
	addl 	$4, %edx

	# Compara o valor do ponteiro anterior do registro da fila com zero para saber se é o primeiro registro
	movl 	$NULL, %ebx
	cmpl 	%ebx, (%edx) # AQUI ERA $0 ao invez de %ebx
	jne 	leReg_CasoMenor_NaoMenorCasoDeTodos

leReg_CasoMenor_MenorCasoDeTodos:
	# Como o registro atual é o menor, o registro da fila vira o proximo 
	movl 	reg_ini, %ebx
	movl 	%ebx, reg_prox

	# Como o registro criado atualmente é o com menor número de comodos de toda lista então ele virá o novo reg_ini !
	movl 	reg, %ebx
	movl 	%ebx, reg_ini

	# $NULL
	# A -> (0, B) <- é o inserido
	# B -> (A, C)

	# Move $NULL para o campo "ponteiro anterior" do registro atual
	movl 	$NULL, %ebx
	movl 	%ebx, (%edi)
	
	# Avança o tam do campo "ponteiro para o endereço anterior" do registro criado atualmente
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Seta o campo "ponteiro próximo" (do registro atual) com o valor do endereço do registro da fila
	movl 	reg_prox, %ebx
	movl 	%ebx, (%edi)

	# Avança o tam do campo "ponteiro para o endereço anterior" do registro criado atualmente
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Agora falta arrumar o registro da fila
	# Então eu coloco o registro atual (que é reg_ini pois é o menor) em %ebx
	movl 	reg_ini, %ebx

	# e escrevo ele no campo "ponteiro anterior" do registro da fila
	movl 	%ebx, (%edx)

	# Pronto !!! o registro foi inserido de forma ordenada, vamos para o final da criação do registro
	jmp 	leReg_partFinal

leReg_CasoMenor_NaoMenorCasoDeTodos:
	# A -> (?, B) # <- é o que vem antes do inserido
	# B -> (A, C) # <- é o inserido	
	# C -> (B, ?) # <- o que está na lista sendo comparado, o da fila

	# Primeiramente precisados dos Registros que vem antes e depois 
	# O registro que vem depois é o da lista
	# O registro que vem antes é o registro anterior o da lista
	movl (%edx), %eax # Joga o valor de memória do registro anterior da lista na variavel reg_ant
	movl %eax, reg_ant # agora temos o endereço do registro anterior
	addl $216, %eax # Avanço para a posição do campo "próximo registro" no registro anterior, que é o registro da fila (e de fato o próximo)
	movl (%eax), %ebx
	movl %ebx, reg_prox # agora temos o endereço do registro prox 

	# Sobre-escrevo o campo "próximo registro" do registro anterior com o endereço do registro atual
	movl reg, %ebx
	movl %ebx, (%eax)

	# Sobre-escrevo o campo "registro anterior" do registro proximo com o endereço do registro atual 
	movl %ebx, (%edx)

	# Movo o endereço do registro anterior para o campo de registro anterior do registro atual
	movl reg_ant, %ebx
	movl %ebx, (%edi)

	# Avança o tam do campo "ponteiro para o endereço anterior" do registro criado atualmente
	popl  %edi
	addl  $4, %edi
	pushl %edi

	# Movo o endereço do registro proximo para o campo de registro proximo do registro atual
	movl  reg_prox, %ebx
	movl  %ebx, (%edi)

	# Avança o tam do campo "ponteiro para o proximo endereço" do registro criado atualmente
	popl  %edi
	addl  $4, %edi
	pushl %edi

	jmp   leReg_partFinal

leReg_CasoMaior:
	# Caso for maior, avança direto para a posição do ponteiro seguinte
	addl  $8, %edx # pos 216

	# Compara ponteiro seguinte com $NULL para ver se esse é o maior registro
	movl  $NULL, %ebx
	cmpl  %ebx, (%edx)
	jne   leReg_CasoMaior_NaoMaiorDeTodos

leReg_CasoMaior_MaiorDeTodos:
	# Se apontar para $NULL isso significa que o registro atual é registro com o maior número de cômodos
	# então vamos inseri-lo como o "próximo" do registro da fila, colocar o registro da fila como o anterior
	# dele e depois aterrar o valor de próximo com $NULL e finalizar

	# Escrevo o registro criado atualmente como o próximo registro da fila
	movl  reg, %ebx
	movl  %ebx, (%edx)

	# Salvo o endereço inicial do registro da fila como "registro anterior" em reg_ant para escreve-lo no registro atual 
	subl  $216, %edx
	movl  %edx, reg_ant

	# Movo o endereço do registro anterior para o campo de registro anterior do registro atual
	movl  reg_ant, %ebx
	movl  %ebx, (%edi)

	# Avança o tam do campo "ponteiro para o endereço anterior" do registro criado atualmente
	popl  %edi
	addl  $4, %edi
	pushl %edi

	# Movo o endereço do registro proximo para o campo de registro proximo do registro atual
	movl  $NULL, %ebx
	movl  %ebx, (%edi)

	# Avança o tam do campo "ponteiro para o proximo endereço" do registro criado atualmente
	popl  %edi
	addl  $4, %edi
	pushl %edi

	jmp   leReg_partFinal

leReg_CasoMaior_NaoMaiorDeTodos:
	# Se não for $NULL, então ainda há mais registros que precisão ser feito a comparação
	# %edx recebe (%edx), isto é, ele avança para o próximo registro da lista
	movl  (%edx), %edx
	jmp   leReg_segOuMais_loop

leReg_partFinal:
	# Incrementa numero de registradores
	incl  numReg

	# Printa comodos para conferir
	pushl numComodosAtual
	pushl $txtMostraNumeroComodos
	call  printf
	addl  $8, %esp

	# Pula a linha
	pushl $pulaLinha
	call  printf
	addl  $4, %esp

	# POPL %edi
	popl  %edi

	RET

remocao:
	# Printa a mensagem de remoção e pede a posição a ser retirado
	pushl $txtPosicaoRemocao
	call  printf
	pushl $posRemocao
	pushl $tipoNum
	call  scanf
	addl  $12, %esp

	movl  $0, countReg # Contador
	movl  reg_ini, %edi # Reg ini

	# Tratando valor invalido, no caso os negativos
	cmpl  $0, posRemocao
	jle   remocao

remocao_Loop:
	# Primeiramente avançaremos até o registro especificado
	# 212 -> Posição do campo "Ponteiro Anterior"
	# 216 -> Posição do campo "Ponteiro Proximo"

	# Compare o registro atual com a posição a ser removida
	# Se achar ela remove !
	incl  countReg
	movl  countReg, %eax
	cmpl  %eax, posRemocao
	je    remover

	# Se não for ele procure até o final !
	addl  $216, %edi
	movl  (%edi), %edi

	# Compara o próximo com $NULL para ver se é o final
	movl  $NULL, %eax
	cmpl  %eax, %edi
	jne   remocao_Loop

	# Não achou !!!
	pushl $txtNaoAcheiPos
	call  printf
	addl  $4, %esp

	RET

remover:
	pushl %edi           # Posição a ser liberada pelo free
	addl  $212, %edi 	 # Avança até o campo "ponteiro anterior" do reg sendo removido 
	
	movl  $NULL, %ecx
	cmpl  %ecx, (%edi)
	jne   remover_Ant_NotNull
	je 	  remover_Ant_Null 

remover_Ant_Null:
	# Se for anterior for $NULL 
	movl  $NULL, %eax
	addl  $4, %edi       # Avança para a posição "ponteiro próximo" do reg sendo removido
	cmpl  %ecx, (%edi) 	 # Verifica se o próximo é $NULL também
	je 	  remover_Prox_Null 

	# Se não for null att reg_ini com o próximo da fila
	movl  (%edi), %edx
	movl  %edx, reg_ini

	jne   remover_Prox_NotNull

remover_Ant_NotNull:
	# Se for anterior não for $NULL 
	movl  (%edi), %eax   # Armazene ele em %eax
	addl  $216, %eax 	 # Avança para a posição "registro próximo" do registro anterior

	addl  $4, %edi       # Avança para a posição "ponteiro próximo" do reg sendo removido 
	cmpl  %ecx, (%edi) 	 # Verifica se o próximo é $NULL também
	jne   remover_Prox_NotNull
	je 	  remover_Prox_Null 

remover_Prox_Null:
	# Se for NULL
	movl  $NULL, %ebx
	jmp   remover_p2 
	
remover_Prox_NotNull:
	movl  (%edi), %ebx   # Armazene ele em %ebx	
	addl  $212, %ebx 	 # Avança para a posição "registro anterior" do registro próximo

remover_p2:
	# Reseta o valor de %edi
	popl  %edi
	pushl %edi  # para o call free

	# Fazendo a troca dos conteudos dos registradores
	addl  $212, %edi 	 # Avança até o campo "ponteiro anterior" do reg sendo removido

	# Se o segundo é $NULL o primeiro não troca
	cmpl  $NULL, %ebx
	je    pulaPrimeiro

	# Troca o "registro anterior" do registro próximo com o "registro anterior" do registro sendo removido
	movl  (%edi), %edx
	xchgl %edx, (%ebx)

pulaPrimeiro:
	addl  $4, %edi 		 # Avança para a posição "ponteiro próximo" do reg sendo removido 

	# Se o primeiro é $NULL o segundo não troca
	cmpl  $NULL, %eax
	je    pulaSegundo

	# Troca o "registro próximo" do registro anterior com o "registro próximo" do registro sendo removido
	movl  (%edi), %edx
	xchgl %edx, (%eax)

pulaSegundo:
	call  free 			 # Libera a memória
	decl  numReg 		 # Diminui o número total de registradores

	addl  $4, %esp 		 # Remove o pushl do %edi que não tem mais significado

	RET

consulta:
	pushl $pedeNumComodosConsulta
	call  printf
	pushl $numComodosConsulta
	pushl $tipoNum
	call  scanf
	addl  $12, %esp

	movl  $0, countReg # Contador
	movl  reg_ini, %edi # Reg ini

consulta_Loop:
	# Primeiramente avançaremos para o número de Cômodos
	# 208 -> Posição do campo "Número de Cômodos"
	# 212 -> Posição do campo "Ponteiro Anterior"
	# 216 -> Posição do campo "Ponteiro Proximo"
	pushl %edi # Backupa %edi na posição 0
	addl  $208, %edi

	# Compara
	movl  (%edi), %eax
	movl  numComodosConsulta, %ebx
	cmpl  %ebx, %eax
	je 	  exibir

	# Se não for igual
	popl  %edi
	addl  $212, %edi # 208 + 4 = 212
	pushl %edi

consulta_Loop_part2:
	# Se não for igual ou se terminou de printar vai para o próximo registro 
	# e faz isso até o fim
	
	# Avança para a posição do próximo
	popl  %edi
	addl  $4, %edi

	# Acessa o valor do endereço do próximo
	movl  (%edi), %edi

	# Finaliza se apontar para 0, se não faz de novo
	cmpl  $NULL, %edi # 0x0 ou $0
	jne   consulta_Loop

	# Pula a linha
	pushl $pulaLinha
	call  printf
	addl  $4, %esp

	RET

exibir:
	# Pula a linha
	pushl $pulaLinha
	call  printf
	addl  $4, %esp

	# Sempre incrementa o número de registradores no começo
	incl  countReg

	pushl countReg
	pushl $txtMostraRegConsult
	call  printf
	addl  $8, %esp

	# Mostra Nome, pos 0
	# %edi já foi salvo antes
	pushl $txtMostraNome
	call  printf
	addl  $4, %esp

	# Avança o tam de Nome
	popl  %edi
	addl  $32, %edi
	
	# Mostra CPF, pos 32
	pushl %edi
	pushl $txtMostraCPF
	call  printf
	addl  $4, %esp

	# Avança tam de CPF
	popl  %edi
	addl  $16, %edi

	# Mostra Telefone, pos 48
	# DDD
	movl  %edi, %eax
	addl  $8, %edi
	# Telefone
	movl  %edi, %ebx
	addl  $12, %edi

	pushl %edi # Salva %edi antes
	pushl %ebx
	pushl %eax
	pushl $txtMostraDDDTelefone
	call  printf
	addl  $12, %esp

	# Mostrar Tipo Imovel, pos 68
	# %edi já incrementado e pronto
	pushl $txtMostraTipoImovel
	call  printf
	addl  $4, %esp

	# Avança o tam de Imovel
	popl  %edi
	addl  $4, %edi

	# Endereço imovel, pos 72
	# Cidade
	movl  %edi, %eax
	addl  $20, %edi
	# Bairro
	movl  %edi, %ebx
	addl  $32, %edi
	# Rua
	movl  %edi, %ecx
	addl  $40, %edi
	# Numero
	movl  (%edi), %edx
	addl  $4, %edi

	pushl %edi # Salva %edi antes
	pushl %edx
	pushl %ecx
	pushl %ebx
	pushl %eax
	pushl $txtMostraEI
	call  printf
	addl  $20, %esp
	
	# Mostra Numero de Quartos, pos 168
	# %edi já ta salvo
	pushl (%edi)
	pushl $txtMostraNumeroQuartos
	call  printf
	addl  $8, %esp # tem q limpar (%edi)

	# Avança tam de Numero de Quartos
	popl  %edi
	addl  $4, %edi
	
	# Mostra Numero de Suites, pos 172
	pushl %edi
	pushl (%edi)
	pushl $txtMostraNumeroSuites
	call  printf
	addl  $8, %esp # tem q limpar (%edi)

	# Avança tam de Numero de Suites
	popl  %edi
	addl  $4, %edi
	
	# Mostra Banheiro Social, pos 176
	pushl %edi
	pushl $txtMostraBanheiroSocial
	call  printf
	addl  $4, %esp

	# Avança tam de Banheiro Social
	popl  %edi
	addl  $4, %edi

	# Mostra Cozinha, pos 180
	pushl %edi
	pushl $txtMostraCozinha
	call  printf
	addl  $4, %esp

	# Avança tam de Cozinha
	popl  %edi
	addl  $4, %edi

	# Mostra Sala, pos 184
	pushl %edi
	pushl $txtMostraSala
	call  printf
	addl  $4, %esp

	# Avança tam de Sala
	popl  %edi
	addl  $4, %edi

	# Mostra Garagem, pos 188
	pushl %edi
	pushl $txtMostraGaragem
	call  printf
	addl  $4, %esp

	# Avança tam de Garagem
	popl  %edi
	addl  $4, %edi

	# Mostra Metragem Total, pos 192
	pushl %edi			# Backup %edi

	fldl  (%edi) 		# Carrega o valor float(double) do endereço %edi no topo da Pilha PFU, convertendo 8 bytes em 80 bits
	subl  $8, %esp 		# Abre espaco de 8 bytes no topo da Pilha do Sistema
	fstpl (%esp) 		# Copia do topo da pilha PFU para o topo da Pilha do Sistema, convertendo 80 bits em 8 bytes e depois tira do topo da pilha PFU
	pushl $txtMostraMetragemTotal
	call  printf
	addl  $12, %esp 	# Remove a msg e $txtMostraMetragemTotal (4 bytes) e o valor float da pilha (8 bytes)

	# Avança tam de Metragem Total
	popl  %edi
	addl  $8, %edi

	# Mostra Valor Aluguel, pos 200
	pushl %edi			# Backup %edi

	fldl  (%edi) 		# Carrega o valor float(double) do endereço %edi no topo da Pilha PFU, convertendo 8 bytes em 80 bits
	subl  $8, %esp 		# Abre espaco de 8 bytes no topo da Pilha do Sistema
	fstpl (%esp) 		# Copia do topo da pilha PFU para o topo da Pilha do Sistema, convertendo 80 bits em 8 bytes e depois tira do topo da pilha PFU
	pushl $txtMostraValorAluguel
	call  printf
	addl  $12, %esp 	# Remove a msg e $txtMostraValorAluguel (4 bytes) e o valor float da pilha (8 bytes)

	# Avança tam de Valor Aluguel
	popl  %edi
	addl  $8, %edi

	# Removi o mov do EAX

	# Número de Cômodos, pos 208
	pushl %edi		# Backup %edi
	pushl (%edi)     
	pushl $txtMostraNumeroComodos
	call  printf
	addl  $8, %esp 	# tem q limpar (%edi)

	# Avança tam de Número de Cômodos
	popl  %edi
	addl  $4, %edi
	pushl %edi

	# Pula a linha
	pushl $pulaLinha
	call  printf
	addl  $4, %esp

	jmp   consulta_Loop_part2

mostraReg: 
	# Mostra mensagem de começo do relatório
	pushl $txtMostraRelatorio
	call  printf
	addl  $4, %esp

	# Relatorio de Registros
	movl  $0, countReg # Contador
	movl  reg_ini, %edi # Registro inicial. pos 0
	pushl %edi

mostraRegLoop:
	# Sempre incrementa no começo
	incl  countReg

	pushl countReg
	pushl $txtMostraReg
	call  printf
	addl  $8, %esp

	# Mostra Nome, pos 0
	# %edi já foi salvo antes
	pushl $txtMostraNome
	call  printf
	addl  $4, %esp

	# Avança o tam de Nome
	popl  %edi
	addl  $32, %edi
	
	# Mostra CPF, pos 32
	pushl %edi
	pushl $txtMostraCPF
	call  printf
	addl  $4, %esp

	# Avança tam de CPF
	popl  %edi
	addl  $16, %edi

	# Mostra Telefone, pos 48
	# DDD
	movl  %edi, %eax
	addl  $8, %edi
	# Telefone
	movl  %edi, %ebx
	addl  $12, %edi

	pushl %edi # Salva %edi antes
	pushl %ebx
	pushl %eax
	pushl $txtMostraDDDTelefone
	call  printf
	addl  $12, %esp

	# Mostrar Tipo Imovel, pos 68
	# %edi já incrementado e pronto
	pushl $txtMostraTipoImovel
	call  printf
	addl  $4, %esp

	# Avança o tam de Imovel
	popl  %edi
	addl  $4, %edi

	# Endereço imovel, pos 72
	# Cidade
	movl  %edi, %eax
	addl  $20, %edi
	# Bairro
	movl  %edi, %ebx
	addl  $32, %edi
	# Rua
	movl  %edi, %ecx
	addl  $40, %edi
	# Numero
	movl  (%edi), %edx
	addl  $4, %edi

	pushl %edi # Salva %edi antes
	pushl %edx
	pushl %ecx
	pushl %ebx
	pushl %eax
	pushl $txtMostraEI
	call  printf
	addl  $20, %esp
	
	# Mostra Numero de Quartos, pos 168
	# %edi já ta salvo
	pushl (%edi)
	pushl $txtMostraNumeroQuartos
	call  printf
	addl  $8, %esp # tem q limpar (%edi)

	# Avança tam de Numero de Quartos
	popl  %edi
	addl  $4, %edi
	
	# Mostra Numero de Suites, pos 172
	pushl %edi
	pushl (%edi)
	pushl $txtMostraNumeroSuites
	call  printf
	addl  $8, %esp # tem q limpar (%edi)

	# Avança tam de Numero de Suites
	popl  %edi
	addl  $4, %edi
	
	# Mostra Banheiro Social, pos 176
	pushl %edi
	pushl $txtMostraBanheiroSocial
	call  printf
	addl  $4, %esp

	# Avança tam de Banheiro Social
	popl  %edi
	addl  $4, %edi

	# Mostra Cozinha, pos 180
	pushl %edi
	pushl $txtMostraCozinha
	call  printf
	addl  $4, %esp

	# Avança tam de Cozinha
	popl  %edi
	addl  $4, %edi

	# Mostra Sala, pos 184
	pushl %edi
	pushl $txtMostraSala
	call  printf
	addl  $4, %esp

	# Avança tam de Sala
	popl  %edi
	addl  $4, %edi

	# Mostra Garagem, pos 188
	pushl %edi
	pushl $txtMostraGaragem
	call  printf
	addl  $4, %esp

	# Avança tam de Garagem
	popl  %edi
	addl  $4, %edi
	
	# Mostra Metragem Total, pos 192
	pushl %edi		# Backup %edi

	fldl  (%edi) 		# Carrega o valor float(double) do endereço %edi no topo da Pilha PFU, convertendo 4 bytes em 80 bits
	subl  $8, %esp 		# Abre espaco de 8 bytes no topo da Pilha do Sistema
	fstpl (%esp) 		# Copia do topo da pilha PFU para o topo da Pilha do Sistema, convertendo 80 bits em 8 bytes e remove o valor da pilha PFU
	pushl $txtMostraMetragemTotal
	call  printf
	addl  $12, %esp 	# Remove a msg e $txtMostraMetragemTotal (4 bytes) e o valor float da pilha (8 bytes)

	# Avança tam de Metragem Total
	popl  %edi
	addl  $8, %edi

	# Mostra Valor Aluguel, pos 200
	pushl %edi		# Backup %edi

	fldl  (%edi) 		# Carrega o valor float(double) do endereço %edi no topo da Pilha PFU, convertendo 4 bytes em 80 bits
	subl  $8, %esp 		# Abre espaco de 8 bytes no topo da Pilha do Sistema
	fstpl (%esp) 		# Copia do topo da pilha PFU para o topo da Pilha do Sistema, convertendo 80 bits em 8 bytes e remove o valor da pilha PFU
	pushl $txtMostraValorAluguel
	call  printf
	addl  $12, %esp 	# Remove a msg e $txtMostraValorAluguel (4 bytes) e o valor float da pilha (8 bytes)

	# Avança tam de Valor Aluguel
	popl  %edi
	addl  $8, %edi

	# Número de Cômodos, pos 208
	pushl %edi		# Backup %edi
	pushl (%edi)
	pushl $txtMostraNumeroComodos
	call  printf
	addl  $8, %esp # tem q limpar (%edi)

	# Avança tam de Número de Cômodos
	popl  %edi
	addl  $4, %edi

	# Aqui estamos na posição 212, a do campo "ponteiro para o registro anterior" do registro que foi impreso
	# ele não é interessante para nós então vamos pular para o proximo registro a ser impreso colocar seu
	# endereço em %edx e voltar no loop para imprimir o próximo como %edi

	# Esse trecho de código a seguir Printa o valor do endereço de memória do registro anterior
	# pushl %edi
	# pushl (%edi)
	# pushl $txtRegAnt
	# call  printf
	# addl  $8, %esp
	# popl  %edi

	addl  $4, %edi

	# Esse trecho de código a seguir Printa o valor do endereço de memória do próximo registro
	# pushl %edi
	# pushl (%edi)
	# pushl $txtRegProx
	# call  printf
	# addl  $8, %esp
	# popl  %edi

	movl  (%edi), %edi
	pushl %edi

	# Compara %edi com $NULL para saber se é o ultimo
	cmpl $NULL, %edi
	jne mostraRegLoop

	# POPL %edi
	popl %edi

	RET
