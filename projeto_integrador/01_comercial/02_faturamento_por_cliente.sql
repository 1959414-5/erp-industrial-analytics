
USE erp_industrial_analytics;

SELECT
    codigo_cliente,
    cliente,

    COUNT(*) AS total_pedidos,

    SUM(quantidade_itens) AS total_itens,

    ROUND(
        SUM(valor_total_pedido),
        2
    ) AS faturamento_total,

    ROUND(
        AVG(NULLIF(valor_total_pedido, 0)),
        2
    ) AS ticket_medio_com_faturamento,

    SUM(
        CASE
            WHEN status_pedido = 'ENTREGUE' THEN 1
            ELSE 0
        END
    ) AS pedidos_entregues

FROM vw_faturamento_pedidos

GROUP BY
    codigo_cliente,
    cliente

ORDER BY faturamento_total DESC;
