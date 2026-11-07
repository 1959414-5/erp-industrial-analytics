
-- Projeto: ERP Industrial Analytics
-- Estrutura simplificada de produto (BOM)

USE erp_industrial_analytics;

CREATE TABLE estrutura_produto (

    id_estrutura BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    id_produto_pai BIGINT UNSIGNED NOT NULL,

    id_produto_componente BIGINT UNSIGNED NOT NULL,

    quantidade_por_unidade DECIMAL(14,3) NOT NULL,

    percentual_perda DECIMAL(5,2)
        NOT NULL DEFAULT 0.00,

    criado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_estrutura_produto
        PRIMARY KEY (id_estrutura),

    CONSTRAINT uk_estrutura_componente
        UNIQUE (
            id_produto_pai,
            id_produto_componente
        ),

    CONSTRAINT fk_estrutura_produto_pai
        FOREIGN KEY (id_produto_pai)
        REFERENCES produtos(id_produto)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_estrutura_produto_componente
        FOREIGN KEY (id_produto_componente)
        REFERENCES produtos(id_produto)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_estrutura_quantidade
        CHECK (quantidade_por_unidade > 0),

    CONSTRAINT chk_estrutura_perda
        CHECK (
            percentual_perda >= 0
            AND percentual_perda <= 100
        ),

    CONSTRAINT chk_estrutura_produtos_diferentes
        CHECK (
            id_produto_pai <> id_produto_componente
        ),

    INDEX idx_estrutura_componente
        (id_produto_componente)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
