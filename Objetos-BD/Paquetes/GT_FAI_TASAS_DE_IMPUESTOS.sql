CREATE OR REPLACE PACKAGE GT_FAI_TASAS_DE_IMPUESTOS AS

FUNCTION TASA_IMPUESTO (cTipoImpuesto VARCHAR2, dFecAplica DATE) RETURN NUMBER;

END GT_FAI_TASAS_DE_IMPUESTOS;
/

CREATE OR REPLACE PACKAGE BODY        GT_FAI_TASAS_DE_IMPUESTOS AS

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
