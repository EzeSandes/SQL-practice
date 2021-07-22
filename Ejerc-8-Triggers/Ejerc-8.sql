/********************* DONE in SQL SERVER ********************/
/*************************************************************/

-- 1. p_EliminaSinstock() : Realizar un procedimiento que elimine los productos que no
	-- poseen stock.

SELECT *
FROM Producto
WHERE StockActual = 0;

EXECUTE p_EliminarSinStock;

ALTER PROCEDURE p_EliminarSinStock
AS
BEGIN
	DELETE FROM Producto WHERE StockActual = 0;
END


/*
2. p_ActualizaStock(): Para los casos que se presenten inconvenientes en los
datos, se necesita realizar un procedimiento que permita actualizar todos los
Stock_Actual de los productos, tomando los datos de la entidad Stock. Para ello,
se utilizará como stock válido la última fecha en la cual se haya cargado el stock.
*/

SELECT *
FROM Stock;


SELECT *
FROM Producto;

/*
3. p_DepuraProveedor(): Realizar un procedimiento que permita depurar todos los
proveedores de los cuales no se posea stock de ningún producto provisto desde
hace más de 1 año.
*/
/*
SELECT *
FROM Proveedor prov
WHERE NOT EXISTS	(	SELECT *
						FROM Stock s
						WHERE 
					)

*/


/*
4. p_InsertStock(nro,fecha,prod,cantidad): Realizar un procedimiento que permita
agregar stocks de productos. Al realizar la inserción se deberá validar que:

a. El producto debe ser un producto existente

b. La cantidad de stock del producto debe ser cualquier número entero
mayor a cero.

c. El número de stock será un valor correlativo que se irá agregando por
cada nuevo stock de producto.
*/

CREATE PROCEDURE p_InsertStock(@nro INT, @Fecha DATE, @Prod VARCHAR(10), @cantidad INT)
AS
BEGIN
	DECLARE @aux INT;
	SET @aux = (SELECT COUNT(*) FROM Stock WHERE Stock.CodProd = @Prod);
	
--	DECLARE @cant INT = (SELECT Cantidad FROM Stock WHERE @Prod = CodProd);

	-- Si AUX == 1 => Existe el producto
	IF(@aux <> 0 AND @cantidad > 0)
		BEGIN
			INSERT INTO Stock(Nro, Fecha, CodProd, Cantidad) VALUES (@nro, @Fecha, @Prod, @cantidad);
		END
	ELSE
		BEGIN
			RAISERROR('Producto no existente en la tabla STOCK', 11, 1);
		END

END

EXECUTE p_InsertStock 10, '2009-12-14', 'e236', 100; --> BIEN. El producto Existe
EXECUTE p_InsertStock 10, '2009-12-14', 'z236', 100; --> Bien. Da error porque el producto NO EXISTE


/*
5. tg_CrearStock: Realizar un trigger que permita automáticamente agregar un
registro en la entidad Stock, cada vez que se inserte un nuevo producto. El stock
inicial a tomar, será el valor del campo Stock_Actual.
*/

CREATE TRIGGER tg_CrearStock
ON Producto
AFTER INSERT
AS
BEGIN
	DECLARE @nro INT = (SELECT MAX(Nro) FROM Stock);
	DECLARE @codProd VARCHAR(10) = (SELECT CodProd FROM inserted);
	DECLARE @stock INT = (SELECT StockActual from inserted);

	INSERT INTO Stock(Nro, Fecha, CodProd, Cantidad) VALUES (@nro + 1, CAST( GETDATE() AS DATE ), @codProd, @stock);
END

-- Inserto un nuevo producto para ver que si el Trigger funciona.
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('w123', 'Auricular', 2, 30);
--Funciona correctamente


/********************* TODO */
/*
p_ListaSinStock(): Crear un procedimiento que permita listar los productos que
no posean stock en este momento y que no haya ingresado ninguno en este
último mes. De estos productos, listar el código y nombre del producto, razón
social del proveedor y stock que se tenía al mes anterior.
*/

/*
7. p_ListaStock(): Realizar un procedimiento que permita generar el siguiente
reporte:

Fecha			> 1000		< 1000			= 0
01/08/2009			100			 8			3
03/08/2009			53			50			7
04/08/2009			50			20			40
------------
En este listado se observa que se contará la cantidad de productos que posean a una
determinada fecha más de 1000 unidades, menos de 1000 unidades o que no
existan unidades de ese producto.
Según el ejemplo, el 01/08/2009 existen 100 productos que poseen más de 1000
unidades, en cambio el 03/08/2009 sólo hubo 53 productos con más de 1000
unidades.
*/

DECLARE PROCEDURE p_ListaStock
AS
BEGIN
	DECLARE @cantFechas INT = (SELECT COUNT(*) FROM Stock GROUP BY Fecha)
END
