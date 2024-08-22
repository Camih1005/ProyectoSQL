

1. Obtener el historial de reparaciones de un vehículo específico

~~~sql
select vh.id,vh.modelo,vh.placa,r.fechaIngreso from reparacion as r 
join vehiculo as vh on r.idVehiculo = vh.id
where vh.id = 1;
~~~

<pre>+----+--------+--------+--------------+
| id | modelo | placa  | fechaIngreso |
+----+--------+--------+--------------+
|  1 | Spark  | ABC123 | 2003-02-20   |
|  1 | Spark  | ABC123 | 2024-06-01   |
+----+--------+--------+--------------+
</pre>

devuelve el historial de reparaciones para un vehículo específico identificado por su ID. Selecciona la ID, modelo y placa del vehículo junto con la fecha de ingreso de cada reparación realizada en dicho vehículo.
--

2. Calcular el costo total de todas las reparaciones realizadas por un empleado
específico en un período de tiempo

~~~sql
select re.idEmpleado,sum(r.total) as suma,r.fechaIngreso from reparacion_empleado as re
join reparacion as r on r.id = re.idReparacion where year(fechaIngreso) between "2020" and "2024"
group by re.idEmpleado,r.fechaIngreso;
~~~
<pre>+------------+----------+--------------+
| idEmpleado | suma     | fechaIngreso |
+------------+----------+--------------+
|          1 | 55000.00 | 2020-10-25   |
|          4 | 48000.00 | 2022-07-30   |
|          2 | 52000.00 | 2024-01-15   |
|          8 | 52000.00 | 2024-01-15   |
+------------+----------+--------------+
</pre>
calcula el costo total de todas las reparaciones realizadas por un empleado específico en un período de tiempo dado. Selecciona la ID del empleado, la suma total de los costos de reparación y la fecha de ingreso de cada reparación.
--
3. Listar todos los clientes y los vehículos que poseen

~~~sql
select c.nombre,c.apellido1,vh.* from cliente as c
join vehiculo as vh on c.id = vh.idCliente;
~~~

<pre>+-----------+------------+----+--------+---------+-------------+------+-----------+---------+
| nombre    | apellido1  | id | placa  | modelo  | kilometraje | año  | idCliente | idMarca |
+-----------+------------+----+--------+---------+-------------+------+-----------+---------+
| Juan      | Pérez      |  1 | ABC123 | Spark   |       50000 | 2018 |         1 |       1 |
| María     | López      |  2 | XYZ987 | Sandero |       60000 | 2017 |         2 |       2 |
| Carlos    | Gómez      |  3 | DEF456 | Fiesta  |       40000 | 2019 |         3 |       3 |
| Laura     | Jiménez    |  4 | GHI789 | Corolla |       70000 | 2015 |         4 |       4 |
| Pedro     | Ramírez    |  5 | JKL321 | Sentra  |       80000 | 2016 |         5 |       5 |
| Ana       | González   |  6 | MNO654 | Aveo    |       55000 | 2014 |         6 |       1 |
| José      | Hernández  |  7 | PQR987 | Logan   |       65000 | 2016 |         7 |       2 |
| Diana     | Torres     |  8 | STU654 | F-150   |       75000 | 2013 |         8 |       3 |
| Alejandro | Sánchez    |  9 | VWX321 | Hilux   |       85000 | 2012 |         9 |       4 |
| Sofía     | Martínez   | 10 | YZA789 | Navara  |       95000 | 2011 |        10 |       5 |
+-----------+------------+----+--------+---------+-------------+------+-----------+---------+
</pre>

 lista todos los clientes y los vehículos que poseen. Selecciona el nombre y apellido del cliente junto con todos los detalles del vehículo que posee.
--
4. Obtener la cantidad de piezas en inventario para cada pieza


~~~SQL
select pz.id as IdPieza,sum(it.cantidad) as catidad from inventario_taller as it
join pieza as pz on pz.id = it.idPieza
group by idTaller,IdPieza
having it.idTaller = 1;
~~~
<pre>+---------+---------+
| IdPieza | catidad |
+---------+---------+
|       1 |     100 |
|       2 |      80 |
|       3 |    NULL |
|       4 |      70 |
|       5 |      98 |
+---------+---------+
</pre>

