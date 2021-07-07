-- Proveedor (NroProv, NomProv, Categoria, CiudadProv)

CREATE DATABASE Ejerc2;
USE Ejerc2;

CREATE TABLE proveedor
(	nroProv INT NOT NULL,
    nomProv VARCHAR(50) NOT NULL,
    categoria INT,
    ciudadProv VARCHAR(50),
    PRIMARY KEY(nroProv)
);

-- Artículo (NroArt, Descripción, CiudadArt, Precio)

CREATE TABLE articulo
(
	nroArt VARCHAR(10) NOT NULL,
    descripcion VARCHAR(50),
    ciudadArt VARCHAR(50),
    precio INT, -- Para simplificar el ejerc, que sean ENTEROS
    PRIMARY KEY(nroArt)
);

-- Cliente (NroCli, NomCli, CiudadCli)

CREATE TABLE cliente
(
	nroCli VARCHAR(10) NOT NULL,
    nomCli VARCHAR(50),
    ciudadCli VARCHAR(50),
    PRIMARY KEY(nroCli)
);

-- Pedido (NroPed, NroArt, NroCli, NroProv, FechaPedido, Cantidad, PrecioTotal)

CREATE TABLE pedido
(
	nroPed INT NOT NULL,
    nroArt VARCHAR(10),
    nroCli VARCHAR(10),
    nroProv INT,
    fechaPedido DATE,
    cantidad INT,
    precioTotal INT,
    PRIMARY KEY(nroPed),
    FOREIGN KEY(nroArt) REFERENCES articulo(nroArt),
    FOREIGN KEY(nroCli) REFERENCES cliente(nroCli),
    FOREIGN KEY(nroProv) REFERENCES proveedor(nroProv)
);

-- Stock (NroArt, fecha, cantidad)

CREATE TABLE stock
(
	nroArt varchar(10),
    fecha DATE,
    cantidad int,
    PRIMARY KEY(nroArt, fecha),
    foreign key(nroArt) REFERENCES articulo(nroArt)
);


-- ///////////////////////// INSERTS
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (1, 'Juan Perez', 1, 'CABA');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (2, 'Maria Lopez', 3, 'La Plata');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (3, 'Jose Nunez', 3, 'Gonzalez Catan');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (4, 'Agustin Estrada', 4, 'CABA');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (5, 'Donald Trump', 1, 'Rosario');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (6, 'Max Power', 3, 'Montevideo');
INSERT INTO proveedor(nroProv, nomProv, categoria, ciudadProv) VALUES (7, 'Carla Rodriguez', 1, 'Cordoba');


INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('a146', 'lapiz', 'Rosario', 20);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('a250', 'cuaderno', 'Mendoza', 50);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('b130', 'portalapiz', 'CABA', 10);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('d456', 'block 30 hojas', 'La Plata', 30);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('c490', 'Resaltador', 'Mendoza', 80);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('e569', 'Mochila', 'CABA', 200);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('e236', 'Lampara', 'Cordoba', 300);
INSERT INTO articulo(nroArt, descripcion, ciudadArt, precio) VALUES ('a123', 'cartuchera', 'La Plata', 60);


INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c23', 'Fereico Almendra', 'Mendoza');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c30', 'MARÍA DOLORES', 'Rosario');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c25', 'JUAN MIGUEL', 'CABA');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c15', 'LAURA SUSANA', 'CABA');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c60', 'SARA GLORIA', 'Rosario');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c80', 'CARLOS ALBERTO', 'La Plata');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c90', 'MARÍA LUCINDA', 'Mendoza');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c35', 'CARLOS ALFONSO', 'CABA');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c40', 'FRANCISCO JAVIER', 'CABA');
INSERT INTO cliente(nroCli, nomCli, ciudadCli) VALUES ('c45', 'ALBERTO MANUEL', 'CABA');



-- -------------------------------
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (1, 'a146', 'c23', 1, '2004-01-01', 10, 1000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (2, 'e236', 'c23', 2, '2004-02-01', 20, 2000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (3, 'a123', 'c15', 5, '2004-03-31', 10, 500);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (4, 'e236', 'c60', 1, '2004-01-01', 50, 2000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (5, 'c490', 'c35', 1, '2004-03-31', 30, 1000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (6, 'a146', 'c40', 3, '2004-02-01', 20, 2000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (7, 'e236', 'c15', 4, '2004-01-01', 10, 1000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (8, 'd456', 'c60', 5, '2004-02-01', 10, 500);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (9, 'a146', 'c23', 1, '2004-02-01', 50, 2000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (10, 'e236', 'c40', 3, '2004-03-31', 10, 1000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (11, 'c490', 'c23', 6, '2004-01-01', 50, 2000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (12, 'a146', 'c15', 4, '2004-01-01', 100, 3000);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (13, 'c490', 'c30', 3, '2004-02-01', 10, 500);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (14, 'd456', 'c30', 1, '2004-01-01', 30, 1000);

INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (15, 'a123', 'c80', 1, '2004-01-01', 20, 100);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (16, 'a250', 'c80', 1, '2004-02-01', 10, 50);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (17, 'e569', 'c45', 1, '2004-01-01', 5, 100);

INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (18, 'e569', 'c90', 6, '2004-02-01', 10, 50);

INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (19, 'd456', 'c60', 4, '2004-02-01', 10, 100);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (20, 'd456', 'c30', 6, '2004-02-01', 10, 50);

INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (21, 'e236', 'c15', 3, '2004-03-31', 1000, 100);
INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (22, 'd456', 'c40', 5, '2004-02-01', 100, 200);
-- INSERT INTO pedido(nroPed, nroArt, nroCli, nroProv, fechaPedido, cantidad, precioTotal) VALUES (, '', '', , '', , );


-- /////////////

INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('a146', '2004-01-01', 100);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('a250', '2004-02-01', 100);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('b130', '2004-02-01', 200);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('d456', '2004-01-01', 50);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('c490', '2004-01-01', 200);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('e569', '2004-01-01', 100);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('e236', '2004-01-01', 50);
INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('a123', '2004-01-01', 100);

INSERT INTO stock(nroArt, fecha, cantidad) VALUES ('d456', '2004-02-01', 50);







