
USE erp_industrial_analytics;

WITH producao_pendente AS (

    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto,

        GREATEST(
            op.quantidade_planejada
            - COALESCE(SUM(ap.quantidade_produzida), 0),
            0
        ) AS quantidade_pendente

    FROM ordens_producao op

    LEFT JOIN apontamentos_producao ap
        ON op.id_ordem_producao = ap.id_ordem_producao

    WHERE op.status_ordem NOT IN ('CONCLUIDA', 'CANCELADA')

    GROUP BY
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto,
        op.quantidade_planejada

    HAVING quantidade_pendente > 0
),

demanda_materiais AS (

    SELECT
        ep.id_produto_componente AS id_produto,

        ROUND(
            SUM(
                pp.quantidade_pendente
                * ep.quantidade_por_unidade
                * (1 + ep.percentual_perda / 100)
            ),
            3
        ) AS necessidade_total

    FROM producao_pendente pp

    INNER JOIN estrutura_produto ep
        ON pp.id_produto = ep.id_produto_pai

    GROUP BY ep.id_produto_componente
),

saldo_estoque AS (

    SELECT
        id_produto,

        ROUND(
            SUM(
                CASE
                    WHEN tipo_movimentacao = 'ENTRADA'
                        THEN quantidade
                    WHEN tipo_movimentacao = 'SAIDA'
                        THEN -quantidade
                    ELSE 0
                END
            ),
            3
        ) AS saldo_atual

    FROM movimentacoes_estoque

    GROUP BY id_produto
)

SELECT
    p.codigo_produto,
    p.descricao,
    p.unidade_medida,

    dm.necessidade_total,

    COALESCE(se.saldo_atual, 0)
        AS estoque_disponivel,

    GREATEST(
        dm.necessidade_total - COALESCE(se.saldo_atual, 0),
        0
    ) AS quantidade_em_falta,

    CASE
        WHEN COALESCE(se.saldo_atual, 0) >= dm.necessidade_total
            THEN 'MATERIAL SUFICIENTE'
        ELSE 'NECESSITA REPOSICAO'
    END AS situacao

FROM demanda_materiais dm

INNER JOIN produtos p
    ON dm.id_produto = p.id_produto

LEFT JOIN saldo_estoque se
    ON dm.id_produto = se.id_produto

ORDER BY quantidade_em_falta DESC;
