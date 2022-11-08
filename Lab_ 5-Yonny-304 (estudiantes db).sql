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
        (SELECT nombprof as nombre from profesor
        WHERE idprof
        ORDER BY idprof);

    cont INTEGER = 5;
        
BEGIN
    OPEN curs1;
    MOVE ABSOLUTE 5 FROM curs1;
    LOOP
        IF (cont<=10) THEN
            UPDATE profesor SET categoria = "Profesor Auxiliar" WHERE CURRENT OF curs1;
            MOVE RELATIVE 1 FROM curs1;
        ELSE
            EXIT;
        END IF;
        cont = cont + 1;
    END LOOP
    CLOSE curs1;
    OPEN curs1;

    LOOP
        FETCH curs1 INTO var;
        RETURN NEXT var;
        IF NOT FOUND THEN 
            EXIT;
        END IF;
    END LOOP;
    CLOSE curs1;
END
$$
LANGUAGE 'plpgsql';
SELECT * from profesor
    WHERE idprof BETWEEN 5 AND 10
    ORDER BY idprof;



-- CASO1 : Uso simple de cursores EXPLÍCITOS 
CREATE OR REPLACE FUNCTION expl_cursor1() RETURNS SETOF profesor AS
$BODY$
DECLARE
    -- Declaración EXPLICITA del cursor
    cur_clientes CURSOR FOR SELECT * FROM profesor; 
    registro profesor%ROWTYPE;
BEGIN
   -- Procesa el cursor
   FOR registro IN cur_clientes LOOP
       RETURN NEXT registro;
   END LOOP;
   RETURN;
END $BODY$ LANGUAGE 'plpgsql';

SELECT expl_cursor1(); 