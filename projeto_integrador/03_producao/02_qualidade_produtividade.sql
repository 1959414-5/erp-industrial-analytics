
USE erp_industrial_analytics;

SELECT
    etapa_producao,
    centro_trabalho,
    COALESCE(maquina, 'NAO INFORMADA') AS maquina,

    COUNT(*) AS total_apontamentos,

    COUNT(DISTINCT id_ordem_producao)
        AS total_ordens,

    SUM(quantidade_produzida)
        AS total_produzido,

    SUM(quantidade_aprovada)
        AS total_aprovado,

    SUM(quantidade_refugo)
        AS total_refugo,

    SUM(tempo_minutos)
        AS tempo_total_minutos,

    ROUND(
        100.0 * SUM(quantidade_refugo)
        / NULLIF(SUM(quantidade_produzida), 0),
        2
    ) AS taxa_refugo_pct,

    ROUND(
        100.0 * SUM(quantidade_aprovada)
        / NULLIF(SUM(quantidade_produzida), 0),
        2
    ) AS taxa_aprovacao_pct,

    ROUND(
        SUM(quantidade_aprovada)
        / NULLIF(SUM(tempo_minutos) / 60, 0),
        2
    ) AS aprovadas_por_hora

FROM apontamentos_producao

GROUP BY
    etapa_producao,
    centro_trabalho,
    maquina

ORDER BY taxa_refugo_pct DESC;
