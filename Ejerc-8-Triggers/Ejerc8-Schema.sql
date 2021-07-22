CREATE TABLE Proveedor
(
	CodProv INT NOT NULL,
	RazonSocial VARCHAR(10),
	FechaInicio DATE,
	PRIMARY KEY(CodProv)
);


CREATE TABLE Producto 
(
	CodProd VARCHAR(10) PRIMARY KEY NOT NULL,
	Descripcion VARCHAR(20),
	CodProv INT NOT NULL,
	StockActual INT,
	FOREIGN KEY (CodProv) REFERENCES Proveedor(CodProv)
);

/*El nombre FK_CodProv se puede obviar junto con CONSTRAINT*/
/*ALTER TABLE + <nomTablaActual> + ADD CONSTRAINT <FK_<nomConstraint>> + SENTENCIA == FOREING KEY <nomTablaActual>
	+ ON DELETE CASCADE ON UPDATE CASCADE*/
ALTER TABLE Producto ADD CONSTRAINT FK_CodProv FOREIGN KEY (CodProv) REFERENCES Proveedor(CodProv)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Stock ADD CONSTRAINT FK_CodProd FOREIGN KEY (CodProd) REFERENCES Producto(CodProd)
ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE Stock
(
	Nro INT NOT NULL,
	Fecha DATE NOT NULL,
	CodProd VARCHAR(10) NOT NULL,
	Cantidad INT,
	CONSTRAINT Pk_Producto PRIMARY KEY(Nro, Fecha, CodProd),
	FOREIGN KEY(CodProd) REFERENCES Producto(CodProd)
);

DROP TABLE Stock;

INSERT INTO Proveedor(CodProv, RazonSocial, FechaInicio) VALUES (1, 'A12345', '2009-08-01');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (2, 'B6789', '2009-08-03');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (3, 'C101112', '2009-08-01');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (4, 'D131415', '2009-08-04');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (5, 'E161718', '2009-08-04');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (6, 'F192021', '2009-08-04');
INSERT INTO proveedor(CodProv, RazonSocial, FechaInicio) VALUES (7, 'G222324', '2009-08-03');



INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('a146', 'lapiz', 1, 20);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('a250', 'cuaderno', 3, 50);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('b130', 'portalapiz', 2, 10);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('d456', 'block 30 hojas', 4, 30);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('c490', 'Resaltador', 5, 80);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('e569', 'Mochila', 6, 200);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('e236', 'Lampara', 1, 300);
INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('a123', 'cartuchera', 3, 60);

INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('z123', 'Block 100', 6, 0);

INSERT INTO Producto(CodProd, descripcion, CodProv, StockActual) VALUES ('h123', 'Block 100', 7, 0);



INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (1, '2009-12-12', 'a146', 100);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (2, '2009-10-10', 'a250', 100);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (3, '2009-10-10', 'c490', 200);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (4, '2009-12-12', 'c490', 50);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (5, '2009-11-11', 'a250', 200);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (6, '2009-11-11', 'a123', 100);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (7, '2009-11-11', 'e236', 50);
INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (8, '2009-12-12', 'e569', 100);

INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (9, '2009-10-10', 'z123', 100);

INSERT INTO stock(Nro, fecha, CodProd, cantidad) VALUES (10, '2012-10-10', 'h123', 0);



