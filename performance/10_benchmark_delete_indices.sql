SET @inicio = NOW(6);

DELETE FROM benchmark_insert_sem_indices
WHERE id <= 50000;

SET @fim = NOW(6);

SELECT
    'SEM INDICE SECUNDARIO' AS cenario,
    ROUND(
        TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000,
        3
    ) AS tempo_ms;