USE erp_industrial_analytics;

INSERT INTO pedidos_venda (
    codigo_pedido,
    id_cliente,
    data_pedido,
    data_prevista_entrega,
    status_pedido,
    observacao
)
SELECT
    'PV-0003',
    c.id_cliente,
    '2026-11-07 10:00:00',
    '2026-11-18',
    'PENDENTE',
    'Pedido demonstrativo ainda sem itens'
FROM clientes c
WHERE c.codigo_cliente = 'CLI-0001'
AND NOT EXISTS (
    SELECT 1
    FROM pedidos_venda pv
    WHERE pv.codigo_pedido = 'PV-0003'
);