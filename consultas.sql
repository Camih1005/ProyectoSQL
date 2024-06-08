-- consultas

/*
1. Obtener el historial de reparaciones de un vehículo específico
*/

select vh.id,vh.modelo,vh.placa,r.fechaIngreso from reparacion as r 
join vehiculo as vh on r.idVehiculo = vh.id
where vh.id = 1;

/*
2. Calcular el costo total de todas las reparaciones realizadas por un empleado
específico en un período de tiempo
*/

select re.idEmpleado,sum(r.total) as suma,r.fechaIngreso from reparacion_empleado as re
join reparacion as r on r.id = re.idReparacion where year(fechaIngreso) between "2020" and "2024"
group by re.idEmpleado,r.fechaIngreso;

/*
3. Listar todos los clientes y los vehículos que poseen
*/
select c.nombre,c.apellido1,vh.* from cliente as c
join vehiculo as vh on c.id = vh.idCliente;

/*
4. Obtener la cantidad de piezas en inventario para cada pieza
*/


select pz.id as IdPieza,sum(it.cantidad) as catidad from inventario_taller as it
join pieza as pz on pz.id = it.idPieza
group by idTaller,IdPieza
having it.idTaller = 1;

/*
5. Obtener las citas programadas para un día específico
*/

Select id,fecha,idCliente from cita
where date(fecha) = "2018-04-05";


/*
6. Generar una factura para un cliente específico en una fecha determinada
*/

select fd.idFacturacion,rp.fechaEntrega,rp.descripcion,fd.precio,(fd.precio * 1.21 - fd.precio) 
as iva,(fd.precio * 1.21) as TotalPagar  from factura_detalle as fd
join reparacion as rp on rp.id = fd.idReparacion
where date(rp.fechaEntrega) = "2005-07-13";

/*
7. Listar todas las órdenes de compra y sus detalles
*/

select oc.idProveedor,od.idPieza,od.idOrdenCompra,od.cantidad,od.precio from orden_compra as oc
join orden_detalle as od on oc.id = od.idOrdenCompra;


/*
8. Obtener el costo total de piezas utilizadas en una reparación específica
*/

select rs.idReparacion,rs.cantidadPieza,pz.nombre,pz.precio,(pz.precio * rs.cantidadPieza)as total from reparacion_servicio AS rs
join pieza as pz on pz.id = rs.idPieza
where rs.idReparacion = 1;

/*
9. Obtener el inventario de piezas que necesitan ser reabastecidas (cantidad
menor que un umbral)
*/

select idPieza,cantidad from inventario_taller 
where cantidad is null ;

/*
10. Obtener la lista de servicios más solicitados en un período específico
*/
select pp as Reparacion, max(p) as servicio
from(
select rs.idReparacion as pp,count(rs.idServicio) as p
from reparacion_servicio as rs
join reparacion as rp on rp.id = rs.idReparacion
where year(rp.fechaIngreso) between "2007" and "2015"
group by rs.idReparacion) as miloca
group by pp;

/*
11. Obtener el costo total de reparaciones para cada cliente en un período
específico
*/

select c.nombre,sum(rp.total) as suma from reparacion as rp
join vehiculo as vh on rp.idVehiculo = vh.id
join cliente as c on c.id = vh.idCliente
where year(rp.fechaIngreso) between "2010" and "2020"
group by c.nombre;

/*
12. Listar los empleados con mayor cantidad de reparaciones realizadas en un
período específico
*/

select idEmpleado,count(idReparacion) as cantidad from reparacion_empleado as re
join reparacion as r on r.id = re.idReparacion
where year(r.fechaIngreso) between "2010" and "2020"
group by idEmpleado
order by cantidad desc limit 4;


/*
13. Obtener las piezas más utilizadas en reparaciones durante un período
específico
*/

select pz.id as pieza,count(pz.nombre) as cantidad from pieza as pz
left join reparacion_servicio as rs on rs.idPieza = pz.id
join reparacion as r on r.id = rs.idReparacion
where year(fechaIngreso) between "2015" and "2024"
group by pieza
order by pieza;

/*
14. Calcular el promedio de costo de reparaciones por vehículo
*/

select idVehiculo,avg(total) as promedio from reparacion
group by idVehiculo;

/*
15. Obtener el inventario de piezas por proveedor
*/

select pp.idPieza,pp.idProveedor,sum(it.cantidad) as cantidad from proveedor_pieza as pp
right join inventario_taller as it on it.idPieza = pp.idPieza
group by pp.idPieza,pp.idProveedor ;


/*
16. Listar los clientes que no han realizado reparaciones en el último año
*/

select cl.id,r.fechaIngreso from reparacion as r
join vehiculo as vh on r.idVehiculo = vh.id
join cliente as cl on cl.id = vh.idCliente
where year(r.fechaIngreso) < "2024" ;

