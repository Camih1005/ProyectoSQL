drop database if exists TallerCamilo;
create database TallerCamilo;
use TallerCamilo;


create table departamento(
id int primary key,
nombre varchar(50) not null
);

create table ciudad(
id int primary key,
nombre varchar(50),
idDepartamento int,
foreign key(idDepartamento)references departamento(id)
);

CREATE TABLE tipo_direccion(
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    descripcion TEXT
);


create table tipo_telefono(
id int primary key auto_increment,
tipo varchar(20) not null
);

create table marca_vehiculo(
id int primary key auto_increment,
nombre varchar(25) not null
);

create table taller(
id int primary key auto_increment,
direccion varchar(100) not null,
idCiudad int,
foreign key(idCiudad)references ciudad(id)
);

create table cliente(
id int primary key,
identicacion varchar(12) not null unique,
tipoIdentificacion enum("cc","nit","ce"),
nombre varchar(50) not null,
apellido1 varchar(50) not null,
apellido2 varchar(50),
email varchar(50) not null unique
);

CREATE TABLE cliente_direccion(
id INT PRIMARY KEY ,
direccion VARCHAR(100),
tipoDireccion INT,
idCliente INT,
idCiudad INT,
FOREIGN KEY(idCliente) REFERENCES cliente(id),
FOREIGN KEY(tipoDireccion) REFERENCES tipo_direccion(id),
FOREIGN KEY(idCiudad) REFERENCES ciudad(id)
);

create table telefono_cliente(
id int primary key auto_increment,
telefono varchar(13) not null,
idCliente int,
idTipo int,
foreign key(idCliente)references cliente(id),
foreign key(idTipo) references tipo_telefono(id)
);

create table vehiculo(
id int primary key auto_increment,
placa varchar(6) unique not null,
modelo varchar(50) not null,
kilometraje int,
año int not null,
idCliente int,
idMarca int,
foreign key(idCliente)references cliente(id),
foreign key(idMarca)references marca_vehiculo(id)
);

create table servicio(
id int primary key,
nombre varchar(60) not null,
descripcion text not null,
precio double(15,2) not null
);

create table reparacion(
id int primary key auto_increment,
fechaIngreso date not null,
fechaEsperada date not null,
fechaEntrega date not null,
descripcion text,
idVehiculo int,
Total double(15,2) not null,
foreign key(idVehiculo) references vehiculo(id)
);

create table cargo(
id int primary key auto_increment,
nombre varchar(50) not null
);

create table empleado(
id int primary key,
identicacion varchar(15) unique not null,
nombre varchar(50) not null,
apellido1 varchar(50) not null,
apellido2 varchar(50),
correo varchar(60) not null unique,
idTaller int,
idCargo int,
foreign key(idTaller)references taller(id),
foreign key(idCargo)references cargo(id)
);

CREATE TABLE empleado_direccion(
id INT PRIMARY KEY ,
ciudad INT,
direccion VARCHAR(100),
tipoDireccion INT,
idEmpleado INT,
idCiudad INT,
FOREIGN KEY(tipoDireccion) REFERENCES tipo_direccion(id),
FOREIGN KEY(idEmpleado) REFERENCES empleado(id),
FOREIGN KEY(idCiudad) REFERENCES ciudad(id)
);


create table telefono_empleado(
id int primary key auto_increment,
telefono varchar(13) not null,
idEmpleado int,
idTipo int,
foreign key(idEmpleado)references empleado(id),
foreign key(idTipo) references tipo_telefono(id)
);

create table reparacion_empleado(
idEmpleado int,
idReparacion int,
horasTrabajadas int not null,
primary key(idEmpleado,idReparacion),
foreign key(idEmpleado) references empleado(id),
foreign key(idReparacion)references reparacion(id)
);

create table cita(
id int primary key auto_increment,
fecha datetime not null,
idCliente int,
idVehiculo int,
idTaller int,
idServicio int,
foreign key(idCliente) references cliente(id),
foreign key(idVehiculo) references vehiculo(id),
foreign key(idTaller) references taller(id),
foreign key(idServicio) references servicio(id)
);

create table facturacion(
id int primary key auto_increment,
fecha date not null,
total double(15,2) not null default 0,
idCliente int,
foreign key(idCliente) references cliente(id)
);

