
USE erp_industrial_analytics;

WITH necessidade_materiais AS (

    SELECT
        op.codigo_ordem,
        pai.codigo_produto AS produto_acabado,
        componente.codigo_produto AS materia_prima,
        componente.descricao AS descricao_componente,
        componente.unidade_medida,

        op.quantidade_planejada,
        ep.quantidade_por_unidade,
        ep.percentual_perda,

        ROUND(
            op.quantidade_planejada
            * ep.quantidade_por_unidade
            * (1 + ep.percentual_perda / 100),
            3
        ) AS necessidade_total

    FROM ordens_producao op

    INNER JOIN produtos pai
        ON op.id_produto = pai.id_produto

    INNER JOIN estrutura_produto ep
        ON pai.id_produto = ep.id_produto_pai

    INNER JOIN produtos componente
        ON ep.id_produto_componente = componente.id_produto
)

SELECT
    codigo_ordem,
    produto_acabado,
    materia_prima,
    descricao_componente,
    unidade_medida,
    quantidade_planejada,
    quantidade_por_unidade,
    percentual_perda,
    necessidade_total

FROM necessidade_materiais

ORDER BY
    codigo_ordem,
    materia_prima;
