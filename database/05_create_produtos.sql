
-- Projeto: ERP Industrial Analytics
-- Criacao da tabela de produtos

USE erp_industrial_analytics;

CREATE TABLE produtos (

    id_produto BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    codigo_produto VARCHAR(30) NOT NULL,

    descricao VARCHAR(150) NOT NULL,

    categoria VARCHAR(60) NOT NULL,

    tipo_produto CHAR(2) NOT NULL,

    unidade_medida VARCHAR(10) NOT NULL,

    controla_estoque TINYINT UNSIGNED NOT NULL DEFAULT 1,

    estoque_minimo DECIMAL(14,3) NOT NULL DEFAULT 0.000,

    estoque_maximo DECIMAL(14,3) DEFAULT NULL,

    custo_padrao DECIMAL(15,2) NOT NULL DEFAULT 0.00,

    preco_venda DECIMAL(15,2) NOT NULL DEFAULT 0.00,

    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,

    criado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_produtos
        PRIMARY KEY (id_produto),

    CONSTRAINT uk_produtos_codigo
        UNIQUE (codigo_produto),

    CONSTRAINT chk_produtos_tipo
        CHECK (tipo_produto IN ('MP', 'PI', 'PA', 'SV')),

    CONSTRAINT chk_produtos_unidade
        CHECK (
            unidade_medida IN ('UN', 'KG', 'M', 'M2', 'CHAPA')
        ),

    CONSTRAINT chk_produtos_controla_estoque
        CHECK (controla_estoque IN (0, 1)),

    CONSTRAINT chk_produtos_estoque_minimo
        CHECK (estoque_minimo >= 0),

    CONSTRAINT chk_produtos_estoque_maximo
        CHECK (
            estoque_maximo IS NULL
            OR estoque_maximo >= estoque_minimo
        ),

    CONSTRAINT chk_produtos_custo
        CHECK (custo_padrao >= 0),

    CONSTRAINT chk_produtos_preco
        CHECK (preco_venda >= 0),

    CONSTRAINT chk_produtos_ativo
        CHECK (ativo IN (0, 1))

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
