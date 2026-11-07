
-- Projeto: ERP Industrial Analytics
-- Insercao de pedidos de venda ficticios

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
    'PV-0001',
    id_cliente,
    '2026-11-05 09:00:00',
    '2026-11-14',
    'APROVADO',
    'Pedido demonstrativo do projeto'
FROM clientes
WHERE codigo_cliente = 'CLI-0001';

INSERT INTO pedidos_venda (
    codigo_pedido,
    id_cliente,
    data_pedido,
    data_prevista_entrega,
    status_pedido,
    observacao
)
SELECT
    'PV-0002',
    id_cliente,
    '2026-11-06 14:30:00',
    '2026-11-16',
    'PENDENTE',
    'Pedido demonstrativo do projeto'
FROM clientes
WHERE codigo_cliente = 'CLI-0002';

-- Conferir pedidos cadastrados

SELECT
    id_pedido_venda,
    codigo_pedido,
    id_cliente,
    data_pedido,
    data_prevista_entrega,
    status_pedido
FROM pedidos_venda
ORDER BY id_pedido_venda;
