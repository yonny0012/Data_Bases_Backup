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
    FOR registro IN cur_trabajo LOOP
        RETURN NEXT registro;
    END LOOP;
    RETURN;
END $BODY$
LANGUAGE 'plpgsql';

SELECT expl_cursor1();

--      Cursor implícito
    /*
        Por otra parte, los cursores implícitos están insertos directamente en el código como una
    instrucción SELECT, sin ser declarados previamente y, generalmente, requieren de alguna
    variable del tipo RECORD o ROWTYPE para las filas.
    */
    --      ejemplo:
-- CASO2 : Uso simple de cursores IMPLICITOS
CREATE OR REPLACE FUNCTION impl_cursor2 () RETURNS SETOF profesor
AS
$BODY$
DECLARE
    registro profesor%ROWTYPE;
BEGIN
    -- Cursor IMPLICITO en el ciclo FOR
    FOR registro IN SELECT * FROM profesor LOOP
        RETURN NEXT registro;
    END LOOP;
    RETURN;
END $BODY$
LANGUAGE 'plpgsql';

select impl_cursor2 ();

    --      Abriendo Cursores

/*    Antes de que el cursor sea utilizado para regresar filas, debe ser abierto.
    PL/pgSQL tiene cuatro formas para el comando OPEN; dos usan variables
    cursor no asignadas y las otras dos usan variables cursor asignadas.
*/

    -- 1    OPEN FOR SELECT
    /*
        La variable cursor es abierta y se le pasa la consulta especificada para ejecutar.

        El cursor no puede ser abierto aún, y debe haber sido declarado como cursor no asignado (esto
    es, una simple variable refcursor). La consulta SELECT es tratada de la misma forma que
    otros comandos SELECT en PL/pgSQL: los nombres de variables PL/pgSQL son sustituidos,
    y el plan de consulta es almacenado para su posible reutilización.

    >>> OPEN curs1 FOR SELECT * FROM foo WHERE key = mykey;
    */

    -- 2     OPEN FOR EXECUTE
    /*
        La variable cursor es abierta y se le pasa la consulta especificada a ser ejecutada.
    El cursor no puede ser abierto aún, y declarado como cursor no asignado (esto es, una simple
    variable refcursor). La consulta es especificada como una expresión de texto de la misma
    forma que en el comando EXECUTE. Como es usual, esto le da flexibilidad para que la
    consulta pueda variar en cada ejecución.

    >>> OPEN curs1 FOR EXECUTE ''SELECT * FROM '' || quote_ident($1);
    */

    -- 3     OPEN bound-cursor [ ( argument_values ) ]
    /*
        Esta forma de OPEN es usada para abrir una variable cursor cuya consulta es asignada
    cuando ésta fue declarada.
    
    OPEN bound -cursor [ ( argument\_values ) ];
    El cursor no puede ser abierto todavía. Una lista de los argumentos de los valores de las
    expresiones debe aparecer si, y sólo si, el cursor fue declarado para tomar argumentos. Estos
    valores son sustituidos en la consulta. El plan de consulta para un cursor asignado siempre
    es considerado como almacenable -no hay equivalencia para EXECUTE en éste caso-.
    
    >>> OPEN curs2;
    
    >>> OPEN curs3 (42);
    */

    --      FETCH

    /*
    *   FETCH recupera la siguiente fila del cursor en una variable de fila
    *   Si no hay fila siguiente, el objetivo se establece en NULL(s)
    *   la función especial FOUND comprueba si se ha obtenido una fila o no

        >>> FETCH [ direction { FROM | IN } ] cursor INTO target;
        ==>     La cláusula direction puede ser cualquiera de las variantes permitidas en el comando FETCH
            de SQL, excepto las que recuperan más de una fila; es decir, puede ser:
            NEXT, PRIOR, FIRST, LAST, ABSOLUTE count, RELATIVE count, FORWARD, o BACKWARD

    ejemplos:

    FETCH curs1 INTO rowvar;
    
    FETCH curs2 INTO foo , bar , baz;
    
    FETCH LAST FROM curs3 INTO x, y;
    
    FETCH RELATIVE -2 FROM curs4 INTO x;
    */

    --      Clase
    /*
        Para cerrar un cursor abierto, utilizamos:

        CLOSE cursor;

        También, puede ser usado para liberar recursos antes del final de una transacción, o para
        liberar una variable cursor para abrirla de nuevo.
*/