create table factura_detalle(
idFacturacion int,
idReparacion int,
cantidad int not null,
precio double(15,2) not null,
primary key(idFacturacion,idReparacion),
foreign key(idReparacion)references reparacion(id),
foreign key(idFacturacion)references facturacion(id)
);

create table proveedor(
id int primary key auto_increment,
nombre varchar(100) not null,
nit varchar(15) not null unique,
email varchar(60) unique
);
create table contacto_proveedor(
id int primary key auto_increment,
nombre varchar(60) not null,
apellido1 varchar(60) not null,
apellido2 varchar(60),
email varchar(100) not null unique,
idProveedor int,
foreign key(idProveedor)references proveedor(id)
);

create table telefono_contacto(
id int primary key auto_increment,
telefono varchar(13) not null,
idContacto int,
idTipo int,
foreign key(idContacto)references contacto_proveedor(id),
foreign key(idTipo) references tipo_telefono(id)
);

create table orden_compra(
id int primary key auto_increment,
fecha date not null,
idProveedor int,
idEmpleado int,
total int not null,
foreign key(idProveedor)references proveedor(id),
foreign key(idEmpleado) references empleado(id)
);

create table marca_pieza(
id int primary key auto_increment,
nombre varchar(100) not null
);

create table pieza(
id int primary key auto_increment,
nombre varchar(100) not null,
descripcion text,
precio double(15,2) not null,
idMarca int,
foreign key(idMarca)references marca_pieza(id)
);


create table reparacion_servicio(
id int primary key auto_increment,
idReparacion int,
idServicio int,
idPieza int,
cantidadPieza int not null,
costo double(15,2) not null,
foreign key(idReparacion)references reparacion(id),
foreign key (idservicio) references servicio(id),
foreign key(idPieza)references pieza(id)
);

/*
create table reparacion_pieza(
idReparacion int,
idPieza int,
cantidad int not null,
primary key(idReparacion,idPieza),
foreign key(idPieza)references pieza(id),
foreign key(idReparacion)references reparacion(id)
);*/

create table proveedor_pieza(
idPieza int,
idProveedor int,
foreign key(idPieza) references pieza(id),
foreign key(idProveedor)references proveedor(id)
);

create table orden_detalle(
idOrdenCompra int,
idPieza int,
cantidad int not null,
precio double(15,2) not null,
primary key(idOrdenCompra,idPieza),
foreign key(idOrdenCompra)references orden_compra(id),
foreign key(idPieza)references pieza(id)
);

create table inventario_taller(
id int primary key auto_increment,
idTaller int,
idPieza int,
cantidad int,
foreign key (idPieza) references pieza(id),
foreign key(idTaller)references taller(id)
);

create table ubicacion_pieza_taller(
id varchar(10) primary key,
nombre varchar(50) not null,
descripcion tinytext,
idUbicacion int,
foreign key (idUbicacion) references inventario_taller(id)
);

-- Insertar datos en la tabla departamento
INSERT INTO departamento (id, nombre) VALUES 
(1, 'Antioquia'),
(2, 'Valle del Cauca'),
(3, 'Bogotá D.C.'),
(4, 'Atlántico'),
(5, 'Santander');

-- Insertar datos en la tabla ciudad
INSERT INTO ciudad (id, nombre, idDepartamento) VALUES 
(1, 'Medellín', 1),
(2, 'Cali', 2),
(3, 'Bogotá', 3),
(4, 'Barranquilla', 4),
(5, 'Bucaramanga', 5);

-- Insertar datos en la tabla cargo
INSERT INTO cargo (nombre) VALUES 
('Jefe de taller'),
('Mecánico'),
('Recepcionista'),
('Contador'),
('Auxiliar de contabilidad'),
('Administrativo'),
('Asistente de taller'),
('Vendedor de repuestos'),
('Lavador de autos'),
('Gerente');


-- Insertar datos en la tabla tipo_direccion
INSERT INTO tipo_direccion (nombre, descripcion) VALUES 
('Residencial', 'Dirección de domicilio'),
('Comercial', 'Dirección de empresa'),
('Oficina', 'Dirección de oficina');

-- Insertar datos en la tabla tipo_telefono
INSERT INTO tipo_telefono (tipo) VALUES 
('Celular'),
('Fijo'),
('Trabajo');

-- Insertar datos en la tabla marca_vehiculo
INSERT INTO marca_vehiculo (nombre) VALUES 
('Chevrolet'),
('Renault'),
('Ford'),
('Toyota'),
('Nissan');

