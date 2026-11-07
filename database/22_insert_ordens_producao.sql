
-- Projeto: ERP Industrial Analytics
-- Cadastro de ordens de producao ficticias

USE erp_industrial_analytics;

-- Ordem OP-0001

INSERT INTO ordens_producao (
    codigo_ordem,
    id_produto,
    data_abertura,
    data_prevista_conclusao,
    quantidade_planejada,
    status_ordem,
    observacao
)
SELECT
    'OP-0001',
    p.id_produto,
    '2026-11-03 08:00:00',
    '2026-11-10',
    100.000,
    'EM_PRODUCAO',
    'Ordem demonstrativa de 100 unidades'
FROM produtos p
WHERE p.codigo_produto = 'PA-0001'
AND NOT EXISTS (
    SELECT 1
    FROM ordens_producao op
    WHERE op.codigo_ordem = 'OP-0001'
);

-- Ordem OP-0002

INSERT INTO ordens_producao (
    codigo_ordem,
    id_produto,
    data_abertura,
    data_prevista_conclusao,
    quantidade_planejada,
    status_ordem,
    observacao
)
SELECT
    'OP-0002',
    p.id_produto,
    '2026-11-04 08:00:00',
    '2026-11-11',
    60.000,
    'EM_PRODUCAO',
    'Ordem demonstrativa de 60 unidades'
FROM produtos p
WHERE p.codigo_produto = 'PA-0001'
AND NOT EXISTS (
    SELECT 1
    FROM ordens_producao op
    WHERE op.codigo_ordem = 'OP-0002'
);

-- Conferir ordens cadastradas

SELECT
    op.id_ordem_producao,
    op.codigo_ordem,
    p.codigo_produto,
    p.descricao,
    op.quantidade_planejada,
    op.status_ordem
FROM ordens_producao op

INNER JOIN produtos p
    ON op.id_produto = p.id_produto

ORDER BY op.codigo_ordem;
