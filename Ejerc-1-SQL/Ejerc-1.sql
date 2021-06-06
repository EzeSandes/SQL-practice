/***************** EJERCICIO 1 BIS- Resuelto(Tiene otros datos) ********************/
####################### MIS INSERCIONES


INSERT INTO articulo (CodArt, Descripcion, Precio) VALUES (5, 'Lavarropa', 50);

INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 1);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 2);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 3);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 4);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 5);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 6);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 7);
INSERT INTO compuesto_por (CodArt, CodMat) VALUES (5, 8);



#######################



-- 1. Listar los nombres de los proveedores de la ciudad de La Plata.
SELECT Nombre
FROM Proveedor
WHERE ciudad = 'La Plata';

-- 2. Listar los números de artículos cuyo precio sea inferior a $10.
SELECT CodArt
FROM Articulo
WHERE precio < 10;

-- 3. Listar los responsables de los almacenes.
SELECT Responsable
FROM Almacen;

-- 4. Listar los códigos de los materiales que provea el proveedor 3 y no los provea el proveedor 5.
SELECT CodMat
FROM Provisto_por
WHERE CodProv = 3 AND CodMat NOT IN 
		(SELECT CodMat FROM provisto_por WHERE CodProv = 5);

-- 5. Listar los números de almacenes que almacenan el artículo 1.
SELECT Nro
FROM Tiene
WHERE CodArt  = 1;

-- 6. Listar los proveedores de Pergamino que se llamen Pérez.
SELECT *
FROM Proveedor
WHERE ciudad = 'Pergamino' AND Nombre LIKE '%Perez';

-- 7. Listar los almacenes que contienen los artículos 1 y los artículos 2 (ambos).
SELECT *
FROM Tiene
WHERE CodArt = 1 AND Nro IN (
		SELECT Nro FROM Tiene WHERE CodArt = 2);

-- 8. Listar los artículos que cuesten más de $10 o que estén compuestos por el material 1.
SELECT *
FROM Articulo
WHERE precio > 10 OR CodArt IN 
				(
					SELECT CodArt FROM
					Compuesto_por WHERE CodMat = 1
				);

SELECT A.codart, c.codmat ,a.descripcion ,a.precio
FROM Articulo A JOIN Compuesto_por C
ON A.CodArt = C.CodArt
WHERE A.precio > 10 OR C.CodMat = 1
GROUP BY A.codart;
	
-- 9. Listar los materiales, código y descripción, provistos por proveedores de la ciudad de CABA.

SELECT CodProv
FROM Proveedor
WHERE Ciudad = 'CABA';

SELECT *-- ProvPor.CodMat
FROM Provisto_por ProvPor
JOIN Proveedor Prov ON Prov.CodProv = ProvPor.codProv
WHERE Prov.ciudad = 'CABA'
GROUP BY ProvPor.CodMat; 
-- BIEN. Fijarse que da tambien Bien para la ciudad de 'La Plata' esto.

-- 10. Listar el código, descripción y precio de los artículos que se almacenan en A1(yo use almacen 1).
SELECT a.codart, a.descripcion, a.precio
FROM Articulo a
JOIN Tiene t
ON a.codart = t.codart
WHERE t.nro = 1
GROUP BY a.codart;

-- 11. Listar la descripción de los materiales que componen el artículo B.

SELECT Descripcion
FROM Material
JOIN(
	SELECT CodMat
	FROM Compuesto_Por
	WHERE CodArt = 4
	) AS X
ON X.CodMat = Material.CodMat;
-- Funciona. Se podra hacer de otra manera?

-- 12. Listar los nombres de los proveedores que proveen los materiales al almacén que Martín Gómez(Uso 'Juan Perez') tiene a su cargo.
SELECT Nro
FROM Almacen
JOIN (
	SELECT CodProv
	FROM Proveedor
	WHERE Nombre = 'Panaderia Carlitos'
    ) AS provCarlitos
ON provCarlitos.CodProv;

(SELECT CodArt
FROM Tiene
JOIN(
	SELECT Nro
	FROM Almacen
	WHERE Responsable = 'Jose Basualdo'
	) AS almsRespX
ON almsRespX.Nro = Tiene.Nro) AS ArtsAlmResX;

