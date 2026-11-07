
-- Projeto: ERP Industrial Analytics
-- Insercao dos itens dos pedidos de compra

USE erp_industrial_analytics;

INSERT INTO itens_pedido_compra (
    id_pedido_compra,
    numero_item,
    id_produto,
    descricao_item,
    unidade_medida,
    quantidade,
    custo_unitario,
    desconto_percentual
)

SELECT
    pc.id_pedido_compra,
    itens.numero_item,
    p.id_produto,
    p.descricao,
    p.unidade_medida,
    itens.quantidade,
    itens.custo_unitario,
    itens.desconto_percentual

FROM (
    SELECT
        'PC-0001' AS codigo_pedido,
        1 AS numero_item,
        'MAT-0001' AS codigo_produto,
        30.000 AS quantidade,
        245.00 AS custo_unitario,
        0.00 AS desconto_percentual

    UNION ALL

    SELECT
        'PC-0001', 2, 'MAT-0002',
        100.000, 17.80, 0.00

    UNION ALL

    SELECT
        'PC-0002', 1, 'MAT-0002',
        200.000, 17.20, 0.00

) AS itens

INNER JOIN pedidos_compra pc
    ON pc.codigo_pedido_compra = itens.codigo_pedido

INNER JOIN produtos p
    ON p.codigo_produto = itens.codigo_produto

WHERE NOT EXISTS (
    SELECT 1
    FROM itens_pedido_compra existente
    WHERE existente.id_pedido_compra = pc.id_pedido_compra
      AND existente.numero_item = itens.numero_item
);
