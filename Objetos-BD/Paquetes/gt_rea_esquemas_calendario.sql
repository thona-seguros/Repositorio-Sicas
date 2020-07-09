--
-- GT_REA_ESQUEMAS_CALENDARIO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   REA_ESQUEMAS_CALENDARIO (Table)
--   REA_ESQUEMAS_CAPAS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_REA_ESQUEMAS_CALENDARIO IS
  
  PROCEDURE COPIAR_CALENDARIO(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2);

  FUNCTION NUMERO_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                             nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER;

  PROCEDURE CREAR_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                             nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                             dFecIniContrato DATE, cPeriodoLiqCtas VARCHAR2);

  FUNCTION EXISTE_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                             nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN VARCHAR2;

  PROCEDURE ENTREGA_EDO_CTA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                            nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                            nIdCalendario NUMBER, dFecRealEntrega DATE);

END GT_REA_ESQUEMAS_CALENDARIO;
/

--
-- GT_REA_ESQUEMAS_CALENDARIO  (Package Body) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_CALENDARIO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_REA_ESQUEMAS_CALENDARIO IS

PROCEDURE COPIAR_CALENDARIO(nCodCia NUMBER, cCodEsquemaOrig VARCHAR2, cCodEsquemaDest VARCHAR2) IS
CURSOR EMP_Q IS
   SELECT IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
          IdCalendario, FecEnvioEstadoCta, MontoEstadoCta,
          FechaPago, MontoPagado, CodInterReaseg
     FROM REA_ESQUEMAS_CALENDARIO
    WHERE CodCia     = nCodCia
      AND CodEsquema = cCodEsquemaOrig;
BEGIN
   FOR W IN EMP_Q LOOP
      BEGIN
         INSERT INTO REA_ESQUEMAS_CALENDARIO
                (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato, CodEmpresaGremio, 
                 IdCalendario, FecEnvioEstadoCta, MontoEstadoCta,
                 FechaPago, MontoPagado, CodInterReaseg)
         VALUES (nCodCia, cCodEsquemaDest, W.IdEsqContrato, W.IdCapaContrato, 
                 W.CodEmpresaGremio, W.IdCalendario, W.FecEnvioEstadoCta, W.MontoEstadoCta,
                 W.FechaPago, W.MontoPagado, W.CodInterReaseg);
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
   END LOOP;
END COPIAR_CALENDARIO;

FUNCTION NUMERO_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                           nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN NUMBER IS
nIdCalendario      REA_ESQUEMAS_CALENDARIO.IdCalendario%TYPE;
BEGIN
   SELECT NVL(MAX(IdCalendario),0) + 1
     INTO nIdCalendario
     FROM REA_ESQUEMAS_CALENDARIO
    WHERE CodCia           = nCodCia
      AND CodEsquema       = cCodEsquema
      AND IdEsqContrato    = nIdEsqContrato
      AND IdCapaContrato   = nIdCapaContrato
      AND CodEmpresaGremio = cCodEmpresaGremio
      AND CodInterReaseg   = cCodInterReaseg;
   RETURN(nIdCalendario);
END NUMERO_CALENDARIO;