-- Para cada articulo necesito saber el CodMaterial que lo componene.
-- FUNCIONA pero tal vez no es lo mas eficiente.
SELECT Nombre
FROM Proveedor
JOIN
(	SELECT CodProv
	FROM Provisto_por
	JOIN
		(	SELECT Compuesto_por.CodArt, CodMat
			FROM Compuesto_por
			JOIN (	SELECT CodArt
				FROM Tiene
	JOIN(
		SELECT Nro
		FROM Almacen
		WHERE Responsable = 'Rogelio Rodriguez'
	) AS almsRespX
ON almsRespX.Nro = Tiene.Nro) AS ArtsAlmResX
ON ArtsAlmResX.CodArt = Compuesto_por.CodArt) AS MatArtProvX
ON MatArtProvX.CodMat = Provisto_por.CodMat
GROUP BY CodProv) AS ProvMatAlmResX
ON ProvMatAlmResX.CodProv = Proveedor.CodProv;

-- 13. Listar códigos y descripciones de los artículos compuestos por al menos un material provisto por el proveedor López.

SELECT distinct Articulo.CodArt, Articulo.Descripcion
FROM Articulo
JOIN compuesto_por 
ON Articulo.codArt = compuesto_por.CodArt
JOIN Material
ON Material.CodMat = compuesto_por.CodMat
JOIN Provisto_por
ON Provisto_por.CodMat = Material.CodMat
JOIN Proveedor
ON Proveedor.CodProv = Provisto_por.CodProv
WHERE Proveedor.Nombre = 'Fiambres Perez';

-- 14. Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100.
SELECT Proveedor.CodProv, Proveedor.Nombre
FROM Proveedor;

SELECT CodProv, Nombre
FROM Proveedor
WHERE CodProv IN
(
SELECT distinct Provisto_por.CodProv
FROM provisto_por
WHERE CodMat IN
(SELECT Compuesto_por.CodMat
FROM Compuesto_por
JOIN (SELECT CodArt
FROM Articulo
WHERE precio > 10) AS ArtMayorX
ON ArtMayorX.codArt = Compuesto_por.codArt)
);


-- 15.Listar los números de almacenes que tienen todos los artículos que incluyen el
-- material con código X.

SELECT alm.Nro
FROM Almacen alm
LEFT JOIN 
(
	SELECT CodArt
	FROM Compuesto_por
	WHERE CodMat = 6
) AS Art
ON alm.Nro = art.codart
WHERE art.codart IS NULL;

SELECT distinct tiene.Nro
FROM tiene
LEFT JOIN 
(
	SELECT distinct CodArt
	FROM Compuesto_por
	WHERE CodMat = 6
) AS Art
ON tiene.codart = art.codart
WHERE art.codart IS NULL;

-- 15.Listar los números de almacenes que tienen todos los artículos que incluyen el
-- material con código X.

SELECT distinct tiene.Nro, tiene.codart
FROM tiene
where tiene.CodArt = ALL
(
	SELECT CodArt
	FROM Compuesto_por
	WHERE CodMat = 1
);

SELECT distinct tiene.Nro, tiene.codart
FROM tiene
WHERE EXISTS
	(
		SELECT CodArt
		FROM Compuesto_por
		WHERE CodMat = 1
        HAVING Count(CodArt) > 1
	);

-- 16. Listar los proveedores que sean únicos proveedores de algún
-- material.

## Veo entonces el material que es proveido por una persona en "Provisto_por"

SELECT pp.codProv AS 'Proveedor' , temp.codmat
FROM
(
SELECT codMat, COUNT(*) as CANT_Prov
FROM Provisto_por
GROUP BY codMat
HAVING COUNT(*) = 3
ORDER BY codMat
) AS temp
JOIN provisto_por pp
ON pp.codMat = temp.codMat;

-- 17. Listar el/los artículo/s de mayor precio.
SELECT *
FROM Articulo
ORDER BY precio DESC
LIMIT 3;



-- 21. Listar los artículos compuestos por al menos 2 materiales.

