--Para Entregable Nro 4 (Solo tabla ventas)--

SELECT*
FROM ventas
--Agregue un par de datos de distinto año y mes para aplicar lo solicitado--


--Consulta 1 (Resumen ejecutivo)--

SELECT cantidad, precio_unitario,
	cantidad*precio_unitario AS total_faturado

FROM ventas;--Total facturado por id--


SELECT
	SUM(cantidad) AS cantidad_pedidos

FROM ventas;

SELECT
	AVG (cantidad*precio_unitario) AS ticket_promedio
FROM ventas;

--Forma conjunta:--

SELECT
	SUM(cantidad*precio_unitario) AS total_faturado,
	SUM(cantidad) AS cantidad_pedidos,
	AVG (cantidad*precio_unitario) AS ticket_promedio
FROM ventas;

--Consulta 2 (Ranking top 5)--

SELECT id_producto,
	SUM (cantidad*precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
--El producto 1 es el que mas facturación generó--

--Consulta 3 (Clientes recurrentes)

SELECT*
FROM ventas

SELECT 
	id_cliente,
	COUNT(*) AS cantidad_pedidos,
	SUM(cantidad*precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*)>1
ORDER BY cantidad_pedidos DESC;
--El cliente 1 es el que mas productos compro--

--Consulta 4:Meses encima o por debajo--

SELECT*
FROM ventas
--
SELECT
	MONTH(fecha_venta) AS mes,
	SUM(cantidad*precio_unitario) AS total_facturado,
	--Aqui va el CASE WHEN--
	CASE WHEN SUM(cantidad*precio_unitario)>
		(SELECT AVG(total_mes)
		FROM (SELECT SUM(cantidad*precio_unitario) AS total_mes
			FROM ventas
			GROUP BY MONTH(fecha_venta))t)
		THEN 'por encima'
		ELSE 'por debajo'
	END AS comparativa
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;