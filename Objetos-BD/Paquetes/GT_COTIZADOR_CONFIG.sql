CREATE OR REPLACE PACKAGE          GT_COTIZADOR_CONFIG IS

  FUNCTION DESCRIPCION_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  PROCEDURE CONFIGURAR_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2);
  PROCEDURE ACTIVAR_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2);
  PROCEDURE SUSPENDER_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2);
  FUNCTION VIGENCIA_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, dFecOperacion DATE) RETURN VARCHAR2;
  FUNCTION DIAS_VIGENCIA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER;
  FUNCTION PERMITE_RECOTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  FUNCTION CANTIDAD_RECOTIZACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER;
  FUNCTION APLICA_TARIFA_RIESGO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  FUNCTION SELECCIONA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  FUNCTION DIAS_REVERSION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER;
  FUNCTION CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  FUNCTION TIPO_DE_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;
  FUNCTION COTIZADOR_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2;

END GT_COTIZADOR_CONFIG;
/

CREATE OR REPLACE PACKAGE BODY          GT_COTIZADOR_CONFIG IS

FUNCTION DESCRIPCION_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cDescCotizador       COTIZADOR_CONFIG.DescCotizador%TYPE;
BEGIN
   BEGIN
      SELECT DescCotizador
        INTO cDescCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cDescCotizador := 'Cotizador NO Existe';
   END;
   RETURN(cDescCotizador);
END DESCRIPCION_COTIZADOR;

PROCEDURE CONFIGURAR_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) IS
CURSOR PROD_Q IS
   SELECT IdTipoSeg
     FROM COTIZADOR_TIPOSEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND CodCotizador   = cCodCotizador
      AND StsTipoSegCot  = 'ACTIVO';
CURSOR CLAU_Q IS
   SELECT CodClausula
     FROM COTIZADOR_CLAUSULAS
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND CodCotizador    = cCodCotizador
      AND StsClausulaCot  = 'ACTIVO';
BEGIN
   UPDATE COTIZADOR_CONFIG
      SET StsCotizador     = 'CONFIG',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND CodCotizador  = cCodCotizador;

   FOR X IN PROD_Q LOOP
      GT_COTIZADOR_TIPOSEG.CONFIGURAR(nCodCia, nCodEmpresa, cCodCotizador, X.IdTipoSeg);
   END LOOP;
   
   FOR X IN CLAU_Q LOOP
      GT_COTIZADOR_CLAUSULAS.CONFIGURAR(nCodCia, nCodEmpresa, cCodCotizador, X.CodClausula);
   END LOOP;
END CONFIGURAR_COTIZADOR;

PROCEDURE ACTIVAR_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) IS
cStsTipoSegCot  COTIZADOR_TIPOSEG.StsTipoSegCot%TYPE;
cStsCotizador   COTIZADOR_CONFIG.StsCotizador%TYPE;

CURSOR PROD_Q IS
   SELECT IdTipoSeg
     FROM COTIZADOR_TIPOSEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND CodCotizador   = cCodCotizador
      AND StsTipoSegCot  = cStsTipoSegCot;

CURSOR CLAU_Q IS
   SELECT CodClausula
     FROM COTIZADOR_CLAUSULAS
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND CodCotizador    = cCodCotizador
      AND StsClausulaCot  = cStsTipoSegCot;
BEGIN
   BEGIN
      SELECT StsCotizador
        INTO cStsCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCotizador = cCodCotizador;
   END;
   IF cStsCotizador = 'CONFIG' THEN
      cStsTipoSegCot := 'CONFIG';
      FOR X IN PROD_Q LOOP
         GT_COTIZADOR_TIPOSEG.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, X.IdTipoSeg);
      END LOOP;

      FOR X IN CLAU_Q LOOP
         GT_COTIZADOR_CLAUSULAS.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, X.CodClausula);
      END LOOP;
   ELSE
      cStsTipoSegCot := 'SUSPEN';
      FOR X IN PROD_Q LOOP
         GT_COTIZADOR_TIPOSEG.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, X.IdTipoSeg);
      END LOOP;

      FOR X IN CLAU_Q LOOP
         GT_COTIZADOR_CLAUSULAS.ACTIVAR(nCodCia, nCodEmpresa, cCodCotizador, X.CodClausula);
      END LOOP;
   END IF;

   UPDATE COTIZADOR_CONFIG
      SET StsCotizador     = 'ACTIVO',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND CodCotizador  = cCodCotizador;
END ACTIVAR_COTIZADOR;

PROCEDURE SUSPENDER_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) IS
cStsTipoSegCot  COTIZADOR_TIPOSEG.StsTipoSegCot%TYPE;
cStsCotizador   COTIZADOR_CONFIG.StsCotizador%TYPE;

CURSOR PROD_Q IS
   SELECT IdTipoSeg
     FROM COTIZADOR_TIPOSEG
    WHERE CodCia         = nCodCia
      AND CodEmpresa     = nCodEmpresa
      AND CodCotizador   = cCodCotizador
      AND StsTipoSegCot  = cStsTipoSegCot;

CURSOR CLAU_Q IS
   SELECT CodClausula
     FROM COTIZADOR_CLAUSULAS
    WHERE CodCia          = nCodCia
      AND CodEmpresa      = nCodEmpresa
      AND CodCotizador    = cCodCotizador
      AND StsClausulaCot  = cStsTipoSegCot;