PROCEDURE CREAR_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                           nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                           dFecIniContrato DATE, cPeriodoLiqCtas VARCHAR2) IS
nMeses                NUMBER(5);
nMesesCapa            NUMBER(5);
nCantPagos            NUMBER(5);
nCantPagosReal        NUMBER(5);
dFecEnvioEstadoCta    REA_ESQUEMAS_CALENDARIO.FecEnvioEstadoCta%TYPE;
dFechaPago            REA_ESQUEMAS_CALENDARIO.FechaPago%TYPE;
nIdCalendario         REA_ESQUEMAS_CALENDARIO.IdCalendario%TYPE;
dFecVigInicial        REA_ESQUEMAS_CAPAS.FecVigInicial%TYPE;
dFecVigFinal          REA_ESQUEMAS_CAPAS.FecVigFinal%TYPE;
BEGIN
   BEGIN
      SELECT FecVigInicial, FecVigFinal
        INTO dFecVigInicial, dFecVigFinal
        FROM REA_ESQUEMAS_CAPAS
       WHERE CodCia         = nCodCia
         AND CodEsquema     = cCodEsquema
         AND IdEsqContrato  = nIdEsqContrato
         AND IdCapaContrato = nIdCapaContrato;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Capa No. '|| nIdCapaContrato || ' para el Esquema ' || nIdEsqContrato);
   END;

   IF cPeriodoLiqCtas = 'ANUAL' THEN
      nMeses       := 12;
      nCantPagos   := 1;
   ELSIF cPeriodoLiqCtas = 'SEMEST' THEN
      nMeses       := 6;
      nCantPagos   := 2;
   ELSIF cPeriodoLiqCtas = 'TRIMES' THEN
      nMeses       := 3;
      nCantPagos   := 4;
   ELSIF cPeriodoLiqCtas = 'MENSUA' THEN
      nMeses       := 1;
      nCantPagos   := 12;
   ELSIF cPeriodoLiqCtas = 'BIMENS' THEN
      nMeses       := 2;
      nCantPagos   := 6;
   ELSE
      nMeses       := 1;
      nCantPagos   := 1;
   END IF;

   nMesesCapa     := ROUND(MONTHS_BETWEEN(dFecVigFinal, dFecVigInicial),0);
   nCantPagosReal := FLOOR(MONTHS_BETWEEN(dFecVigFinal, dFecVigInicial) / nMeses);

   IF nCantPagosReal <= 0 THEN
      nCantPagosReal := 1;
   END IF;

   IF nCantPagosReal < nCantPagos THEN
      nCantPagos := nCantPagosReal;
   END IF;

   dFecEnvioEstadoCta := dFecIniContrato;
   FOR W IN 1..nCantPagos LOOP
      nIdCalendario  := GT_REA_ESQUEMAS_CALENDARIO.NUMERO_CALENDARIO(nCodCia, cCodEsquema, nIdEsqContrato,
                                                                     nIdCapaContrato, cCodEmpresaGremio, cCodInterReaseg);

      dFecEnvioEstadoCta := ADD_MONTHS(dFecEnvioEstadoCta, nMeses);
      dFechaPago         := ADD_MONTHS(dFecEnvioEstadoCta, 1);

      INSERT INTO REA_ESQUEMAS_CALENDARIO
             (CodCia, CodEsquema, IdEsqContrato, IdCapaContrato,
              CodEmpresaGremio, IdCalendario, FecEnvioEstadoCta,
              MontoEstadoCta, FechaPago, MontoPagado, CodInterReaseg)
      VALUES (nCodCia, cCodEsquema, nIdEsqContrato, nIdCapaContrato,
              cCodEmpresaGremio, nIdCalendario, dFecEnvioEstadoCta,
              0, dFechaPago, 0, cCodInterReaseg);
   END LOOP;
END CREAR_CALENDARIO;

FUNCTION EXISTE_CALENDARIO(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                           nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2) RETURN VARCHAR2 IS
cExiste     VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM REA_ESQUEMAS_CALENDARIO
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTE_CALENDARIO;

PROCEDURE ENTREGA_EDO_CTA(nCodCia NUMBER, cCodEsquema VARCHAR2, nIdEsqContrato NUMBER,
                            nIdCapaContrato NUMBER, cCodEmpresaGremio VARCHAR2, cCodInterReaseg VARCHAR2,
                            nIdCalendario NUMBER, dFecRealEntrega DATE) IS
BEGIN
   BEGIN
      UPDATE REA_ESQUEMAS_CALENDARIO
         SET IndEstCtaEntreg = 'S',
             FecRealEntrega  = dFecRealEntrega
       WHERE CodCia           = nCodCia
         AND CodEsquema       = cCodEsquema
         AND IdEsqContrato    = nIdEsqContrato
         AND IdCapaContrato   = nIdCapaContrato
         AND CodEmpresaGremio = cCodEmpresaGremio
         AND CodInterReaseg   = cCodInterReaseg
         AND IdCalendario     = nIdCalendario;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR (-20100,'No Existe Esquema para Actualizar '|| nIdCapaContrato || ' para el Esquema ' || nIdEsqContrato);
   END;
END ENTREGA_EDO_CTA;

END GT_REA_ESQUEMAS_CALENDARIO;
/

--
-- GT_REA_ESQUEMAS_CALENDARIO  (Synonym) 
--
--  Dependencies: 
--   GT_REA_ESQUEMAS_CALENDARIO (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM GT_REA_ESQUEMAS_CALENDARIO FOR SICAS_OC.GT_REA_ESQUEMAS_CALENDARIO
/


GRANT EXECUTE ON SICAS_OC.GT_REA_ESQUEMAS_CALENDARIO TO PUBLIC
/