-- Insertar datos en la tabla taller
INSERT INTO taller (direccion, idCiudad) VALUES 
('Calle 10 # 25-35', 1),
('Carrera 20 # 30-40', 2),
('Avenida 30 # 40-50', 3),
('Calle 40 # 50-60', 4),
('Carrera 50 # 60-70', 5);

-- Insertar datos en la tabla cliente
INSERT INTO cliente (id, identicacion, tipoIdentificacion, nombre, apellido1, apellido2, email) VALUES 
(1, '1234567890', 'cc', 'Juan', 'Pérez', 'García', 'juan.perez@example.com'),
(2, '9876543210', 'cc', 'María', 'López', 'Martínez', 'maria.lopez@example.com'),
(3, '8765432109', 'cc', 'Carlos', 'Gómez', 'López', 'carlos.gomez@example.com'),
(4, '4455667788', 'nit', 'Laura', 'Jiménez', 'Sánchez', 'laura.jimenez@example.com'),
(5, '5566778899', 'nit', 'Pedro', 'Ramírez', 'Díaz', 'pedro.ramirez@example.com'),
(6, '1122334455', 'cc', 'Ana', 'González', 'Rodríguez', 'ana.gonzalez@example.com'),
(7, '6677889900', 'nit', 'José', 'Hernández', 'Gómez', 'jose.hernandez@example.com'),
(8, '9988776655', 'cc', 'Diana', 'Torres', 'Vargas', 'diana.torres@example.com'),
(9, '123123123', 'cc', 'Alejandro', 'Sánchez', 'López', 'alejandro.sanchez@example.com'),
(10, '456456456', 'cc', 'Sofía', 'Martínez', 'Pérez', 'sofia.martinez@example.com');

-- Insertar datos en la tabla cliente_direccion
INSERT INTO cliente_direccion (id, direccion, tipoDireccion, idCliente, idCiudad) VALUES 
(1, 'Carrera 45 # 67-89', 1, 1, 1),
(2, 'Calle 30 # 20-15', 2, 2, 2),
(3, 'Avenida 10 # 15-25', 1, 3, 3),
(4, 'Calle 50 # 40-30', 1, 4, 4),
(5, 'Carrera 15 # 35-45', 2, 5, 5),
(6, 'Calle 70 # 25-35', 1, 6, 1),
(7, 'Avenida 20 # 40-50', 2, 7, 2),
(8, 'Carrera 35 # 15-25', 1, 8, 3),
(9, 'Calle 25 # 30-40', 2, 9, 4),
(10, 'Avenida 50 # 45-55', 1, 10, 5);

-- Insertar datos en la tabla telefono_cliente
INSERT INTO telefono_cliente (telefono, idCliente, idTipo) VALUES 
('3201234567', 1, 1),
('3102345678', 2, 1),
('3003456789', 3, 1),
('3154567890', 4, 1),
('3165678901', 5, 1),
('3176789012', 6, 1),
('3187890123', 7, 1),
('3198901234', 8, 1),
('3009012345', 9, 1),
('3010123456', 10, 1);

-- Insertar datos en la tabla vehiculo
INSERT INTO vehiculo (placa, modelo, kilometraje, año, idCliente, idMarca) VALUES 
('ABC123', 'Spark', 50000, 2018, 1, 1),
('XYZ987', 'Sandero', 60000, 2017, 2, 2),
('DEF456', 'Fiesta', 40000, 2019, 3, 3),
('GHI789', 'Corolla', 70000, 2015, 4, 4),
('JKL321', 'Sentra', 80000, 2016, 5, 5),
('MNO654', 'Aveo', 55000, 2014, 6, 1),
('PQR987', 'Logan', 65000, 2016, 7, 2),
('STU654', 'F-150', 75000, 2013, 8, 3),
('VWX321', 'Hilux', 85000, 2012, 9, 4),
('YZA789', 'Navara', 95000, 2011, 10, 5);


