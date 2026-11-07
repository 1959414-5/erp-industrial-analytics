
USE erp_industrial_analytics;

DROP TABLE IF EXISTS benchmark_insert_sem_indices;
DROP TABLE IF EXISTS benchmark_insert_com_indice;

-- Tabela sem índices secundários
CREATE TABLE benchmark_insert_sem_indices (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_produto INT UNSIGNED NOT NULL,
    origem_movimentacao VARCHAR(10) NOT NULL,
    tipo_movimentacao VARCHAR(10) NOT NULL,
    quantidade DECIMAL(14,3) NOT NULL,
    data_movimentacao DATETIME NOT NULL,
    documento_referencia VARCHAR(30) NOT NULL,
    PRIMARY KEY (id)
) ENGINE = InnoDB;


-- Tabela com índice composto
CREATE TABLE benchmark_insert_com_indice (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_produto INT UNSIGNED NOT NULL,
    origem_movimentacao VARCHAR(10) NOT NULL,
    tipo_movimentacao VARCHAR(10) NOT NULL,
    quantidade DECIMAL(14,3) NOT NULL,
    data_movimentacao DATETIME NOT NULL,
    documento_referencia VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),

    INDEX idx_bench_produto_origem_data (
        id_produto,
        origem_movimentacao,
        data_movimentacao
    )
) ENGINE = InnoDB;
