/* Some notes of theory */

/*

Store procedure

Creamos un procedimiento para encapsular un set de instrucciones
Es un conjunto de sentencias que pueden ejecutarse, que se invoca con su nombre

- Acepta parametros de Ent y Sal

- Puede llamar a otro store procedure

- Puede devolver otro tambien

CREATE PROCESURE p_borrarClientes
AS
	DELETE FROM CLIENTE
--> Lo que hara es borrar los clientes. sp_ o xp_ NO USARLOS
	usar p_NOMBRE_PROCEDURE por ejemplo
	SOlo lo creo aca, no lo ejecuta.


CREATE PROCEDURE p_borrarClientesID(@IDDESDE int, @IDHASTA int)
AS
BEGIN
	DELETE FROM VENTA where idcliente between @IDDESDE and @IDHASTA
	DELETE FROM CLIENTE where idcliente between @IDDESDE and @IDHASTA
END

//// BORRAR UN SP

DROP PROCEDURE <nombreStoreProcedure>
DROM PROCEDURE IF EXISTS <nombreStoreProcedure>

///// CAMBIAR

No se puede cambiar una linea del SP, en definitiva es como si tengo que crearlo otra vez
solo que con ALTER y no con CREATE.
Recreo, reescribo los SP
--
ALTER PROCEDURE <nombreStoreProcedure>
AS
	DELETE FROM CLIENTE
--
ALTER PROCEDURE p_borrarClientesID (@IDDESDE int, @IDHASTA int)
AS
BEGIN
	DELETE FROM CLIENTE where idcliente between @IDDESDE and @IDHASTA
END

/////////////////// EJECUTAR
En otros lenguaje se puede usar 'CALL'
EXEC/EXECUTE PROC/PROCEDURE <nombreStoreProcedure> <PARAMETROS>

EXEC PROCEDURE p_borrarClientes

EXECUTE PROCEDURE p_borrarClientesID @pcliid ...

////////////////////// VARIABLES

####Sintaxis

DECLARE @<nomVariable> [AS] tipoDatos [= valor por defecto]

ej:
DECLARE @vApellido varchar(100)
DECLARE @id int, @vNombre varchar(100)

###### Asignacion
SET @<nomVariable> = <VALOR>

SET @id = 1
SET @vApellido = 'Perez'



 ################# /////////////////////// FUNCION			###############
 
 CREATE FUNCTION <nomFuncion>
 (parametros[ = default])
 RETURNS return_tipoDeDatp // Si retorna un INT, coloco INT,texto => VARCHAR
 [AS] //Opcional
 BEGIN
	Sentencias SQL
    
    RETURN valor
 END

ej: CREATE FUNCTION f_proximoCliente ()


 ################# /////////////////////// TRIGGER			###############



*/

CREATE PROCEDURE P_CANT_ADDRESS
AS
BEGIN
	DECLARE @CANT INT;
    
    SET @CANT = (SELECT COUNT(*) FROM Persona.Address);
    
    SELECT @CANT AS CANT_ADDRESS;
END;


--- FUNCION EN MySQL
DELIMITER ||
CREATE FUNCTION f_test()
RETURNS INT
BEGIN
	DECLARE valor INT;
    SET valor = 9999;
    
    RETURN valor;
END
||
DELIMITER ;
-- --------

CREATE TABLE TABLAPRUEBA(campo int, campo2 varchar(10), fecha datetime);

INSERT INTO TABLAPRUEBA VALUES(1, 'A', null);
INSERT INTO TABLAPRUEBA VALUES(1, 'B', null);

CREATE TRIGGER tg_prueba ON TABLAPRUEBA
AFTER INSERT
AS
	UPDATE TABLAPRUEBA SET fecha = CURDATE()
    WHERE campo1 IN (SELECT campo1 FROM inserted)
-----
;


SELECT TOP 10 City, LOWER(City) AS Ciudad_Min, 
			LEFT(City, 1) AS Primer_char
FROM Person.Address;

SELECT TOP 10 ModifiedDate, MONTH(ModifiedDate)
FROM Person.Address;


SELECT TOP 10 ModifiedDate
FROM Person.Address
WHERE MONTH(ModifiedDate) = 12 AND YEAR(ModifiedDate) = 2008;

DROP TABLE TABLAPRUEBA;
CREATE TABLE TABLAPRUEBA (campo1 INT, campo2 VARCHAR(10), fecha datetime);

insert into TABLAPRUEBA VALUES (1, 'A', null);
insert into TABLAPRUEBA VALUES (2, 'B', null);


SELECT * from TABLAPRUEBA;
-----

CREATE TRIGGER tgPrueba ON TABLAPRUEBA
AFTER INSERT
AS
	UPDATE TABLAPRUEBA
	SET fecha = GETDATE()
	WHERE campo1 IN (SELECT campo1 FROM inserted);
----------

-- Llamo al trigger
INSERT INTO TABLAPRUEBA VALUES (3, 'c', null);

DROP TRIGGER IF EXISTS tgPrueba;