-- Insertar datos en la tabla servicio
INSERT INTO servicio (id, nombre, descripcion, precio) VALUES 
(1, 'Cambio de aceite', 'Incluye cambio de aceite y filtro', 50000),
(2, 'Revisión de frenos', 'Revisión y ajuste de frenos', 60000),
(3, 'Alineación y balanceo', 'Alineación y balanceo de llantas', 70000),
(4, 'Reparación de motor', 'Reparación completa del motor', 150000),
(5, 'Cambio de llantas', 'Cambio de llantas por nuevas', 80000),
(6, 'Revisión de suspensión', 'Revisión y ajuste de la suspensión', 70000),
(7, 'Cambio de batería', 'Cambio de batería por una nueva', 90000),
(8, 'Diagnóstico computarizado', 'Diagnóstico del vehículo con equipo especializado', 100000),
(9, 'Cambio de filtro de aire', 'Cambio del filtro de aire del motor', 30000),
(10, 'Revisión de sistemas eléctricos', 'Revisión de sistemas eléctricos del vehículo', 80000);

-- Inserciones para la tabla reparacion con fechas variadas y vehículo asociado
INSERT INTO reparacion (fechaIngreso, fechaEsperada, fechaEntrega, descripcion, Total, idVehiculo) VALUES
('2003-02-20', '2003-02-25', '2003-02-23', 'Reparación de motor', 50000, 1),
('2005-07-10', '2005-07-15', '2005-07-13', 'Cambio de aceite y filtros', 20000, 2),
('2007-09-25', '2007-09-30', '2007-09-28', 'Reparación de frenos', 35000, 3),
('2010-04-15', '2010-04-20', '2010-04-17', 'Mantenimiento preventivo', 30000, 4),
('2012-11-25', '2012-12-01', '2012-11-30', 'Reparación de transmisión', 60000, 5),
('2015-09-05', '2015-09-10', '2015-09-08', 'Reemplazo de neumáticos', 45000, 6),
('2018-04-15', '2018-04-20', '2018-04-19', 'Reparación de sistema eléctrico', 40000, 7),
('2020-10-25', '2020-10-30', '2020-10-29', 'Reparación de suspensión', 55000, 8),
('2022-07-30', '2022-08-05', '2022-08-03', 'Reparación de sistema de refrigeración', 48000, 9),
('2024-01-15', '2024-01-20', '2024-01-18', 'Reparación de sistema de combustible', 52000, 10),
('2024-06-01', '2024-06-05', '2024-06-04', 'Reparación de sistema de frenos', 30000, 1),
('2024-07-05', '2024-07-08', '2024-07-12', 'Reparación de sistema de frenos', 30000, 4),
('2024-08-25', '2024-08-18', '2024-08-22', 'Mantenimiento preventivo', 30000, 2);



-- Insertar datos en la tabla empleado
INSERT INTO empleado (id, identicacion, nombre, apellido1, correo, idTaller, idCargo) VALUES
(1, '123456789', 'Juan', 'Pérez', 'juan.perez@example.com', 1, 1),
(2, '987654321', 'María', 'Gómez', 'maria.gomez@example.com', 1, 2),
(3, '456789123', 'Carlos', 'López', 'carlos.lopez@example.com', 1, 2),
(4, '789123456', 'Ana', 'Martínez', 'ana.martinez@example.com', 1, 4),
(5, '321654987', 'Pedro', 'García', 'pedro.garcia@example.com', 1, 5),
(6, '654987321', 'Laura', 'Rodríguez', 'laura.rodriguez@example.com', 1, 2),
(7, '147258369', 'Diego', 'Hernández', 'diego.hernandez@example.com', 1, 7),
(8, '258369147', 'Sofía', 'Díaz', 'sofia.diaz@example.com', 1, 8),
(9, '369147258', 'Lucas', 'Muñoz', 'lucas.munoz@example.com', 1, 9),
(10, '456123789', 'Marta', 'Sánchez', 'marta.sanchez@example.com', 1, 10);


-- Insertar datos en la tabla empleado_direccion
INSERT INTO empleado_direccion (id, ciudad, direccion, tipoDireccion, idEmpleado, idCiudad) VALUES 
(1, 1, 'Calle 12 # 34-56', 1, 1, 1),
(2, 2, 'Carrera 45 # 67-89', 2, 2, 2),
(3, 3, 'Avenida 90 # 20-30', 1, 3, 3),
(4, 4, 'Calle 50 # 40-60', 1, 4, 4),
(5, 5, 'Carrera 30 # 45-67', 2, 5, 5);

-- Insertar datos en la tabla telefono_empleado
INSERT INTO telefono_empleado (telefono, idEmpleado, idTipo) VALUES 
('3101112233', 1, 1),
('3203334455', 2, 1),
('3005556677', 3, 1),
('3157778899', 4, 1),
('3179990011', 5, 1);

