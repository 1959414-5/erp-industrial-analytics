
USE erp_industrial_analytics;

WITH producao_apontada AS (

    -- Etapa 1: identificar quanto já foi produzido por ordem
    SELECT
        id_ordem_producao,
        SUM(quantidade_produzida) AS total_produzido

    FROM apontamentos_producao

    GROUP BY id_ordem_producao
),

ordens_pendentes AS (

    -- Etapa 2: calcular o saldo de produção pendente
    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto,
        op.quantidade_planejada,

        COALESCE(pa.total_produzido, 0) AS total_produzido,

        GREATEST(
            op.quantidade_planejada
            - COALESCE(pa.total_produzido, 0),
            0
        ) AS quantidade_pendente

    FROM ordens_producao op

    LEFT JOIN producao_apontada pa
        ON op.id_ordem_producao = pa.id_ordem_producao

    WHERE op.status_ordem IN (
        'PLANEJADA',
        'LIBERADA',
        'EM_PRODUCAO'
    )
),

necessidade_materiais AS (

    -- Etapa 3: calcular a necessidade das matérias-primas
    SELECT
        ep.id_produto_componente,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida,

        ROUND(
            SUM(
                op.quantidade_pendente
                * ep.quantidade_por_unidade
                * (1 + ep.percentual_perda / 100)
            ),
            3
        ) AS necessidade_total

    FROM ordens_pendentes op

    INNER JOIN estrutura_produto ep
        ON op.id_produto = ep.id_produto_pai

    INNER JOIN produtos componente
        ON ep.id_produto_componente = componente.id_produto

    WHERE op.quantidade_pendente > 0

    GROUP BY
        ep.id_produto_componente,
        componente.codigo_produto,
        componente.descricao,
        componente.unidade_medida
),

disponibilidade_estoque AS (

    -- Etapa 4: consultar o saldo disponível
    SELECT
        id_produto,
        saldo_atual

    FROM vw_saldo_estoque
)

-- Resultado final: necessidade x disponibilidade
SELECT
    nm.codigo_produto,
    nm.descricao,
    nm.unidade_medida,
    nm.necessidade_total,

    de.saldo_atual AS estoque_disponivel,

    ROUND(
        GREATEST(
            nm.necessidade_total - de.saldo_atual,
            0
        ),
        3
    ) AS quantidade_em_falta,

    CASE
        WHEN de.saldo_atual >= nm.necessidade_total
            THEN 'MATERIAL SUFICIENTE'

        ELSE 'NECESSITA REPOSICAO'
    END AS situacao

FROM necessidade_materiais nm

INNER JOIN disponibilidade_estoque de
    ON nm.id_produto_componente = de.id_produto

ORDER BY nm.codigo_produto;
