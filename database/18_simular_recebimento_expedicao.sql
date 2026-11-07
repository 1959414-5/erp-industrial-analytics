
-- Projeto: ERP Industrial Analytics
-- Simulacao de recebimento e expedicao
-- Todos os dados sao ficticios

USE erp_industrial_analytics;

START TRANSACTION;

-- 1. Registrar recebimento do pedido de compra

UPDATE pedidos_compra
SET status_pedido = 'RECEBIDO'
WHERE codigo_pedido_compra = 'PC-0001'
  AND status_pedido = 'APROVADO';

-- 2. Registrar entrega do pedido de venda

UPDATE pedidos_venda
SET status_pedido = 'ENTREGUE'
WHERE codigo_pedido = 'PV-0001'
  AND status_pedido = 'APROVADO';


-- 3. Registrar entradas provenientes de compras

INSERT INTO movimentacoes_estoque (
    id_produto,
    tipo_movimentacao,
    origem_movimentacao,
    id_item_pedido_compra,
    quantidade,
    data_movimentacao,
    documento_referencia,
    observacao
)

SELECT
    ip.id_produto,
    'ENTRADA',
    'COMPRA',
    ip.id_item_pedido_compra,
    ip.quantidade,
    '2026-11-06 16:00:00',
    pc.codigo_pedido_compra,
    'Recebimento simulado de material'

FROM itens_pedido_compra ip

INNER JOIN pedidos_compra pc
    ON ip.id_pedido_compra = pc.id_pedido_compra

INNER JOIN produtos p
    ON ip.id_produto = p.id_produto

WHERE pc.codigo_pedido_compra = 'PC-0001'
  AND pc.status_pedido = 'RECEBIDO'
  AND p.controla_estoque = 1

  AND NOT EXISTS (
      SELECT 1
      FROM movimentacoes_estoque me
      WHERE me.id_item_pedido_compra =
            ip.id_item_pedido_compra
  );


-- 4. Registrar saidas provenientes de vendas

INSERT INTO movimentacoes_estoque (
    id_produto,
    tipo_movimentacao,
    origem_movimentacao,
    id_item_pedido_venda,
    quantidade,
    data_movimentacao,
    documento_referencia,
    observacao
)

SELECT
    ipv.id_produto,
    'SAIDA',
    'VENDA',
    ipv.id_item_pedido_venda,
    ipv.quantidade,
    '2026-11-07 10:00:00',
    pv.codigo_pedido,
    'Expedicao simulada de material'

FROM itens_pedido_venda ipv

INNER JOIN pedidos_venda pv
    ON ipv.id_pedido_venda = pv.id_pedido_venda

INNER JOIN produtos p
    ON ipv.id_produto = p.id_produto

WHERE pv.codigo_pedido = 'PV-0001'
  AND pv.status_pedido = 'ENTREGUE'
  AND p.controla_estoque = 1

  AND NOT EXISTS (
      SELECT 1
      FROM movimentacoes_estoque me
      WHERE me.id_item_pedido_venda =
            ipv.id_item_pedido_venda
  );


-- Confirmar a transacao
COMMIT;
