--
-- OC_CLAUSULAS_POLIZA  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   DETALLE_POLIZA (Table)
--   CLAUSULAS (Table)
--   CLAUSULAS_DETALLE (Table)
--   CLAUSULAS_PLAN_COBERTURAS (Table)
--   CLAUSULAS_POLIZA (Table)
--   CLAUSULAS_TIPOS_SEGUROS (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CLAUSULAS_POLIZA IS

PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER);

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER) RETURN VARCHAR2;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER);

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER);

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER);

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER);

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER);  --CLAUREN

END OC_CLAUSULAS_POLIZA;
/

--
-- OC_CLAUSULAS_POLIZA  (Package Body) 
--
--  Dependencies: 
--   OC_CLAUSULAS_POLIZA (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CLAUSULAS_POLIZA IS
--
-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 31/08/2017  CLAUREN
--
PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER) IS

CURSOR CLAU_Q IS
   SELECT Cod_Clausula, Tipo_Clausula, Texto, Estado,
          TRUNC(SYSDATE) Inicio_Vigencia, ADD_MONTHS(TRUNC(SYSDATE), 12) Fin_Vigencia
     FROM CLAUSULAS_POLIZA
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPolizaOrig
      AND Estado     != 'ANULAD';
BEGIN
   FOR W IN CLAU_Q LOOP
      BEGIN
         INSERT INTO CLAUSULAS_POLIZA
                (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPolizaDest, W.Cod_Clausula, W.Tipo_Clausula,
                 W.Texto, W.Inicio_Vigencia, W.Fin_Vigencia, 'SOLICI');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
   END LOOP;
END COPIAR;

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CLAUSULAS_POLIZA
       WHERE CodCia       = nCodCia
         AND IdPoliza     = nIdPoliza
         AND Cod_Clausula = nCod_Clausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_CLAUSULA;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'ANULAD'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND Cod_Clausula = nCod_Clausula;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'EXCLUI'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND Cod_Clausula = nCod_Clausula;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'EMITID'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND Cod_Clausula = nCod_Clausula;
END EMITIR;

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'ANULAD'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza;
END ANULAR_TODAS;

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'EXCLUI'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza;
END EXCLUIR_TODAS;

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_POLIZA
      SET Estado = 'EMITID'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza;
END EMITIR_TODAS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER) IS   --CLAUREN INICIO
cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
dFecIniVig      POLIZAS.FecIniVig%TYPE;
dFecFinVig      POLIZAS.FecFinVig%TYPE;
nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
nCodEmpresa     POLIZAS.CODEMPRESA%TYPE;

CURSOR DET_Q IS
   SELECT DISTINCT IdTipoSeg, PlanCob
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

CURSOR CLAU_Q IS
   SELECT C.CodClausula
     FROM CLAUSULAS_TIPOS_SEGUROS CTS, CLAUSULAS C
    WHERE CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'S'
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
    UNION
   SELECT C.CodClausula
     FROM CLAUSULAS_PLAN_COBERTURAS CTS, CLAUSULAS C
    WHERE CTS.PlanCob     = cPlanCOb
      AND CTS.IdTipoSeg   = cIdTipoSeg
      AND CTS.CodCia      = nCodCia
      AND CTS.CodEmpresa  = nCodEmpresa
      AND CTS.IDRENOVACION = 'S'
      AND C.CodClausula   = CTS.CodClausula
      AND C.CodCia        = CTS.CodCia
      AND C.CodEmpresa    = CTS.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
    MINUS
   SELECT CP.Tipo_Clausula
     FROM CLAUSULAS_POLIZA CP
    WHERE CP.IdPoliza  = nIdPoliza
      AND CP.CodCia    = nCodCia
    MINUS
   SELECT CD.Tipo_Clausula
     FROM CLAUSULAS_DETALLE CD
    WHERE CD.IdPoliza  = nIdPoliza
      AND CD.CodCia    = nCodCia;
BEGIN
   nIdPoliza   := nIdPolizaDest;
   nCodEmpresa := nCodCia;
   BEGIN
      SELECT FecIniVig, FecFinVig
        INTO dFecIniVig, dFecFinVig
        FROM POLIZAS
       WHERE IdPoliza   = nIdPoliza
         AND CodEmpresa = nCodEmpresa
         AND CodCia     = nCodCia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No. de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' NO Existe');
   END;

   FOR Y IN DET_Q LOOP
      cIdTipoSeg := Y.IdTipoSeg;
      cPlanCob   := Y.PlanCob;
      FOR X IN CLAU_Q LOOP
         SELECT NVL(MAX(Cod_Clausula),0) + 1
           INTO nCod_Clausula
           FROM CLAUSULAS_POLIZA
          WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza;

            BEGIN
               SELECT TextoClausula
                 INTO cTextoClausula
                FROM CLAUSULAS
               WHERE CodCia      = nCodCia
                 AND CodEmpresa  = nCodEmpresa
                 AND CodClausula = X.CodClausula;
            EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    cTextoClausula := NULL;
            END;

         INSERT INTO CLAUSULAS_POLIZA
                (CodCia, IdPoliza, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPoliza, nCod_Clausula, X.CodClausula,
                 cTextoClausula, dFecIniVig, dFecFinVig, 'XRENOV');
      END LOOP;
   END LOOP;

END RENOVAR;   --CLAUREN FIN

END OC_CLAUSULAS_POLIZA;
/
