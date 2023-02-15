CREATE OR REPLACE PACKAGE          OC_FACT_ELECT_SERIES_FOLIOS IS
   FUNCTION SERIE(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2) RETURN VARCHAR2;
   FUNCTION FOLIO(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN NUMBER;
   FUNCTION ULTIMO_FOLIO (nCodCia IN NUMBER, cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2) RETURN NUMBER;
   PROCEDURE ACTUALIZA_FOLIO (nCodCia IN NUMBER, nFolio IN NUMBER, cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2);
   FUNCTION FECHA_INICIO_VIGENCIA (nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN DATE;
   FUNCTION FECHA_FIN_VIGENCIA (nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN DATE;
   FUNCTION EMPALMA_VIGENCIAS(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2, dFecIniVig IN DATE, dFecFinVig IN DATE) RETURN VARCHAR2; 
END OC_FACT_ELECT_SERIES_FOLIOS;
/

CREATE OR REPLACE PACKAGE BODY          OC_FACT_ELECT_SERIES_FOLIOS IS
FUNCTION SERIE(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2) RETURN VARCHAR2 IS
cSerie         FACT_ELECT_SERIES_FOLIOS.SERIE%TYPE;
BEGIN
   BEGIN
      SELECT Serie
        INTO cSerie
        FROM FACT_ELECT_SERIES_FOLIOS
       WHERE CodCia               = nCodCia
         AND TipoCfdi             = cTipoCfdi
         AND TipoDocumento        = cTipoDocumento
         AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar La Serie Para Facturar Electrónicamente Este Documento, Por Favor Valide Su Configuración');
   END;
   RETURN cSerie;
END SERIE;
    --
FUNCTION FOLIO(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN NUMBER IS
PRAGMA AUTONOMOUS_TRANSACTION;
nFolio  FACT_ELECT_SERIES_FOLIOS.FOLIO%TYPE;
BEGIN
  BEGIN
      SELECT NVL(MAX(Folio),0) + 1
        INTO nFolio
        FROM FACT_ELECT_SERIES_FOLIOS
       WHERE CodCia               = nCodCia
         AND TipoCfdi             = cTipoCfdi
         AND TipoDocumento        = cTipoDocumento
         AND Serie                = cSerie
         AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar El Folio Para La Serie: '||cSerie||' Por Favor Valide Su Configuración');
  END;
  UPDATE FACT_ELECT_SERIES_FOLIOS
     SET Folio = nFolio
   WHERE CodCia               = nCodCia
     AND TipoCfdi             = cTipoCfdi
     AND TipoDocumento        = cTipoDocumento
     AND Serie                = cSerie
     AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
  COMMIT;
  RETURN nFolio;
END FOLIO;
    
FUNCTION ULTIMO_FOLIO(nCodCia IN NUMBER, cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2) RETURN NUMBER IS
nFolio  FACT_ELECT_SERIES_FOLIOS.FOLIO%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(Folio),0)
        INTO nFolio
        FROM FACT_ELECT_SERIES_FOLIOS
       WHERE CodCia               = nCodCia
         AND TipoCfdi             = cTipoCfdi
         AND TipoDocumento        = cTipoDocumento
         AND Serie                = cSerie
         AND TRUNC(SYSDATE) BETWEEN FecIniVig AND FecFinVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'Error: No Es Posible Determinar El Folio Por Favor Valide Su Configuración');
   END;
   RETURN nFolio;
END ULTIMO_FOLIO;
    
PROCEDURE ACTUALIZA_FOLIO (nCodCia IN NUMBER, nFolio IN NUMBER, cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2) IS
BEGIN
   UPDATE FACT_ELECT_SERIES_FOLIOS
      SET Folio = nFolio
    WHERE CodCia           = nCodCia
      AND TipoCfdi         = cTipoCfdi
         AND TipoDocumento = cTipoDocumento
         AND Serie         = cSerie;
END ACTUALIZA_FOLIO;
    
FUNCTION FECHA_INICIO_VIGENCIA (nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN DATE IS
dFecIniVig FACT_ELECT_SERIES_FOLIOS.FecIniVig%TYPE;
BEGIN
   BEGIN
      SELECT FecIniVig
        INTO dFecIniVig
        FROM FACT_ELECT_SERIES_FOLIOS
       WHERE CodCia        = nCodCia
         AND TipoCfdi      = cTipoCfdi
         AND TipoDocumento = cTipoDocumento
         AND Serie         = cSerie;
   END;
   RETURN dFecIniVig;
END FECHA_INICIO_VIGENCIA;
    
FUNCTION FECHA_FIN_VIGENCIA (nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2,cSerie IN VARCHAR2) RETURN DATE IS
dFecFinVig FACT_ELECT_SERIES_FOLIOS.FecFinVig%TYPE;
BEGIN
   BEGIN
      SELECT FecFinVig
        INTO dFecFinVig
        FROM FACT_ELECT_SERIES_FOLIOS
       WHERE CodCia        = nCodCia
         AND TipoCfdi      = cTipoCfdi
         AND TipoDocumento = cTipoDocumento
         AND Serie         = cSerie;
   END;
   RETURN dFecFinVig;
END FECHA_FIN_VIGENCIA;

FUNCTION EMPALMA_VIGENCIAS(nCodCia IN NUMBER,cTipoCfdi IN VARCHAR2,cTipoDocumento IN VARCHAR2, cSerie IN VARCHAR2, dFecIniVig IN DATE, dFecFinVig IN DATE) RETURN VARCHAR2 IS
cExiste VARCHAR2(1);
BEGIN
   IF cSerie IS NULL THEN 
      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM FACT_ELECT_SERIES_FOLIOS
          WHERE CodCia            = nCodCia
            AND TipoCfdi          = cTipoCfdi
            AND TipoDocumento     = cTipoDocumento
            AND (dFecIniVig BETWEEN FecIniVig AND FecFinVig 
             OR  dFecFinVig BETWEEN FecIniVig AND FecFinVig);
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN 
            cExiste := 'S';
      END;
   ELSE
      BEGIN
         SELECT 'S'
           INTO cExiste
           FROM FACT_ELECT_SERIES_FOLIOS
          WHERE CodCia            = nCodCia
            AND TipoCfdi          = cTipoCfdi
            AND TipoDocumento     = cTipoDocumento
            AND Serie            != cSerie
            AND (dFecIniVig BETWEEN FecIniVig AND FecFinVig 
             OR  dFecFinVig BETWEEN FecIniVig AND FecFinVig);
      EXCEPTION 
         WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
         WHEN TOO_MANY_ROWS THEN 
            cExiste := 'S';
      END;
   END IF;
   RETURN cExiste;
END EMPALMA_VIGENCIAS;

END OC_FACT_ELECT_SERIES_FOLIOS;
