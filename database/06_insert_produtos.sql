
-- Projeto: ERP Industrial Analytics
-- Cadastro de produtos ficticios

USE erp_industrial_analytics;

INSERT INTO produtos (
    codigo_produto,
    descricao,
    categoria,
    tipo_produto,
    unidade_medida,
    controla_estoque,
    estoque_minimo,
    estoque_maximo,
    custo_padrao,
    preco_venda
)
VALUES

(
    'MAT-0001',
    'Chapa de Aco Carbono 3mm',
    'Chapas',
    'MP',
    'CHAPA',
    1,
    10.000,
    100.000,
    250.00,
    315.00
),

(
    'MAT-0002',
    'Tubo de Aco Carbono',
    'Tubos',
    'MP',
    'M',
    1,
    50.000,
    500.000,
    18.50,
    26.90
),

(
    'INT-0001',
    'Perfil Metalico Cortado',
    'Perfis',
    'PI',
    'UN',
    1,
    20.000,
    200.000,
    45.00,
    68.00
),

(
    'PA-0001',
    'Conjunto Metalico Acabado',
    'Componentes',
    'PA',
    'UN',
    1,
    5.000,
    50.000,
    180.00,
    290.00
),

(
    'SV-0001',
    'Servico de Corte Industrial',
    'Servicos',
    'SV',
    'UN',
    0,
    0.000,
    NULL,
    12.00,
    25.00
);

-- Consultar produtos cadastrados

SELECT
    id_produto,
    codigo_produto,
    descricao,
    tipo_produto,
    unidade_medida,
    custo_padrao,
    preco_venda,
    controla_estoque
FROM produtos
ORDER BY id_produto;
