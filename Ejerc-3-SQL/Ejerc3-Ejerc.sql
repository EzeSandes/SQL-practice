# \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

-- 1 Indicar la cant de productos que tiene la empresa

SELECT COUNT(*) AS Cant_Prod
FROM producto;

#Otra forma(NO SIEMPRE FUNCIONAL, por eso no hacerla, es solo para ver).
SELECT MAX(is_producto)
FROM producto;

# Otra
-- En detalle venta el producto puede repetirse varias veces, quiero la cant de prodts
-- que alguna vez fueron ventas.
SELECT COUNT(DISTINCT ID_PRODUCTO)
FROM Detalle_venta;

-- 2. Indique la cantidad de productos en estado 'en stock' que tiene la empresa.
SELECT COUNT(*) AS Cant_Prod
FROM producto
WHERE estado = 'stock';

-- 3. Indique los productos que nunca fueron vendidos.

# MIO. BIEN
SELECT id_producto
FROM producto
WHERE id_producto NOT IN 	(
								SELECT id_producto
                                FROM detalle_venta
							);

#Another way
SELECT p.id_producto
FROM producto p
WHERE NOT EXISTS 
(
	SELECT 1
    FROM detalle_venta dv
    WHERE dv.id_producto = p.id_producto
);


#Another way
SELECT p.*
FROM Producto p
LEFT JOIN Detalle_venta dv
ON p.Id_producto = dv.Id_producto
WHERE dv.Id_producto IS NULL;


-- 4. Indique la cantidad de unidades que fueron vendidas de cada producto.

# Otra. Bien
SELECT p.id_producto, SUM(cantidad)
FROM producto p
JOIN detalle_venta dv
ON p.Id_producto = dv.Id_producto
GROUP BY p.id_producto;

SELECT p.id_producto, ISNULL(SUM(cantidad), 0) AS 'Cantidad'
FROM producto p
LEFT JOIN detalle_venta dv
ON p.Id_producto = dv.Id_producto
GROUP BY p.Id_producto;

-- 5. Indique cual es la cantidad promedio de unidades vendidas de cada producto.

SELECT p.id_producto, AVG(cantidad)
FROM producto p
JOIN detalle_venta dv
ON p.Id_producto = dv.Id_producto
GROUP BY p.id_producto;

/* Better way */
SELECT p.Id_producto, ISNULL(AVG(cantidad), 0) AS 'Cantidad'
FROM Producto p
LEFT JOIN Detalle_venta dv
ON p.Id_producto = dv.Id_producto
GROUP BY p.Id_producto;


-- 6. Indique quien es el vendedor con mas ventas realizadas.

# Mio. BIEN
SELECT ve.id_vendedor, ve.Nombre, MAX(temp.cant)
FROM vendedor ve
JOIN
	(
    SELECT Id_vendedor, COUNT(*) AS cant
	FROM venta v
	GROUP BY Id_vendedor
    ) AS temp
ON temp.id_vendedor = ve.id_vendedor;

# OTRA. Con VISTAS
CREATE VIEW ventasXvendedor
AS 
    SELECT Id_vendedor, COUNT(*) AS CantVentas
	FROM venta v
	GROUP BY Id_vendedor
;

SELECT vxv.id_vendedor
FROM ventasXvendedor vxv
WHERE vxv.CantVentas = (
						SELECT MAX(CantVentas)
                        FROM ventasXvendedor
                        )
;

/* Another Way */
SELECT v.Id_vendedor, COUNT(*)
FROM Vendedor vend
JOIN Venta v
ON v.Id_vendedor = vend.Id_vendedor
GROUP BY v.Id_vendedor
HAVING COUNT(*) = (SELECT MAX(temp.cant) FROM (SELECT COUNT(*) AS Cant FROM Vendedor JOIN Venta ON Venta.Id_vendedor = Vendedor.Id_vendedor GROUP BY Venta.Id_vendedor) AS temp);



-- 7. Indique todos los productos de lo que se hayan vendido más de 15(o tambien si no 20) unidades, en total

SELECT id_producto, SUM(cantidad)
FROM detalle_venta
GROUP BY id_producto
HAVING SUM(cantidad) > 20;

-- 8. Indique los clientes que le han comprado a todos los vendedores.

-- "Obtener a todos los clientes tales que NO EXISTA un vendedor que NO LE haya comprado"
# MIO. NO completado
SELECT *
FROM cliente
WHERE NOT EXISTS (
					SELECT *
                    FROM vendedor
                    WHERE NOT EXISTS (
										SELECT *
                                        FROM venta
                                        WHERE venta.Id_cliente = venta.Id_vendedor
										)
                    );

#Otra. BIEN
SELECT *
FROM cliente c
WHERE NOT EXISTS 
				(
					SELECT *
                    FROM vendedor v
                    WHERE NOT EXISTS (
										SELECT *
										FROM venta vta
										WHERE	vta.id_vendedor = v.id_vendedor
												AND vta.id_cliente = c.id_cliente
										)
                )
;

#OTRA. Menos eficiente pero mas facil de leer.

SELECT vta.id_cliente, COUNT(DISTINCT id_vendedor)
FROM venta vta
GROUP BY vta.Id_cliente
HAVING COUNT(DISTINCT id_vendedor) = (SELECT COUNT(*) FROM vendedor)
;







