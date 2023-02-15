CREATE OR REPLACE PACKAGE GT_REA_ESQUEMAS_EMPRESAS IS
  PROCEDURE ACTIVAR_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE SUSPENDER_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  PROCEDURE CONFIGURAR_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2);
  FUNCTION PORCENTAJE(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                      nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                      cTipoPorcen VARCHAR2) RETURN NUMBER;

  FUNCTION CUOTA_REASEGURO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                           nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  FUNCTION PRIMA_REASEGURO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                           nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  FUNCTION PERIODO_VARIABLE(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                            nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  FUNCTION FACTOR_PRORRATEO_CUOTA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                  nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  PROCEDURE COPIAR_EMPRESAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

  FUNCTION INTERMEDIARIO_REASEGURO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                   nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2;

  FUNCTION PORCENTAJE_INTERMEDIARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                    nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  FUNCTION PORCENTAJE_EMPRESAS_CAPA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                    nIdCapaContrato NUMBER) RETURN NUMBER;

END GT_REA_ESQUEMAS_EMPRESAS;
/

CREATE OR REPLACE PACKAGE BODY GT_REA_ESQUEMAS_EMPRESAS IS

PROCEDURE ACTIVAR_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_EMPRESAS
      SET StsEsqEmpresa  = 'ACTIVO',
          FecStatus      = TRUNC(SYSDATE)
    WHERE CodCia         = nCodCia
      AND CodEsquema     = cCodEsquema
      AND StsEsqEmpresa IN ('CONFIG','SUSPEN');
END ACTIVAR_EMPRESAS;

PROCEDURE SUSPENDER_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_EMPRESAS
      SET StsEsqEmpresa = 'SUSPEN',
          FecStatus     = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEsquema    = cCodEsquema
      AND StsEsqEmpresa = 'ACTIVO';
END SUSPENDER_EMPRESAS;

PROCEDURE CONFIGURAR_EMPRESAS(nCodCia NUMBER, cCodEsquema VARCHAR2) IS
BEGIN
   UPDATE REA_ESQUEMAS_EMPRESAS
      SET StsEsqEmpresa = 'CONFIG',
          FecStatus     = TRUNC(SYSDATE)
    WHERE CodCia        = nCodCia
      AND CodEsquema    = cCodEsquema
      AND StsEsqEmpresa = 'ACTIVO';
END CONFIGURAR_EMPRESAS;

FUNCTION PORCENTAJE(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                    nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2, 
                    cTipoPorcen VARCHAR2) RETURN NUMBER IS
