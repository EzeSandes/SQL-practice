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
		
/* Another way */
SELECT t1.*
FROM TIENE t1, TIENE t2
WHERE t1.Nro = t2.Nro
	AND t1.CodArt = 1 
	AND t2.CodArt = 2;

-- 8. Listar los artículos que cuesten más de $10 o que estén compuestos por el material 1.
SELECT *
FROM Articulo
WHERE precio > 10 OR CodArt IN 
				(
					SELECT DISTINCT CodArt FROM
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

/* Another way */
SELECT DISTINCT mat.CodMat, mat.Descripcion
FROM Provisto_por pp, Material mat
WHERE pp.CodMat = mat.CodMat
		AND pp.CodProv IN (SELECT CodProv FROM Proveedor WHERE Ciudad = 'CABA');


-- BIEN. Fijarse que da tambien Bien para la ciudad de 'La Plata' esto.

-- 10. Listar el código, descripción y precio de los artículos que se almacenan en A1(yo use almacen 1).
SELECT a.codart, a.descripcion, a.precio
FROM Articulo a
JOIN Tiene t
ON a.codart = t.codart
WHERE t.nro = 1
GROUP BY a.codart;

/* Another way */
SELECT DISTINCT art.*
FROM Articulo art, TIENE t
WHERE art.CodArt = t.CodArt
		AND t.Nro = 1;

-- 11. Listar la descripción de los materiales que componen el artículo B.

SELECT Descripcion
FROM Material
JOIN(
	SELECT CodMat
	FROM Compuesto_Por
	WHERE CodArt = 4
	) AS X
ON X.CodMat = Material.CodMat;


/* Another way with codigo articulo = 4*/
SELECT mat.Descripcion
FROM Material mat
WHERE mat.CodMat IN (SELECT CodMat FROM Compuesto_por WHERE CodArt = 4);

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

-- 14. Hallar los códigos y nombres de los proveedores que proveen al menos un material que se usa en algún artículo cuyo precio es mayor a $100(Yo uso $10).

SELECT DISTINCT prov.CodProv, prov.Nombre
FROM Proveedor prov, Provisto_por pp
WHERE prov.CodProv = pp.CodProv
		AND pp.CodMat IN (	SELECT DISTINCT cp.CodMat FROM Articulo art, Compuesto_por cp 
							WHERE	art.CodArt = cp.CodArt
							AND art.Precio > 10
						 );

-- 15.Listar los números de almacenes que tienen todos los artículos que incluyen el
-- material con código X.

/* WRONG? */
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


/* Another way. This is good */
--Los articulos 3, 4, 5 estan compuestos por el material con cod = 6
INSERT INTO TIENE VALUES (2, 5);

SELECT *
FROM Almacen alm
WHERE NOT EXISTS	(	SELECT 1
				FROM Articulo art
				WHERE CodArt IN (SELECT Compuesto_por.CodArt FROM Compuesto_por, Articulo art WHERE art.CodArt = Compuesto_por.CodArt AND Compuesto_por.CodMat = 1)
				AND NOT EXISTS	(		SELECT 1
								FROM TIENE t
								WHERE t.CodArt = art.CodArt
								AND t.Nro = alm.Nro
								)
					);


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


/* Another way */
/*First, Insert rows that verify the exercise*/
INSERT INTO Provisto_por VALUES (9, 1);
INSERT INTO Provisto_por VALUES (10, 2);

--Con esto, el material que de 1 sera el que sea proveido por un solo proveedor.
SELECT pp.codProv
FROM Provisto_por pp
WHERE pp.CodMat IN 
(
SELECT pp.CodMat
FROM Provisto_por pp
GROUP BY pp.CodMat
HAVING COUNT(*) = 1
);


-- 17. Listar el/los artículo/s de mayor precio.
SELECT *
FROM Articulo
ORDER BY precio DESC
LIMIT 3;

/* SQL SERVER */
SELECT TOP 1 *
FROM Articulo
ORDER BY Precio DESC;

/* Another way */
-- Personally, I think  this is better because If it is more than one product with the max price this query will show them.
SELECT codArt, Descripcion
FROM Articulo
WHERE precio = (SELECT MAX(Precio) FROM Articulo);

-- 18. Listar el/los artículo/s de menor precio.

SELECT *
FROM Articulo
WHERE Precio = (SELECT MIN(Precio) FROM Articulo);

-- 19. Listar el promedio de precios de los artículos en cada almacén.

SELECT t.Nro, AVG(art.Precio)
FROM Articulo art, TIENE t
WHERE art.CodArt = t.CodArt
GROUP BY t.Nro;

-- 20. Listar los almacenes que almacenan la mayor cantidad de artículos.

SELECT Nro
FROM TIENE
GROUP BY Nro
HAVING COUNT(*) = ( SELECT MAX(temp.cantArticulos) FROM (SELECT COUNT(*) AS cantArticulos FROM TIENE GROUP BY Nro) AS temp);


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

/*Only to see the amount*/
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













