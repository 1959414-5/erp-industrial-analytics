
USE erp_industrial_analytics;

SELECT
    codigo_pedido,
    cliente,

    DATE(data_pedido) AS data_pedido,
    data_prevista_entrega,

    DATEDIFF(
        data_prevista_entrega,
        DATE(data_pedido)
    ) AS prazo_previsto_dias,

    COALESCE(
        status_pedido,
        'SEM STATUS'
    ) AS status_pedido,

    COALESCE(
        quantidade_itens,
        0
    ) AS quantidade_itens,

    COALESCE(
        valor_total_pedido,
        0
    ) AS valor_total_pedido,

    CASE
        WHEN data_prevista_entrega IS NULL
            THEN 'SEM PREVISAO'

        WHEN status_pedido = 'ENTREGUE'
            THEN 'CONCLUIDO'

        WHEN status_pedido = 'CANCELADO'
            THEN 'CANCELADO'

        ELSE 'EM ANDAMENTO'
    END AS situacao_pedido

FROM vw_faturamento_pedidos

ORDER BY data_pedido;