Esta consulta obtiene la cantidad de piezas en inventario para cada pieza en el taller. Calcula la suma de la cantidad de cada pieza y agrupa los resultados por la ID de la pieza.
--
5. Obtener las citas programadas para un día específico

~~~SQL
Select id,fecha,idCliente from cita
where date(fecha) = "2018-04-05";
~~~
<pre>+----+---------------------+-----------+
| id | fecha               | idCliente |
+----+---------------------+-----------+
|  7 | 2018-04-05 16:45:00 |         7 |
+----+---------------------+-----------+</pre>

obtiene las citas programadas para un día específico identificado por su fecha. Selecciona la ID de la cita, la fecha y la ID del cliente asociado a cada cita.
--

6. Generar una factura para un cliente específico en una fecha determinada

~~~SQL
select fd.idFacturacion,rp.fechaEntrega,rp.descripcion,fd.precio,(fd.precio * 1.21 - fd.precio) as iva,(fd.precio * 1.21) as TotalPagar  from factura_detalle as fd
join reparacion as rp on rp.id = fd.idReparacion
where date(rp.fechaEntrega) = "2005-07-13";
~~~

<pre>+---------------+--------------+----------------------------+----------+----------+------------+
| idFacturacion | fechaEntrega | descripcion                | precio   | iva      | TotalPagar |
+---------------+--------------+----------------------------+----------+----------+------------+
|             2 | 2005-07-13   | Cambio de aceite y filtros | 75000.00 | 15750.00 |   90750.00 |
+---------------+--------------+----------------------------+----------+----------+------------+
</pre>
 genera una factura para un cliente específico en una fecha determinada. Selecciona la ID de la factura, la fecha de entrega de la reparación asociada, la descripción de la reparación, el precio de la factura y el total a pagar, incluyendo el IVA.
--


7. Listar todas las órdenes de compra y sus detalles

~~~SQL
select oc.idProveedor,od.idPieza,od.idOrdenCompra,od.cantidad,od.precio from orden_compra as oc
join orden_detalle as od on oc.id = od.idOrdenCompra;
~~~
<pre>+-------------+---------+---------------+----------+----------+
| idProveedor | idPieza | idOrdenCompra | cantidad | precio   |
+-------------+---------+---------------+----------+----------+
|           1 |       1 |             1 |      400 | 40000.00 |
|           2 |       2 |             2 |      200 | 80000.00 |
|           3 |       3 |             3 |      100 | 50000.00 |
|           4 |       4 |             4 |      190 | 80000.00 |
|           5 |       5 |             5 |      398 | 90000.00 |
|           3 |       6 |             6 |      400 | 40000.00 |
|           4 |       7 |             7 |      200 | 80000.00 |
|           1 |       8 |             8 |      100 | 50000.00 |
|           3 |       9 |             9 |      190 | 80000.00 |
|           5 |      10 |            10 |      398 | 90000.00 |
+-------------+---------+---------------+----------+----------+
</pre>

Esta consulta lista todas las órdenes de compra y sus detalles. Selecciona la ID del proveedor, la ID de la pieza, la ID de la orden de compra, la cantidad y el precio de cada orden de compra.
--

8. Obtener el costo total de piezas utilizadas en una reparación específica

~~~SQL
select rs.idReparacion,rs.cantidadPieza,pz.nombre,pz.precio,(pz.precio * rs.cantidadPieza)as total from reparacion_servicio AS rs
join pieza as pz on pz.id = rs.idPieza
where rs.idReparacion = 1;
~~~
<pre>+--------------+---------------+----------+----------+-----------+
| idReparacion | cantidadPieza | nombre   | precio   | total     |
+--------------+---------------+----------+----------+-----------+
|            1 |             3 | Batería  | 80000.00 | 240000.00 |
+--------------+---------------+----------+----------+-----------+
</pre>

la consulta obtiene el costo total de las piezas utilizadas en una reparación específica identificada por su ID. Selecciona la ID de la reparación, la cantidad de cada pieza utilizada, el nombre de la pieza, el precio unitario de la pieza y el costo total de cada pieza utilizada en la reparación.
--

9. Obtener el inventario de piezas que necesitan ser reabastecidas (cantidad
menor que un umbral)

