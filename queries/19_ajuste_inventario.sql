
USE erp_industrial_analytics;

INSERT INTO movimentacoes_estoque (
    id_produto,
    tipo_movimentacao,
    origem_movimentacao,
    quantidade,
    documento_referencia,
    observacao
)
SELECT
    p.id_produto,
    'SAIDA',
    'AJUSTE',
    2.000,
    'INV-2026-001',
    'Ajuste demonstrativo por divergencia de inventario'
FROM produtos p
WHERE p.codigo_produto = 'MAT-0001'
AND NOT EXISTS (
    SELECT 1
    FROM movimentacoes_estoque me
    WHERE me.documento_referencia = 'INV-2026-001'
      AND me.id_produto = p.id_produto
);
