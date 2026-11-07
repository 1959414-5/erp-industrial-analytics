
USE erp_industrial_analytics;

SELECT
    pv.codigo_pedido,
    c.nome_razao_social AS cliente,

    COUNT(ipv.id_item_pedido_venda) AS quantidade_itens,

    ROUND(
        COALESCE(
            SUM(
                ipv.quantidade * ipv.preco_unitario
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
    c.nome_razao_social

HAVING
    SUM(
        COALESCE(
            ipv.quantidade * ipv.preco_unitario
            * (1 - ipv.desconto_percentual / 100),
            0
        )
    ) > 500

ORDER BY valor_total_pedido DESC;
