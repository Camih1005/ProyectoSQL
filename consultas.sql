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

select fd.idFacturacion,rp.fechaEntrega,rp.descripcion,fd.precio,(fd.precio * 1.21 - fd.precio) as iva,(fd.precio * 1.21) as TotalPagar  from factura_detalle as fd
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


select * from pieza ;

