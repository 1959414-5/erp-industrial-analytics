
-- Projeto: ERP Industrial Analytics
-- Criacao dos itens dos pedidos de venda

USE erp_industrial_analytics;

CREATE TABLE itens_pedido_venda (

    id_item_pedido_venda BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    id_pedido_venda BIGINT UNSIGNED NOT NULL,

    numero_item SMALLINT UNSIGNED NOT NULL,

    id_produto BIGINT UNSIGNED NOT NULL,

    descricao_item VARCHAR(150) NOT NULL,

    unidade_medida VARCHAR(10) NOT NULL,

    quantidade DECIMAL(14,3) NOT NULL,

    preco_unitario DECIMAL(15,2) NOT NULL,

    desconto_percentual DECIMAL(5,2)
        NOT NULL DEFAULT 0.00,

    CONSTRAINT pk_itens_pedido_venda
        PRIMARY KEY (id_item_pedido_venda),

    CONSTRAINT uk_itens_pedido_numero
        UNIQUE (id_pedido_venda, numero_item),

    CONSTRAINT fk_itens_pedido_venda_pedido
        FOREIGN KEY (id_pedido_venda)
        REFERENCES pedidos_venda(id_pedido_venda)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_itens_pedido_venda_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_itens_pedido_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_itens_pedido_preco
        CHECK (preco_unitario >= 0),

    CONSTRAINT chk_itens_pedido_desconto
        CHECK (
            desconto_percentual >= 0
            AND desconto_percentual <= 100
        ),

    INDEX idx_itens_pedido_produto (id_produto)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