nPorcEmpresa         REA_ESQUEMAS_EMPRESAS.PorcEmpresa%TYPE;
nPorcComisBasica     REA_ESQUEMAS_EMPRESAS.PorcComisBasica%TYPE;
nPorcRvaPrimas       REA_ESQUEMAS_EMPRESAS.PorcRvaPrimas%TYPE;
nPorcIntRvaPrimas    REA_ESQUEMAS_EMPRESAS.PorcIntRvaPrimas%TYPE;
nPorcRvaSini         REA_ESQUEMAS_EMPRESAS.PorcRvaSini%TYPE;
nPorcIntRvaSini      REA_ESQUEMAS_EMPRESAS.PorcIntRvaSini%TYPE;
nPorcTrasPrimas      REA_ESQUEMAS_EMPRESAS.PorcTrasPrimas%TYPE;
nPorcTrasSini        REA_ESQUEMAS_EMPRESAS.PorcTrasSini%TYPE;
nPorcPartUtil        REA_ESQUEMAS_EMPRESAS.PorcPartUtil%TYPE;
nPorcRetImpuestos    REA_ESQUEMAS_EMPRESAS.PorcRetImpuestos%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcEmpresa,0), NVL(PorcComisBasica,0), NVL(PorcRvaPrimas,0), NVL(PorcIntRvaPrimas,0),
             NVL(PorcRvaSini,0), NVL(PorcIntRvaSini,0), NVL(PorcTrasPrimas,0), NVL(PorcTrasSini,0),
             NVL(PorcPartUtil,0), NVL(PorcRetImpuestos,0)
        INTO nPorcEmpresa, nPorcComisBasica, nPorcRvaPrimas, nPorcIntRvaPrimas,
             nPorcRvaSini, nPorcIntRvaSini, nPorcTrasPrimas, nPorcTrasSini,
             nPorcPartUtil, nPorcRetImpuestos
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcEmpresa       := 0;
         nPorcComisBasica   := 0;
         nPorcRvaPrimas     := 0;
         nPorcIntRvaPrimas  := 0;
         nPorcRvaSini       := 0;
         nPorcIntRvaSini    := 0;
         nPorcTrasPrimas    := 0;
         nPorcTrasSini      := 0;
         nPorcPartUtil      := 0;
         nPorcRetImpuestos  := 0;
   END;
   IF cTipoPorcen = 'PEMP' THEN
      RETURN(nPorcEmpresa);
   ELSIF cTipoPorcen = 'PCOB' THEN
      RETURN(nPorcComisBasica);
   ELSIF cTipoPorcen = 'PRVP' THEN
      RETURN(nPorcRvaPrimas);
   ELSIF cTipoPorcen = 'PIRP' THEN
      RETURN(nPorcIntRvaPrimas);
   ELSIF cTipoPorcen = 'PRVS' THEN
      RETURN(nPorcRvaSini);
   ELSIF cTipoPorcen = 'PIRS' THEN
      RETURN(nPorcIntRvaSini);
   ELSIF cTipoPorcen = 'PTRP' THEN
      RETURN(nPorcTrasPrimas);
   ELSIF cTipoPorcen = 'PTRS' THEN
      RETURN(nPorcTrasSini);
   ELSIF cTipoPorcen = 'PUTL' THEN
      RETURN(nPorcPartUtil);
   ELSIF cTipoPorcen = 'PRIM' THEN
      RETURN(nPorcRetImpuestos);
   ELSE
      RETURN(0);
   END IF;
END PORCENTAJE;

FUNCTION CUOTA_REASEGURO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                         nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nCuotaReaseg         REA_ESQUEMAS_EMPRESAS.CuotaReaseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(CuotaReaseg,0)
        INTO nCuotaReaseg
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nCuotaReaseg       := 0;
   END;
   RETURN(nCuotaReaseg);
END CUOTA_REASEGURO;

FUNCTION PRIMA_REASEGURO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                         nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nPrimaReaseg         REA_ESQUEMAS_EMPRESAS.PrimaReaseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PrimaReaseg,0)
        INTO nPrimaReaseg
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPrimaReaseg       := 0;
   END;
   RETURN(nPrimaReaseg);
END PRIMA_REASEGURO;

FUNCTION PERIODO_VARIABLE(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                          nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nPeriodoVariable      REA_ESQUEMAS_EMPRESAS.PeriodoVariable%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PeriodoVariable,0)
        INTO nPeriodoVariable
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPeriodoVariable := 0;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'No Existe Periodo Variable para Empresa del Gremio ' || cCodEmpresaGremio || 
                                 ' Intermediario ' || cCodInterReaseg || ' en Esquema ' || cCodEsquema);
   END;
   RETURN(nPeriodoVariable);
END PERIODO_VARIABLE;

FUNCTION FACTOR_PRORRATEO_CUOTA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nFactProrrateo         REA_ESQUEMAS_EMPRESAS.FactProrrateo%TYPE;
BEGIN
   BEGIN
      SELECT NVL(FactProrrateo,0)
        INTO nFactProrrateo
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nFactProrrateo       := 0;
   END;
   RETURN(nFactProrrateo);
END FACTOR_PRORRATEO_CUOTA;

