
-- Projeto: ERP Industrial Analytics
-- Entrada de produtos acabados aprovados

USE erp_industrial_analytics;

START TRANSACTION;

-- 1. Concluir ordens que atingiram a quantidade planejada

UPDATE ordens_producao op

SET op.status_ordem = 'CONCLUIDA'

WHERE op.status_ordem = 'EM_PRODUCAO'

AND (
    SELECT COALESCE(SUM(ap.quantidade_produzida), 0)
    FROM apontamentos_producao ap
    WHERE ap.id_ordem_producao = op.id_ordem_producao
) >= op.quantidade_planejada;


-- 2. Consolidar as quantidades aprovadas por ordem

INSERT INTO movimentacoes_estoque (
    id_produto,
    tipo_movimentacao,
    origem_movimentacao,
    id_ordem_producao,
    quantidade,
    data_movimentacao,
    documento_referencia,
    observacao
)

SELECT
    consolidado.id_produto,
    'ENTRADA',
    'PRODUCAO',
    consolidado.id_ordem_producao,
    consolidado.quantidade_aprovada,
    consolidado.data_movimentacao,
    consolidado.documento_referencia,
    'Entrada de produto acabado aprovado'

FROM (

    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto AS id_produto,

        SUM(ap.quantidade_aprovada) AS quantidade_aprovada,

        MAX(ap.data_apontamento) AS data_movimentacao,

        CONCAT('PROD-', op.codigo_ordem)
            AS documento_referencia

    FROM ordens_producao op

    INNER JOIN apontamentos_producao ap
        ON op.id_ordem_producao = ap.id_ordem_producao

    INNER JOIN produtos p
        ON op.id_produto = p.id_produto

    WHERE p.controla_estoque = 1

    GROUP BY
        op.id_ordem_producao,
        op.codigo_ordem,
        op.id_produto

) AS consolidado

WHERE consolidado.quantidade_aprovada > 0

AND NOT EXISTS (
    SELECT 1
    FROM movimentacoes_estoque me
    WHERE me.id_ordem_producao =
          consolidado.id_ordem_producao

      AND me.origem_movimentacao = 'PRODUCAO'
      AND me.tipo_movimentacao = 'ENTRADA'

      AND me.documento_referencia =
          consolidado.documento_referencia
);

COMMIT;
