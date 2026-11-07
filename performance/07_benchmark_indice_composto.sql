USE erp_industrial_analytics;

CREATE INDEX idx_bench_produto_origem_data
ON benchmark_movimentacoes (
    id_produto,
    origem_movimentacao,
    data_movimentacao
);

ANALYZE TABLE benchmark_movimentacoes;