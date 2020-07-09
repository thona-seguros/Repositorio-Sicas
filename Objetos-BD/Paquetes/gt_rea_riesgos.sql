--
-- GT_REA_RIESGOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_RIESGOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_RIESGOS IS

  PROCEDURE ACTIVAR_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2);
  PROCEDURE SUSPENDER_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2);
  FUNCTION DESCRIPCION_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODCUMULO_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2;
  FUNCTION INDICADORES(nCodCia NUMBER, cCodRiesgo VARCHAR2, cTipoIndicador VARCHAR2) RETURN VARCHAR2;
  FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2;
END GT_REA_RIESGOS;
/

--
-- GT_REA_RIESGOS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_RIESGOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_RIESGOS IS

PROCEDURE ACTIVAR_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) IS
BEGIN
   UPDATE REA_RIESGOS
      SET StsRiesgo  = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodRiesgo  = cCodRiesgo;
END ACTIVAR_RIESGO;

PROCEDURE SUSPENDER_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) IS
BEGIN
   UPDATE REA_RIESGOS
      SET StsRiesgo  = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodRiesgo  = cCodRiesgo;
END SUSPENDER_RIESGO;

FUNCTION DESCRIPCION_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2 IS
cDescRiesgo       REA_RIESGOS.DescRiesgo%TYPE;
BEGIN
   BEGIN
      SELECT DescRiesgo
        INTO cDescRiesgo
        FROM REA_RIESGOS
       WHERE CodCia     = nCodCia
         AND CodRiesgo  = cCodRiesgo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescRiesgo := 'Riesgo - NO EXISTE';
   END;
   RETURN(cDescRiesgo);
END DESCRIPCION_RIESGO;

FUNCTION CODCUMULO_RIESGO(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2 IS
cCodCumuloRiesgo       REA_RIESGOS.CodCumuloRiesgo%TYPE;
BEGIN
   BEGIN
      SELECT CodCumuloRiesgo
        INTO cCodCumuloRiesgo
        FROM REA_RIESGOS
       WHERE CodCia     = nCodCia
         AND CodRiesgo  = cCodRiesgo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodCumuloRiesgo := NULL;
   END;
   RETURN(cCodCumuloRiesgo);
END CODCUMULO_RIESGO;

FUNCTION INDICADORES(nCodCia NUMBER, cCodRiesgo VARCHAR2, cTipoIndicador VARCHAR2) RETURN VARCHAR2 IS
cIndTraspasos         REA_RIESGOS.IndTraspasos%TYPE;
cIndCumulos           REA_RIESGOS.IndCumulos%TYPE;
cIndDetMovimientos    REA_RIESGOS.IndDetMovimientos%TYPE;
cIndPolizaEspec       REA_RIESGOS.IndPolizaEspec%TYPE;
cIndEnvioEMail        REA_RIESGOS.IndEnvioEMail%TYPE;
cIndAplicaCotizacion  REA_RIESGOS.IndAplicaCotizacion%TYPE;
BEGIN
   BEGIN
      SELECT IndTraspasos, IndCumulos, IndDetMovimientos, 
             IndPolizaEspec, IndEnvioEMail, IndAplicaCotizacion
        INTO cIndTraspasos, cIndCumulos, cIndDetMovimientos, 
             cIndPolizaEspec, cIndEnvioEMail, cIndAplicaCotizacion
        FROM REA_RIESGOS
       WHERE CodCia     = nCodCia
         AND CodRiesgo  = cCodRiesgo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndTraspasos        := 'N';
         cIndCumulos          := 'N';
         cIndDetMovimientos   := 'N';
         cIndPolizaEspec      := 'N';
         cIndEnvioEMail       := 'N';
         cIndAplicaCotizacion := 'N';
   END;
   IF cTipoIndicador = 'TRASPA' THEN
      RETURN(cIndTraspasos);
   ELSIF cTipoIndicador = 'CUMULO' THEN
      RETURN(cIndCumulos);
   ELSIF cTipoIndicador = 'DETMOV' THEN
      RETURN(cIndDetMovimientos);
   ELSIF cTipoIndicador = 'POLESP' THEN
      RETURN(cIndPolizaEspec);
   ELSIF cTipoIndicador = 'EEMAIL' THEN
      RETURN(cIndEnvioEMail);
   ELSIF cTipoIndicador = 'APLCOT' THEN
      RETURN(cIndAplicaCotizacion);
   ELSE
      RAISE_APPLICATION_ERROR(-20220,'Indicador de Riesgos de Reasegur NO Definido ');
   END IF;
END INDICADORES;

FUNCTION CODIGO_OFICIAL(nCodCia NUMBER, cCodRiesgo VARCHAR2) RETURN VARCHAR2 IS
cCodOficial       REA_RIESGOS.CodOficial%TYPE;
BEGIN
   BEGIN
      SELECT CodOficial
        INTO cCodOficial
        FROM REA_RIESGOS
       WHERE CodCia     = nCodCia
         AND CodRiesgo  = cCodRiesgo;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodOficial := NULL;
   END;
   RETURN(cCodOficial);
END CODIGO_OFICIAL;

END GT_REA_RIESGOS;
/

--
-- GT_REA_RIESGOS  (Synonym) 
--
--  Dependencies: 
--   GT_REA_RIESGOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_RIESGOS FOR SICAS_OC.GT_REA_RIESGOS
/


GRANT EXECUTE ON SICAS_OC.GT_REA_RIESGOS TO PUBLIC
/
