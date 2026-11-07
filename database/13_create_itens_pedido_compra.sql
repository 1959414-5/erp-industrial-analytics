
-- Projeto: ERP Industrial Analytics
-- Criacao dos itens dos pedidos de compra

USE erp_industrial_analytics;

CREATE TABLE itens_pedido_compra (

    id_item_pedido_compra BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    id_pedido_compra BIGINT UNSIGNED NOT NULL,

    numero_item SMALLINT UNSIGNED NOT NULL,

    id_produto BIGINT UNSIGNED NOT NULL,

    descricao_item VARCHAR(150) NOT NULL,

    unidade_medida VARCHAR(10) NOT NULL,

    quantidade DECIMAL(14,3) NOT NULL,

    custo_unitario DECIMAL(15,2) NOT NULL,

    desconto_percentual DECIMAL(5,2)
        NOT NULL DEFAULT 0.00,

    CONSTRAINT pk_itens_pedido_compra
        PRIMARY KEY (id_item_pedido_compra),

    CONSTRAINT uk_itens_compra_numero
        UNIQUE (id_pedido_compra, numero_item),

    CONSTRAINT fk_itens_compra_pedido
        FOREIGN KEY (id_pedido_compra)
        REFERENCES pedidos_compra(id_pedido_compra)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_itens_compra_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_itens_compra_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_itens_compra_custo
        CHECK (custo_unitario >= 0),

    CONSTRAINT chk_itens_compra_desconto
        CHECK (
            desconto_percentual >= 0
            AND desconto_percentual <= 100
        ),

    INDEX idx_itens_compra_produto (id_produto)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
