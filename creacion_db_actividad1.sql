CREATE DATABASE Actividad1;
\c Actividad1

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Creación de la tabla
CREATE TABLE PERSONAS1 (
    RUT NUMERIC(10,0) NOT NULL,
    Nombre CHAR(50) NOT NULL,
    Edad NUMERIC(2,0) NOT NULL,
    Direccion CHAR(100) NOT NULL
);

CREATE TABLE PERSONAS2 (
    RUT NUMERIC(10,0) NOT NULL,
    Nombre CHAR(50) NOT NULL,
    Edad NUMERIC(2,0) NOT NULL,
    Direccion CHAR(100) NOT NULL,
    PRIMARY KEY (RUT)
);

--Arreglar archivo "diezmil" 
--comando para insertar el archivo "diezmil" en la tabla "personas1"

\COPY personas1 FROM '/home/diego/Documents/5TO SEMESTRE/BASES DE DATOS AVANZADA/diezmil' DELIMITER '|';

--INDEXAR PERSONAS1 POR RUT y tomar el tiempo

\timing
CREATE INDEX rut_index ON personas1 (rut);

--crear un script con el cual solucionar los problemas de repeticion de rut en el archivo "diezmil"

--insertar el archivo "diezmil" en la tabla "personas2"
\COPY personas2 FROM '/home/diego/Documents/5TO SEMESTRE/BASES DE DATOS AVANZADA/diezmil' DELIMITER '|';

--para lograr que ambas tablas tengan la misma fila elimino los datos de la tabla "personas1" y los inserto nuevamente
--pero esta ves con el archivo modificado en el cual despues de solucionar los problemas queda con 9994 filas

TRUNCATE TABLE personas1; --comando "TRUNCATE" para poder borrar los datos de la tabla pero preservar su estructura

--Ahora volvemos a usar el comando "COPY" para insertar el archivo "diezmil" arreglado

\COPY personas1 FROM '/home/diego/Documents/5TO SEMESTRE/BASES DE DATOS AVANZADA/diezmil' DELIMITER '|';

--PARTE 2:

TRUNCATE TABLE personas1; --borrar los datos de la tabla 1

TRUNCATE TABLE personas2; --borrar los datos de la tabla 2

DROP INDEX rut_index;

docker run -e name=millones50 -e lines=50000000 -v "C:\Users\diego\OneDrive\Documentos\1PDFCLASES\SEMESTRE 5\BASE DE DATOS AVANZADA":/app/mount/ ensena/bdd-generator
--comando para obtener el archivo "50millones"

\COPY personas1 FROM 'C:\Users\diego\OneDrive\Documentos\1PDFCLASES\SEMESTRE 5\BASE DE DATOS AVANZADA\millones50' DELIMITER '|'; --comando para insertar el archivo en la tabla "personas1"

\COPY personas2 FROM 'C:\Users\diego\OneDrive\Documentos\1PDFCLASES\SEMESTRE 5\BASE DE DATOS AVANZADA\millones50' DELIMITER '|'; --comando para insertar el archivo en la tabla "personas2"

CREATE INDEX rut_index ON personas1 (rut); --crear indice en base al rut

SELECT COUNT(*) FROM personas1; --para contar la cantidad de filas de la tabla "personas1"

SELECT COUNT(*) FROM personas2; --para contar la cantidad de filas de la tabla "personas2"

--verificar los tiempos de ejecucion de insertar el archivo "millones50" en "personas1" y la indexacion v/s insertar el archivo "millones50" en "personas2"

--Hacer un informe en el que se muestre la evidencia de los procesos usados para cargar ambas
--tablas, se indique los problemas encontrados que tuvo que solucionar, se analice los resultados
--obtenidos y se concluya, en base a las comparacion hecha en el punto 8, cual es el metodo mas
--eficiente para cargar un archivo de gran volumen.






















