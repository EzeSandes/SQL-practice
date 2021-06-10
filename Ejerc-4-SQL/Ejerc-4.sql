USE Ejerc4;

/*Todas las operaciones realizadas para los cambios de moneda hacen referencia al dólar. Es decir, 
para convertir pesos a euros, debo convertir pesos a dólares, luego dolares a euros.
*/

-- A. Listar a las personas que no tienen ninguna cuenta en "pesos argentinos" en Ningún banco. Que además
	-- tengan al menos dos cuentas en "dólares"

--Personas con Pesos Argentinos
SELECT idPersona
FROM cuenta c 
JOIN moneda m 
ON m.id = c.idmoneda
WHERE m.descripcion = 'Peso Argentino';

SELECT *
FROM persona
WHERE pasaporte NOT IN 
						(
							SELECT idPersona
							FROM cuenta c 
							JOIN moneda m 
							ON m.id = c.idmoneda
							WHERE m.descripcion = 'Peso Argentino'
						);
-- 

SELECT idPersona, COUNT(*)
FROM cuenta c
WHERE idMoneda IN (SELECT id FROM Moneda WHERE descripcion = 'Dolar')
GROUP BY idPersona
HAVING COUNT(*) >= 2;



SELECT persona.*
FROM persona
WHERE pasaporte NOT IN 
						(
							SELECT idPersona
							FROM cuenta c 
							JOIN moneda m 
							ON m.id = c.idmoneda
							WHERE m.descripcion = 'Peso Argentino'
						)
	AND pasaporte IN	(
							SELECT idPersona
							FROM cuenta c
							WHERE idMoneda IN (SELECT id FROM Moneda WHERE descripcion = 'Dolar')
							GROUP BY idPersona
							HAVING COUNT(*) >= 2
						)
;

-- Otra forma

SELECT *
FROM persona P1
WHERE p1.pasaporte NOT IN
							(
								SELECT idPersona
								FROM cuenta c JOIN moneda m ON m.id = c.idmoneda
								WHERE m.descripcion = 'Peso Argentino'
							)
					AND EXISTS
							(
								SELECT 1
								FROM cuenta c JOIN moneda m ON m.id = c.idmoneda
								WHERE c.idpersona=p1.pasaporte
								AND m.descripcion = 'dolar'
								GROUP by idpersona
								HAVING COUNT(distinct idbanco)>=2
						);
							
-- B. Listar de las monedas que son operadas en todos los bancos, aquellas con el valor oro más alto.

-- "Listar las monedas(con el valor oro mas alto) tales que NO EXISTE | un banco en que NO | sea operada"

--Monedas que operan en todos los bancos
CREATE VIEW Monedas_en_todos_los_bancos AS
SELECT *
FROM Moneda m
WHERE NOT EXISTS (
					SELECT 1
					FROM Banco b
					WHERE NOT EXISTS	(
											SELECT 1
											FROM Opera
											WHERE	Opera.idBanco = b.id
													AND m.id = Opera.idMoneda
										)
				 )
;

SELECT id, descripcion FROM Monedas_en_todos_los_bancos
WHERE valorOro >= (SELECT MAX(valorOro) FROM Monedas_en_todos_los_bancos);