BEGIN
   BEGIN
      SELECT StsCotizador
        INTO cStsCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND CodCotizador = cCodCotizador;
   END;
   IF cStsCotizador = 'CONFIG' THEN
      cStsTipoSegCot := 'CONFIG';
      FOR X IN PROD_Q LOOP
         GT_COTIZADOR_TIPOSEG.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, X.IdTipoSeg);
      END LOOP;

      FOR X IN CLAU_Q LOOP
         GT_COTIZADOR_CLAUSULAS.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, X.CodClausula);
      END LOOP;
   ELSE
      cStsTipoSegCot := 'SUSPEN';
      FOR X IN PROD_Q LOOP
         GT_COTIZADOR_TIPOSEG.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, X.IdTipoSeg);
      END LOOP;

      FOR X IN CLAU_Q LOOP
         GT_COTIZADOR_CLAUSULAS.SUSPENDER(nCodCia, nCodEmpresa, cCodCotizador, X.CodClausula);
      END LOOP;
   END IF;
   UPDATE COTIZADOR_CONFIG
      SET StsCotizador     = 'SUSPEN',
          FecStatus        = TRUNC(SYSDATE),
          CodUsuario       = USER,
          FecUltModif      = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND CodCotizador  = cCodCotizador;

END SUSPENDER_COTIZADOR;

FUNCTION VIGENCIA_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2, dFecOperacion DATE) RETURN VARCHAR2 IS
cCotizadorVigente       VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cCotizadorVigente
        FROM COTIZADOR_CONFIG
       WHERE CodCia            = nCodCia
         AND CodEmpresa        = nCodEmpresa
         AND CodCotizador      = cCodCotizador
         AND FecIniCotizador  <= dFecOperacion
         AND FecFinCotizador  >= dFecOperacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCotizadorVigente := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR (-20100,'Error en Configuración de Cotizador '||cCodCotizador);
   END;
   RETURN(cCotizadorVigente);
END VIGENCIA_COTIZADOR;

FUNCTION DIAS_VIGENCIA_COTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER IS
nDiasVigCotizacion       COTIZADOR_CONFIG.DiasVigCotizacion%TYPE;
BEGIN
   BEGIN
      SELECT DiasVigCotizacion
        INTO nDiasVigCotizacion
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nDiasVigCotizacion := 0;
   END;
   RETURN(nDiasVigCotizacion);
END DIAS_VIGENCIA_COTIZACION;

FUNCTION PERMITE_RECOTIZACION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cIndRecotiza       COTIZADOR_CONFIG.IndRecotiza%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndRecotiza,'N')
        INTO cIndRecotiza
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndRecotiza := 'N';
   END;
   RETURN(cIndRecotiza);
END PERMITE_RECOTIZACION;

FUNCTION CANTIDAD_RECOTIZACIONES(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER IS
nCantRecotizaciones       COTIZADOR_CONFIG.CantRecotizaciones%TYPE;
BEGIN
   BEGIN
      SELECT CantRecotizaciones
        INTO nCantRecotizaciones
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantRecotizaciones := 0;
   END;
   RETURN(nCantRecotizaciones);
END CANTIDAD_RECOTIZACIONES;

FUNCTION APLICA_TARIFA_RIESGO(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cIndTarifaRiesgo       COTIZADOR_CONFIG.IndTarifaRiesgo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndTarifaRiesgo,'N')
        INTO cIndTarifaRiesgo
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndTarifaRiesgo := 'N';
   END;
   RETURN(cIndTarifaRiesgo);
END APLICA_TARIFA_RIESGO;

FUNCTION SELECCIONA_COBERTURAS(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cIndSelManualCobert       COTIZADOR_CONFIG.IndSelManualCobert%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndSelManualCobert,'N')
        INTO cIndSelManualCobert
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndSelManualCobert := 'N';
   END;
   RETURN(cIndSelManualCobert);
END SELECCIONA_COBERTURAS;

FUNCTION DIAS_REVERSION(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN NUMBER IS
nCantDiasRevCoti      COTIZADOR_CONFIG.CantDiasRevCoti%TYPE;
BEGIN
   BEGIN
      SELECT CantDiasRevCoti
        INTO nCantDiasRevCoti
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCantDiasRevCoti := 0;
   END;
   RETURN(nCantDiasRevCoti);
END DIAS_REVERSION;

FUNCTION CALCULA_SAMI(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cIndCalculaSAMI      COTIZADOR_CONFIG.IndCalculaSAMI%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCalculaSAMI,'N')
        INTO cIndCalculaSAMI
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cIndCalculaSAMI := 'N';
   END;
   RETURN(cIndCalculaSAMI);
END CALCULA_SAMI;

FUNCTION TIPO_DE_COTIZADOR(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cCodTipoCotizador       COTIZADOR_CONFIG.CodTipoCotizador%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CodTipoCotizador,'NA')
        INTO cCodTipoCotizador
        FROM COTIZADOR_CONFIG
       WHERE CodCia        = nCodCia
         AND CodEmpresa    = nCodEmpresa
         AND CodCotizador  = cCodCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodTipoCotizador := 'NA';
   END;
   RETURN(cCodTipoCotizador);
END TIPO_DE_COTIZADOR;

FUNCTION COTIZADOR_WEB(nCodCia NUMBER, nCodEmpresa NUMBER, cCodCotizador VARCHAR2) RETURN VARCHAR2 IS
cIndCotizadorWeb COTIZADOR_CONFIG.IndCotizadorWeb%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IndCotizadorWeb,'N')
        INTO cIndCotizadorWeb
        FROM COTIZADOR_CONFIG
       WHERE CodCia                 = nCodCia
         AND CodEmpresa             = nCodEmpresa
         AND CodCotizador           = cCodCotizador
         AND StsCotizador           = 'ACTIVO'
         AND TRUNC(SYSDATE)   BETWEEN FecIniCotizador AND FecFinCotizador;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'Error en Configuración de Cotizador '||cCodCotizador||' Cotizador NO disponible o fuera de vigencia');
   END;
   RETURN(cIndCotizadorWeb);
END COTIZADOR_WEB;

END GT_COTIZADOR_CONFIG;
