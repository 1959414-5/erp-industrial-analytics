
-- Projeto: ERP Industrial Analytics
-- Integracao das movimentacoes com ordens de producao

USE erp_industrial_analytics;

ALTER TABLE movimentacoes_estoque

    -- Referencia a ordem de producao
    ADD COLUMN id_ordem_producao BIGINT UNSIGNED NULL
        AFTER id_item_pedido_venda,

    ADD INDEX idx_mov_estoque_ordem
        (id_ordem_producao),

    ADD CONSTRAINT fk_mov_estoque_ordem
        FOREIGN KEY (id_ordem_producao)
        REFERENCES ordens_producao(id_ordem_producao)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    -- Atualizar origens permitidas
    DROP CHECK chk_mov_estoque_origem,

    ADD CONSTRAINT chk_mov_estoque_origem
        CHECK (
            origem_movimentacao IN (
                'COMPRA',
                'VENDA',
                'AJUSTE',
                'PRODUCAO'
            )
        ),

    -- Atualizar regras das referencias
    DROP CHECK chk_mov_estoque_referencia,

    ADD CONSTRAINT chk_mov_estoque_referencia
        CHECK (

            (
                origem_movimentacao = 'COMPRA'
                AND tipo_movimentacao = 'ENTRADA'
                AND id_item_pedido_compra IS NOT NULL
                AND id_item_pedido_venda IS NULL
                AND id_ordem_producao IS NULL
            )

            OR

            (
                origem_movimentacao = 'VENDA'
                AND tipo_movimentacao = 'SAIDA'
                AND id_item_pedido_venda IS NOT NULL
                AND id_item_pedido_compra IS NULL
                AND id_ordem_producao IS NULL
            )

            OR

            (
                origem_movimentacao = 'PRODUCAO'
                AND id_ordem_producao IS NOT NULL
                AND id_item_pedido_compra IS NULL
                AND id_item_pedido_venda IS NULL
            )

            OR

            (
                origem_movimentacao = 'AJUSTE'
                AND id_item_pedido_compra IS NULL
                AND id_item_pedido_venda IS NULL
                AND id_ordem_producao IS NULL
            )

        );
