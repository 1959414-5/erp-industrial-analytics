
# Benchmark de Otimização de Índices — MySQL

## Objetivo
Avaliar o impacto de índices simples e compostos
na consulta de movimentações de estoque.

## Ambiente
- MySQL Server 8.4.13
- Engine: InnoDB
- Registros: 100.000
- Dados: inteiramente fictícios
- Ferramenta: MySQL Workbench

## Consulta avaliada
Filtros por:
- id_produto
- origem_movimentacao
- data_movimentacao

Ordenação por data_movimentacao.

## Resultados

| Cenário | Linhas examinadas | Tempo observado |
|---|---:|---:|
| Sem índice secundário | 100.000 | 41,2 ms |
| Índice simples | 1.000 | 1,61 ms |
| Índice composto | 31 | 0,0916 ms |

## Índice composto avaliado

CREATE INDEX idx_bench_produto_origem_data
ON benchmark_movimentacoes (
    id_produto,
    origem_movimentacao,
    data_movimentacao
);

## Conclusão

O índice composto permitiu utilizar os três filtros
na busca por intervalo, reduzir a quantidade de
registros examinados e eliminar a operação Sort
no plano de execução observado.

O otimizador escolheu automaticamente o índice
composto após a atualização das estatísticas.

Os tempos são medições pontuais e não representam
uma garantia de desempenho em produção.
