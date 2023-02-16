CREATE OR REPLACE PACKAGE          OC_CLAUSULAS_DETALLE IS

PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER);

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER) RETURN VARCHAR2;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER);

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER);

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER);  --CLAUREN

END OC_CLAUSULAS_DETALLE;

/

CREATE OR REPLACE PACKAGE BODY          OC_CLAUSULAS_DETALLE IS
--
-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 31/08/2017  CLAUREN
--
PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER) IS

CURSOR CLAU_Q IS
   SELECT Cod_Clausula, Tipo_Clausula, Texto, Estado,
          TRUNC(SYSDATE) Inicio_Vigencia, ADD_MONTHS(TRUNC(SYSDATE), 12) Fin_Vigencia
     FROM CLAUSULAS_DETALLE
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPolizaOrig
      AND IDetPol     = nIDetPolOrig
      AND Estado     != 'ANULAD';
BEGIN
   FOR W IN CLAU_Q LOOP
      BEGIN
         INSERT INTO CLAUSULAS_DETALLE
                (CodCia, IdPoliza, IDetPol, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPolizaDest, nIDetPolDest, W.Cod_Clausula, W.Tipo_Clausula,
                 W.Texto, W.Inicio_Vigencia, W.Fin_Vigencia, 'SOLICI');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
   END LOOP;
END COPIAR;

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CLAUSULAS_DETALLE
       WHERE CodCia       = nCodCia
         AND IdPoliza     = nIdPoliza
         AND IDetPol      = nIDetPol
         AND Cod_Clausula = nCod_Clausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_CLAUSULA;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'ANULAD'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND Cod_Clausula = nCod_Clausula;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'EXCLUI'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND Cod_Clausula = nCod_Clausula;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'EMITID'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol
      AND Cod_Clausula = nCod_Clausula;
END EMITIR;

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'ANULAD'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol;
END ANULAR_TODAS;

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'EXCLUI'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol;
END EXCLUIR_TODAS;

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_DETALLE
      SET Estado = 'EMITID'
    WHERE CodCia       = nCodCia
      AND IdPoliza     = nIdPoliza
      AND IDetPol      = nIDetPol;
END EMITIR_TODAS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER) IS   --CLAUREN INICIO
nIDetPol        DETALLE_POLIZA.IDetPol%TYPE;
cIdTipoSeg      DETALLE_POLIZA.IdTipoSeg%TYPE;
cPlanCob        DETALLE_POLIZA.PlanCob%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
nCodEmpresa     POLIZAS.CODEMPRESA%TYPE;

CURSOR DET_Q IS
   SELECT DISTINCT IDetPol, IdTipoSeg, PlanCob, FecIniVig, FecFinVig
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
   SELECT CD.Tipo_Clausula
     FROM CLAUSULAS_DETALLE CD
    WHERE CD.IdPoliza  = nIdPoliza
      AND CD.IdeTpol   = nIDetPol
      AND CD.CodCia    = nCodCia;
BEGIN
   nIdPoliza   := nIdPolizaDest;
   nCodEmpresa := nCodCia;
   FOR Y IN DET_Q LOOP
      nIDetPol   := Y.IDetPol;
      cIdTipoSeg := Y.IdTipoSeg;
      cPlanCob   := Y.PlanCob;
      FOR X IN CLAU_Q LOOP
         SELECT NVL(MAX(Cod_Clausula),0) + 1
           INTO nCod_Clausula
           FROM CLAUSULAS_DETALLE
          WHERE CodCia    = nCodCia
            AND IdPoliza  = nIdPoliza
            AND IDetPol   = nIdetPol;

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

         INSERT INTO CLAUSULAS_DETALLE
                (CodCia, IdPoliza, IDetpol, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPoliza, nIDetPol, nCod_Clausula, X.CodClausula,
                 cTextoClausula, Y.FecIniVig, Y.FecFinVig, 'XRENOV');
      END LOOP;
   END LOOP;

END RENOVAR;   --CLAUREN FIN

END OC_CLAUSULAS_DETALLE;
