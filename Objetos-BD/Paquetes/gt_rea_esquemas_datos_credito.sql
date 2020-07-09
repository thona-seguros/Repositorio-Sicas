--
-- GT_REA_ESQUEMAS_DATOS_CREDITO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CONFIG_PLANTILLAS_CAMPOS (Table)
--   REA_ESQUEMAS_DATOS_CREDITO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_DATOS_CREDITO IS

  FUNCTION EXISTEN_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION SALDO_INSOLUTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                          nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;
  FUNCTION FECHA_INICIO_CREDITO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                                nIdPoliza NUMBER, nIDetPol NUMBER) RETURN DATE;
  FUNCTION PLAZO_DEL_CREDITO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                             nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;
  FUNCTION MESES_DE_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                          nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER;
  PROCEDURE ELIMINAR_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE COPIAR_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

END GT_REA_ESQUEMAS_DATOS_CREDITO;
/

--
-- GT_REA_ESQUEMAS_DATOS_CREDITO  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_DATOS_CREDITO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_DATOS_CREDITO IS

FUNCTION EXISTEN_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cExistenDatosCred      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExistenDatosCred
        FROM REA_ESQUEMAS_DATOS_CREDITO
       WHERE CodCia      = nCodCia
         AND CodEsquema  = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExistenDatosCred := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existe Varias Plantillas de Datos para Créditos en Esquema ' || cCodEsquema);
   END;
   RETURN(cExistenDatosCred);
END EXISTEN_DATOS_CREDITOS;

FUNCTION SALDO_INSOLUTO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                        nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
cCodPlantilla            REA_ESQUEMAS_DATOS_CREDITO.CodPlantilla%TYPE;
cSaldoInsoluto           REA_ESQUEMAS_DATOS_CREDITO.SaldoInsoluto%TYPE;
cOrdenDatoPart           VARCHAR2(50);
cValorCampo              VARCHAR2(500);
cQuery                   VARCHAR2(4000);
nSaldoInsoluto           NUMBER(28,2);
BEGIN
   BEGIN
      SELECT CodPlantilla, SaldoInsoluto
        INTO cCodPlantilla, cSaldoInsoluto
        FROM REA_ESQUEMAS_DATOS_CREDITO
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Datos para Créditos (Saldo Insoluto) en Esquema' || cCodEsquema);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existe Varias Plantillas de Datos para Créditos en Esquema ' || cCodEsquema);
   END;
   
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart))
        INTO cOrdenDatoPart
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodPlantilla = cCodPlantilla
         AND CodEmpresa   = nCodEmpresa
         AND NomCampo     = cSaldoInsoluto
         AND CodCia       = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Campo ' || cSaldoInsoluto || ' en Plantilla ' || cCodPlantilla);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existen Varios Campos ' || cSaldoInsoluto || ' en Plantilla ' || cCodPlantilla);
   END;
   cQuery := 'SELECT ' || cOrdenDatoPart ||
             '  FROM DATOS_PART_EMISION ' ||
             ' WHERE CodCia   = ' || nCodCia ||
             '   AND IdPoliza = ' || nIdPoliza ||
             '   AND IDetPol  = ' || nIDetPol;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(TO_NUMBER(cValorCampo));
END SALDO_INSOLUTO;

FUNCTION FECHA_INICIO_CREDITO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                             nIdPoliza NUMBER, nIDetPol NUMBER) RETURN DATE IS
cCodPlantilla            REA_ESQUEMAS_DATOS_CREDITO.CodPlantilla%TYPE;
cFechaInicioCredito      REA_ESQUEMAS_DATOS_CREDITO.FechaInicioCredito%TYPE;
cOrdenDatoPart           VARCHAR2(50);
cValorCampo              VARCHAR2(500);
cQuery                   VARCHAR2(4000);
BEGIN
   BEGIN
      SELECT CodPlantilla, FechaInicioCredito
        INTO cCodPlantilla, cFechaInicioCredito
        FROM REA_ESQUEMAS_DATOS_CREDITO
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Datos para Créditos (Fecha Inicio Crédito) en Esquema' || cCodEsquema);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existe Varias Plantillas de Datos para Créditos en Esquema ' || cCodEsquema);
   END;
   
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart))
        INTO cOrdenDatoPart
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodPlantilla = cCodPlantilla
         AND CodEmpresa   = nCodEmpresa
         AND NomCampo     = cFechaInicioCredito
         AND CodCia       = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Campo ' || cFechaInicioCredito || ' en Plantilla ' || cCodPlantilla);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existen Varios Campos ' || cFechaInicioCredito || ' en Plantilla ' || cCodPlantilla);
   END;
   cQuery := 'SELECT ' || cOrdenDatoPart ||
             '  FROM DATOS_PART_EMISION ' ||
             ' WHERE CodCia   = ' || nCodCia ||
             '   AND IdPoliza = ' || nIdPoliza ||
             '   AND IDetPol  = ' || nIDetPol;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(TO_DATE(cValorCampo,'YYYYMMDD'));
END FECHA_INICIO_CREDITO;