--      MOVE
/*
        MOVE posiciona un cursor sin devolver datos; trabaja como el comando FETCH, excepto
    que sólo posiciona el cursor y no recupera la fila actual. Como con SELECT INTO, la variable
    FOUND verifica que haya una siguiente fila a recuperar

    >>> MOVE [ direction { FROM | IN } ] cursor;

    Ejemplos:

    MOVE curs1;
    MOVE LAST FROM curs3;
    MOVE RELATIVE -2 FROM curs4;
    MOVE FORWARD 2 FROM curs4;
    */

    --  UPDATE/DELETE WHERE CURRENT OF

    /*
        UPDATE table SET {<Valores a modificar>} WHERE CURRENT OF cursor;
        DELETE FROM table WHERE CURRENT OF cursor;

            Cuando un cursor es ubicado en la fila de una tabla, esa fila es actualizada o eliminada usando
        el cursor para identificarla. Hay restricciones para las cuales, la consulta del cursor puede ser
        no agrupada, por lo que es mejor utilizar FOR UPDATE en el cursor

        Ejemplo:
        UPDATE foo SET dataval = myval WHERE CURRENT OF curs1;
    */

    --      Retornando Cursores

    /*
        *       Las funciones PL/pgSQL devuelven cursores al cliente.
        *       Acción usada para devolver múltiples filas o columnas desde la función, la cual abre 
            el cursor y devuelve el nombre del cursor.
        *       Éste, se puede recuperar (con FETCH) filas desde el cursor.
        *       El cursor puede ser cerrado por el remitente, o bien cerrado cuando termine la transacción.

        *       El nombre del cursor devuelto por la función puede ser especificado por el cliente o generado 
            automáticamente. 
    */
    --  El siguiente código muestra cómo un nombre de cursor es proporcionado por el cliente:
    CREATE OR REPLACE FUNCTION reffunc(refcursor) RETURNS refcursor AS 
    '
    BEGIN
        OPEN $1 FOR SELECT nombest FROM estudiante;
        RETURN $1;
    END;
    '
    LANGUAGE 'plpgsql';
    BEGIN;
    SELECT reffunc('funccursor');
    FETCH ALL IN funccursor;
    COMMIT;

    --  El siguiente código usa la generación automática para nombrar un cursor:
    CREATE OR REPLACE FUNCTION reffunc2() RETURNS refcursor AS
    '
    DECLARE
        ref refcursor;
    BEGIN
        OPEN ref FOR SELECT nombest FROM estudiante;
        RETURN ref;
    END;
    '
    LANGUAGE 'plpgsql';
    BEGIN;
    SELECT reffunc2 ();
    reffunc2
    --------------------
    <unnamed cursor 1>
    (1 row)
    FETCH ALL IN "<unnamed cursor 1>";
    COMMIT;

    --      El siguiente código regresa múltiples cursores con una única función:
    CREATE OR REPLACE FUNCTION myfunc(refcursor , refcursor) RETURNS SETOF refcursor AS $$
    BEGIN
        OPEN $1 FOR SELECT * FROM grupo;
        RETURN NEXT $1;
        OPEN $2 FOR SELECT * FROM profesor;
        RETURN NEXT $2;
    END;
    $$ LANGUAGE plpgsql;
    --Debe ser una transacción para usar cursores.
    SELECT * FROM myfunc('a', 'b');
    FETCH ALL FROM a;
    FETCH ALL FROM b;
    COMMIT;