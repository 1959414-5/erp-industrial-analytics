
-- Projeto: ERP Industrial Analytics
-- Insercao dos itens dos pedidos de venda

USE erp_industrial_analytics;

INSERT INTO itens_pedido_venda (
    id_pedido_venda,
    numero_item,
    id_produto,
    descricao_item,
    unidade_medida,
    quantidade,
    preco_unitario,
    desconto_percentual
)

SELECT
    pv.id_pedido_venda,
    itens.numero_item,
    p.id_produto,
    p.descricao,
    p.unidade_medida,
    itens.quantidade,
    itens.preco_unitario,
    itens.desconto_percentual

FROM (
    SELECT
        'PV-0001' AS codigo_pedido,
        1 AS numero_item,
        'MAT-0001' AS codigo_produto,
        5.000 AS quantidade,
        315.00 AS preco_unitario,
        0.00 AS desconto_percentual

    UNION ALL

    SELECT
        'PV-0001', 2, 'MAT-0002',
        20.000, 26.90, 5.00

    UNION ALL

    SELECT
        'PV-0002', 1, 'PA-0001',
        2.000, 290.00, 0.00

    UNION ALL

    SELECT
        'PV-0002', 2, 'SV-0001',
        3.000, 25.00, 0.00

) AS itens

INNER JOIN pedidos_venda pv
    ON pv.codigo_pedido = itens.codigo_pedido

INNER JOIN produtos p
    ON p.codigo_produto = itens.codigo_produto;
