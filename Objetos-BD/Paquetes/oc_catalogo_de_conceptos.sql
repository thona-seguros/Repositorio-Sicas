--
-- OC_CATALOGO_DE_CONCEPTOS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   CATALOGO_DE_CONCEPTOS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CATALOGO_DE_CONCEPTOS IS

  FUNCTION DESCRIPCION_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN VARCHAR2;
  FUNCTION INDICADOR_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2, cTipoIndicador VARCHAR2) RETURN VARCHAR2;
  FUNCTION SIGNO_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN VARCHAR2;
  FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN NUMBER;
  PROCEDURE TIPO_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2, cIndTipoConcepto OUT VARCHAR2,
                          nPorcConcepto OUT NUMBER, nMontoConcepto OUT NUMBER);

END OC_CATALOGO_DE_CONCEPTOS;
/

--
-- OC_CATALOGO_DE_CONCEPTOS  (Package Body) 
--
--  Dependencies: 
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CATALOGO_DE_CONCEPTOS IS

FUNCTION DESCRIPCION_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
cDescripConcepto    CATALOGO_DE_CONCEPTOS.DescripConcepto%TYPE;
BEGIN
   BEGIN
      SELECT DescripConcepto
        INTO cDescripConcepto
        FROM CATALOGO_DE_CONCEPTOS
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescripConcepto := 'CONCEPTO NO EXISTE';
   END;
   RETURN(cDescripConcepto);
END DESCRIPCION_CONCEPTO;

FUNCTION INDICADOR_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2, cTipoIndicador VARCHAR2) RETURN VARCHAR2 IS
cIndCptoPrimas      CATALOGO_DE_CONCEPTOS.IndCptoPrimas%TYPE;
cIndCptoAjuste      CATALOGO_DE_CONCEPTOS.IndCptoAjuste%TYPE;
cIndRedondeo        CATALOGO_DE_CONCEPTOS.IndRedondeo%TYPE;
cIndContabRedondeo  CATALOGO_DE_CONCEPTOS.IndContabRedondeo%TYPE;
cIndCptoServicio    CATALOGO_DE_CONCEPTOS.IndCptoServicio%TYPE;
cIndCalcReserva     CATALOGO_DE_CONCEPTOS.IndCalcReserva%TYPE;
cIndCptoReaseg      CATALOGO_DE_CONCEPTOS.IndCptoReaseg%TYPE;
cIndRangosTipSeg    CATALOGO_DE_CONCEPTOS.IndRangosTipSeg%TYPE;
cIndAplicaComision  CATALOGO_DE_CONCEPTOS.IndAplicaComision%TYPE;
cIndCptoSini        CATALOGO_DE_CONCEPTOS.IndCptoSini%TYPE;
cIndEsImpuesto      CATALOGO_DE_CONCEPTOS.IndEsImpuesto%TYPE;
cIndCptoFondo       CATALOGO_DE_CONCEPTOS.IndCptoFondo%TYPE;
cIndCptoPrestamo    CATALOGO_DE_CONCEPTOS.IndCptoPrestamo%TYPE;

