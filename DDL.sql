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


