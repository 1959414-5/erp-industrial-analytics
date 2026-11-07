
USE erp_industrial_analytics;

EXPLAIN ANALYZE

SELECT
    p.codigo_produto,
    p.descricao,
    me.tipo_movimentacao,
    me.quantidade,
    me.data_movimentacao

FROM movimentacoes_estoque me

INNER JOIN produtos p
    ON me.id_produto = p.id_produto

WHERE me.id_produto = 1
  AND me.data_movimentacao >= '2026-11-01 00:00:00'

ORDER BY me.data_movimentacao;
