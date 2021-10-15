# SME0110 - Programação Matemática

## Grupo 13
Gabriel dos Reis Coutinho - 9807124

Frederico Bulhões de Souza Ribeiro - 11208440

Maria Eduarda Kawakami Moreira - 11218751

Matheus Barcellos de Castro Cunha - 11208238

Gustavo Tuani Mastrobuono - 10734411

Juliana Perfeito dos Santos - 10295141

## Algoritmos
Todos os algoritmos implementados nesse trabalho estão contidos dentro de um .ipynb, i.e. um jupyter notebook, logo para executa-los sugerimos usar o Jupyter Notebook. 

Aqui temos notebooks de:
 - Setup: 
  * 0 - Setup.ipynb -> instalar pacotes necessários
 - Modelagem:
  * 1 - Modelo.ipynb -> Modelagem genérica do problema em questão
 - Toy problem:
  * 2 - Toy Problem.ipynb -> Modelagem de um problema exemplo de designação
 - Resoluções de instâncias:
  * 3 - CBC-A.ipynb
  * 3 - CBC-B.ipynb
  * 3 - Gurobi-A.ipynb
  * 3 - Gurobi-B.ipynb
  * 3 - Hungaro-A.ipynb
  * 3 - Hungaro-B.ipynb


### Passo a passo para execução
#### 1º passo
O primeiro passo seria executar a celula contida no arquivo "0 - Setup.ipynb" para poder instalar todos os pacotes usados durante a implementação dos algoritmos.

#### 2º passo
Agora todos os notebooks subsequentes podem ser executados sem problema algum.

## Resultados das execuções
Como resultado das execuções, nós guardamos as seguintes informações convenientemente dentro de arquivos .csv:
 - file_name (Nome do arquivo da instância)
 - agents_number (Quantidade de agentes da instância)
 - solve_time (Tempo decorrido para o solver resolver a instância)
 - is_optimal_solution (É uma solução ótima) (Não disponível para o solver hungáro)
 - solution (Melhor solução encontrada)
 