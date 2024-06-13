\c actividad3

COPY (
    SELECT Codigo, RUT, Nombre
    FROM clientes
    ORDER BY codigo
    LIMIT 5000
)
TO 'ruta/clientes.csv'
DELIMITER '|' CSV HEADER;
