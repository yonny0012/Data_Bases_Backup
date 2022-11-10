/*
	Sintaxis del trigger:
	create trigger <nombre_trigger>
		cuando(before|after|...) <evento (insertear|eliminar|actualizar)> on <nombre_tabla>
		for <nombre_filas> when <condicion_trigger>
		execute procedure <nombre_funcin>
	
	* Trigger INSERTS no pueden referirse a OLD y Trigger DELETE no pueden 
	  referirse a NEW

*/
/*
	Se debe realizar un monitoreo de las operaciones de eliminación de datos 
	sobre la tabla "opinion_temporal". 
	1- 	Luego de eliminar una opinión de la tabla opinion_temporal, esta pasa para 
		la tabla opinion_publicada si la cantidad de opiniones publicadas del tema 
		a que pertenece no supera la cifra de 300. La fecha de publicación es la 
		fecha del día en que tiene lugar esta operación.

*/

CREATE OR REPLACE FUNCTION incertar_opinion() RETURNS AS
$
BEGIN
	INSERT into opinion 
END
$
LANGUAGE plpgsql;

CREATE TRIGGER insert_opinion AFTER DELETE ON opinion_temporal 
	FOR each row execute procedure incertar_opinion();



--POSIBLE RESPUESTA: 
--(función)
CREATE OR REPLACE FUNCTION trigger_func() RETURNS trigger AS --declaracion de la funcion que retorna un trigger
$BODY$
DECLARE
	cant integer; --declara una variable para contar
BEGIN
	--se cuenta lo que pide el ejercicio
	/*
	la consulta une las tablas opinion_publicada y opinion, por id_opinion.
	donde coincidan con el id_tema de la tupla eliminada en el trigger	
	*/
	cant:=(select count("opinion_publicada".id_opinion)
		   FROM "opinion_publicada" Inner Join opinion ON 
		   		("opinion_publicada".id_opinion = opinion.id_opinion) 
		   WHERE opinion.id_tema=
		   (SELECT opinion.id_tema FROM opinion WHERE opinion.id_opinion= OLD.id_opinion));
	--condicion
	IF(cant<300)THEN
	--se insxerta en opinion pubicada la acabada de eliminar
		INSERT INTO "opinion_publicada" VALUES (OLD.id_opinion, CURRENT_DATE);
	--si no, se inerta en opinion denegada
	ELSE
		INSERT INTO "opinion_denegada" VALUES (OLD.id_opinion,'Tema completo');
	END IF;
	RETURN NULL;
END;
$BODY$
LANGUAGE 'plpgsql' VOLATILE;

--(trigger)
/*declara el trigger que, despues de eliminaar una tupla de Opinion_temporal
	ejecutara la funcion*/
CREATE TRIGGER "trigger1" AFTER DELETE
	ON "public"."opinion_temporal" FOR EACH ROW
	EXECUTE PROCEDURE "public"."trigger_func"();







