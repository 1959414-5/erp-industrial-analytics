
-- Projeto: ERP Industrial Analytics
-- Insercao de apontamentos de producao ficticios

USE erp_industrial_analytics;

INSERT INTO apontamentos_producao (
    id_ordem_producao,
    numero_apontamento,
    data_apontamento,
    etapa_producao,
    centro_trabalho,
    maquina,
    quantidade_produzida,
    quantidade_aprovada,
    quantidade_refugo,
    tempo_minutos,
    observacao
)

SELECT
    op.id_ordem_producao,
    dados.numero_apontamento,
    dados.data_apontamento,
    dados.etapa_producao,
    dados.centro_trabalho,
    dados.maquina,
    dados.quantidade_produzida,
    dados.quantidade_aprovada,
    dados.quantidade_refugo,
    dados.tempo_minutos,
    dados.observacao

FROM (

    SELECT
        'OP-0001' AS codigo_ordem,
        1 AS numero_apontamento,
        '2026-11-05 09:00:00' AS data_apontamento,
        'Montagem final' AS etapa_producao,
        'Montagem' AS centro_trabalho,
        'Bancada 01' AS maquina,
        40.000 AS quantidade_produzida,
        38.000 AS quantidade_aprovada,
        2.000 AS quantidade_refugo,
        120.00 AS tempo_minutos,
        'Apontamento do primeiro turno' AS observacao

    UNION ALL

    SELECT
        'OP-0001', 2, '2026-11-05 13:00:00',
        'Montagem final', 'Montagem', 'Bancada 01',
        35.000, 34.000, 1.000, 100.00,
        'Apontamento do segundo turno'

    UNION ALL

    SELECT
        'OP-0001', 3, '2026-11-06 09:00:00',
        'Montagem final', 'Montagem', 'Bancada 01',
        25.000, 25.000, 0.000, 70.00,
        'Apontamento final da ordem'

    UNION ALL

    SELECT
        'OP-0002', 1, '2026-11-06 09:30:00',
        'Montagem final', 'Montagem', 'Bancada 01',
        25.000, 24.000, 1.000, 80.00,
        'Apontamento do primeiro turno'

    UNION ALL

    SELECT
        'OP-0002', 2, '2026-11-06 14:00:00',
        'Montagem final', 'Montagem', 'Bancada 01',
        20.000, 19.000, 1.000, 65.00,
        'Apontamento do segundo turno'

) AS dados

INNER JOIN ordens_producao op
    ON op.codigo_ordem = dados.codigo_ordem

WHERE NOT EXISTS (
    SELECT 1
    FROM apontamentos_producao existente
    WHERE existente.id_ordem_producao = op.id_ordem_producao
      AND existente.numero_apontamento = dados.numero_apontamento
);
