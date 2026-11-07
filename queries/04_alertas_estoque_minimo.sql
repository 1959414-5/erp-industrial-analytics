
USE erp_industrial_analytics;

WITH saldo_estoque AS (

    SELECT
        p.id_produto,
        p.codigo_produto,
        p.descricao,
        p.unidade_medida,
        p.estoque_minimo,

        COALESCE(
            SUM(
                CASE
                    WHEN me.tipo_movimentacao = 'ENTRADA'
                        THEN me.quantidade

                    WHEN me.tipo_movimentacao = 'SAIDA'
                        THEN -me.quantidade

                    ELSE 0
                END
            ),
            0
        ) AS saldo_atual

    FROM produtos p

    LEFT JOIN movimentacoes_estoque me
        ON p.id_produto = me.id_produto

    WHERE p.controla_estoque = 1
      AND p.ativo = 1

    GROUP BY
        p.id_produto,
        p.codigo_produto,
        p.descricao,
        p.unidade_medida,
        p.estoque_minimo
)

SELECT
    codigo_produto,
    descricao,
    unidade_medida,
    estoque_minimo,
    saldo_atual,

    CASE
        WHEN saldo_atual < estoque_minimo
            THEN 'ABAIXO DO MINIMO'
        ELSE 'ESTOQUE NORMAL'
    END AS status_estoque,

    GREATEST(
        estoque_minimo - saldo_atual,
        0
    ) AS quantidade_sugerida_reposicao

FROM saldo_estoque

ORDER BY
    CASE
        WHEN saldo_atual < estoque_minimo THEN 0
        ELSE 1
    END,
    codigo_produto;
