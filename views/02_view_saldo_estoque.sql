
USE erp_industrial_analytics;

CREATE OR REPLACE VIEW vw_saldo_estoque AS

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
    ) AS saldo_atual,

    CASE
        WHEN COALESCE(
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
        ) < p.estoque_minimo
        THEN 'ABAIXO DO MINIMO'

        ELSE 'ESTOQUE NORMAL'
    END AS status_estoque

FROM produtos p

LEFT JOIN movimentacoes_estoque me
    ON p.id_produto = me.id_produto

WHERE p.controla_estoque = 1

GROUP BY
    p.id_produto,
    p.codigo_produto,
    p.descricao,
    p.unidade_medida,
    p.estoque_minimo;
