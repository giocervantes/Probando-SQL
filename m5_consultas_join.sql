--TP 5--
--Archivo: ventas_tech_db--

--Tablas a usar --

    SELECT *
    FROM cliente

    SELECT *
    FROM categoria

    SELECT *
    FROM productos

    SELECT *
    FROM ventas

---

--Consulta 1(Vista base del proyecto)--
--Proposito: ver las ventas mas recientes, que se vendió, cuantas unidades y quien lo compro y el ingreso generado
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre                    AS nombre_cliente,
   
    p.id_producto,
    p.nombre_producto                    AS producto,
    p.id_categoria,
    
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta

FROM ventas AS v
INNER JOIN cliente c  ON v.id_cliente  = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta DESC;
--Hallazgos: Podemos ver que Laura Torres fue la clienta mas reciente y compro 2 monitores generando un ingreso a la empresa de 900.--

---

--Consulta 2 (Clientes sin ventas)--
--Proposito: La idea es identificar clientes registrados que aún no han realizado ninguna compra pero en los datos tablas involucradas todos los registrados si realizaron compras asi que lo organicé  ascendente para saber quien gasto menos--

SELECT
    c.id_cliente,
    c.nombre,
    c.mail AS COrreo,
    c.fecha_registro AS Registro,
    ISNULL((SELECT SUM(precio_unitario*cantidad)
            FROM ventas AS v
            WHERE v.id_cliente = c.id_cliente),0)
            AS TotalComprado
        FROM cliente AS c
        ORDER BY TotalComprado ASC;

--Hallazgos: En la tabla muestra mis peores y mejores clientes. Vemos que Pedro Sanz fue la que gasto menos y MAría Lopez con mayor gasto en productos--

---

--Consulta 3 (productos sin ventas. Que no tienen ninguna venta registrada)
--Proposito: Es parecido al anterior todos los productos tiene como minimo una venta realizada , asi que tambien lo orgnaice ascendente--

SELECT
    p.id_producto,
    p.nombre_producto AS Producto,
    p.precio AS Precio,
    ISNULL((SELECT SUM(precio_unitario*cantidad)
            FROM ventas AS v
            WHERE v.id_producto = p.id_producto),0)
            AS TotalVendido
        FROM productos AS p
        ORDER BY TotalVendido ASC;

--Hallazgos: Al ordenar la tabla ascendente, en la parte de arriba se muestra que el producto auriculares es el que generó menor ingreso y abajo los que mas dinero generaron--

---

--Consulta 4 (UNION ALL)--
--No entendi la consulta. En portal de CODER el video dispone de 2 tablas parecidas y en las que tengo no. Tengo que dividir, crear  2 grupos con esos datos (total facturado), definiendo un corte en los meses indicando cuales fueron online y presencial..y las uno en una nueva tabla  --

SELECT canal, SUM(total) AS total_canal
FROM (
    -- SELECT 1: Ventas realizadas del 5 al 8 de marzo
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Online' AS canal
    FROM ventas 
    WHERE fecha_venta <= '2024-03-08'

    UNION ALL

    -- SELECT 2:Ventas realizadas del 9 al 12 de marzo
    SELECT fecha_venta, cantidad * precio_unitario AS total, 'Presencial' AS canal
    FROM ventas 
    WHERE fecha_venta > '2024-03-08'
) AS consolidado
GROUP BY canal;

--Hallazgos:  vemos que de forma online genero mayor ingreso--

--or--
