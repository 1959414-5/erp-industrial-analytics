
USE erp_industrial_analytics;

SELECT
    codigo_pedido,
    cliente,
    status_pedido,
    quantidade_itens,
    valor_total_pedido

FROM vw_faturamento_pedidos

WHERE valor_total_pedido > (

    SELECT
        AVG(valor_total_pedido)

    FROM vw_faturamento_pedidos

)

ORDER BY valor_total_pedido DESC;
