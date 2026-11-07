
-- Projeto: ERP Industrial Analytics
-- Consumo de materias-primas na producao

USE erp_industrial_analytics;

START TRANSACTION;

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
    consumo.id_produto,
    'SAIDA',
    'PRODUCAO',
    consumo.id_ordem_producao,
    consumo.quantidade_consumida,
    consumo.data_movimentacao,
    consumo.documento_referencia,
    consumo.observacao

FROM (

    SELECT
        op.id_ordem_producao,
        op.codigo_ordem,
        componente.id_produto,
        componente.codigo_produto,

        ROUND(
            SUM(
                ap.quantidade_produzida
                * ep.quantidade_por_unidade
                * (1 + ep.percentual_perda / 100)
            ),
            3
        ) AS quantidade_consumida,

        MAX(ap.data_apontamento) AS data_movimentacao,

        CONCAT(
            'CONS-',
            op.codigo_ordem,
            '-',
            componente.codigo_produto
        ) AS documento_referencia,

        CONCAT(
            'Consumo calculado pela BOM da ordem ',
            op.codigo_ordem
        ) AS observacao

    FROM ordens_producao op

    INNER JOIN apontamentos_producao ap
        ON op.id_ordem_producao = ap.id_ordem_producao

    INNER JOIN estrutura_produto ep
        ON op.id_produto = ep.id_produto_pai

    INNER JOIN produtos componente
        ON ep.id_produto_componente = componente.id_produto

    WHERE op.status_ordem IN (
        'EM_PRODUCAO',
        'CONCLUIDA'
    )
    AND componente.controla_estoque = 1

    GROUP BY
        op.id_ordem_producao,
        op.codigo_ordem,
        componente.id_produto,
        componente.codigo_produto,
        ep.quantidade_por_unidade,
        ep.percentual_perda

) AS consumo

WHERE NOT EXISTS (
    SELECT 1
    FROM movimentacoes_estoque existente
    WHERE existente.id_ordem_producao =
          consumo.id_ordem_producao

      AND existente.id_produto =
          consumo.id_produto

      AND existente.origem_movimentacao = 'PRODUCAO'
      AND existente.tipo_movimentacao = 'SAIDA'

      AND existente.documento_referencia =
          consumo.documento_referencia
);

COMMIT;
