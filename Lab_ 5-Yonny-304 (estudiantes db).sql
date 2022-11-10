--Tema: Cursores, 7/11/2022, semana 6 curso 21-22

-- Active: 1665153006604@@127.0.0.1@5432

/*
    Ejercicio 1. A partir de un listado de los profesores ordenados de menor a 
    mayor por su identificador, modifique la categoría a aquellos que quedan en
    la posición de la 5 a la 10, la nueva categoría será: Auxiliar. Muestre los 
    datos de todos los profesores, incluyendo las modificaciones.
*/

--EL "SETOF" es para cuando voy a retornar varias filas
CREATE OR REPLACE FUNCTION mostrarProfesores() returns SETOF profesor as
$$
DECLARE
    var profesor%ROWTYPE;
    curs1 CURSOR FOR
        SELECT nombprof as nombre from profesor
        WHERE idprof
        ORDER BY idprof;
        
BEGIN
    
END
$$
LANGUAGE 'plpgsql';
SELECT * from profesor
    WHERE idprof BETWEEN 5 AND 10
    ORDER BY idprof;


    CREATE OR REPLACE FUNCTION cursor_while() RETURNS VOID AS
$BODY$
DECLARE
    reg          RECORD;
    cur_clientes CURSOR FOR SELECT * FROM profesor
                 ORDER BY idprof;
BEGIN
   OPEN cur_clientes;
   FETCH cur_clientes INTO reg;
   WHILE( FOUND ) LOOP
       RAISE NOTICE ' PROCESANDO  %', reg.nombprof;
       FETCH cur_clientes INTO reg;
   END LOOP ;
   RETURN;
END
$BODY$
LANGUAGE 'plpgsql';

select cursor_while();