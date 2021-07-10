/***************************************************************/
/******** IMPORTANT: This exercise was do it in SQL Server *****/
/***************************************************************/


-- 4. Listar los códigos de los materiales que provea el proveedor 3 y no los provea el proveedor 5.
SELECT pp.CodMat
FROM Provisto_Por pp
WHERE CodProv = 3
		AND CodMat NOT IN(SELECT CodMat FROM Provisto_Por WHERE CodProv = 5);

/* Another way */
SELECT pp.CodMat
FROM provisto_por pp
WHERE pp.CodProv = 3
EXCEPT
SELECT pp.CodMat
FROM provisto_por pp
WHERE pp.CodProv = 5;

-- 5. Listar los números de almacenes que almacenan el artículo 1.

SELECT a.*
FROM Tiene t, Almacen a
WHERE CodArt = 1 AND a.Nro = t.NroAlmacen;

-- 7.Listar los almacenes que contienen los artículos A 1 y los artículos B 2 (ambos).
-- Uso articulo 1 y 2;


SELECT t.NroAlmacen
FROM Tiene t
WHERE CodArt = 1
		AND t.NroAlmacen IN (SELECT NroAlmacen FROM Tiene WHERE CodArt = 2);

/* Another way */
SELECT t.NroAlmacen
FROM tiene t
WHERE t.CodArt = 1
INTERSECT
SELECT t.NroAlmacen
FROM tiene t
WHERE t.CodArt = 2

-- 8. Listar los artículos que cuesten más de $100 o que estén compuestos por el material M1.

SELECT a.codArt
FROM Articulo a
WHERE a.precio > 100
UNION
Select cp.CodArt
FROM Compuesto_por cp
WHERE cp.codMat = 1;


-- 14. Hallar los códigos y nombres de los proveedores que proveen al menos un material 
-- que se usa en algún artículo cuyo precio es mayor a $100.

SELECT DISTINCT pp.CodProv, prov.Nombre
FROM Compuesto_Por cp
JOIN (SELECT CodArt FROM Articulo WHERE Precio > 100) AS temp
ON temp.CodArt = cp.CodArt
JOIN Provisto_Por pp
ON pp.CodMat = cp.CodMat
JOIN Proveedor prov
ON prov.CodProv = pp.CodProv;

/* Another way */
SELECT distinct p.codprov, p.nombre
FROM proveedor p 
JOIN provisto_por pp
ON p.CodProv = pp.CodProv
join compuesto_por cp 
on cp.CodMat = pp.CodMat
join articulo a 
on a.CodArt = cp.CodArt
WHERE a.Precio > 100
order by p.CodProv;


-- 18. Listar el/los artículo/s de menor precio.

SELECT *
FROM Articulo a
WHERE a.Precio = (SELECT MIN(Precio) FROM Articulo);

-- 21. Listar los artículos compuestos por al menos 2 materiales.

SELECT cp.CodArt
FROM Compuesto_Por cp
GROUP BY cp.CodArt
HAVING COUNT(*) >= 2;

-- 25. Listar las ciudades donde existan proveedores que provean todos los materiales.

--OTRA FORMA: Listar las ciudades tales que NO EXISTAN materiales que NO SEAN provistos

SELECT *
FROM Proveedor prov
WHERE NOT EXISTS	(SELECT 1
					 FROM Material mat
					 WHERE NOT EXISTS	(SELECT 1
										 FROM Provisto_Por pp
										 WHERE pp.CodMat = mat.CodMat
												AND pp.CodProv = prov.CodProv
										)
					);

 -- ///////////////////////
-- Adicionales
-- 1) - Listar los proveedores que fueron dados de alta en la década de 90

SELECT *
FROM Proveedor
WHERE fecha_alta LIKE '199_%';

-- 4) - Listar todos los códigos de artículos, descripción y los códigos de materiales por los
-- que están compuestos, informando “9999” en el código “material” para el caso de los
-- artículos que no están compuestos por ningún material

SELECT a.CodArt, a.Descripcion, cp.CodMat as cod_mat
FROM articulo a 
LEFT JOIN compuesto_por cp
ON a.codart = cp.codart;

--5) - Listar todos los artículos y materiales por los cuales están compuestos. Mostrar
-- artículos sin materiales y Materiales que no componen ningún artículo

SELECT a.CodArt,a.Descripcion, cp.CodMat as Material_compuesto, mat.Descripcion
FROM Articulo a
FULL OUTER JOIN Compuesto_Por cp
ON cp.CodArt = a.CodArt
FULL OUTER JOIN Material mat
ON mat.CodMat = cp.CodMat;
