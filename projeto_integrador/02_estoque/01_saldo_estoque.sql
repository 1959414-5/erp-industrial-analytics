
USE erp_industrial_analytics;

SELECT
    codigo_produto,
    descricao,
    unidade_medida,
    estoque_minimo,
    saldo_atual,

    ROUND(
        saldo_atual - estoque_minimo,
        3
    ) AS diferenca_estoque,

    CASE
        WHEN saldo_atual = 0
            THEN 'SEM ESTOQUE'

        WHEN saldo_atual < estoque_minimo
            THEN 'ABAIXO DO MINIMO'

        ELSE 'ESTOQUE NORMAL'
    END AS classificacao_estoque,

    GREATEST(
        estoque_minimo - saldo_atual,
        0
    ) AS quantidade_repor

FROM vw_saldo_estoque

ORDER BY
    CASE
        WHEN saldo_atual = 0 THEN 1
        WHEN saldo_atual < estoque_minimo THEN 2
        ELSE 3
    END,
    codigo_produto;
