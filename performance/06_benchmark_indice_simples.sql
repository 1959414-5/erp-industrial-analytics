USE erp_industrial_analytics;

CREATE INDEX idx_bench_produto
ON benchmark_movimentacoes (id_produto);

ANALYZE TABLE benchmark_movimentacoes;