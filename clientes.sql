\c Actividad1

COPY (
    SELECT RUT, Nombre, Direccion
    FROM PERSONAS1
    LIMIT 5000
)
TO 'ruta/clientes.csv'
DELIMITER '|' CSV HEADER;