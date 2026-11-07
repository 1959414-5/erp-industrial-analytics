
USE erp_industrial_analytics;

SELECT
    pv.codigo_pedido,
    c.nome_razao_social AS cliente,
    pv.status_pedido,

    COUNT(ipv.id_item_pedido_venda) AS quantidade_itens,

    SUM(
        ipv.quantidade * ipv.preco_unitario
        * (1 - ipv.desconto_percentual / 100)
    ) AS valor_total_pedido

FROM pedidos_venda pv

INNER JOIN clientes c
    ON pv.id_cliente = c.id_cliente

INNER JOIN itens_pedido_venda ipv
    ON pv.id_pedido_venda = ipv.id_pedido_venda

GROUP BY
    pv.id_pedido_venda,
    pv.codigo_pedido,
    c.nome_razao_social,
    pv.status_pedido

ORDER BY valor_total_pedido DESC;