~~~SQL
select idPieza,cantidad from inventario_taller 
where cantidad is null ;
~~~
<pre>+---------+----------+
| idPieza | cantidad |
+---------+----------+
|       3 |     NULL |
|       2 |     NULL |
|       4 |     NULL |
+---------+----------+
</pre>
obtiene el inventario de piezas que necesitan ser reabastecidas, es decir, las piezas cuya cantidad está por debajo de un umbral especificado. Selecciona la ID de la pieza y la cantidad disponible en inventario para cada pieza que necesita ser reabastecida.
--

10. Obtener la lista de servicios más solicitados en un período específico

~~~SQL
select pp as Reparacion, max(p) as servicio
from(
select rs.idReparacion as pp,count(rs.idServicio) as p
from reparacion_servicio as rs
join reparacion as rp on rp.id = rs.idReparacion
where year(rp.fechaIngreso) between "2007" and "2015"
group by rs.idReparacion) as miloca
group by pp;
~~~
<pre>+------------+----------+
| Reparacion | servicio |
+------------+----------+
|          3 |        1 |
|          4 |        1 |
|          5 |        1 |
|          6 |        1 |
+------------+----------+
</pre>

la consulta obtiene la lista de servicios más solicitados en un período específico. Selecciona el nombre del servicio y la cantidad de veces que ha sido solicitado, ordenando los resultados por la cantidad de solicitudes en orden descendente.
--

11. Obtener el costo total de reparaciones para cada cliente en un período
específico

~~~SQL
select c.nombre,sum(rp.total) as suma from reparacion as rp
join vehiculo as vh on rp.idVehiculo = vh.id
join cliente as c on c.id = vh.idCliente
where year(rp.fechaIngreso) between "2010" and "2020"
group by c.nombre;
~~~
<pre>+--------+----------+
| nombre | suma     |
+--------+----------+
| Laura  | 30000.00 |
| Pedro  | 60000.00 |
| Ana    | 45000.00 |
| José   | 40000.00 |
| Diana  | 55000.00 |
+--------+----------+
</pre>

esyo calcula el costo total de las reparaciones para cada cliente en un rango de fechas dado. Muestra el nombre del cliente y el costo total de las reparaciones realizadas para ese cliente en el período especificado.
--

12. Listar los empleados con mayor cantidad de reparaciones realizadas en un
período específico

~~~SQL
select idEmpleado,count(idReparacion) as cantidad from reparacion_empleado as re
join reparacion as r on r.id = re.idReparacion
where year(r.fechaIngreso) between "2010" and "2020"
group by idEmpleado
order by cantidad desc limit 4;
~~~
<pre>+------------+----------+
| idEmpleado | cantidad |
+------------+----------+
|          3 |        2 |
|          1 |        1 |
|          2 |        1 |
|          4 |        1 |
+------------+----------+
</pre>

Esta consulta muestra los empleados con la mayor cantidad de reparaciones realizadas en un rango de fechas dado. Muestra el ID del empleado y la cantidad de reparaciones realizadas por ese empleado en el período especificado.
--

13. Obtener las piezas más utilizadas en reparaciones durante un período
específico

~~~SQL
select pz.id as pieza,count(pz.nombre) as cantidad from pieza as pz
left join reparacion_servicio as rs on rs.idPieza = pz.id
join reparacion as r on r.id = rs.idReparacion
where year(fechaIngreso) between "2015" and "2024"
group by pieza
order by pieza;
~~~

<pre>+-------+----------+
| pieza | cantidad |
+-------+----------+
|     6 |        2 |
|     7 |        3 |
|     8 |        1 |
|     9 |        1 |
+-------+----------+</pre>

esto muestra las piezas más utilizadas en reparaciones durante un rango de fechas dado. Muestra el ID de la pieza y la cantidad de veces que fue utilizada en reparaciones durante el período especificado.
--

14. Calcular el promedio de costo de reparaciones por vehículo

~~~SQL
select idVehiculo,avg(total) as promedio from reparacion
group by idVehiculo;
~~~
<pre>+------------+---------------+
| idVehiculo | promedio      |
+------------+---------------+
|          1 |  40000.000000 |
|          2 | 122500.000000 |
|          3 |  35000.000000 |
|          4 |  30000.000000 |
|          5 |  60000.000000 |
|          6 |  45000.000000 |
|          7 |  40000.000000 |
|          8 |  55000.000000 |
|          9 |  48000.000000 |
|         10 |  52000.000000 |
+------------+---------------+
</pre>
Esta consulta calcula el promedio de costo de reparaciones por vehículo. Muestra el ID del vehículo y el promedio de costo de las reparaciones realizadas para ese vehículo.
--

