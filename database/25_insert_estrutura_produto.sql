
-- Projeto: ERP Industrial Analytics
-- Cadastro da estrutura de produto (BOM)

USE erp_industrial_analytics;

INSERT INTO estrutura_produto (
    id_produto_pai,
    id_produto_componente,
    quantidade_por_unidade,
    percentual_perda
)

SELECT
    pai.id_produto,
    componente.id_produto,
    dados.quantidade_por_unidade,
    dados.percentual_perda

FROM (

    SELECT
        'PA-0001' AS codigo_pai,
        'MAT-0001' AS codigo_componente,
        0.200 AS quantidade_por_unidade,
        5.00 AS percentual_perda

    UNION ALL

    SELECT
        'PA-0001',
        'MAT-0002',
        0.800,
        3.00

) AS dados

INNER JOIN produtos pai
    ON pai.codigo_produto = dados.codigo_pai
    AND pai.tipo_produto = 'PA'

INNER JOIN produtos componente
    ON componente.codigo_produto = dados.codigo_componente
    AND componente.tipo_produto = 'MP'

WHERE NOT EXISTS (
    SELECT 1
    FROM estrutura_produto ep
    WHERE ep.id_produto_pai = pai.id_produto
      AND ep.id_produto_componente = componente.id_produto
);
