--Tema: Cursores, 7/11/2022, semana 6 curso 21-22

-- Active: 1665153006604@@127.0.0.1@5432

/*
    Ejercicio 1. A partir de un listado de los profesores ordenados de menor a 
    mayor por su identificador, modifique la categoría a aquellos que quedan en
    la posición de la 5 a la 10, la nueva categoría será: Auxiliar. Muestre los 
    datos de todos los profesores, incluyendo las modificaciones.
*/
CREATE OR REPLACE FUNCTION mostrarProfesores() returns void as
$$
DECLARE
    variable record;
    curs1 CURSOR FOR 
        SELECT nombprof as nombre from profesor
        WHERE idprof BETWEEN 5 AND 10
        ORDER BY idprof;
BEGIN
    OPEN curs1;
    FETCH cursr1 into variable;
    CLOSE curs1;
END
$$
LANGUAGE plpgsql;
SELECT nombprof as nombre from profesor
    WHERE idprof BETWEEN 5 AND 10
    ORDER BY idprof;