
-- Projeto: ERP Industrial Analytics
-- Inserção de clientes fictícios

USE erp_industrial_analytics;

INSERT INTO clientes (
    codigo_cliente,
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
    'CLI-0001',
    'J',
    'Industria Exemplo Norte Ltda',
    'Exemplo Norte',
    '00000000000001',
    'compras@industria-exemplo.example',
    '44999990001',
    'Maringa',
    'PR',
    '87000000',
    1
),
(
    'CLI-0002',
    'F',
    'Carla Exemplo',
    NULL,
    '00000000001',
    'carla@cliente-exemplo.example',
    '43999990002',
    'Londrina',
    'PR',
    '86000000',
    1
);

-- Conferir os clientes cadastrados
SELECT
    id_cliente,
    codigo_cliente,
    tipo_pessoa,
    nome_razao_social,
    documento,
    ativo
FROM clientes
ORDER BY id_cliente;
