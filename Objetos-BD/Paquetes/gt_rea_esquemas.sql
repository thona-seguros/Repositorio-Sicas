--
-- GT_REA_ESQUEMAS  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   REA_ESQUEMAS (Table)
--   GT_REA_ESQUEMAS_CALENDARIO (Package)
--   GT_REA_ESQUEMAS_CAPAS (Package)
--   GT_REA_ESQUEMAS_CONTRATOS (Package)
--   GT_REA_ESQUEMAS_DATOS_CREDITO (Package)
--   GT_REA_ESQUEMAS_EMPRESAS (Package)
--   GT_REA_ESQUEMAS_FACT_CREDITOS (Package)
--   GT_REA_ESQUEMAS_POLIZAS (Package)
--   GT_REA_ESQUEMAS_XL (Package)
--   GT_REA_ESQUEMAS_XL_REINSTAL (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS IS
  PROCEDURE ACTIVAR_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE SUSPENDER_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE CONFIGURAR_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2);
  FUNCTION NOMBRE_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION ESQUEMA_VIGENTE(nCodCia NUMBER, cCodEsquema VARCHAR2, dFechaVig DATE) RETURN VARCHAR2;
  FUNCTION TIPO_DISTRIBUCION(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION APLICA_DISTRIBUCION(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION PORCENTAJE_RECALCULO(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  FUNCTION DIAS_RECALCULO(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2;
  PROCEDURE COPIAR_ESQUEMA(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, 
                           cCodEsquemaDest VARCHAR2, cDescEsquemaDest VARCHAR2);
END GT_REA_ESQUEMAS;
/

--
-- GT_REA_ESQUEMAS  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS IS

PROCEDURE ACTIVAR_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS
      SET StsEsquema = 'ACTIVO',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquema;

   GT_REA_ESQUEMAS_CONTRATOS.ACTIVAR_CONTRATOS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_CAPAS.ACTIVAR_CAPAS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_EMPRESAS.ACTIVAR_EMPRESAS(nCodCia, cCodEsquema);
END ACTIVAR_ESQUEMA;

PROCEDURE SUSPENDER_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS
      SET StsEsquema = 'SUSPEN',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquema;

   GT_REA_ESQUEMAS_CONTRATOS.SUSPENDER_CONTRATOS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_CAPAS.SUSPENDER_CAPAS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_EMPRESAS.SUSPENDER_EMPRESAS(nCodCia, cCodEsquema);
END SUSPENDER_ESQUEMA;

PROCEDURE CONFIGURAR_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS
      SET StsEsquema = 'CONFIG',
          FecStatus  = TRUNC(SYSDATE)
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquema;

   GT_REA_ESQUEMAS_CONTRATOS.CONFIGURAR_CONTRATOS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_CAPAS.CONFIGURAR_CAPAS(nCodCia, cCodEsquema);
   GT_REA_ESQUEMAS_EMPRESAS.CONFIGURAR_EMPRESAS(nCodCia, cCodEsquema);

END CONFIGURAR_ESQUEMA;

FUNCTION NOMBRE_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cDescEsquema       REA_ESQUEMAS.DescEsquema%TYPE;
BEGIN
   BEGIN
      SELECT DescEsquema
        INTO cDescEsquema
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescEsquema := 'Esquema de Reaseguro/Coaseguro ' || cCodEsquema || ' - NO EXISTE!!!';
   END;
   RETURN(cDescEsquema);
END NOMBRE_ESQUEMA;

FUNCTION TIPO_ESQUEMA(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cTipoEsquema      REA_ESQUEMAS.TipoEsquema%TYPE;
BEGIN
   BEGIN
      SELECT TipoEsquema
        INTO cTipoEsquema
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cTipoEsquema := 'N';
   END;
   RETURN(cTipoEsquema);
END TIPO_ESQUEMA;

FUNCTION ESQUEMA_VIGENTE(nCodCia NUMBER, cCodEsquema VARCHAR2, dFechaVig DATE) RETURN VARCHAR2 IS
cVigente      VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cVigente
        FROM REA_ESQUEMAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND FecIniEsquema   >= dFechaVig
         AND FecFinEsquema   <= dFechaVig;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cVigente := 'N';
   END;
   RETURN(cVigente);
END ESQUEMA_VIGENTE;

FUNCTION TIPO_DISTRIBUCION(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cIndTipoDistrib      REA_ESQUEMAS.IndTipoDistrib%TYPE;
BEGIN
   BEGIN
      SELECT IndTipoDistrib
        INTO cIndTipoDistrib
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndTipoDistrib := 'NO EXISTE';
   END;
   RETURN(cIndTipoDistrib);
END TIPO_DISTRIBUCION;

FUNCTION APLICA_DISTRIBUCION(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
cIndMovAplicacion      REA_ESQUEMAS.IndMovAplicacion%TYPE;
BEGIN
   BEGIN
      SELECT IndMovAplicacion
        INTO cIndMovAplicacion
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndMovAplicacion := 'TODOS';
   END;
   RETURN(cIndMovAplicacion);
END APLICA_DISTRIBUCION;

FUNCTION PORCENTAJE_RECALCULO(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
nPorcenRecalculo      REA_ESQUEMAS.PorcenRecalculo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcenRecalculo,0)
        INTO nPorcenRecalculo
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenRecalculo := 0;
   END;
   RETURN(nPorcenRecalculo);
END PORCENTAJE_RECALCULO;

FUNCTION DIAS_RECALCULO(nCodCia NUMBER, cCodEsquema VARCHAR2) RETURN VARCHAR2 IS
nDiasRecalculo      REA_ESQUEMAS.DiasRecalculo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(DiasRecalculo,0)
        INTO nDiasRecalculo
        FROM REA_ESQUEMAS
       WHERE CodCia     = nCodCia
         AND CodEsquema = cCodEsquema;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasRecalculo := 0;
   END;
   RETURN(NDiasRecalculo);
END DIAS_RECALCULO;

PROCEDURE COPIAR_ESQUEMA(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, 
                         cCodEsquemaDest VARCHAR2, cDescEsquemaDest VARCHAR2) IS
CURSOR ESQ_Q IS
   SELECT TipoEsquema, FecIniEsquema, FecFinEsquema, StsEsquema, FecStatus, 
          IndPolizas, IndTipoDistrib, PrimaTotalGrupo, PrimaRetenidaGrupo, 
          PrimaCedidaGrupo, IndMovAplicacion, PorcenRecalculo, DiasRecalculo
     FROM REA_ESQUEMAS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN ESQ_Q LOOP
      INSERT INTO REA_ESQUEMAS
             (CodCia, CodEsquema, DescEsquema, TipoEsquema, FecIniEsquema, FecFinEsquema,
              StsEsquema, FecStatus, IndPolizas, IndTipoDistrib, PrimaTotalGrupo,
              PrimaRetenidaGrupo, PrimaCedidaGrupo, IndMovAplicacion, PorcenRecalculo,
              DiasRecalculo)
      VALUES (nCodCia, cCodEsquemaDest, cDescEsquemaDest, W.TipoEsquema, W.FecIniEsquema, W.FecFinEsquema,
              'ACTIVO', TRUNC(SYSDATE), W.IndPolizas, W.IndTipoDistrib, W.PrimaTotalGrupo,
              W.PrimaRetenidaGrupo, W.PrimaCedidaGrupo, W.IndMovAplicacion, W.PorcenRecalculo,
              W.DiasRecalculo);
   END LOOP;
   GT_REA_ESQUEMAS_CONTRATOS.COPIAR_CONTRATOS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_CAPAS.COPIAR_CAPAS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_EMPRESAS.COPIAR_EMPRESAS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_CALENDARIO.COPIAR_CALENDARIO(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_XL.COPIAR_ESQUEMA_XL(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_XL_REINSTAL.COPIAR_REINSTALAMENTOS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_POLIZAS.COPIAR_POLIZAS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_FACT_CREDITOS.COPIAR_FACTORES_CREDITOS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
   GT_REA_ESQUEMAS_DATOS_CREDITO.COPIAR_DATOS_CREDITOS(nCodCia, cCodEsquemaOrig, cCodEsquemaDest);
END COPIAR_ESQUEMA;

END GT_REA_ESQUEMAS;
/

--
-- GT_REA_ESQUEMAS  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS FOR SICAS_OC.GT_REA_ESQUEMAS
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS TO PUBLIC
/