INSERT INTO reparacion_empleado (idReparacion, idEmpleado,horasTrabajadas) VALUES 
    -- Reparaciones para el empleado con ID 2 (mecánico 1)
    (10, 2,8), (1, 1,5), (4, 10,8), (7, 3,4), (5, 2,6),
    -- Reparaciones para el empleado con ID 3 (mecánico 2)
    (2, 9,6), (1, 8,12), (2, 7,19), (4, 3,5), (5, 4,15),
    -- Reparaciones para el empleado con ID 6 (mecánico 3)
    (8, 1,2), (2, 3,4), (9, 4,6), (10, 8,14), (4, 6,25);

-- Inserciones para la tabla cita con fechas variadas
INSERT INTO cita (fecha, idCliente, idVehiculo, idTaller, idServicio) VALUES
('2003-02-15 10:30:00', 1, 1, 1, 1),
('2005-06-20 09:45:00', 2, 2, 1, 2),
('2007-09-10 14:00:00', 3, 3, 1, 3),
('2010-03-25 08:00:00', 4, 4, 1, 4),
('2012-11-12 13:30:00', 5, 5, 1, 5),
('2015-08-30 11:15:00', 6, 6, 1, 6),
('2018-04-05 16:45:00', 7, 7, 1, 7),
('2020-10-18 10:00:00', 8, 8, 1, 8),
('2022-07-22 12:20:00', 9, 9, 1, 9),
('2024-01-09 15:30:00', 10, 10, 1, 10);

-- Inserciones para la tabla facturacion con fechas variadas
INSERT INTO facturacion (fecha, total, idCliente) VALUES
('2003-02-25', 12600.00, 1),
('2005-07-13', 24300.00, 2),
('2007-09-28', 3540.00, 3),
('2010-04-17', 30320.00, 4),
('2012-11-30', 6003.00, 5),
('2015-09-08', 4550.00, 6),
('2018-04-19', 4040.00, 7),
('2020-10-29', 5550.00, 8),
('2022-08-03', 46780.00, 9),
('2024-01-18', 522320.00, 10);

-- Insertar datos en la tabla factura_detalle
INSERT INTO factura_detalle (idFacturacion, idReparacion, cantidad, precio) VALUES 
(1, 1, 1, 180000),
(2, 2, 1, 75000),
(3, 3, 1, 60000),
(4, 4, 1, 120000),
(5, 5, 1, 80000),
(6, 6, 1, 95000),
(7, 7, 1, 85000),
(8, 8, 1, 110000),
(9, 9, 1, 65000),
(10, 10, 1, 75000);



-- Inserciones adicionales para la tabla proveedor
INSERT INTO proveedor (nombre, nit, email) VALUES
('Autopartes S.A.', '123456789', 'info@autopartes.com'),
('Repuestos Rápidos Ltda.', '987654321', 'ventas@repuestosrapidos.com'),
('Mecánica y Reparaciones Automotrices', '456789123', 'contacto@mecanica.com'),
('Neumáticos Veloces S.A.', '789123456', 'ventas@neumaticosveloces.com'),
('Pinturas y Acabados de Alta Calidad', '321654987', 'info@pinturasalta.com');


-- Modificaciones para proveedores y contactos
-- Añadir contactos para cada proveedor
INSERT INTO contacto_proveedor (nombre, apellido1, email, idProveedor) VALUES
('Juan', 'Pérez', 'juan@autopartes.com', 1),
('María', 'Gómez', 'maria@repuestosrapidos.com', 2),
('Luis', 'Hernández', 'luis@mecanica.com', 3),
('Ana', 'Rodríguez', 'ana@neumaticosveloces.com', 4),
('Carlos', 'Martínez', 'carlos@pinturasalta.com', 5);

-- Asegurar que haya registros en la tabla telefono_contacto para cada contacto de proveedor
INSERT INTO telefono_contacto (telefono, idContacto, idTipo) VALUES
('1234567890', 1, 1), -- Teléfono de Juan Pérez
('2345678901', 2, 1), -- Teléfono de María Gómez
('3456789012', 3, 1), -- Teléfono de Luis Hernández
('4567890123', 4, 1), -- Teléfono de Ana Rodríguez
('5678901234', 5, 1); -- Teléfono de Carlos Martínez


