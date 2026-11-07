
USE erp_industrial_analytics;

SELECT
    p.codigo_produto,
    p.descricao,
    p.unidade_medida,

    COUNT(me.id_movimentacao) AS total_movimentacoes,

    COALESCE(
        SUM(
            CASE
                WHEN me.tipo_movimentacao = 'ENTRADA'
                THEN me.quantidade
                ELSE 0
            END
        ), 0
    ) AS total_entradas,

    COALESCE(
        SUM(
            CASE
                WHEN me.tipo_movimentacao = 'SAIDA'
                THEN me.quantidade
                ELSE 0
            END
        ), 0
    ) AS total_saidas,

    COALESCE(
        SUM(
            CASE
                WHEN me.tipo_movimentacao = 'ENTRADA'
                    THEN me.quantidade
                WHEN me.tipo_movimentacao = 'SAIDA'
                    THEN -me.quantidade
                ELSE 0
            END
        ), 0
    ) AS saldo_liquido_movimentacoes

FROM produtos p

LEFT JOIN movimentacoes_estoque me
    ON p.id_produto = me.id_produto

WHERE p.controla_estoque = 1

GROUP BY
    p.id_produto,
    p.codigo_produto,
    p.descricao,
    p.unidade_medida

ORDER BY total_movimentacoes DESC;
