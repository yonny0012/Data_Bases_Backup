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











