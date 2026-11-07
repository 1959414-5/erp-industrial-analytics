
-- Projeto: ERP Industrial Analytics
-- Criacao da tabela de movimentacoes de estoque
-- Versao corrigida para MySQL 8.4

USE erp_industrial_analytics;

CREATE TABLE movimentacoes_estoque (

    id_movimentacao BIGINT UNSIGNED
        NOT NULL AUTO_INCREMENT,

    id_produto BIGINT UNSIGNED NOT NULL,

    tipo_movimentacao VARCHAR(10) NOT NULL,

    origem_movimentacao VARCHAR(10) NOT NULL,

    id_item_pedido_compra BIGINT UNSIGNED,

    id_item_pedido_venda BIGINT UNSIGNED,

    quantidade DECIMAL(14,3) NOT NULL,

    data_movimentacao DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP,

    documento_referencia VARCHAR(30) NOT NULL,

    observacao TEXT,

    CONSTRAINT pk_movimentacoes_estoque
        PRIMARY KEY (id_movimentacao),

    CONSTRAINT fk_mov_estoque_produto
        FOREIGN KEY (id_produto)
        REFERENCES produtos(id_produto)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_mov_estoque_compra
        FOREIGN KEY (id_item_pedido_compra)
        REFERENCES itens_pedido_compra(id_item_pedido_compra)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_mov_estoque_venda
        FOREIGN KEY (id_item_pedido_venda)
        REFERENCES itens_pedido_venda(id_item_pedido_venda)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_mov_estoque_tipo
        CHECK (
            tipo_movimentacao IN ('ENTRADA', 'SAIDA')
        ),

    CONSTRAINT chk_mov_estoque_origem
        CHECK (
            origem_movimentacao IN (
                'COMPRA',
                'VENDA',
                'AJUSTE'
            )
        ),

    CONSTRAINT chk_mov_estoque_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_mov_estoque_referencia
        CHECK (
            (
                origem_movimentacao = 'COMPRA'
                AND tipo_movimentacao = 'ENTRADA'
                AND id_item_pedido_compra IS NOT NULL
                AND id_item_pedido_venda IS NULL
            )
            OR
            (
                origem_movimentacao = 'VENDA'
                AND tipo_movimentacao = 'SAIDA'
                AND id_item_pedido_venda IS NOT NULL
                AND id_item_pedido_compra IS NULL
            )
            OR
            (
                origem_movimentacao = 'AJUSTE'
                AND id_item_pedido_compra IS NULL
                AND id_item_pedido_venda IS NULL
            )
        ),

    INDEX idx_mov_estoque_produto_data
        (id_produto, data_movimentacao),

    INDEX idx_mov_estoque_origem
        (origem_movimentacao, tipo_movimentacao)

) ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;
