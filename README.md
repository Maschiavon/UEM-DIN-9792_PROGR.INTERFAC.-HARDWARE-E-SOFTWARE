# UEM-DIN-9792_PROGR.INTERFAC.-HARDWARE-E-SOFTWARE
Um repositório para os trabalhos e exercicios realizados para a conclusão da disciplina programação de interface de hardware e software da Universidade estadual de Maringá (UEM)

## Trabalho 2

ENUNCIADO

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

ORGANIZAÇÃO DOS DADOS é descrita dentro do arquivo Trabalho2PIHS.s
