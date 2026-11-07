
USE erp_industrial_analytics;

CREATE TABLE clientes (

    -- Identificador interno
    id_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    -- Código utilizado pelo ERP
    codigo_cliente VARCHAR(20) NOT NULL,

    -- F = Pessoa Física | J = Pessoa Jurídica
    tipo_pessoa CHAR(1) NOT NULL,

    -- Dados cadastrais
    nome_razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150),
    documento VARCHAR(14) NOT NULL,

    -- Contato
    email VARCHAR(254),
    telefone VARCHAR(20),

    -- Localização
    cidade VARCHAR(100),
    uf CHAR(2),
    cep CHAR(8),

    -- Controle cadastral
    ativo TINYINT UNSIGNED NOT NULL DEFAULT 1,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    -- Chaves
    CONSTRAINT pk_clientes
        PRIMARY KEY (id_cliente),

    CONSTRAINT uk_clientes_codigo
        UNIQUE (codigo_cliente),

    CONSTRAINT uk_clientes_documento
        UNIQUE (documento),

    -- Regras de validação
    CONSTRAINT chk_clientes_tipo_pessoa
        CHECK (tipo_pessoa IN ('F', 'J')),

    CONSTRAINT chk_clientes_documento
        CHECK (
            (tipo_pessoa = 'F' AND CHAR_LENGTH(documento) = 11)
            OR
            (tipo_pessoa = 'J' AND CHAR_LENGTH(documento) = 14)
        ),

    CONSTRAINT chk_clientes_ativo
        CHECK (ativo IN (0, 1))

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
