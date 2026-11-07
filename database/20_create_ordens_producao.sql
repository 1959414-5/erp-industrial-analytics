
-- Projeto: ERP Industrial Analytics
-- Criacao das ordens de producao

USE erp_industrial_analytics;

CREATE TABLE ordens_producao (

    id_ordem_producao BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    codigo_ordem VARCHAR(30) NOT NULL,

    id_produto BIGINT UNSIGNED NOT NULL,

    data_abertura DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    data_prevista_conclusao DATE,

    quantidade_planejada DECIMAL(14,3) NOT NULL,

    status_ordem VARCHAR(20) NOT NULL
        DEFAULT 'PLANEJADA',

    observacao TEXT,

    criado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_ordens_producao
        PRIMARY KEY (id_ordem_producao),

    CONSTRAINT uk_ordens_producao_codigo
        UNIQUE (codigo_ordem),

    CONSTRAINT fk_ordens_producao_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_ordens_producao_quantidade
        CHECK (quantidade_planejada > 0),

    CONSTRAINT chk_ordens_producao_status
        CHECK (
            status_ordem IN (
                'PLANEJADA',
                'LIBERADA',
                'EM_PRODUCAO',
                'CONCLUIDA',
                'CANCELADA'
            )
        ),

    CONSTRAINT chk_ordens_producao_data
        CHECK (
            data_prevista_conclusao IS NULL
            OR DATE(data_abertura) <= data_prevista_conclusao
        ),

    INDEX idx_ordens_producao_produto_status
        (id_produto, status_ordem)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