-- Inserciones para la tabla orden_compra con fechas variadas
INSERT INTO orden_compra (fecha, idProveedor, idEmpleado, total) VALUES
('2003-02-28', 1, 1, 16000000.00),
('2005-07-16', 2, 2, 16000000.00),
('2007-10-01', 3, 3, 5000000.00),
('2010-04-25', 4, 4, 900),
('2012-12-05', 5, 5, 1500),
('2015-09-15', 3, 6, 1100),
('2018-04-25', 4, 7, 1300),
('2020-11-01', 1, 8, 1000),
('2022-08-10', 3, 9, 1400),
('2024-01-25', 5, 10, 1600);

-- Insertar datos en la tabla marca_pieza
INSERT INTO marca_pieza (nombre) VALUES 
('Bosch'),
('Motorcraft'),
('Mopar');

-- Inserción en la tabla pieza
INSERT INTO pieza (nombre, descripcion, precio, idMarca) VALUES 
('Filtro de aceite', 'Filtro de aceite para motor', 20000, 1),
('Batería', 'Batería para automóvil', 80000, 2),
('Pastillas de freno', 'Pastillas de freno delanteras', 50000, 3),
('Amortiguador', 'Amortiguador trasero', 120000, 1),
('Sensor de oxígeno', 'Sensor de oxígeno para sistema de inyección', 90000, 2),
('Llanta', 'Llanta para automóvil', 150000, 3),
('Bujía', 'Bujía de encendido', 10000, 1),
('Radiador', 'Radiador para enfriamiento del motor', 180000, 2),
('Alternador', 'Alternador para generación de electricidad', 200000, 3),
('Termostato', 'Termostato para control de temperatura', 30000, 1);


-- Inserciones en la tabla reparacion_servicio con precios corregidos
INSERT INTO reparacion_servicio (idReparacion, idServicio, idPieza, cantidadPieza, costo) VALUES
(1, 1, null, 0, 50000),  
(1, 2, 2, 3, 60000),   
(3, 4, 3, 3, 150000),  
(4, 4, 4, 2, 300000),  
(5, 4, 5, 1, 80000),   
(6, 6, 6, 2, 140000),  
(7, 7, 7, 3, 270000), 
(8, 8, 8, 1, 100000),  
(9, 9, 9, 2, 60000),   
(10, 2, 6, 3, 240000),
(11,3,7,1,250000),
(12,3,7,1,250000),
(13,9,null,0,30000);  


-- Insertar datos en la tabla proveedor_pieza
INSERT INTO proveedor_pieza (idPieza, idProveedor) VALUES 
(1, 1),
(2, 1),
(3, 1),
(4, 2),
(5, 2);

INSERT INTO orden_detalle (idOrdenCompra, idPieza, cantidad, precio) VALUES 
(1, 1, 400, 40000),
(2, 2, 200, 80000),
(3, 3, 100, 50000),
(4, 4, 190, 80000),
(5, 5, 398, 90000),
(6, 6, 400, 40000),
(7, 7, 200, 80000),
(8, 8, 100, 50000),
(9, 9, 190, 80000),
(10, 10, 398, 90000);

INSERT INTO inventario_taller (idTaller, idPieza, cantidad) VALUES 
(1, 1, 100),
(1, 2, 80),
(1, 3, null),
(1, 4, 70),
(1, 5, 98),
(2, 1, 34),
(2, 2, null),
(2, 3, 122),
(2, 4, 409),
(2, 5, 133),
(3, 1, 60),
(3, 2, 110),
(3, 3, 80),
(3, 4, null),
(3, 5, 3),
(4, 1, 9),
(4, 2, 7),
(4, 3, 10),
(4, 4, 5),
(4, 5, 13),
(5, 1, 122),
(5, 2, 633),
(5, 3, 9),
(5, 4, 8),
(5, 5, 116);


-- Insertar datos en la tabla ubicacion_pieza_taller
INSERT INTO ubicacion_pieza_taller (id, nombre, descripcion, idUbicacion) VALUES 
('A1', 'Estante A, Nivel 1', 'Estante superior', 1),
('B2', 'Estante B, Nivel 2', 'Estante medio', 2),
('C3', 'Estante C, Nivel 3', 'Estante inferior', 3),
('D1', 'Estante D, Nivel 1', 'Estante superior', 4),
('E2', 'Estante E, Nivel 2', 'Estante medio', 5);


select * from inventario_taller;
show tables;
