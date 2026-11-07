
-- Projeto: ERP Industrial Analytics
-- Cadastro de fornecedores ficticios

USE erp_industrial_analytics;

INSERT INTO fornecedores (
    codigo_fornecedor,
    tipo_pessoa,
    nome_razao_social,
    nome_fantasia,
    documento,
    email,
    telefone,
    cidade,
    uf,
    cep,
    ativo
)
VALUES
(
    'FOR-0001',
    'J',
    'Acos Exemplo Distribuidora Ltda',
    'Acos Exemplo',
    '00000000000011',
    'vendas@acos-exemplo.example',
    '44333330001',
    'Maringa',
    'PR',
    '87000000',
    1
),
(
    'FOR-0002',
    'J',
    'Metalurgica Exemplo de Tubos Ltda',
    'Metal Tubos',
    '00000000000012',
    'comercial@metal-tubos.example',
    '44333330002',
    'Londrina',
    'PR',
    '86000000',
    1
);

-- Conferir fornecedores cadastrados

SELECT
    id_fornecedor,
    codigo_fornecedor,
    nome_razao_social,
    cidade,
    uf,
    ativo
FROM fornecedores
ORDER BY id_fornecedor;
