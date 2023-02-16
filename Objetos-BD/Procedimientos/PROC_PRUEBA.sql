PROCEDURE              "PROC_PRUEBA" IS
   cDummy VARCHAR2(1);
BEGIN
    select 'X' into cdummy
    from persona_natural_juridica
    where rownum = 1;
EXCEPTION
    WHEN no_data_found THEN null;
END; -- Procedure
