
-- Projeto: ERP Industrial Analytics
-- Insercao de pedidos de compra ficticios

USE erp_industrial_analytics;

-- Pedido PC-0001

INSERT INTO pedidos_compra (
    codigo_pedido_compra,
    id_fornecedor,
    data_pedido,
    data_prevista_entrega,
    status_pedido,
    observacao
)
SELECT
    'PC-0001',
    f.id_fornecedor,
    '2026-11-05 10:00:00',
    '2026-11-12',
    'APROVADO',
    'Compra demonstrativa de chapas de aco'
FROM fornecedores f
WHERE f.codigo_fornecedor = 'FOR-0001'
AND NOT EXISTS (
    SELECT 1
    FROM pedidos_compra pc
    WHERE pc.codigo_pedido_compra = 'PC-0001'
);

-- Pedido PC-0002

INSERT INTO pedidos_compra (
    codigo_pedido_compra,
    id_fornecedor,
    data_pedido,
    data_prevista_entrega,
    status_pedido,
    observacao
)
SELECT
    'PC-0002',
    f.id_fornecedor,
    '2026-11-06 11:30:00',
    '2026-11-15',
    'PENDENTE',
    'Compra demonstrativa de tubos de aco'
FROM fornecedores f
WHERE f.codigo_fornecedor = 'FOR-0002'
AND NOT EXISTS (
    SELECT 1
    FROM pedidos_compra pc
    WHERE pc.codigo_pedido_compra = 'PC-0002'
);

-- Conferir pedidos e fornecedores

SELECT
    pc.id_pedido_compra,
    pc.codigo_pedido_compra,
    f.codigo_fornecedor,
    f.nome_razao_social AS fornecedor,
    pc.status_pedido,
    pc.data_prevista_entrega
FROM pedidos_compra pc

INNER JOIN fornecedores f
    ON pc.id_fornecedor = f.id_fornecedor

ORDER BY pc.codigo_pedido_compra;
