

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


5. Obtener las citas programadas para un día específico

~~~SQL
Select id,fecha,idCliente from cita
where date(fecha) = "2018-04-05";
~~~


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






