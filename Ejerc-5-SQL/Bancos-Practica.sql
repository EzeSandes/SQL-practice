USE bancos;

/*
1-Redactar las sentencias que permitan agregar las restricciones de integridad referencial 
permitiendo la actualizacion automatica para el caso de actualizar o eliminar un banco, 
moneda o persona. Demostrar el correcto funcionamiento de las restricciones creadas
Redactar las sentencias que permitan eliminar las restricciones creadas en el paso anterior.
*/

--2 constraint, 2 FK una con nombre y otra sin nombre.
--On delete cascade -> Si borra moneda, se borra cuenta tambien. Todas las filas en donde
	-- ese ID que le borramos este.
	-- ON UPDATE CASCADE -> Hace lo mismo, si hago una actualizacion del iDMoneda, se actualizara en
	-- donde aparece en cuenta el que actualice.
ALTER TABLE Cuenta 
ADD CONSTRAINT fk_bancoNombre
FOREIGN KEY (idBanco) REFERENCES Banco(id)
ON DELETE CASCADE 
ON UPDATE CASCADE;

ALTER TABLE Cuenta 
ADD FOREIGN KEY (idMoneda) REFERENCES Moneda(id)
ON DELETE CASCADE 
ON UPDATE CASCADE;

/*
2-
Listar los bancos que solamente operan todas las monedas que no son el PESO URUGUAYO.
Utilizar una vista para todas las monedas.
*/

--Buscar a los bancos que no operen con el peso uruguayo. 
SELECT *
FROM Moneda m
WHERE NOT EXISTS (
						SELECT *
						FROM Banco b
						WHERE  NOT EXISTS (
												SELECT *
												FROM Opera o
												WHERE o.idBanco = b.id
														AND o.idMoneda = m.id
											)
					);

;

CREATE VIEW vBancoMultimoneda AS
SELECT *
FROM banco b
WHERE NOT EXISTS	(
						SELECT *
						FROM Moneda m
						WHERE m.id NOT IN ('UY')
						AND NOT EXISTS	(
												SELECT *
												FROM OPERA O
												WHERE o.idBanco = b.id
												AND o.idMoneda = m.id
										)
					)
;

/*
SELECT * from vBancoMultimoneda
SELECT * FROM moneda
SELECT * FROM Opera WHERE idBanco = 3;
SELECT * FROM Opera WHERE IdMoneda = 'UY'
*/
SELECT id
FROM vBancoMultimoneda
EXCEPT
SELECT idBanco
FROM Opera
WHERE idMoneda = 'UY';

--3--

/*
4-Crear una funcion que devuelva el valor oro de una moneda. La misma debe recibir como parametro el
codigo de la moneda y devolver el valor -1 para el caso en que la moneda no exista.
Escribir la sentencia que prueba el correcto funcionamiento.
*/
/*
SELECT * FROM Moneda WHERE EXISTS (SELECT id FROM MONEDA WHERE id IN ('UY'));

CREATE FUNCTION fValorOro(@idMoneda CHAR(2))
RETURNS DECIMAL(18,3)
AS
BEGIN
	IF((SELECT * FROM Moneda WHERE EXISTS (SELECT id FROM MONEDA WHERE id IN (@idMoneda)))
		
END
*/

CREATE FUNCTION fValorOro(@idMoneda CHAR(2))
RETURNS DECIMAL(18,3)
AS
BEGIN
	DECLARE @aux DECIMAL (18,3);
	SET @aux = 0;

	SET @aux = (SELECT COUNT(*) FROM Moneda m WHERE m.iD = @idMoneda) -- Como es la PK, dara 1 si EXISTE, 0 si NO EXISTE
	if(@aux = 0)
		SET @aux = -1;
	ELSE
		SELECT @aux = m.valorOro FROM Moneda m WHERE m.ID = @idMoneda;

	RETURN @aux;
END

SELECT dbo.fValorOro('RR') AS ValorOro;
SELECT dbo.fValorOro('UY') AS ValorOro;


