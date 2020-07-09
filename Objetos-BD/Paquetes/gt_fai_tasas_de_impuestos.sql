--
-- GT_FAI_TASAS_DE_IMPUESTOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   FAI_TASAS_DE_IMPUESTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_FAI_TASAS_DE_IMPUESTOS AS

FUNCTION TASA_IMPUESTO (cTipoImpuesto VARCHAR2, dFecAplica DATE) RETURN NUMBER;

END GT_FAI_TASAS_DE_IMPUESTOS;
/

--
-- GT_FAI_TASAS_DE_IMPUESTOS  (Package Body) 
--
--  Dependencies: 
--   GT_FAI_TASAS_DE_IMPUESTOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_FAI_TASAS_DE_IMPUESTOS AS

FUNCTION TASA_IMPUESTO (cTipoImpuesto VARCHAR2, dFecAplica DATE) RETURN NUMBER IS
nTasaImpuesto       FAI_TASAS_DE_IMPUESTOS.TasaImpuesto%TYPE;
BEGIN
   BEGIN
      SELECT TasaImpuesto
        INTO nTasaImpuesto
        FROM FAI_TASAS_DE_IMPUESTOS
       WHERE TipoImpuesto = cTipoImpuesto
         AND (FecIniVig, FecFinVig) IN 
             (SELECT MAX(FecIniVig), MAX(FecFinVig)
                FROM FAI_TASAS_DE_IMPUESTOS
               WHERE TipoImpuesto  = cTipoImpuesto
                 AND FecIniVig    <= TRUNC(dFecAplica)
                 AND FecFinVig    >= TRUNC(dFecAplica));
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20100,'No existe ls Tasa de Impuesto '||cTipoImpuesto||
                                        ' para la Fecha: '||TO_DATE(dFecAplica,'DD/MM/YYYY'));
   END;
   RETURN(NVL(nTasaImpuesto,0));
END TASA_IMPUESTO;

END GT_FAI_TASAS_DE_IMPUESTOS;
/

--
-- GT_FAI_TASAS_DE_IMPUESTOS  (Synonym) 
--
--  Dependencies: 
--   GT_FAI_TASAS_DE_IMPUESTOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_FAI_TASAS_DE_IMPUESTOS FOR SICAS_OC.GT_FAI_TASAS_DE_IMPUESTOS
/


GRANT EXECUTE, DEBUG ON SICAS_OC.GT_FAI_TASAS_DE_IMPUESTOS TO PUBLIC
/
