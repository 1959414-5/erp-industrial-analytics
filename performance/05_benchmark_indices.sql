
-- Projeto: ERP Industrial Analytics
-- Benchmark de indices
-- Geracao de 100.000 movimentacoes ficticias

USE erp_industrial_analytics;

-- Recria somente a tabela de benchmark.
-- Nenhuma tabela operacional sera alterada.

DROP TABLE IF EXISTS benchmark_movimentacoes;

CREATE TABLE benchmark_movimentacoes (

    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,

    id_produto INT UNSIGNED NOT NULL,

    origem_movimentacao VARCHAR(10) NOT NULL,

    tipo_movimentacao VARCHAR(10) NOT NULL,

    quantidade DECIMAL(14,3) NOT NULL,

    data_movimentacao DATETIME NOT NULL,

    documento_referencia VARCHAR(30) NOT NULL,

    PRIMARY KEY (id)

) ENGINE = InnoDB;


-- Gerar 100.000 registros utilizando combinacoes
-- de cinco conjuntos de digitos (0 a 9).

INSERT INTO benchmark_movimentacoes (
    id_produto,
    origem_movimentacao,
    tipo_movimentacao,
    quantidade,
    data_movimentacao,
    documento_referencia
)

SELECT
    MOD(FLOOR(n / 4), 100) + 1,

    CASE MOD(n, 4)
        WHEN 0 THEN 'COMPRA'
        WHEN 1 THEN 'VENDA'
        WHEN 2 THEN 'PRODUCAO'
        ELSE 'AJUSTE'
    END,

    CASE MOD(n, 4)
        WHEN 0 THEN 'ENTRADA'
        WHEN 1 THEN 'SAIDA'
        WHEN 2 THEN 'SAIDA'
        ELSE 'ENTRADA'
    END,

    (MOD(n, 500) + 1) / 10,

    DATE_ADD(
        '2026-06-01 00:00:00',
        INTERVAL FLOOR(n / 400) DAY
    ),

    CONCAT(
        'BENCH-',
        LPAD(n + 1, 6, '0')
    )

FROM (

    SELECT
        a.d
        + b.d * 10
        + c.d * 100
        + d.d * 1000
        + e.d * 10000 AS n

    FROM (
        SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
        SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
    ) a

    CROSS JOIN (
        SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
        SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
    ) b

    CROSS JOIN (
        SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
        SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
    ) c

    CROSS JOIN (
        SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
        SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
    ) d

    CROSS JOIN (
        SELECT 0 AS d UNION ALL SELECT 1 UNION ALL
        SELECT 2 UNION ALL SELECT 3 UNION ALL
        SELECT 4 UNION ALL SELECT 5 UNION ALL
        SELECT 6 UNION ALL SELECT 7 UNION ALL
        SELECT 8 UNION ALL SELECT 9
    ) e

) numeros;