PROCEDURE COPIAR_EMPRESAS(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR EMP_Q IS
   SELECT IdEsqContrato, IdCapaContrato, CodEmpresaGremio, PorcEmpresa,
          PorcComisBasica, PorcRvaPrimas, PorcIntRvaPrimas, PorcRvaSini,
          PorcIntRvaSini, PorcTrasPrimas, PorcTrasSini, PorcPartUtil,
          LimArrastrePerd, PeriodoLiqCtas, StsEsqEmpresa, FecStatus,
          CodInterReaseg, PorcRetImpuestos, CuotaReaseg, PrimaReaseg,
          PeriodoVariable, FactProrrateo, PorcenInterReaseg
     FROM REA_ESQUEMAS_EMPRESAS
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN EMP_Q LOOP
      INSERT INTO REA_ESQUEMAS_EMPRESAS
             (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
              PorcEmpresa, PorcComisBasica, PorcRvaPrimas, PorcIntRvaPrimas, PorcRvaSini,
              PorcIntRvaSini, PorcTrasPrimas, PorcTrasSini, PorcPartUtil,
              LimArrastrePerd, PeriodoLiqCtas, StsEsqEmpresa, FecStatus,
              CodInterReaseg, PorcRetImpuestos, CuotaReaseg, PrimaReaseg,
              PeriodoVariable, FactProrrateo, PorcenInterReaseg)
      VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.IdCapaContrato, 
              W.CodEmpresaGremio, W.PorcEmpresa, W.PorcComisBasica, W.PorcRvaPrimas, 
              W.PorcIntRvaPrimas, W.PorcRvaSini, W.PorcIntRvaSini, W.PorcTrasPrimas, 
              W.PorcTrasSini, W.PorcPartUtil, W.LimArrastrePerd, W.PeriodoLiqCtas, 
              'ACTIVO', TRUNC(SYSDATE), W.CodInterReaseg, W.PorcRetImpuestos, 
              W.CuotaReaseg, W.PrimaReaseg, W.PeriodoVariable, W.FactProrrateo,
              W.PorcenInterReaseg);
   END LOOP;
END COPIAR_EMPRESAS;

FUNCTION INTERMEDIARIO_REASEGURO(nCodCia NUMBER,  cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                 nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2) RETURN VARCHAR2 IS
cCodInterReaseg       REA_ESQUEMAS_EMPRESAS.CodInterReaseg%TYPE;
BEGIN
   BEGIN
      SELECT CodInterReaseg
        INTO cCodInterReaseg
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cCodInterReaseg := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20000,'Existen Varios Intermediarios para Empresa del Gremio ' || cCodEmpresaGremio || ' en Esquema ' || cCodEsquema);
   END;
   RETURN(cCodInterReaseg);
END INTERMEDIARIO_REASEGURO;

FUNCTION PORCENTAJE_INTERMEDIARIO(nCodCia NUMBER,  cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                  nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nPorcenInterReaseg       REA_ESQUEMAS_EMPRESAS.PorcenInterReaseg%TYPE;
BEGIN
   BEGIN
      SELECT NVL(PorcenInterReaseg,0)
        INTO nPorcenInterReaseg
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcenInterReaseg := 0;
   END;
   RETURN(nPorcenInterReaseg);
END PORCENTAJE_INTERMEDIARIO;

FUNCTION PORCENTAJE_EMPRESAS_CAPA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                                  nIdCapaContrato NUMBER) RETURN NUMBER IS
nPorcEmpresa       REA_ESQUEMAS_EMPRESAS.PorcEmpresa%TYPE;
BEGIN
   BEGIN
      SELECT NVL(SUM(PorcEmpresa),0)
        INTO nPorcEmpresa
        FROM REA_ESQUEMAS_EMPRESAS
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nPorcEmpresa := 0;
   END;
   RETURN(nPorcEmpresa);
END PORCENTAJE_EMPRESAS_CAPA;

END GT_REA_ESQUEMAS_EMPRESAS;
