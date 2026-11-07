
USE erp_industrial_analytics;

WITH producao_real AS (

    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto,

        COALESCE(
            SUM(ap.quantidade_produzida), 0
        ) AS quantidade_produzida

    FROM ordens_producao op

    LEFT JOIN apontamentos_producao ap
        ON op.id_ordem_producao = ap.id_ordem_producao

    GROUP BY
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto
),

consumo_previsto AS (

    SELECT
        pr.id_ordem_producao,
        pr.codigo_ordem,
        ep.id_produto_componente AS id_materia_prima,

        ROUND(
            pr.quantidade_produzida
            * ep.quantidade_por_unidade
            * (1 + ep.percentual_perda / 100),
            3
        ) AS quantidade_prevista

    FROM producao_real pr

    INNER JOIN estrutura_produto ep
        ON pr.id_produto = ep.id_produto_pai
),

consumo_real AS (

    SELECT
        id_ordem_producao,
        id_produto AS id_materia_prima,

        ROUND(SUM(quantidade), 3)
            AS quantidade_consumida

    FROM movimentacoes_estoque

    WHERE origem_movimentacao = 'PRODUCAO'
      AND tipo_movimentacao = 'SAIDA'
      AND id_ordem_producao IS NOT NULL

    GROUP BY
        id_ordem_producao,
        id_produto
)

SELECT
    cp.codigo_ordem,
    p.codigo_produto,
    p.descricao AS materia_prima,
    p.unidade_medida,

    cp.quantidade_prevista,

    COALESCE(
        cr.quantidade_consumida, 0
    ) AS quantidade_consumida,

    ROUND(
        COALESCE(cr.quantidade_consumida, 0)
        - cp.quantidade_prevista,
        3
    ) AS diferenca_consumo,

    CASE
        WHEN cr.quantidade_consumida IS NULL
            THEN 'SEM MOVIMENTACAO'

        WHEN ABS(
            cr.quantidade_consumida
            - cp.quantidade_prevista
        ) <= 0.001
            THEN 'DENTRO DO PADRAO'

        WHEN cr.quantidade_consumida
             > cp.quantidade_prevista
            THEN 'CONSUMO ACIMA DO PREVISTO'

        ELSE 'CONSUMO ABAIXO DO PREVISTO'
    END AS situacao_consumo

FROM consumo_previsto cp

INNER JOIN produtos p
    ON cp.id_materia_prima = p.id_produto

LEFT JOIN consumo_real cr
    ON cp.id_ordem_producao = cr.id_ordem_producao
    AND cp.id_materia_prima = cr.id_materia_prima

ORDER BY
    cp.codigo_ordem,
    p.codigo_produto;