FUNCTION PLAZO_DEL_CREDITO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                           nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
cCodPlantilla            REA_ESQUEMAS_DATOS_CREDITO.CodPlantilla%TYPE;
cPlazoCredito            REA_ESQUEMAS_DATOS_CREDITO.PlazoCredito%TYPE;
cOrdenDatoPart           VARCHAR2(50);
cValorCampo              VARCHAR2(500);
cQuery                   VARCHAR2(4000);
BEGIN
   BEGIN
      SELECT CodPlantilla, PlazoCredito
        INTO cCodPlantilla, cPlazoCredito
        FROM REA_ESQUEMAS_DATOS_CREDITO
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Datos para Créditos (Plazo de Crédito) en Esquema' || cCodEsquema);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existe Varias Plantillas de Datos para Créditos en Esquema ' || cCodEsquema);
   END;
   
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart))
        INTO cOrdenDatoPart
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodPlantilla = cCodPlantilla
         AND CodEmpresa   = nCodEmpresa
         AND NomCampo     = cPlazoCredito
         AND CodCia       = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Campo ' || cPlazoCredito || ' en Plantilla ' || cCodPlantilla);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existen Varios Campos ' || cPlazoCredito || ' en Plantilla ' || cCodPlantilla);
   END;
   cQuery := 'SELECT ' || cOrdenDatoPart ||
             '  FROM DATOS_PART_EMISION ' ||
             ' WHERE CodCia   = ' || nCodCia ||
             '   AND IdPoliza = ' || nIdPoliza ||
             '   AND IDetPol  = ' || nIDetPol;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(TO_NUMBER(cValorCampo));
END PLAZO_DEL_CREDITO;

FUNCTION MESES_DE_PRIMA(nCodCia NUMBER, nCodEmpresa NUMBER, cCodEsquema VARCHAR2, 
                        nIdPoliza NUMBER, nIDetPol NUMBER) RETURN NUMBER IS
cCodPlantilla            REA_ESQUEMAS_DATOS_CREDITO.CodPlantilla%TYPE;
cMesesPrima              REA_ESQUEMAS_DATOS_CREDITO.MesesPrima%TYPE;
cOrdenDatoPart           VARCHAR2(50);
cValorCampo              VARCHAR2(500);
cQuery                   VARCHAR2(4000);
nSaldoInsoluto           NUMBER(28,2);
BEGIN
   BEGIN
      SELECT CodPlantilla, MesesPrima
        INTO cCodPlantilla, cMesesPrima
        FROM REA_ESQUEMAS_DATOS_CREDITO
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Datos para Créditos (Meses de Prima) en Esquema' || cCodEsquema);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existe Varias Plantillas de Datos para Créditos en Esquema ' || cCodEsquema);
   END;
   
   BEGIN
      SELECT 'CAMPO' || TRIM(TO_CHAR(OrdenDatoPart))
        INTO cOrdenDatoPart
        FROM CONFIG_PLANTILLAS_CAMPOS
       WHERE CodPlantilla = cCodPlantilla
         AND CodEmpresa   = nCodEmpresa
         AND NomCampo     = cMesesPrima
         AND CodCia       = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20000,'NO Existe Campo ' || cMesesPrima || ' en Plantilla ' || cCodPlantilla);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existen Varios Campos ' || cMesesPrima || ' en Plantilla ' || cCodPlantilla);
   END;
   cQuery := 'SELECT ' || cOrdenDatoPart ||
             '  FROM DATOS_PART_EMISION ' ||
             ' WHERE CodCia   = ' || nCodCia ||
             '   AND IdPoliza = ' || nIdPoliza ||
             '   AND IDetPol  = ' || nIDetPol;
   EXECUTE IMMEDIATE cQuery INTO cValorCampo;

   RETURN(TO_NUMBER(cValorCampo));
END MESES_DE_PRIMA;

PROCEDURE ELIMINAR_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
    DELETE REA_ESQUEMAS_DATOS_CREDITO
     WHERE CodCia      = nCodCia
       AND CodEsquema  = cCodEsquema;
END ELIMINAR_DATOS_CREDITOS;

PROCEDURE COPIAR_DATOS_CREDITOS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR FACT_Q IS
   SELECT CodPlantilla, SaldoInsoluto, FechaInicioCredito,
          PlazoCredito, MesesPrima, CodUsuario
     FROM REA_ESQUEMAS_DATOS_CREDITO
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN FACT_Q LOOP
      INSERT INTO REA_ESQUEMAS_DATOS_CREDITO
             (CodCia, CodEsquema, CodPlantilla, SaldoInsoluto,
              FechaInicioCredito, PlazoCredito, MesesPrima, CodUsuario)
      VALUES (nCodCia, cCodEsquemaDest, W.CodPlantilla, W.SaldoInsoluto,
              W.FechaInicioCredito, W.PlazoCredito, W.MesesPrima, USER);
   END LOOP;
END COPIAR_DATOS_CREDITOS;

END GT_REA_ESQUEMAS_DATOS_CREDITO;
/

--
-- GT_REA_ESQUEMAS_DATOS_CREDITO  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_DATOS_CREDITO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS_DATOS_CREDITO FOR SICAS_OC.GT_REA_ESQUEMAS_DATOS_CREDITO
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS_DATOS_CREDITO TO PUBLIC
/
