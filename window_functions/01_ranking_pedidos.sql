
USE erp_industrial_analytics;

SELECT
    codigo_pedido,
    cliente,
    status_pedido,
    valor_total_pedido,

    RANK() OVER (
        ORDER BY valor_total_pedido DESC
    ) AS ranking_pedido,

    DENSE_RANK() OVER (
        ORDER BY valor_total_pedido DESC
    ) AS ranking_denso

FROM vw_faturamento_pedidos

ORDER BY valor_total_pedido DESC;

WITH exemplo AS (

    SELECT 'PEDIDO A' AS pedido, 2000 AS valor
    UNION ALL
    SELECT 'PEDIDO B', 1500
    UNION ALL
    SELECT 'PEDIDO C', 1500
    UNION ALL
    SELECT 'PEDIDO D', 1000

)

SELECT
    pedido,
    valor,

    RANK() OVER (
        ORDER BY valor DESC
    ) AS ranking,

    DENSE_RANK() OVER (
        ORDER BY valor DESC
    ) AS ranking_denso,

    ROW_NUMBER() OVER (
        ORDER BY valor DESC, pedido
    ) AS numero_linha

FROM exemplo;