15. Obtener el inventario de piezas por proveedor

~~~SQL
select pp.idPieza,pp.idProveedor,sum(it.cantidad) as cantidad from proveedor_pieza as pp
right join inventario_taller as it on it.idPieza = pp.idPieza
group by pp.idPieza,pp.idProveedor ;
~~~
<pre>+---------+-------------+----------+
| idPieza | idProveedor | cantidad |
+---------+-------------+----------+
|       1 |           1 |      475 |
|       2 |           1 |      830 |
|       3 |           1 |      221 |
|       4 |           2 |      492 |
|       5 |           2 |      363 |
+---------+-------------+----------+
</pre>
muestroo el inventario de piezas por proveedor. Muestra el ID de la pieza, el ID del proveedor y la cantidad total en inventario para cada pieza suministrada por cada proveedor.
 --

16. Listar los clientes que no han realizado reparaciones en el último año

~~~SQL
select cl.id,r.fechaIngreso from reparacion as r
join vehiculo as vh on r.idVehiculo = vh.id
join cliente as cl on cl.id = vh.idCliente
where year(r.fechaIngreso) < "2024" ;
~~~
<pre>+----+--------------+
| id | fechaIngreso |
+----+--------------+
|  1 | 2003-02-20   |
|  2 | 2005-07-10   |
|  3 | 2007-09-25   |
|  4 | 2010-04-15   |
|  5 | 2012-11-25   |
|  6 | 2015-09-05   |
|  7 | 2018-04-15   |
|  8 | 2020-10-25   |
|  9 | 2022-07-30   |
+----+--------------+</pre>

 muestra los clientes que no han realizado reparaciones en el último año. Muestra el ID del cliente y la fecha de ingreso de la última reparación asociada a ese cliente.
 --

17. Obtener las ganancias totales del taller en un período específico

~~~SQL
SELECT 
SUM(total) as ganancia,(CASE 
WHEN YEAR(fechaIngreso) = year(fechaIngreso) THEN year(fechaIngreso)
ELSE 'otra fecha'
END) AS "año"FROM reparacion
WHERE YEAR(fechaIngreso) BETWEEN 2022 AND 2024
GROUP BY fechaIngreso;
~~~
<pre>+-----------+------+
| ganancia  | año  |
+-----------+------+
|  48000.00 | 2022 |
|  52000.00 | 2024 |
|  30000.00 | 2024 |
|  30000.00 | 2024 |
|  30000.00 | 2024 |
| 440000.00 | 2024 |
+-----------+------+
</pre>
calcula las ganancias totales del taller en un rango de fechas dado. Muestra la ganancia total y el año correspondiente para cada año dentro del período especificado.
--

18. Listar los empleados y el total de horas trabajadas en reparaciones en un
período específico (asumiendo que se registra la duración de cada reparación)

~~~SQL
select em.id,sum(re.horasTrabajadas) as horas from reparacion_empleado as re
join empleado as em on em.id = re.idEmpleado
join reparacion as r on r.id = re.idReparacion
where year(r.fechaEntrega) between "2010" and "2022"
group by em.id;
~~~
<pre>+----+-------+
| id | horas |
+----+-------+
|  1 |     2 |
|  2 |     6 |
|  3 |     9 |
|  4 |    21 |
|  6 |    25 |
| 10 |     8 |
+----+-------+
</pre>

 muestra los empleados y el total de horas trabajadas en reparaciones en un rango de fechas dado. Muestra el ID del empleado y el total de horas trabajadas por ese empleado en el período especificado.
 -

19. Obtener el listado de servicios prestados por cada empleado en un período
específico

~~~SQL
select re.idEmpleado,s.nombre from reparacion_servicio as rs
join reparacion as r on r.id = rs.idReparacion
join reparacion_empleado as re on re.idReparacion = r.id
join servicio as s on s.id = rs.idServicio
where year(r.fechaIngreso) between "2013" and "2024"
order by re.idEmpleado;
~~~
<pre>+------------+----------------------------+
| idEmpleado | nombre                     |
+------------+----------------------------+
|          1 | Diagnóstico computarizado  |
|          2 | Revisión de frenos         |
|          3 | Cambio de batería          |
|          4 | Cambio de filtro de aire   |
|          8 | Revisión de frenos         |
+------------+----------------------------+
</pre>

