
USE erp_industrial_analytics;

-- 1. Consolidar producao realizada por ordem

WITH producao_por_ordem AS (

    SELECT
        id_ordem_producao,
        SUM(quantidade_produzida) AS total_produzido

    FROM apontamentos_producao

    GROUP BY id_ordem_producao
),

-- 2. Identificar quantidade ainda nao produzida

ordens_pendentes AS (

    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto,

        GREATEST(
            op.quantidade_planejada
            - COALESCE(pp.total_produzido, 0),
            0
        ) AS quantidade_restante

    FROM ordens_producao op

    LEFT JOIN producao_por_ordem pp
        ON op.id_ordem_producao = pp.id_ordem_producao

    WHERE op.status_ordem IN (
        'PLANEJADA',
        'LIBERADA',
        'EM_PRODUCAO'
    )

),

-- 3. Calcular necessidade de materias-primas

necessidade_materiais AS (

    SELECT
        componente.id_produto,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida,

        SUM(
            op.quantidade_restante
            * ep.quantidade_por_unidade
            * (1 + ep.percentual_perda / 100)
        ) AS necessidade_restante

    FROM ordens_pendentes op

    INNER JOIN estrutura_produto ep
        ON op.id_produto = ep.id_produto_pai

    INNER JOIN produtos componente
        ON ep.id_produto_componente = componente.id_produto

    WHERE componente.controla_estoque = 1
      AND op.quantidade_restante > 0

    GROUP BY
        componente.id_produto,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida
),

-- 4. Calcular saldo atual do estoque

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
      AND p.ativo = 1

    GROUP BY p.id_produto
)

-- 5. Comparar necessidade restante com estoque

SELECT
    nm.codigo_produto,
    nm.descricao,
    nm.unidade_medida,

    ROUND(nm.necessidade_restante, 3)
        AS necessidade_restante,

    ROUND(se.saldo_disponivel, 3)
        AS estoque_disponivel,

    ROUND(
        GREATEST(
            nm.necessidade_restante - se.saldo_disponivel,
            0
        ),
        3
    ) AS quantidade_em_falta,

    ROUND(
        se.saldo_disponivel - nm.necessidade_restante,
        3
    ) AS saldo_projetado,

    CASE
        WHEN se.saldo_disponivel >= nm.necessidade_restante
            THEN 'MATERIAL SUFICIENTE'
        ELSE 'NECESSITA REPOSICAO'
    END AS situacao

FROM necessidade_materiais nm

INNER JOIN saldo_estoque se
    ON nm.id_produto = se.id_produto

ORDER BY nm.codigo_produto;
