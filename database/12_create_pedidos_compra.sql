
-- Projeto: ERP Industrial Analytics
-- Criacao dos pedidos de compra

USE erp_industrial_analytics;

CREATE TABLE pedidos_compra (

    id_pedido_compra BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    codigo_pedido_compra VARCHAR(30) NOT NULL,

    id_fornecedor BIGINT UNSIGNED NOT NULL,

    data_pedido DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    data_prevista_entrega DATE,

    status_pedido VARCHAR(20) NOT NULL
        DEFAULT 'PENDENTE',

    observacao TEXT,

    criado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    atualizado_em DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT pk_pedidos_compra
        PRIMARY KEY (id_pedido_compra),

    CONSTRAINT uk_pedidos_compra_codigo
        UNIQUE (codigo_pedido_compra),

    CONSTRAINT fk_pedidos_compra_fornecedor
        FOREIGN KEY (id_fornecedor)
        REFERENCES fornecedores(id_fornecedor)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_pedidos_compra_status
        CHECK (
            status_pedido IN (
                'PENDENTE',
                'APROVADO',
                'RECEBIDO',
                'CANCELADO'
            )
        ),

    CONSTRAINT chk_pedidos_compra_data
        CHECK (
            data_prevista_entrega IS NULL
            OR DATE(data_pedido) <= data_prevista_entrega
        ),

    INDEX idx_pedidos_compra_fornecedor_data
        (id_fornecedor, data_pedido)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
