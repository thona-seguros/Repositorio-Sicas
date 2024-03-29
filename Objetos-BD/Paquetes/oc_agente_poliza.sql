--
-- OC_AGENTE_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   AGENTE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_AGENTE_POLIZA IS

  PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER);
  FUNCTION AGENTE_PRINCIPAL(nCodCia NUMBER, nIdPoliza NUMBER) RETURN NUMBER;

END OC_AGENTE_POLIZA;
/

--
-- OC_AGENTE_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_AGENTE_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_AGENTE_POLIZA IS
PROCEDURE BORRAR_REGISTRO(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   DELETE AGENTE_POLIZA
    WHERE CodCia   = nCodCia 
      AND IdPoliza = nIdPoliza;
END BORRAR_REGISTRO;

FUNCTION AGENTE_PRINCIPAL(nCodCia NUMBER, nIdPoliza NUMBER) RETURN NUMBER IS
nCod_Agente     AGENTE_POLIZA.Cod_Agente%TYPE;
BEGIN
   BEGIN
      SELECT Cod_Agente
        INTO nCod_Agente
        FROM AGENTE_POLIZA
       WHERE CodCia        = nCodCia 
         AND IdPoliza      = nIdPoliza
         AND Ind_Principal = 'S';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Agente Principal para la P�liza No. ' ||nIdPoliza);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Agentes Principales para la P�liza No. ' ||nIdPoliza);
   END;
   RETURN(nCod_Agente);
END AGENTE_PRINCIPAL;

END OC_AGENTE_POLIZA;
/
