CREATE DATABASE actividad3;
\c actividad3

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Creacion de tablas

CREATE TABLE clientes (
    codigo SERIAL NOT NULL,
    rut NUMERIC(10,0) NOT NULL,
    nombre CHAR(50) NOT NULL,
    direccion CHAR(100) NOT NULL
);

CREATE TABLE productos (
    codigo SERIAL NOT NULL,
    nombre CHAR(20) NOT NULL,
    precio NUMERIC(4) NOT NULL
);

CREATE TABLE ventas (
    codigo_cliente NUMERIC(7) NOT NULL,
    codigo_producto NUMERIC(4) NOT NULL,
    cantidad NUMERIC(3) NOT NULL,
    fecha_venta DATE NOT NULL
);

-- Obtener datos de personas de tabla anterior

\c Actividad1

COPY (
    SELECT RUT, Nombre, Direccion
    FROM PERSONAS1
    LIMIT 5000000
)
TO 'ruta\personas5millones.csv'
DELIMITER '|' CSV HEADER;


-- Poner datos en tablas actuales

\c actividad3

--se especifica el nombre de las columnas a la que iran los datos del archivo
COPY clientes (rut, nombre, direccion)
FROM 'ruta\personas5millones.csv'
DELIMITER '|' CSV HEADER;

COPY productos (nombre, precio)
FROM 'ruta\productos1000.csv'
DELIMITER '|' CSV HEADER;

COPY ventas (codigo_cliente, codigo_producto, cantidad, fecha_venta)
FROM 'ruta\ventas200millones.csv'
DELIMITER '|' CSV HEADER;

-- PARTE 1 --

/* Transaccion de venta: Ingreso de una venta que se ha hecho a un cliente,
identificado por su nombre, de una cierta cantidad de un
producto, identificado por su nombre */

INSERT INTO ventas(
    codigo_cliente,
    codigo_producto,
    cantidad,
    fecha_venta
)
SELECT c.codigo, p.codigo, 10, CURRENT_DATE
FROM clientes c, productos p
WHERE c.nombre = 'nombre'
AND p.nombre = 'productox';

-- 1) Nombre del mejor cliente y monto total comprado

SELECT c.nombre, SUM(p.precio * v.cantidad) AS monto
FROM clientes c
JOIN ventas v ON c.codigo = v.codigo_cliente
JOIN productos p ON p.codigo = v.codigo_producto
GROUP BY c.nombre
HAVING SUM(p.precio * v.cantidad) = (
    SELECT MAX(monto_total)
    FROM (
        SELECT SUM(p1.precio * v1.cantidad) AS monto_total
        FROM productos p1
        JOIN ventas v1 ON p1.codigo = v1.codigo_producto
        GROUP BY v1.codigo_cliente
    ) AS subconsulta
);

-- 2) Código y Nombre del producto con la mayor cantidad acumulada de ventas en un rango de tiempo variable

SELECT p.codigo, p.nombre
FROM productos p
JOIN ventas v ON p.codigo = v.codigo_producto
WHERE v.fecha_venta BETWEEN 'fecha_inicio' AND 'fecha_final'
GROUP BY p.codigo, p.nombre
HAVING SUM(v.cantidad) = (
    SELECT MAX(cant)
    FROM (
        SELECT SUM(v1.cantidad) AS cant
        FROM ventas v1
        WHERE v1.fecha_venta BETWEEN 'fecha_inicio' AND 'fecha_final'
        GROUP BY v1.codigo_producto
    )
);

-- 3) Nombre y Rut de todos los clientes que han comprado un producto específico identificado por su nombre

SELECT c.nombre, c.rut
FROM clientes c
JOIN ventas v ON c.codigo = v.codigo_cliente
JOIN productos p ON v.codigo_producto = p.codigo
WHERE p.nombre = 'nombre_variable'
GROUP BY c.nombre, c.rut;

-- PARTE 2 --
/* Creacion de nueva base de datos desnormalizada */

CREATE DATABASE actividad3_2;
\c actividad3_2

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE ventas (
    cliente_rut NUMERIC(10) NOT NULL,
    cliente_nombre CHAR(50) NOT NULL,
    cliente_direccion CHAR(100) NOT NULL,
    producto_codigo NUMERIC(4) NOT NULL,
    producto_nombre CHAR(20) NOT NULL,
    producto_precio NUMERIC(4,0) NOT NULL,
    cantidad NUMERIC(3) NOT NULL,
    fecha_venta DATE NOT NULL
);

