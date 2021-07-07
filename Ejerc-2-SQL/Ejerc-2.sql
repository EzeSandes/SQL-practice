USE ejerc2;

-- 1. Hallar el código (nroProv) de los proveedores que proveen el artículo a146.

SELECT DISTINCT nroProv
FROM pedido
WHERE nroArt = 'a146';

-- 2. Hallar los clientes (nomCli) que solicitan artículos provistos por p015(yo elijo el 5).

SELECT nroCli
FROM pedido
WHERE nroArt IN (
					SELECT nroArt
                    FROM pedido
                    WHERE nroProv = 5
				);

-- 3. Hallar los clientes que solicitan algún item provisto por proveedores con categoría
	-- mayor que 4(yo tomo >= 3).

SELECT DISTINCT nroCli
FROM pedido
WHERE nroProv IN 	(	SELECT nroProv
						FROM proveedor
                        WHERE categoria >= 3
					);

-- 4. Hallar los pedidos en los que un cliente de Rosario solicita artículos producidos en
	-- la ciudad de Mendoza.

SELECT *
FROM pedido
WHERE nroCli IN (
						SELECT nroCli
                        FROM cliente
                        WHERE ciudadCli = 'Rosario'
						)
		AND
        nroArt IN (
					SELECT nroArt
					FROM articulo
					WHERE ciudadArt = 'Mendoza'
				)
;

/* Another way */
SELECT p.*
FROM pedido p, cliente c
WHERE	p.nroCli = c.nroCli 
		AND c.ciudadCli = 'Rosario'
		AND p.nroArt IN (SELECT nroArt FROM articulo WHERE ciudadArt = 'Mendoza');


-- 5. Hallar los pedidos en los que el cliente c23 solicita artículos solicitados por el
	-- cliente c30.

SELECT DISTINCT p1.*
FROM pedido p1, pedido p2
WHERE p1.nroCli = 'c30' AND p2.nroCli = 'c23' AND p2.nroArt = p1.nroArt
;

SELECT *
FROM pedido 
WHERE nroCli = 'c23';

SELECT *
FROM pedido 
WHERE nroCli = 'c30';

/* Another way. I think the above solution is wrong and the following is correct. Just in case I keep both */
SELECT p.*
FROM pedido p
WHERE p.nroCli = 'c23'
	AND p.nroArt IN (SELECT DISTINCT nroArt FROM pedido WHERE nroCli = 'c30');

-- 6. Hallar los proveedores que suministran todos los artículos cuyo precio es superior
	-- al precio promedio de los artículos que se producen en La Plata.

# Hallar los preveedores tales que NO EXISTE articulos cuyo precio es superior al precio promedio de los articulos
# que se preoducen en La Plata que NO sean suministrados.

SELECT nroArt
FROM articulo 
WHERE precio > (SELECT AVG(precio) FROM articulo WHERE ciudadArt = 'La Plata');

SELECT precio FROM articulo WHERE ciudadArt = 'La Plata';

#BIEN. El proveedor 1 es el unico que suministra TODOS los articulos cuyo precio es superior al promedio....
SELECT nroProv
FROM proveedor
WHERE NOT EXISTS (	SELECT *
					FROM articulo 
					WHERE precio > (SELECT AVG(precio) FROM articulo WHERE ciudadArt = 'La Plata')
                    AND NOT EXISTS (	SELECT *
										FROM pedido
                                        WHERE 	proveedor.nroProv = pedido.nroProv
												AND articulo.nroArt = pedido.nroArt
									)
				 )
;

-- 7. Hallar la cantidad de artículos diferentes provistos por cada proveedor que provee
	-- a todos los clientes de Junín(yo utilizo Mendoza).

# provee a todos los clientes de Junín(yo utilizo Mendoza)

#RTA: nro Prov: 6. Es quien provee a TODOS los clientes de mendoza

-- Proveedores que provee a TODOS los clientes de Mendoza
SELECT nroProv
FROM proveedor
WHERE NOT EXISTS (	SELECT *
					FROM cliente
                    WHERE ciudadCli = 'Mendoza'
                    AND NOT EXISTS (	SELECT *
										FROM pedido
                                        WHERE	pedido.nroCli = cliente.nroCli
												AND proveedor.nroProv = pedido.nroProv
									)
					)
;
--
# BIEN
SELECT nroProv, COUNT(*) AS "Cant Art dif"
FROM pedido
WHERE nroProv IN 
(
SELECT nroProv
FROM proveedor
WHERE NOT EXISTS (	SELECT *
					FROM cliente
                    WHERE ciudadCli = 'Mendoza'
                    AND NOT EXISTS (	SELECT *
										FROM pedido
                                        WHERE	pedido.nroCli = cliente.nroCli
												AND proveedor.nroProv = pedido.nroProv
									)
					)
)
GROUP BY nroProv;

