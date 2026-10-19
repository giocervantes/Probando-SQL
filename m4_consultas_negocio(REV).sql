--TP 4-Ventas Tech--
SElECT *
FROM ventas

--Agregué 2 filas con otros datos para tener mas variedad--
INSERT INTO ventas (id_venta,fecha_venta,id_cliente,id_producto,cantidad,precio_unitario)
	VALUES
	(11, '2024-01-12',2, 2, 3, 28.00),
	(12, '2024-01-18',3, 6, 1, 95.00);

--Consultas SQL--
SElECT *
FROM ventas

--Consulta 1 (Resumen ejecutivo por mes)

SELECT
    MONTH(fecha_venta)                          AS mes,
    SUM(cantidad * precio_unitario)             AS total_facturado,
    COUNT(*)                                    AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) / COUNT(*)  AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


--Consulta 2 (Ranking de productos-Top 5 que generan mayor facturación)
SELECT TOP 5
    id_producto,
    SUM(cantidad)                   AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--Consulta 3 (Clientes recurrentes)
SELECT
    id_cliente,
    COUNT(*)                        AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

--Consulta 4 (Meses por encima o por debajo del promedio)
WITH totales_mensuales AS (
    SELECT
        MONTH(fecha_venta)              AS mes,
        SUM(cantidad * precio_unitario) AS total_mensual
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_mensual,
    CASE
        WHEN total_mensual > (SELECT AVG(total_mensual) FROM totales_mensuales)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparativa_prom
FROM totales_mensuales
ORDER BY mes;

--Conclusiones-Hallazgos--

--El producto 1 es el que genera mayor facturación y concentra aproximadamente el 70% del total--

--El cliente 1 es el mas recurrente, mas gastó y aportó en la facturación generada.

--El mes 3 (marzo) generó mayor facturación--