/*
17. Obtener las ganancias totales del taller en un período específico
*/

SELECT 
SUM(total) as ganancia,(CASE 
WHEN YEAR(fechaIngreso) = year(fechaIngreso) THEN year(fechaIngreso)
ELSE 'otra fecha'
END) AS "año"FROM reparacion
WHERE YEAR(fechaIngreso) BETWEEN 2022 AND 2024
GROUP BY fechaIngreso;


/*
18. Listar los empleados y el total de horas trabajadas en reparaciones en un
período específico (asumiendo que se registra la duración de cada reparación)
*/

select em.id,sum(re.horasTrabajadas) as horas from reparacion_empleado as re
join empleado as em on em.id = re.idEmpleado
join reparacion as r on r.id = re.idReparacion
where year(r.fechaEntrega) between "2010" and "2022"
group by em.id;

/*
19. Obtener el listado de servicios prestados por cada empleado en un período
específico
*/
select re.idEmpleado,s.nombre from reparacion_servicio as rs
join reparacion as r on r.id = rs.idReparacion
join reparacion_empleado as re on re.idReparacion = r.id
join servicio as s on s.id = rs.idServicio
where year(r.fechaIngreso) between "2013" and "2024"
order by re.idEmpleado;


/*
SUBCONSULTASS
*/

/*1. Obtener el cliente que ha gastado más en reparaciones durante el último año.*/

select idCliente,max(total) as total from 
(select idCliente,total from facturacion) as cli
group by idCliente
order by total desc limit 1;

/*
2. Obtener la pieza más utilizada en reparaciones durante el último mes
*/
SELECT rs.idPieza, COUNT(rs.idPieza) AS cantidad
FROM reparacion_servicio AS rs
JOIN reparacion AS r ON r.id = rs.idReparacion
WHERE date(r.fechaIngreso) = (select max(date(r.fechaIngreso)))
GROUP BY rs.idPieza
ORDER BY COUNT(rs.idPieza) DESC
limit 1;

/*
3. Obtener los proveedores que suministran las piezas más caras
*/

select pp.idPieza,pp.idProveedor,sum(it.cantidad),pz.precio as cantidad from proveedor_pieza as pp
right join inventario_taller as it on it.idPieza = pp.idPieza
join (select id,precio from pieza ) as pz on pz.id = it.idPieza
group by pp.idPieza,pp.idProveedor,pz.precio
order by pz.precio desc limit 3 ;


/*
4. Listar las reparaciones que no utilizaron piezas específicas durante el último
año
*/

select rs.idReparacion,rs.idPieza from reparacion_servicio as rs
left join reparacion as r on rs.idReparacion = r.id
where year(r.fechaIngreso) = (select (max(year(fechaIngreso))) from reparacion)
and rs.idPieza is null;


/*
5. Obtener las piezas que están en inventario por debajo del 10% del stock inicial
*/
SELECT pz.id AS IdPieza, SUM(it.cantidad) AS cantidad
FROM inventario_taller AS it
JOIN pieza AS pz ON pz.id = it.idPieza
GROUP BY IdPieza
HAVING SUM(it.cantidad) < 30;



/*
procedimientos almacenados
*/

/*
1. Crear un procedimiento almacenado para insertar una nueva reparación.
*/

DELIMITER //
CREATE PROCEDURE NewReparacion(
    IN fechaEs DATE,
    IN fechaEn DATE,
    IN descripcionp TEXT,
    IN totalp DOUBLE(15,2),
    IN idVehiculo INT
)
BEGIN
    INSERT INTO reparacion (fechaIngreso, fechaEsperada, fechaEntrega, descripcion, Total, idVehiculo) 
    VALUES (CURDATE(), fechaEs, fechaEn, descripcionp, totalp, idVehiculo);

    SELECT * FROM reparacion 
    WHERE DATE(fechaIngreso) = (SELECT MAX(DATE(fechaIngreso)) FROM reparacion);
END //
DELIMITER ;

CALL NewReparacion('2024-09-06', '2024-10-06', 'averiado', 220000, 2);

/*
2. Crear un procedimiento almacenado para actualizar el inventario de una pieza.
*/
select * from inventario_taller;

delimiter //
create procedure ActualizarInventario(
in idTallerp int,
in idPiezap int,
in cantidadp int
)
begin
UPDATE inventario_taller
SET cantidad = cantidad + cantidadp
WHERE idPieza = idPiezap;

select * from inventario_taller;
end//
delimiter ;



call ActualizarInventario(1,1,30);


/*
3. Crear un procedimiento almacenado para eliminar una cita
*/

DELIMITER //

CREATE PROCEDURE eliminarCita(
    IN idCita INT 
)
BEGIN 
    DELETE FROM cita WHERE id = idCita;
	SELECT * FROM cita;
END //

DELIMITER ;


call eliminarCita(1);

/*
4. Crear un procedimiento almacenado para generar una factura
*/
delimiter //