-- Extraer datos de las tablas anteriores
\c actividad3

COPY(
    SELECT c.rut, c.nombre, c.direccion,
    p.codigo, p.nombre, p.precio, v.cantidad, v.fecha_venta
    FROM clientes c
    JOIN ventas v ON c.codigo = v.codigo_cliente
    JOIN productos p ON v.codigo_producto = p.codigo
) TO 'ruta/basedesnormalizada.csv'
DELIMITER '|' CSV HEADER;

-- Insertar datos en segunda base
\c actividad3_2

COPY ventas (cliente_rut, cliente_nombre, cliente_direccion,
    producto_codigo, producto_nombre, producto_precio, cantidad, fecha_venta)
FROM 'ruta/basedesnormalizada.csv'
DELIMITER '|' CSV HEADER;

-- Transaccion de venta

INSERT INTO ventas (
    cliente_rut, cliente_nombre, cliente_direccion,
    producto_codigo, producto_nombre, producto_precio,
    cantidad, fecha_venta
)
SELECT
    cliente_rut, cliente_nombre, cliente_direccion,
    producto_codigo, producto_nombre, producto_precio,
    10 AS cantidad,    
    CURRENT_DATE AS fecha_venta
FROM ventas
WHERE cliente_nombre = 'nombre_del_cliente' AND producto_nombre = 'nombre_producto';

-- Consultas --
-- 1) Nombre del mejor cliente y monto total comprado

SELECT c.nombre AS cliente_nombre, 
       SUM(v.producto_precio * v.cantidad) AS monto_total
FROM ventas v
JOIN clientes c ON v.codigo_clientes = c.codigo
GROUP BY c.nombre
HAVING SUM(v.producto_precio * v.cantidad) = (
    SELECT MAX(monto)
    FROM (
        SELECT SUM(producto_precio * cantidad) AS monto
        FROM ventas
        GROUP BY codigo_clientes
    ) AS subconsulta
);

-- 2) Código y Nombre del producto con la mayor cantidad acumulada de ventas en un rango de tiempo variable

SELECT producto_codigo, producto_nombre
FROM ventas
WHERE fecha_venta BETWEEN 'fecha_inicio' AND 'fecha_final'
GROUP BY producto_codigo, producto_nombre
HAVING SUM(cantidad) = (
    SELECT MAX(cant)
    FROM (
        SELECT SUM(cantidad) AS cant
        FROM ventas
        WHERE fecha_venta BETWEEN 'fecha inicio' AND 'fecha_final'
        GROUP BY producto_codigo, producto_nombre
    )
);

-- 3) Nombre y Rut de todos los clientes que han comprado un producto específico identificado por su nombre

SELECT cliente_nombre, cliente_rut
FROM ventas
WHERE producto_nombre = 'nombre_variable'
GROUP BY cliente_nombre, clientes_rut;


-- NUEVA NORMALIZACION --
CREATE TABLE clientes (
    codigo SERIAL NOT NULL,
    rut NUMERIC(10,0) NOT NULL,
    nombre CHAR(50) NOT NULL,
    direccion CHAR(100) NOT NULL
);
CREATE TABLE ventas (
    codigo_cliente NUMERIC(7) NOT NULL,
    producto_nombre CHAR(20) NOT NULL,
    producto_precio NUMERIC(4) NOT NULL,
    cantidad NUMERIC(3) NOT NULL,
    fecha_venta DATE NOT NULL
);

COPY(
    SELECT c.codigo, p.nombre, p.precio, v.cantidad, v.fecha_venta
    FROM clientes c
    JOIN ventas v ON c.codigo = v.codigo_cliente
    JOIN productos p ON v.codigo_producto = p.codigo
) TO 'ruta/ventasproductos.csv'
DELIMITER '|' CSV HEADER;

COPY clientes (cliente_rut, cliente_nombre, cliente_direccion,
    producto_codigo, producto_nombre, producto_precio, cantidad, fecha_venta)
FROM 'ruta/basedesnormalizada.csv'
DELIMITER '|' CSV HEADER;

COPY ventas (codigo_cliente, producto_nombre, producto_precio, cantidad, fecha_venta)
FROM 'ruta/ventasproductos.csv'
DELIMITER '|' CSV HEADER;