Esta muestra el listado de servicios prestados por cada empleado en un rango de fechas dado. Muestra el ID del empleado y el nombre del servicio prestado por ese empleado en el período especificado.
--

# SUBCONSULTAS


1. Obtener el cliente que ha gastado más en reparaciones durante el último año.

~~~SQL
select idCliente,max(total) as total from 
(select idCliente,total from facturacion) as cli
group by idCliente
order by total desc limit 1;
~~~
<pre>+-----------+-----------+
| idCliente | total     |
+-----------+-----------+
|        10 | 522320.00 |
+-----------+-----------+</pre>
busca al cliente que ha gastado la cantidad máxima en reparaciones durante el último año. Calcula la suma total gastada por cada cliente en reparaciones, luego selecciona al cliente con el gasto máximo utilizando la función MAX y agrupando por el ID del cliente
--

2. Obtener la pieza más utilizada en reparaciones durante el último mes

~~~SQL
SELECT rs.idPieza, COUNT(rs.idPieza) AS cantidad
FROM reparacion_servicio AS rs
JOIN reparacion AS r ON r.id = rs.idReparacion
WHERE date(r.fechaIngreso) = (select max(date(r.fechaIngreso)))
GROUP BY rs.idPieza
ORDER BY COUNT(rs.idPieza) DESC
limit 1;
~~~
<pre>+---------+----------+
| idPieza | cantidad |
+---------+----------+
|       7 |        3 |
+---------+----------+
</pre>

esta subconsulta encuentra la pieza que ha sido utilizada con mayor frecuencia en las reparaciones durante el último mes. Cuenta el número de veces que se ha utilizado cada pieza en las reparaciones durante el último mes y selecciona la pieza con el recuento máximo.
--
3. Obtener los proveedores que suministran las piezas más caras

~~~SQL
select pp.idPieza,pp.idProveedor,sum(it.cantidad),pz.precio as cantidad from proveedor_pieza as pp
right join inventario_taller as it on it.idPieza = pp.idPieza
join (select id,precio from pieza ) as pz on pz.id = it.idPieza
group by pp.idPieza,pp.idProveedor,pz.precio
order by pz.precio desc limit 3 ;
~~~
<pre>+---------+-------------+------------------+-----------+
| idPieza | idProveedor | sum(it.cantidad) | cantidad  |
+---------+-------------+------------------+-----------+
|       4 |           2 |              492 | 120000.00 |
|       5 |           2 |              363 |  90000.00 |
|       2 |           1 |              830 |  80000.00 |
+---------+-------------+------------------+-----------+
</pre>

Esta subconsulta identifica a los proveedores que suministran las piezas más caras basadas en el precio de las piezas. Agrupa las piezas por proveedor y muestra los proveedores cuyas piezas tienen el precio más alto.
--

4. Listar las reparaciones que no utilizaron piezas específicas durante el último
año

~~~SQL
select rs.idReparacion,rs.idPieza from reparacion_servicio as rs
left join reparacion as r on rs.idReparacion = r.id
where year(r.fechaIngreso) = (select (max(year(fechaIngreso))) from reparacion)
and rs.idPieza is null;
~~~
<pre>+--------------+---------+
| idReparacion | idPieza |
+--------------+---------+
|           13 |    NULL |
+--------------+---------+
</pre>

busca identificar las reparaciones que no han utilizado piezas específicas durante el último año. Selecciona las reparaciones que no tienen ninguna pieza asociada durante el último año y las muestra en la lista.
--
5. Obtener las piezas que están en inventario por debajo del 10% del stock inicial

~~~SQL
SELECT pz.id AS IdPieza, SUM(it.cantidad) AS cantidad
FROM inventario_taller AS it
JOIN pieza AS pz ON pz.id = it.idPieza
GROUP BY IdPieza
HAVING SUM(it.cantidad) < 30;
~~~
<pre>+---------+----------+
| IdPieza | cantidad |
+---------+----------+
|       3 |       19 |
+---------+----------+
</pre>

identifica las piezas que están en el inventario y cuya cantidad actual es inferior al 10% del stock inicial. Selecciona las piezas cuya cantidad en inventario es menor al 10% del stock inicial y las lista.
--

# procedimientos almacenados



1. Crear un procedimiento almacenado para insertar una nueva reparación.