CREATE PROCEDURE generar_factura_cliente(in cliente_id int)
begin
    declare total_factura double default 0;
    
    insert into facturacion (fecha, idcliente) values (curdate(), cliente_id);
    set @factura_id = last_insert_id();
    
    select sum(total) into total_factura
    from reparacion
    where idvehiculo in (select id from vehiculo where idcliente = cliente_id);

    update facturacion set total = total_factura where id = @factura_id;
    
    insert into factura_detalle (idfacturacion, idreparacion, cantidad, precio)
    select @factura_id, id, 1, total
    from reparacion
    where idvehiculo in (select id from vehiculo where idcliente = cliente_id);
    
    select concat('se ha generado la factura con id: ', @factura_id) as mensaje;
end //

delimiter ;

CALL generar_factura_cliente(2);


/*
5. Crear un procedimiento almacenado para obtener el historial de reparaciones
de un vehículo
*/
drop procedure obtener_historial_reparaciones;
delimiter //

create procedure obtener_historial_reparaciones(in vehiculo_id int)
begin
    select r.id, r.fechaIngreso,fechaEntrega, r.descripcion, r.total
    from reparacion r
    where r.idVehiculo = vehiculo_id;
end //

delimiter ;

call obtener_historial_reparaciones(2);


/*
6. Crear un procedimiento almacenado para calcular el costo total de
reparaciones de un cliente en un período
*/
delimiter //

create procedure calcular_costo_total_reparaciones(
    in cliente_id int,
    in fecha_inicio date,
    in fecha_fin date
)
begin
    declare total_costo double default 0;
    
    select sum(r.total) into total_costo
    from reparacion r
    inner join vehiculo v on r.idVehiculo = v.id
    where v.idCliente = cliente_id
    and r.fechaIngreso between fecha_inicio and fecha_fin;
    
    select total_costo as costo_total;
end //

delimiter ;

call calcular_costo_total_reparaciones(1,"2002-01-01","2010-01-01");



/*
7. Crear un procedimiento almacenado para obtener la lista de vehículos que
requieren mantenimiento basado en el kilometraje.
*/
drop procedure obtener_vehiculos_mantenimiento_kilometraje;
delimiter //

create procedure obtener_vehiculos_mantenimiento_kilometraje(
    in kilometraje_limite int
)
begin
    select id, idMarca, modelo, kilometraje
    from vehiculo
    where kilometraje >= kilometraje_limite;
end //

delimiter ;

call obtener_vehiculos_mantenimiento_kilometraje(80000);



/*
8. Crear un procedimiento almacenado para insertar una nueva orden de compra
*/
drop procedure insertar_orden_compra;
delimiter //

create procedure insertar_orden_compra(
    in idProveedor int,
    in idEmpleado int,
    in total int
)
begin
    declare fecha_pedido date;
    set fecha_pedido = curdate();
    set @orden_id = last_insert_id();
    insert into orden_compra (fecha, idProveedor, idEmpleado, total)
    values (fecha_pedido, idProveedor, idEmpleado, total);
    
    select * from orden_compra where id = @orden_id;
end //

delimiter ;

call insertar_orden_compra(1,3,10);

/*
9. Crear un procedimiento almacenado para actualizar los datos de un cliente
*/
drop procedure actualizar_datos_cliente;
DELIMITER //

CREATE PROCEDURE actualizar_datos_cliente(
    IN cliente_id INT,
    IN nuevo_nombre VARCHAR(255),
    IN nuevo_apellido1 VARCHAR(255),
    IN nuevo_apellido2 VARCHAR(255),
    IN nuevo_email VARCHAR(255)
)
BEGIN
    UPDATE cliente
    SET nombre = nuevo_nombre,
        apellido1 = nuevo_apellido1,
        apellido2 = nuevo_apellido2,
        email = nuevo_email
    WHERE id = cliente_id;
    
    SELECT CONCAT('Los datos del cliente con ID ', cliente_id, ' han sido actualizados.') AS Mensaje;
END //

DELIMITER ;

call actualizar_datos_cliente(1,"camilo","hernandez","torres","camiloht0918@gmail.com");

/*
10. Crear un procedimiento almacenado para obtener los servicios más solicitados
en un período
*/
drop procedure obtener_servicios_mas_solicitados;

delimiter //

CREATE PROCEDURE obtener_servicios_mas_solicitados(
    in fecha_inicio date,
    in fecha_fin date
)
begin
    select s.nombre as servicio, count(*) as solicitudes
    from servicio s
    inner join reparacion_servicio rs on s.id = rs.idServicio
    inner join reparacion r on rs.idReparacion = r.id
    where r.fechaIngreso between fecha_inicio and fecha_fin
    group by s.nombre
    order by count(*) desc;
end //

delimiter ;


call obtener_servicios_mas_solicitados("2002-01-01","2010-01-01");



