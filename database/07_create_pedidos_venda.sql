
-- Projeto: ERP Industrial Analytics
-- Criacao da tabela de pedidos de venda

USE erp_industrial_analytics;

CREATE TABLE pedidos_venda (

    id_pedido_venda BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    codigo_pedido VARCHAR(30) NOT NULL,

    id_cliente BIGINT UNSIGNED NOT NULL,

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

    CONSTRAINT pk_pedidos_venda
        PRIMARY KEY (id_pedido_venda),

    CONSTRAINT uk_pedidos_venda_codigo
        UNIQUE (codigo_pedido),

    CONSTRAINT fk_pedidos_venda_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_pedidos_venda_status
        CHECK (
            status_pedido IN (
                'PENDENTE',
                'APROVADO',
                'EM_PRODUCAO',
                'FATURADO',
                'ENTREGUE',
                'CANCELADO'
            )
        ),

    CONSTRAINT chk_pedidos_venda_data
        CHECK (
            data_prevista_entrega IS NULL
            OR DATE(data_pedido) <= data_prevista_entrega
        ),

    INDEX idx_pedidos_cliente_data
        (id_cliente, data_pedido)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
