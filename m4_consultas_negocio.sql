-- Pre-entrega: Consultas SQL de negocio

-- Título: Extrayendo métricas clave con SQL

USE Ventas_Tech_DB;
GO

-- CONSULTA 1: Resumen ejecutivo mensual 
-- Total facturado, cantidad de pedidos y ticket promedio por mes.
SELECT
    MONTH(fecha_venta)               AS mes,
    SUM(cantidad * precio_unitario)  AS total_facturado,
    COUNT(*)                         AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)  AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


-- CONSULTA 2: Ranking de productos (Top 5) 
-- Los 5 productos que más facturaron, con sus unidades vendidas.
SELECT TOP 5
    id_producto,
    SUM(cantidad)                    AS unidades_vendidas,
    SUM(cantidad * precio_unitario)  AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;


-- CONSULTA 3: Clientes recurrentes
-- Clientes con más de un pedido, con su cantidad de compras y gasto total.
SELECT
    id_cliente,
    COUNT(*)                         AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)  AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1

-- HAVING filtra sobre el resultado ya agrupado (no se puede usar WHERE
-- acá porque COUNT(*) todavía no existe antes de agrupar).
ORDER BY total_gastado DESC;


-- CONSULTA 4: Meses por encima / por debajo del promedio
-- Total facturado por mes, comparado contra el promedio mensual general.
WITH ventas_por_mes AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM ventas_por_mes)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_por_mes
ORDER BY mes;


-- ══════════════════════════════════════════
-- HALLAZGOS LUEGO DE LAS CONSULTAS
-- ══════════════════════════════════════════
-- 1. El producto 2 es el que mayor rotacion tuvo en el periodo.
-- sin embargo, la facturacion fue la mas baja, por debajo del ticket promedio.

-- 2. El cliente 1 generó la mayor parte de los ingresos en el periodo,
-- con un 41% del total facturado.

-- 3. Todos nuestros clientes realizaron 2 pedidos en el periodo.