BEGIN
   BEGIN
      SELECT IndCptoPrimas, IndCptoAjuste, IndRedondeo,
             IndContabRedondeo, IndCptoServicio, IndCalcReserva,
             IndCptoReaseg, IndRangosTipSeg, IndAplicaComision,
             IndCptoSini, IndEsImpuesto, IndCptoFondo, IndCptoPrestamo
        INTO cIndCptoPrimas, cIndCptoAjuste, cIndRedondeo,
             cIndContabRedondeo, cIndCptoServicio, cIndCalcReserva,
             cIndCptoReaseg, cIndRangosTipSeg, cIndAplicaComision,
             cIndCptoSini, cIndEsImpuesto, cIndCptoFondo, cIndCptoPrestamo
        FROM CATALOGO_DE_CONCEPTOS
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCptoPrimas     := 'N';
         cIndCptoAjuste     := 'N';
         cIndRedondeo       := 'N';
         cIndContabRedondeo := 'N';
         cIndCptoServicio   := 'N';
         cIndCalcReserva    := 'N';
         cIndCptoReaseg     := 'N';
         cIndRangosTipSeg   := 'N';
         cIndAplicaComision := 'N';
         cIndCptoSini       := 'N';
         cIndEsImpuesto		  := 'N';
         cIndCptoFondo      := 'N';
         cIndCptoPrestamo   := 'N';
   END;
   IF cTipoIndicador = 'P' THEN
      RETURN(cIndCptoPrimas);
   ELSIF cTipoIndicador = 'S' THEN
      RETURN(cIndCptoServicio);
   ELSIF cTipoIndicador = 'A' THEN
      RETURN(cIndCptoAjuste);
   ELSIF cTipoIndicador = 'R' THEN
      RETURN(cIndRedondeo);
   ELSIF cTipoIndicador = 'C' THEN
      RETURN(cIndContabRedondeo);
   ELSIF cTipoIndicador = 'CR' THEN
      RETURN(cIndCalcReserva);
   ELSIF cTipoIndicador = 'REASEG' THEN
      RETURN(cIndCptoReaseg);
   ELSIF cTipoIndicador = 'RANGOS' THEN
      RETURN(cIndRangosTipSeg);
   ELSIF cTipoIndicador = 'COMIS' THEN
      RETURN(cIndAplicaComision);
   ELSIF cTipoIndicador = 'SINI' THEN
      RETURN(cIndCptoSini);
   ELSIF cTipoIndicador = 'IMPUESTO' THEN
      RETURN(cIndEsImpuesto);
   ELSIF cTipoIndicador = 'FONDO' THEN
      RETURN(cIndCptoFondo);
   ELSIF cTipoIndicador = 'PTMO' THEN
      RETURN(cIndCptoPrestamo);
   ELSE
      RAISE_APPLICATION_ERROR(-20220,'No Existe Concepto ' || cCodConcepto || ' al que le Solicita el Indicador '||cTipoIndicador);
   END IF;
END INDICADOR_CONCEPTO;

FUNCTION SIGNO_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN VARCHAR2 IS
cSigno_Concepto      CATALOGO_DE_CONCEPTOS.Signo_Concepto%TYPE;
BEGIN
   BEGIN
      SELECT NVL(Signo_Concepto,'+')
        INTO cSigno_Concepto
        FROM CATALOGO_DE_CONCEPTOS
       WHERE CodCia      = nCodCia
         AND CodConcepto = cCodConcepto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cSigno_Concepto := NULL;
   END;
   RETURN(cSigno_Concepto);
END SIGNO_CONCEPTO;

FUNCTION PORCENTAJE_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2) RETURN NUMBER IS
    nPorcConcepto CATALOGO_DE_CONCEPTOS.PorcConcepto%TYPE;
BEGIN
    BEGIN
        SELECT NVL(PorcConcepto,0)
          INTO nPorcConcepto
          FROM CATALOGO_DE_CONCEPTOS
         WHERE CodCia      = nCodCia
           AND CodConcepto = cCodConcepto;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcConcepto := 0;
    END;
    RETURN nPorcConcepto;
END PORCENTAJE_CONCEPTO; 

PROCEDURE TIPO_CONCEPTO(nCodCia NUMBER, cCodConcepto VARCHAR2, cIndTipoConcepto OUT VARCHAR2, nPorcConcepto OUT NUMBER, nMontoConcepto OUT NUMBER) IS
BEGIN
  SELECT IndTipoConcepto, NVL(PorcConcepto,0),NVL(MontoConcepto,0)
    INTO cIndTipoConcepto,nPorcConcepto, nMontoConcepto
    FROM CATALOGO_DE_CONCEPTOS
   WHERE CodCia      = nCodCia
     AND CodConcepto = cCodConcepto;
  EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20220,'No Existe Concepto ' || cCodConcepto);
END TIPO_CONCEPTO;

END OC_CATALOGO_DE_CONCEPTOS;
/

--
-- OC_CATALOGO_DE_CONCEPTOS  (Synonym) 
--
--  Dependencies: 
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CATALOGO_DE_CONCEPTOS FOR SICAS_OC.OC_CATALOGO_DE_CONCEPTOS
/


GRANT EXECUTE ON SICAS_OC.OC_CATALOGO_DE_CONCEPTOS TO PUBLIC
/
