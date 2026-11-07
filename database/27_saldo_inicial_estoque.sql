
-- Projeto: ERP Industrial Analytics
-- Registro do saldo inicial ficticio
-- Data anterior ao inicio da producao

USE erp_industrial_analytics;

INSERT INTO movimentacoes_estoque (
    id_produto,
    tipo_movimentacao,
    origem_movimentacao,
    quantidade,
    data_movimentacao,
    documento_referencia,
    observacao
)

SELECT
    p.id_produto,
    'ENTRADA',
    'AJUSTE',
    dados.quantidade,
    '2026-11-03 07:00:00',
    dados.documento_referencia,
    'Saldo inicial ficticio para abertura do historico'

FROM (

    SELECT
        'MAT-0001' AS codigo_produto,
        30.450 AS quantidade,
        'SALDO-INI-2026-MAT-0001' AS documento_referencia

    UNION ALL

    SELECT
        'MAT-0002',
        119.480,
        'SALDO-INI-2026-MAT-0002'

) AS dados

INNER JOIN produtos p
    ON p.codigo_produto = dados.codigo_produto

WHERE p.controla_estoque = 1

AND NOT EXISTS (
    SELECT 1
    FROM movimentacoes_estoque me
    WHERE me.id_produto = p.id_produto
      AND me.documento_referencia = dados.documento_referencia
);
