-- Active: 1665153006604@@127.0.0.1@5432@estudiantes@public
--¿Qué son los cursores?:
    /*
        Los cursores son tablas temporales que ejecutan consultas; son soportados dentro de las
    funciones, como un SQL embebido, y pueden o no hacer copias de sus resultados; éstos, son
    de sólo lectura.
    */
    /*
        Un cursor es el nombre que recibe un apuntador (pointer) de sólo lectura hacia un conjunto
    de datos ( resultset) que se obtiene de una consulta SQL asociada. Pensemos en términos
    de arreglos similar a los de un lenguaje de programación, los cursores procesan, una a una,
    las filas que componen un conjunto de resultados en vez de trabajar con todos los registros
    como en una consulta tradicional de SQL.
    */

    -- Comandos utilizados en los cursores:
        --comando                               Descripcion
        /*
        BEGIN       |       Para indicar el comienzo de la operación
        --------------------------------------------------------------------------------
        DECLARE     |       Define un cursor para acceso a una tabla
        --------------------------------------------------------------------------------
        FETCH               Permite devolver las filas usando un
                    |    cursor. El numero de filas devueltas es
                    |    `especificado por un número (#), este
                    |    puede ser reemplazado por ALL que de-
                    |    vuelve todas las filas del cursor. Tam-
                    |    bién, podemos utilizar los comandos
                    |    BACKWARD y FORWARD para indi-
                    |    car la dirección
        --------------------------------------------------------------------------------
        CLOSE       |   Libera los recursos del cursor abierto.
        --------------------------------------------------------------------------------
        COMMIT      |   Realiza la transacción actual
        --------------------------------------------------------------------------------
        END         |   Es un sinónimo en PostgreSQL de
                    |   COMMIT. Finaliza la transacción ac-
                    |   tual
        --------------------------------------------------------------------------------
        ROLLBACK    |   Deshace la transacción actual tal que
                    |   todas las modificaciones originadas por
                    |   la misma sean restauradas
        */

        --          Tipos de Cursor
        /*
            Los cursores, en una consulta, manipulan y procesan datos mediante algún lenguaje de
        programación. En PostgreSQL existen dos tipos de cursores, explícitos o implícitos, depen-
        diendo de la necesidad de programación utilizamos uno u otro
        */
    --      Cursor explícito
    /*
        Los cursores explícitos son variables que almacenan datos de consultas de una o mas
    tablas; por tanto, el cursor está formado por una instrucción SELECT y debe ser declarado
    como una variable.
    */
    --          Ejemplo:

    -- CASO1 : Uso simple de cursores EXPLÍCITOS
CREATE OR REPLACE FUNCTION expl_cursor1 () RETURNS SETOF trabajo
AS
$BODY$
DECLARE
    -- Declaración explicita del cursor
    cur_trabajo CURSOR FOR SELECT * FROM trabajo; 
    registro trabajo%ROWTYPE;
BEGIN
    -- Procesa el cursor
    FOR registro IN cur_clientes LOOP
    RETURN NEXT registro;
    END LOOP;
    RETURN;
END $BODY$
LANGUAGE 'plpgsql';
        