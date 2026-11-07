
USE erp_industrial_analytics;

-- 1. Necessidade total das ordens de producao

WITH necessidade_materiais AS (

    SELECT
        componente.id_produto,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida,

        SUM(
            op.quantidade_planejada
            * ep.quantidade_por_unidade
            * (1 + ep.percentual_perda / 100)
        ) AS necessidade_total

    FROM ordens_producao op

    INNER JOIN estrutura_produto ep
        ON op.id_produto = ep.id_produto_pai

    INNER JOIN produtos componente
        ON ep.id_produto_componente = componente.id_produto

    WHERE op.status_ordem IN (
        'PLANEJADA',
        'LIBERADA',
        'EM_PRODUCAO'
    )

    GROUP BY
        componente.id_produto,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida
),

-- 2. Saldo atual calculado pelas movimentacoes

saldo_estoque AS (

    SELECT
        p.id_produto,

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
        ) AS saldo_disponivel

    FROM produtos p

    LEFT JOIN movimentacoes_estoque me
        ON p.id_produto = me.id_produto

    WHERE p.controla_estoque = 1

    GROUP BY p.id_produto
)

-- 3. Comparacao entre necessidade e disponibilidade

SELECT
    nm.codigo_produto,
    nm.descricao,
    nm.unidade_medida,

    ROUND(nm.necessidade_total, 3)
        AS necessidade_total,

    ROUND(se.saldo_disponivel, 3)
        AS estoque_disponivel,

    ROUND(
        GREATEST(
            nm.necessidade_total - se.saldo_disponivel,
            0
        ),
        3
    ) AS quantidade_em_falta,

    CASE
        WHEN se.saldo_disponivel >= nm.necessidade_total
            THEN 'MATERIAL SUFICIENTE'
        ELSE 'NECESSITA REPOSICAO'
    END AS situacao

FROM necessidade_materiais nm

INNER JOIN saldo_estoque se
    ON nm.id_produto = se.id_produto

ORDER BY nm.codigo_produto;
