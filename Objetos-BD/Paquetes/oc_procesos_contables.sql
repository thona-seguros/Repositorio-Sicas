--
-- OC_PROCESOS_CONTABLES  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   PROCESOS_CONTABLES (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_PROCESOS_CONTABLES IS

  FUNCTION NOMBRE_PROCESO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPO_COMPROBANTE(nCodCia NUMBER, cCodProceso VARCHAR2, cTipoComp VARCHAR2) RETURN VARCHAR2;

  FUNCTION TIPO_DIARIO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;

END OC_PROCESOS_CONTABLES;
/

--
-- OC_PROCESOS_CONTABLES  (Package Body) 
--
--  Dependencies: 
--   OC_PROCESOS_CONTABLES (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_PROCESOS_CONTABLES IS

FUNCTION NOMBRE_PROCESO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cNomProceso   PROCESOS_CONTABLES.NomProceso%TYPE;
BEGIN
   BEGIN
      SELECT NomProceso
        INTO cNomProceso
        FROM PROCESOS_CONTABLES
       WHERE Codcia     = nCodCia
                   AND CodProceso = cCodProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cNomProceso := 'NO EXISTE';
   END;
   RETURN(cNomProceso);
END NOMBRE_PROCESO;

FUNCTION TIPO_COMPROBANTE(nCodCia NUMBER, cCodProceso VARCHAR2, cTipoComp VARCHAR2) RETURN VARCHAR2 IS
cTipoComprob    PROCESOS_CONTABLES.TipoComprob%TYPE;
cTipoCompRev    PROCESOS_CONTABLES.TipoCompRev%TYPE;
BEGIN
   BEGIN
      SELECT TipoComprob, TipoCompRev
        INTO cTipoComprob, cTipoCompRev
        FROM PROCESOS_CONTABLES
       WHERE Codcia     = nCodCia
                   AND CodProceso = cCodProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoComprob := NULL;
                        cTipoCompRev := NULL;
   END;
   IF cTipoComp = 'C' THEN
      RETURN(cTipoComprob);
   ELSE
      RETURN(cTipoCompRev);
   END IF;
END TIPO_COMPROBANTE;

FUNCTION TIPO_DIARIO(nCodCia NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cTipoDiario   PROCESOS_CONTABLES.TipoDiario%TYPE;
BEGIN
   BEGIN
      SELECT TipoDiario
        INTO cTipoDiario
        FROM PROCESOS_CONTABLES
       WHERE Codcia     = nCodCia
         AND CodProceso = cCodProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoDiario := 'SYSTM';
   END;
   RETURN(cTipoDiario);
END TIPO_DIARIO;

END OC_PROCESOS_CONTABLES;
/
