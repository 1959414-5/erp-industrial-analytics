
USE erp_industrial_analytics;

SELECT
    codigo_pedido,
    cliente,
    DATE(data_pedido) AS data_pedido,
    data_prevista_entrega,
    status_pedido,
    quantidade_itens,
    valor_total_pedido,

    CASE
        WHEN quantidade_itens = 0
            THEN 'PEDIDO SEM ITENS'
        WHEN status_pedido = 'ENTREGUE'
            THEN 'ENTREGUE'
        WHEN status_pedido = 'CANCELADO'
            THEN 'CANCELADO'
        ELSE 'PENDENTE'
    END AS situacao_analise,

    DATEDIFF(
        data_prevista_entrega,
        DATE(data_pedido)
    ) AS prazo_previsto_dias,

    RANK() OVER (
        ORDER BY valor_total_pedido DESC
    ) AS ranking_faturamento,

    ROUND(
        100 * valor_total_pedido /
        NULLIF(SUM(valor_total_pedido) OVER (), 0),
        2
    ) AS participacao_faturamento_pct

FROM vw_faturamento_pedidos

ORDER BY valor_total_pedido DESC;
