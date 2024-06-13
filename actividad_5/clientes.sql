\c actividad3

COPY (
    SELECT Codigo, RUT, Nombre
    FROM PERSONAS1
    LIMIT 5000
)
TO 'ruta/clientes.csv'
DELIMITER '|' CSV HEADER;
