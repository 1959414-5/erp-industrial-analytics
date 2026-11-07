
-- TABELA SEM INDICE SECUNDARIO

SET @inicio = NOW(6);

UPDATE benchmark_insert_sem_indices
SET quantidade = quantidade + 1
WHERE id <= 50000;

SET @fim = NOW(6);

SELECT
    'SEM INDICE SECUNDARIO' AS cenario,
    ROUND(
        TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000,
        3
    ) AS tempo_ms;


-- TABELA COM INDICE COMPOSTO

SET @inicio = NOW(6);

UPDATE benchmark_insert_com_indice
SET quantidade = quantidade + 1
WHERE id <= 50000;

SET @fim = NOW(6);

SELECT
    'COM INDICE COMPOSTO' AS cenario,
    ROUND(
        TIMESTAMPDIFF(MICROSECOND, @inicio, @fim) / 1000,
        3
    ) AS tempo_ms;
