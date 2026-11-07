
USE erp_industrial_analytics;

CREATE OR REPLACE VIEW vw_faturamento_pedidos AS

SELECT
    pv.id_pedido_venda,
    pv.codigo_pedido,
    pv.data_pedido,
    pv.data_prevista_entrega,
    pv.status_pedido,

    c.codigo_cliente,
    c.nome_razao_social AS cliente,

    COUNT(ipv.id_item_pedido_venda) AS quantidade_itens,

    ROUND(
        COALESCE(
            SUM(
                ipv.quantidade
                * ipv.preco_unitario
                * (1 - ipv.desconto_percentual / 100)
            ),
            0
        ),
        2
    ) AS valor_total_pedido

FROM pedidos_venda pv

INNER JOIN clientes c
    ON pv.id_cliente = c.id_cliente

LEFT JOIN itens_pedido_venda ipv
    ON pv.id_pedido_venda = ipv.id_pedido_venda

GROUP BY
    pv.id_pedido_venda,
    pv.codigo_pedido,
    pv.data_pedido,
    pv.data_prevista_entrega,
    pv.status_pedido,
    c.codigo_cliente,
    c.nome_razao_social;