SELECT distinct compuesto_por.codArt
FROM compuesto_por
JOIN 
(SELECT compuesto_por.CodArt, compuesto_por.CodMat
FROM Compuesto_por
CROSS JOIN
Compuesto_por cp1) AS cp
ON compuesto_por.CodArt = cp.CodArt AND cp.CodMat <> compuesto_por.CodMat;

-- MEJOR FORMA
SELECT codArt, COUNT(*) AS CANT_MAT_COMP
FROM Compuesto_por
GROUP BY CodArt
HAVING COUNT(*) >= 2;

-- 22. Listar los artículos compuestos por exactamente 2 materiales.
SELECT codArt, COUNT(*) AS CANT_MAT_COMP
FROM Compuesto_por
GROUP BY CodArt
HAVING COUNT(*) = 2;

-- 23. Listar los artículos que estén compuestos con hasta 2 materiales.
SELECT codArt, COUNT(*) AS CANT_MAT_COMP
FROM Compuesto_por
GROUP BY CodArt
HAVING COUNT(*) <= 2;

-- 24. Listar los artículos compuestos por todos los materiales.
SELECT CodMat, COUNT(*) AS CANT
FROM Compuesto_por
GROUP BY CodMat;

/*OTRA FORMA DE EXPRESARLO: Articulos tales que | NO EXISTE un material de lo que | NO esten compuestos*/
SELECT a.CodArt
FROM articulo a
WHERE NOT EXISTS	(	SELECT *
				FROM Material m
                        	WHERE NOT EXISTS(	SELECT *
							FROM compuesto_por cp
                                                	WHERE	cp.CodArt = a.codArt
							AND cp.CodMat = m.codMat
						)
			)
;

/*OTRA FORMA: Contar la # de materiales y luego encontrar los articulos con esa misma # de Materiales compuesto*/

SELECT CodMat, COUNT(*)
FROM Material
GROUP BY CodMat;

SELECT cp.CodArt, COUNT(*) AS 'Cant Materiales'
FROM Compuesto_por cp
WHERE CodMat IN (	SELECT CodMat
					FROM Material
					GROUP BY CodMat
				)
GROUP BY cp.CodArt
HAVING COUNT(*) = (	SELECT COUNT(*) -- # de Materiales
					FROM Material
				   );


-- 25. Listar las ciudades donde existan proveedores que provean todos los materiales.
-- Prov 3: Provee todos los materiales

INSERT INTO provisto_por (CodMat, CodProv) VALUES (5, 3);
DELETE FROM provisto_por 
WHERE CodMat = 5 AND CodProv = 3;

#OTRA FORMA: Listar las ciudades tales que NO EXISTA | proveedores que | NO provea algun material

# MAL. NO FUNCIONA
SELECT prov.Ciudad
FROM proveedor prov
WHERE NOT EXISTS (	SELECT *
		  	FROM proveedor prov2
                   	WHERE NOT EXISTS	(	SELECT *
							FROM provisto_por pp, proveedor prov2
                                        		WHERE	prov2.CodProv = pp.CodProv
						)
		)
;

SELECT prov.Ciudad
FROM proveedor prov
WHERE NOT EXISTS (	SELECT *
			FROM provisto_por pp
                    	WHERE NOT EXISTS(	SELECT *
						FROM material m
                                       		WHERE	pp.CodProv = prov.CodProv
						AND m.codMat = pp.CodMat
					)
		)
;



SELECT prov.Ciudad
FROM proveedor prov
WHERE NOT EXISTS	(	SELECT *
				FROM provisto_por pp
                        	WHERE pp.CodProv = prov.CodProv
			)
;

-- 25. Listar las ciudades donde existan proveedores que provean todos los materiales.
# Listar los proveedores tales que NO EXISTA materiales que no provean

# BIEN
select *
from proveedor p
where not exists (
					select 1
					from material m
					where not exists (
											select 1
											from provisto_por pp
											where pp.CodMat=m.CodMat and pp.CodProv=p.CodProv));


# OTRA FORMA 2: Contar la # de materiales y luego encontrar la # materiales que provee cada proveedor y quedarse con el igual 

-- # De materiales que provee cada proveedor
SELECT codProv, COUNT(*) AS CANT_MAT
FROM provisto_por pp
GROUP BY CodProv;