/*
5-Crear una funcion que retorne el pasaporte y el nombre de las personas que tienen 
cuenta en todos los bancos.
Escribir la sentencia que prueba el correcto funcionamiento.
*/

CREATE FUNCTION f_Todos()
RETURNS TABLE
AS
	RETURN (
	SELECT p.pasaporte, p.nombre
FROM Persona p
WHERE NOT EXISTS	(
						SELECT *
						FROM Banco b
						WHERE NOT EXISTS	(
												SELECT *
												FROM Cuenta c
												WHERE	c.idBanco = b.id
														AND c.idPersona = p.pasaporte
											)
					)
	);

	SELECT * from f_Todos();
-- CREAR UNA VIEW Y DEVOLVER POR EL RETURN?




/*
6-
Crear un SP que muestre por pantalla a las personas que tienen mas de 2 cuentas en dolares en bancos extranjeros.
Escribir la sentencia que prueba el correcto funcionamiento.
*/

CREATE PROCEDURE p_2_CuentasPersonasBancoExtranjero
AS
BEGIN
SELECT p.pasaporte, p.nombre, COUNT(*) AS Cantidad
FROM Persona p
JOIN Cuenta c
ON p.pasaporte = c.idPersona
JOIN Banco b
ON b.id = c.idBanco
WHERE c.idMoneda = 'US'
		AND b.pais <> 'Argentina'
GROUP BY p.pasaporte, p.nombre
HAVING COUNT(*) > 2;
END


EXEC p_2_CuentasPersonasBancoExtranjero;



/*
7-
Crear un SP que reciba por parametro un pasaporte y muestre las cuentas asociadas a la misma. Si el pasaporte no existe,
mostrar un mensaje de error.
Escribir la sentencia que prueba el correcto funcionamiento.https://docs.microsoft.com/en-us/sql/t-sql/language-elements/raiserror-transact-sql?view=sql-server-ver15
*/




/*
8- Crear un Trigger que realice el respaldo de los datos de un Banco cuando el mismo es 
eliminado. 
El trigger no debe permitir que se eliminen bancos que operan con la moneda "PESO ARGENTINO"
Se debe crear una tabla "banco_respaldo"
Escribir las sentencias que prueban el correcto funcionamiento.
*/

--Duplico la tabla en una nueva que la crea. Pero no esta vacia
SELECT * INTO banco_respaldo FROM Banco;

--Asi borro todo el contenido y me quedo con la estructura(Sin PK, Sin Funciones ni nada)
SELECT * FROM banco_respaldo;
TRUNCATE TABLE banco_respaldo;


CREATE TRIGGER t_BajaBanco
ON Banco
INSTEAD OF DELETE
AS
BEGIN

DECLARE @aux INT;
SET @aux = 0;

	SELECT @aux = COUNT(*)
	FROM deleted d
	JOIN Opera o
	ON d.id = o.idBanco
	WHERE o.idMoneda = 'AR';

	if(@aux = 0)
		BEGIN
			INSERT INTO banco_respaldo SELECT * FROM Banco WHERE id IN (SELECT id FROM deleted);
			DELETE FROM Banco WHERE id IN (SELECT id FROM deleted);
		END
	ELSE
		BEGIN
			RAISERROR('No se pueden borrar bancos que operan con peso argentina', 11, 1)
		END
END

/*
CREATE TRIGGER t_BancoRespaldo
ON Banco
AFTER DELETE
AS
BEGIN
	INSERT INTO banco_respaldo
	SELECT * 
	FROM deleted
END
*/

DELETE FROM Banco WHERE id = 4;


/*
9-Crear un Trigger que actualice el id de moneda en las tablas "opera" y "cuenta", para cuando un codigo de moneda
sea actualizado en la tabla "moneda".
Escribir la sentencia que prueba el correcto funcionamiento.
RAISERROR (Transact-SQL) - SQL Server
RAISERROR (Transact-SQL)
*/