~~~SQL
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
~~~
<pre>+----+--------------+---------------+--------------+--------------------------+------------+----------+
| id | fechaIngreso | fechaEsperada | fechaEntrega | descripcion              | idVehiculo | Total    |
+----+--------------+---------------+--------------+--------------------------+------------+----------+
| 13 | 2024-08-25   | 2024-08-18    | 2024-08-22   | Mantenimiento preventivo |          2 | 30000.00 |
+----+--------------+---------------+--------------+--------------------------+------------+----------+
</pre>

insertar una nueva reparación en la base de datos. Toma como entrada la fecha esperada de la reparación, la fecha de entrega, la descripción de la reparación, el costo total y el ID del vehículo asociado. Después de insertar la reparación en la tabla correspondiente, devuelve los detalles de la reparación recién creada.
--

2. Crear un procedimiento almacenado para actualizar el inventario de una pieza.


~~~SQL
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
~~~
<pre>+----+----------+---------+----------+
| id | idTaller | idPieza | cantidad |
+----+----------+---------+----------+
|  1 |        1 |       1 |      130 |
|  2 |        1 |       2 |       80 |
|  3 |        1 |       3 |     NULL |
|  4 |        1 |       4 |       70 |
|  5 |        1 |       5 |       98 |
|  6 |        2 |       1 |       64 |
|  7 |        2 |       2 |     NULL |
|  8 |        2 |       3 |        2 |
|  9 |        2 |       4 |      409 |
| 10 |        2 |       5 |      133 |
| 11 |        3 |       1 |       90 |
| 12 |        3 |       2 |      110 |
| 13 |        3 |       3 |       10 |
| 14 |        3 |       4 |     NULL |
| 15 |        3 |       5 |        3 |
| 16 |        4 |       1 |       39 |
| 17 |        4 |       2 |        7 |
| 18 |        4 |       3 |        5 |
| 19 |        4 |       4 |        5 |
| 20 |        4 |       5 |       13 |
| 21 |        5 |       1 |      152 |
| 22 |        5 |       2 |      633 |
| 23 |        5 |       3 |        2 |
| 24 |        5 |       4 |        8 |
| 25 |        5 |       5 |      116 |
+----+----------+---------+----------+
</pre>

Este procedimiento  se encarga de actualizar el inventario de una pieza específica en el taller. Recibe como entrada el ID del taller, el ID de la pieza y la cantidad a actualizar. Después de realizar la actualización, muestra el inventario actualizado.
--

3. Crear un procedimiento almacenado para eliminar una cita

~~~SQL
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
~~~
<pre>+----+---------------------+-----------+------------+----------+------------+
| id | fecha               | idCliente | idVehiculo | idTaller | idServicio |
+----+---------------------+-----------+------------+----------+------------+
|  2 | 2005-06-20 09:45:00 |         2 |          2 |        1 |          2 |
|  3 | 2007-09-10 14:00:00 |         3 |          3 |        1 |          3 |
|  4 | 2010-03-25 08:00:00 |         4 |          4 |        1 |          4 |
|  5 | 2012-11-12 13:30:00 |         5 |          5 |        1 |          5 |
|  6 | 2015-08-30 11:15:00 |         6 |          6 |        1 |          6 |
|  7 | 2018-04-05 16:45:00 |         7 |          7 |        1 |          7 |
|  8 | 2020-10-18 10:00:00 |         8 |          8 |        1 |          8 |
|  9 | 2022-07-22 12:20:00 |         9 |          9 |        1 |          9 |
| 10 | 2024-01-09 15:30:00 |        10 |         10 |        1 |         10 |
+----+---------------------+-----------+------------+----------+------------+
</pre>

Toma como entrada el ID de la cita que se va a eliminar y luego borra la cita correspondiente. Finalmente, devuelve los detalles de las citas restantes en la base de datos.
--

4. Crear un procedimiento almacenado para generar una factura

~~~SQL
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
~~~
<pre>+--------------------------------------+
| mensaje                              |
+--------------------------------------+
| se ha generado la factura con id: 12 |
+--------------------------------------+
</pre>

esto quiere generar una factura detallada para un cliente específico. Toma como entrada el ID del cliente para el cual se generará la factura. Calcula el total de las reparaciones asociadas con ese cliente, actualiza la factura con el total calculado y devuelve un mensaje que indica que la factura ha sido generada con éxito.
--

