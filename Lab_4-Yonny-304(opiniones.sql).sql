-- Active: 1665153006604@@127.0.0.1@5432@opiniones@public
CREATE OR REPLACE FUNCTION delOpinionVieja() RETURNS TRIGGER AS
$$
BEGIN
    
    DELETE FROM opinion o WHERE (o.fecha_opinion - NEW.fecha_opinion) > 2;
    RETURN NEW; 
    SELECT old;
END
$$LANGUAGE 'plpgsql';
CREATE OR REPLACE TRIGGER elimTrig AFTER INSERT ON opinion
    FOR EACH ROW EXECUTE PROCEDURE delOpinionVieja();


INSERT INTO opinion (id_opinion, titulo, texto_opinion, fecha_opinion)
VALUES (40002, 'opinion2', 'No olvide liberar cada objeto resultado con PQclear cuando lo haya hecho.', '2011-07-16');

