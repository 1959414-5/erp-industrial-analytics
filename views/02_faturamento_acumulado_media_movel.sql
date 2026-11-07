
USE erp_industrial_analytics;

WITH vendas_por_dia AS (

    SELECT
        DATE(data_pedido) AS dia,

        COUNT(*) AS quantidade_pedidos,

        ROUND(
            SUM(valor_total_pedido),
            2
        ) AS faturamento_dia

    FROM vw_faturamento_pedidos

    GROUP BY DATE(data_pedido)
)

SELECT
    dia,
    quantidade_pedidos,
    faturamento_dia,

    ROUND(
        SUM(faturamento_dia) OVER (
            ORDER BY dia
            ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS faturamento_acumulado,

    ROUND(
        AVG(faturamento_dia) OVER (
            ORDER BY dia
            ROWS BETWEEN 1 PRECEDING
            AND CURRENT ROW
        ),
        2
    ) AS media_movel_2_dias

FROM vendas_por_dia

ORDER BY dia;
