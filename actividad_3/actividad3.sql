CREATE DATABASE actividad3
\c actividad3

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Creacion de tablas

CREATE TABLE clientes (
    codigo SERIAL NOT NULL,
    rut NUMERIC(9,0) NOT NULL,
    nombre CHAR(50) NOT NULL,
    direccion CHAR(100) NOT NULL,
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
    fecha_venta DATE NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo),
    FOREIGN KEY (codigo_producto) REFERENCES productos(codigo)
);

-- Obtener datos de personas de tabla anterior

\c Actividad1

COPY (
    SELECT RUT, Nombre, Direccion
    FROM PERSONAS1
)
TO 'ruta/personas5millones.csv'
DELIMITER '|' CSV HEADER;

-- Poner datos en tablas actuales

\c actividad3

COPY clientes
FROM 'ruta/personas5millones.csv'
DELIMITER '|' CSV HEADER;

COPY productos
FROM 'ruta/productos1000.csv'
DELIMITER '|' CSV HEADER;

COPY ventas
FROM 'ruta/ventas200millones.csv'
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
SELECT c.codigo, p.codigo, 40, CURRENT_DATE
FROM clientes c, productos p
WHERE c.nombre = 'nombre'
AND p.nombre = 'productox';

-- 1) Nombre del mejor cliente y monto total comprado

SELECT c.nombre, SUM(p.precio * v.cantidad) AS monto
FROM clientes c
JOIN ventas v ON c.codigo = v.codigo_cliente
JOIN productos p ON p.codigo = v.codigo_producto
GROUP BY c.codigo
HAVING monto = (
    SELECT MAX(monto_total)
    FROM (
        SELECT SUM(p1.precio * v1.cantidad) AS monto_total
        FROM productos p1
        JOIN ventas v1 ON p1.codigo = v1.codigo_producto
        GROUP BY v2.codigo_cliente
    )
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