/* Another way*/
CREATE VIEW proveeTodoCliMendoza
AS
SELECT nroProv
FROM proveedor prov
WHERE NOT EXISTS	(	SELECT 1
						FROM cliente cli
						WHERE cli.ciudadCli = 'Mendoza'
						AND NOT EXISTS	(	SELECT 1
											FROM pedido ped
											WHERE ped.nroCli = cli.nroCli
													AND ped.nroProv = prov.nroProv
										)
					);


SELECT nroProv, COUNT(*)
FROM pedido
WHERE nroProv IN (SELECT nroProv FROM proveeTodoCliMendoza)
GROUP BY nroProv;

-- 8. Hallar los nombres de los proveedores cuya categoría sea mayor que la de todos
	-- los proveedores que proveen el artículo “cuaderno”.

;
# Todos los proveedores que proveen el articulo 'Cuaderno' y su categoria
SELECT DISTINCT proveedor.nroProv, categoria
FROM pedido, proveedor
WHERE nroArt = (	SELECT nroArt
					FROM articulo
                    WHERE descripcion = 'cuaderno'
				)
	AND pedido.nroProv = proveedor.nroProv
;

#BIEN
SELECT nomProv
FROM proveedor p1
WHERE p1.categoria > ALL 
(
	SELECT DISTINCT categoria
	FROM pedido, proveedor
	WHERE nroArt = (	SELECT nroArt
						FROM articulo
						WHERE descripcion = 'cuaderno'
					)
			AND pedido.nroProv = proveedor.nroProv
);

/* Another way */
SELECT nomProv
FROM proveedor
WHERE categoria > (SELECT MAX(prov.categoria) 
					FROM proveedor prov, pedido ped 
					WHERE prov.nroProv = ped.nroProv
					AND ped.nroArt IN (SELECT nroArt FROM articulo WHERE descripcion = 'Cuaderno'));


-- 9. Hallar los proveedores que han provisto más de 1000 unidades entre los artículos
	-- A001y A100.(...mas de 50 unidades entre los articulos a250 y c490)
/* TO DO: Exerc 9
SELECT prov.nroProv
FROM proveedores prov, pedido ped
WHERE	prov.nroProv = ped.nroProv
		AND 
 ;       
	
# EN VERDAD. NI IDEA DE LO QUE PIDE MAS QUE DE LA RESOLUCION
SELECT SUM(cantidad)
FROM pedido
WHERE nroArt = 'a250' OR nroArt = 'c490';
*/

-- 10. Listar la cantidad y el precio total de cada artículo que han pedido los Clientes a
	-- sus proveedores entre las fechas 01-01-2004 y 31-03-2004 (se requiere visualizar
	-- Cliente, Articulo, Proveedor, Cantidad y Precio).

# Nota/To Do: Funciona, pero, si agrupo por 'nroProv' => no mostrara las cantidades totales y el precio total. Corregir esto
SELECT nroCli, nroArt, /*nroProv,*/ SUM(cantidad) AS Cant_total, SUM(precioTotal) AS Prec_Total
FROM pedido p
WHERE fechaPedido BETWEEN '2004-01-01' AND '2004-03-31'
GROUP BY nroArt, nroCli
ORDER BY nroCli, nroArt;


-- 11. Idem anterior y que además la Cantidad sea mayor o igual a 1000 o el Precio sea
	-- mayor a $ 1000. (Yo utilice, por mi lote de prueba, cantidad >= 1000 y precio > 1000 )

SELECT nroCli, nroArt, /*nroProv,*/ SUM(cantidad) AS Cant_total, SUM(precioTotal) AS Prec_Total
FROM pedido p
WHERE	fechaPedido BETWEEN '2004-01-01' AND '2004-03-31'
GROUP BY nroArt, nroCli
HAVING SUM(cantidad) >= 1000 OR SUM(precioTotal) > 1000
ORDER BY nroCli, nroArt;

-- 12. Listar la descripción de los artículos en donde se hayan pedido en el día más del
	-- stock existente para ese mismo día.

SELECT DISTINCT a.descripcion, pe.fechaPedido /*fecha Pedido para verificar que son de distintos dias.*/
FROM articulo a, stock s, pedido pe
WHERE	a.nroArt = pe.nroArt 
		AND s.nroArt = pe.nroArt
		AND pe.fechaPedido = s.fecha
        AND s.cantidad < (	SELECT SUM(cantidad)
							FROM pedido pe2
                            WHERE	a.nroArt = pe2.nroArt
									AND pe2.fechaPedido = pe.fechaPedido
						 )
;


-- 13. Listar los datos de los proveedores que hayan pedido de todos los artículos en un
	-- mismo día. Verificar sólo en el último mes de pedidos.

# TO DO
/*
SELECT prov.*
FROM proveedor prov
WHERE NOT EXISTS (	SELECT 1
					FROM articulo a
                    WHERE NOT EXISTS (	SELECT 1
										FROM pedido pe
                                        WHERE	prov.nroProv = pe.nroProv
												AND a.nroArt = pe.nroArt
									 )
				 )
*/







