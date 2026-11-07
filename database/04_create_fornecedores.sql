
-- Projeto: ERP Industrial Analytics
-- Criacao da tabela de fornecedores

USE erp_industrial_analytics;

CREATE TABLE fornecedores (

    id_fornecedor BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    codigo_fornecedor VARCHAR(20) NOT NULL,

    tipo_pessoa CHAR(1) NOT NULL,

    nome_razao_social VARCHAR(150) NOT NULL,

    nome_fantasia VARCHAR(150),

    documento VARCHAR(14) NOT NULL,

    email VARCHAR(254),

    telefone VARCHAR(20),

    cidade VARCHAR(100),

    uf CHAR(2),

    cep CHAR(8),

    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,

    criado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_fornecedores
        PRIMARY KEY (id_fornecedor),

    CONSTRAINT uk_fornecedores_codigo
        UNIQUE (codigo_fornecedor),

    CONSTRAINT uk_fornecedores_documento
        UNIQUE (documento),

    CONSTRAINT chk_fornecedores_tipo_pessoa
        CHECK (tipo_pessoa IN ('F', 'J')),

    CONSTRAINT chk_fornecedores_documento
        CHECK (
            (tipo_pessoa = 'F' AND CHAR_LENGTH(documento) = 11)
            OR
            (tipo_pessoa = 'J' AND CHAR_LENGTH(documento) = 14)
        ),

    CONSTRAINT chk_fornecedores_ativo
        CHECK (ativo IN (0, 1))

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
