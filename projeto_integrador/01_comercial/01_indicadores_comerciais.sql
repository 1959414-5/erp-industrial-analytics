
USE erp_industrial_analytics;

SELECT

    COUNT(*) AS total_pedidos,

    COUNT(DISTINCT codigo_cliente)
        AS clientes_com_pedidos,

    SUM(quantidade_itens)
        AS total_itens,

    ROUND(
        SUM(valor_total_pedido),
        2
    ) AS faturamento_total,

    ROUND(
        AVG(valor_total_pedido),
        2
    ) AS ticket_medio,

    SUM(
        CASE
            WHEN status_pedido = 'ENTREGUE' THEN 1
            ELSE 0
        END
    ) AS pedidos_entregues,

    SUM(
        CASE
            WHEN status_pedido = 'PENDENTE' THEN 1
            ELSE 0
        END
    ) AS pedidos_pendentes,

    SUM(
        CASE
            WHEN quantidade_itens = 0 THEN 1
            ELSE 0
        END
    ) AS pedidos_sem_itens,

    ROUND(
        100.0 *
        SUM(
            CASE
                WHEN status_pedido = 'ENTREGUE' THEN 1
                ELSE 0
            END
        ) / NULLIF(COUNT(*), 0),
        2
    ) AS percentual_entregues

FROM vw_faturamento_pedidos;