5. Crear un procedimiento almacenado para obtener el historial de reparaciones
de un vehículo

~~~SQL
delimiter //

create procedure obtener_historial_reparaciones(in vehiculo_id int)
begin
    select r.id, r.fechaIngreso,fechaEntrega, r.descripcion, r.total
    from reparacion r
    where r.idVehiculo = vehiculo_id;
end //

delimiter ;

call obtener_historial_reparaciones(2);
~~~
<pre>+----+--------------+--------------+----------------------------+-----------+
| id | fechaIngreso | fechaEntrega | descripcion                | total     |
+----+--------------+--------------+----------------------------+-----------+
|  2 | 2005-07-10   | 2005-07-13   | Cambio de aceite y filtros |  20000.00 |
| 13 | 2024-08-25   | 2024-08-22   | Mantenimiento preventivo   |  30000.00 |
| 14 | 2024-06-08   | 2024-10-06   | averiado                   | 220000.00 |
+----+--------------+--------------+----------------------------+-----------+
</pre>

Este procedimiento recupera el historial de reparaciones de un vehículo específico. Toma como entrada el ID del vehículo y devuelve una lista de todas las reparaciones realizadas en ese vehículo, incluyendo detalles como el ID de la reparación, la fecha de ingreso, la fecha de entrega, la descripción y el costo total.
--

6. Crear un procedimiento almacenado para calcular el costo total de
reparaciones de un cliente en un período

~~~SQL
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
~~~
<pre>+-------------+
| costo_total |
+-------------+
|       50000 |
+-------------+
</pre>

calculo el costo total de las reparaciones realizadas por un cliente en un período específico. Recibe como entrada el ID del cliente y el rango de fechas, luego calcula el costo total de las reparaciones asociadas con ese cliente durante ese período y lo muestra como resultado.
--

7. Crear un procedimiento almacenado para obtener la lista de vehículos que
requieren mantenimiento basado en el kilometraje.

~~~SQL
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

~~~
<pre>+----+---------+--------+-------------+
| id | idMarca | modelo | kilometraje |
+----+---------+--------+-------------+
|  5 |       5 | Sentra |       80000 |
|  9 |       4 | Hilux  |       85000 |
| 10 |       5 | Navara |       95000 |
+----+---------+--------+-------------+
</pre>

Este procedimiento recupera una lista de vehículos que requieren mantenimiento basado en el kilometraje. Toma como entrada un límite de kilometraje y devuelve una lista de vehículos cuyo kilometraje sea igual o superior al límite especificado.
--

8. Crear un procedimiento almacenado para insertar una nueva orden de compra


~~~SQL
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
~~~
<pre>+----+------------+-------------+------------+-------+
| id | fecha      | idProveedor | idEmpleado | total |
+----+------------+-------------+------------+-------+
| 11 | 2024-06-08 |           1 |          3 |    10 |
+----+------------+-------------+------------+-------+
</pre>

para insertar una nueva orden de compra en la base de datos Tomo como entrada el ID del proveedor, el ID del empleado que realiza la orden y el total de la orden. Después de insertar la orden en la tabla correspondiente, devuelve los detalles de la orden recién creada.
--

9. Crear un procedimiento almacenado para actualizar los datos de un cliente

~~~SQL
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
~~~
<pre>+-------------------------------------------------------+
| Mensaje                                               |
+-------------------------------------------------------+
| Los datos del cliente con ID 1 han sido actualizados. |
+-------------------------------------------------------+
</pre>

actualizo los datos de un cliente específico en la base de datos. Toma como entrada el ID del cliente y los nuevos detalles del cliente, como el nombre, apellidos y correo electrónico. Después de actualizar los datos, devuelve un mensaje que confirma que los datos del cliente han sido actualizados.
--

10. Crear un procedimiento almacenado para obtener los servicios más solicitados
en un período

~~~SQL
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
~~~

<pre>+----------------------+-------------+
| servicio             | solicitudes |
+----------------------+-------------+
| Cambio de aceite     |           1 |
| Revisión de frenos   |           1 |
| Reparación de motor  |           1 |
+----------------------+-------------+
</pre>
recupero una lista de los servicios más solicitados en un período específico. Toma como entrada el rango de fechas y muestra una lista de los servicios junto con la cantidad de veces que fueron solicitados durante ese período.
