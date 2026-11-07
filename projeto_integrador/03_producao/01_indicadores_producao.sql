
USE erp_industrial_analytics;

SELECT
    op.codigo_ordem,
    p.codigo_produto,
    p.descricao AS produto,
    op.status_ordem,
    op.quantidade_planejada,

    COUNT(ap.id_apontamento) AS total_apontamentos,

    COALESCE(
        SUM(ap.quantidade_produzida), 0
    ) AS total_produzido,

    COALESCE(
        SUM(ap.quantidade_aprovada), 0
    ) AS total_aprovado,

    COALESCE(
        SUM(ap.quantidade_refugo), 0
    ) AS total_refugo,

    ROUND(
        100.0 * COALESCE(SUM(ap.quantidade_produzida), 0)
        / NULLIF(op.quantidade_planejada, 0),
        2
    ) AS percentual_conclusao,

    ROUND(
        100.0 * COALESCE(SUM(ap.quantidade_refugo), 0)
        / NULLIF(SUM(ap.quantidade_produzida), 0),
        2
    ) AS taxa_refugo

FROM ordens_producao op

INNER JOIN produtos p
    ON op.id_produto = p.id_produto

LEFT JOIN apontamentos_producao ap
    ON op.id_ordem_producao = ap.id_ordem_producao

GROUP BY
    op.id_ordem_producao,
    op.codigo_ordem,
    p.codigo_produto,
    p.descricao,
    op.status_ordem,
    op.quantidade_planejada

ORDER BY op.codigo_ordem;
