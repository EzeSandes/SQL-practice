/**************** DO IT IN SQL SERVER ****************/
/*****************************************************/

USE bancos;

/*
1-Redactar las sentencias que permitan agregar las restricciones de integridad referencial 
permitiendo la actualizacion automatica para el caso de actualizar o eliminar un banco, 
moneda o persona. Demostrar el correcto funcionamiento de las restricciones creadas
Redactar las sentencias que permitan eliminar las restricciones creadas en el paso anterior.
*/


ALTER TABLE Cuenta 
ADD CONSTRAINT fk_bancoNombre
FOREIGN KEY (idBanco) REFERENCES Banco (id)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE Cuenta
ADD CONSTRAINT fk_idMoneda
FOREIGN KEY (idMoneda) REFERENCES Moneda(id)
ON DELETE CASCADE
ON UPDATE CASCADE;

/*
2-
Listar los bancos que solamente operan todas las monedas que no son el PESO URUGUAYO.
Utilizar una vista para todas las monedas.
*/

-- Listar los bancos tales que NO EXISTE monedas que no son el Peso uruguayo que NO operen.

CREATE VIEW vBancoMultimoneda AS
SELECT *
FROM Banco b
WHERE NOT EXISTS	(	SELECT 1
						FROM Moneda m
						WHERE m.id NOT IN (SELECT id FROM Moneda WHERE Moneda.descripcion = 'Peso Uruguayo')
						AND NOT EXISTS	(	SELECT 1
											FROM Opera o
											WHERE o.idBanco = b.id
													AND o.idMoneda = m.id
										)
					);



SELECT id 
FROM vBancoMultimoneda
EXCEPT
SELECT idBanco
FROM Opera
WHERE idMoneda = 'UY';

/*
4-Crear una funcion que devuelva el valor oro de una moneda. La misma debe recibir como parametro el
codigo de la moneda y devolver el valor -1 para el caso en que la moneda no exista.
Escribir la sentencia que prueba el correcto funcionamiento.
*/

CREATE FUNCTION fValorOro(@idMoneda CHAR(2))
RETURNS	DECIMAL(18,3)
AS
BEGIN
	DECLARE @aux DECIMAL(18,3) = (SELECT COUNT(*) FROM Moneda WHERE id = @idMoneda);

	IF(@aux <> 0)
		BEGIN
			SET @aux = (SELECT valorOro FROM Moneda WHERE id = @idMoneda);
		END
	ELSE
		BEGIN
			SET @aux = -1;
		END

	RETURN @aux;
END

/*
5-Crear una funcion que retorne el pasaporte y el nombre de las personas que tienen 
cuenta en todos los bancos.
Escribir la sentencia que prueba el correcto funcionamiento.
*/

--1ero. Quienes son las personas que tienen cuentas en todos los bancos?
SELECT *
FROM Persona p
WHERE NOT EXISTS	(	SELECT 1
						FROM Banco b
						WHERE NOT EXISTS	(	SELECT 1
												FROM Cuenta c
												WHERE c.idBanco = b.id
													AND	c.idPersona = p.pasaporte
											)
					);

CREATE FUNCTION f_TODOS_2()
RETURNS TABLE
AS
	RETURN
		(	SELECT p.pasaporte, p.nombre
			FROM Persona p
			WHERE NOT EXISTS	(	SELECT 1
									FROM Banco b
									WHERE NOT EXISTS	(	SELECT 1
															FROM Cuenta c
															WHERE c.idBanco = b.id
															AND	c.idPersona = p.pasaporte
														)
								)
		);


/*
6-
Crear un SP que muestre por pantalla a las personas que tienen mas de 2 cuentas en dolares en bancos extranjeros.
Escribir la sentencia que prueba el correcto funcionamiento.

(Yo utilizo "...al menos 2 cuentas en dolares en bancos extranjeros")
*/

CREATE PROCEDURE p_CuentasPersonaBancos
AS
BEGIN
	SELECT p.nombre, p.pasaporte, COUNT(*) AS Cantidad
	FROM Cuenta c, Banco b, Persona p
	WHERE c.idMoneda = (SELECT id FROM Moneda WHERE descripcion = 'Dolar')
			AND b.pais <> 'Argentina'
			AND b.id = c.idBanco
			AND p.pasaporte = c.idPersona
	GROUP BY p.nombre, p.pasaporte
	HAVING COUNT(*) >= 2;
END

EXEC p_CuentasPersonaBancos;

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
INSTEAD OF DELETE -- 'Instead of' Porque no tengo que dejar que se borre si opera con peso argentino.
AS
BEGIN
	DECLARE @aux INT;
	SET @aux = 0;
	SET @aux = (SELECT COUNT(*) FROM deleted d JOIN Opera o ON o.idBanco = d.id WHERE o.idMoneda = 'AR');

	--Si opera con 'AR' => @aux != 0
	IF(@aux = 0)
		BEGIN
			INSERT INTO banco_respaldo SELECT * FROM Banco WHERE id IN (SELECT id FROM deleted);
			DELETE FROM Banco WHERE id IN (SELECT id FROM deleted);
		END
	ELSE
		BEGIN
			RAISERROR('No se pueden borrar bancos que operan con peso argentino', 11, 1);
		END
END

DROP TRIGGER IF EXISTS t_BajaBanco;

SELECT * FROM Opera;

DELETE FROM Banco WHERE id = 4;

SELECT * FROM Banco;
/*
9-Crear un Trigger que actualice el id de moneda en las tablas "opera" y "cuenta", para cuando un codigo de moneda
sea actualizado en la tabla "moneda".
Escribir la sentencia que prueba el correcto funcionamiento.
RAISERROR (Transact-SQL) - SQL Server
RAISERROR (Transact-SQL)
*/

ALTER TRIGGER t_ActualizarIdMonedaEnOperaYCuenta
ON Moneda
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @aux INT = (SELECT COUNT(*) FROM Moneda m WHERE m.id IN (SELECT id FROM deleted));
	DECLARE @idMonedaOld CHAR(2) = (SELECT id FROM deleted);
	DECLARE @idMonedaNew CHAR(2) = (SELECT id FROM inserted);

	IF(@aux != 0)
		BEGIN
			UPDATE Opera SET idMoneda = @idMonedaNew WHERE idMoneda = @idMonedaOld;
			UPDATE Cuenta SET idMoneda = @idMonedaNew WHERE idMoneda = @idMonedaOld;
			UPDATE Moneda SET id = @idMonedaNew WHERE id = @idMonedaOld;
		END
	ELSE
		BEGIN
			RAISERROR('ERROR: No existe esa clave de moneda', 11, 1);
		END
END

/* TEST */
UPDATE Moneda SET id = 'UY' WHERE id = 'ZZ';
