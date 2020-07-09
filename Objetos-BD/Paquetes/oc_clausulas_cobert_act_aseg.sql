--
-- OC_CLAUSULAS_COBERT_ACT_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   POLIZAS (Table)
--   ASEGURADO_CERTIFICADO (Table)
--   CLAUSULAS (Table)
--   CLAUSULAS_COBERTURAS (Table)
--   CLAUSULAS_COBERT_ACT_ASEG (Table)
--   CLAUSULAS_DETALLE (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   DETALLE_POLIZA (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_CLAUSULAS_COBERT_ACT_ASEG IS

PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER);

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER) RETURN VARCHAR2;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                 nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER);

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                  nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER);

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                 nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER);

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER);

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER);

END OC_CLAUSULAS_COBERT_ACT_ASEG;
/

--
-- OC_CLAUSULAS_COBERT_ACT_ASEG  (Package Body) 
--
--  Dependencies: 
--   OC_CLAUSULAS_COBERT_ACT_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_CLAUSULAS_COBERT_ACT_ASEG IS
--
-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 31/08/2017  CLAUREN
--
PROCEDURE COPIAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIDetPolOrig NUMBER,
                 nIdPolizaDest NUMBER, nIDetPolDest NUMBER) IS

CURSOR CLAU_Q IS
   SELECT Cod_Asegurado, CodCobert, Cod_Clausula, Tipo_Clausula, Texto, Estado,
          TRUNC(SYSDATE) Inicio_Vigencia, ADD_MONTHS(TRUNC(SYSDATE), 12) Fin_Vigencia
     FROM CLAUSULAS_COBERT_ACT_ASEG
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPolizaOrig
      AND IDetPol     = nIDetPolOrig
      AND Estado     != 'ANULAD';
BEGIN
   FOR W IN CLAU_Q LOOP
      BEGIN
         INSERT INTO CLAUSULAS_COBERT_ACT_ASEG
                (CodCia, IdPoliza, IDetPol, Cod_Asegurado, CodCobert, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPolizaDest, nIDetPolDest, W.Cod_Asegurado, W.CodCobert, W.Cod_Clausula, W.Tipo_Clausula,
                 W.Texto, W.Inicio_Vigencia, W.Fin_Vigencia, 'SOLICI');
      EXCEPTION
         WHEN DUP_VAL_ON_INDEX THEN
            NULL;
      END;
   END LOOP;
END COPIAR;

FUNCTION EXISTE_CLAUSULA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                         nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER) RETURN VARCHAR2 IS
cExiste  VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM CLAUSULAS_COBERT_ACT_ASEG
       WHERE CodCia        = nCodCia
         AND IdPoliza      = nIdPoliza
         AND IDetPol       = nIDetPol
         AND Cod_Asegurado = nCod_Asegurado
         AND CodCobert     = cCodCobert
         AND Cod_Clausula  = nCod_Clausula;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
 RETURN(cExiste);
END EXISTE_CLAUSULA;

PROCEDURE ANULAR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                 nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'ANULAD'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND CodCobert     = cCodCobert
      AND Cod_Clausula  = nCod_Clausula;
END ANULAR;

PROCEDURE EXCLUIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                  nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'EXCLUI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND CodCobert     = cCodCobert
      AND Cod_Clausula  = nCod_Clausula;
END EXCLUIR;

PROCEDURE EMITIR(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER,
                 nCod_Asegurado NUMBER, cCodCobert VARCHAR2, nCod_Clausula NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'EMITID'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado
      AND CodCobert     = cCodCobert
      AND Cod_Clausula  = nCod_Clausula;
END EMITIR;

PROCEDURE ANULAR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'ANULAD'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END ANULAR_TODAS;

PROCEDURE EXCLUIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'EXCLUI'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END EXCLUIR_TODAS;

PROCEDURE EMITIR_TODAS(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS
BEGIN
   UPDATE CLAUSULAS_COBERT_ACT_ASEG
      SET Estado = 'EMITID'
    WHERE CodCia        = nCodCia
      AND IdPoliza      = nIdPoliza
      AND IDetPol       = nIDetPol
      AND Cod_Asegurado = nCod_Asegurado;
END EMITIR_TODAS;

PROCEDURE INSERTA_CLAUSULAS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, nCod_Asegurado NUMBER) IS   --
cIdTipoSeg      COBERT_ACT.IdTipoSeg%TYPE;
cPlanCob        COBERT_ACT.PlanCob%TYPE;
cCodCobert      COBERT_ACT.CodCobert%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;

CURSOR COB_Q IS
   SELECT DISTINCT CA.IdTipoSeg, CA.PlanCob, CA.CodCobert, DP.FecIniVig, DP.FecFinVig
     FROM COBERT_ACT_ASEG CA, DETALLE_POLIZA DP
    WHERE DP.IDetPol       = CA.IDetPol
      AND DP.IdPoliza      = CA.IdPoliza
      AND DP.CodEmpresa    = CA.CodEmpresa
      AND DP.CodCia        = CA.CodCia
      AND CA.CodCia        = nCodCia
      AND CA.CodEmpresa    = nCodEmpresa
      AND CA.IdPoliza      = nIdPoliza
      AND CA.IDetPol       = nIDetPol
      AND CA.Cod_Asegurado = nCod_Asegurado;

CURSOR CLAU_Q IS
   SELECT C.CodClausula
     FROM CLAUSULAS_COBERTURAS CC, CLAUSULAS C
    WHERE CC.CodCobert    = cCodCobert
      AND CC.IdTipoSeg    = cIdTipoSeg
      AND CC.CodEmpresa   = nCodEmpresa
      AND CC.CodCia       = nCodCia
      AND CC.IDRENOVACION = 'N'  --CLAUREN
      AND C.CodClausula   = CC.CodClausula
      AND C.CodCia        = CC.CodCia
      AND C.CodEmpresa    = CC.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
      AND C.IndOblig      = 'S'
    MINUS
   SELECT CD.Tipo_Clausula
     FROM CLAUSULAS_COBERT_ACT_ASEG CD
    WHERE CD.CodCobert     = cCodCobert
      AND CD.Cod_Asegurado = nCod_Asegurado
      AND CD.IdPoliza      = nIdPoliza
      AND CD.IDetPol       = nIDetPol
      AND CD.CodCia        = nCodCia;
BEGIN
   FOR Y IN COB_Q LOOP
      cCodCobert := Y.CodCobert;
      cIdTipoSeg := Y.IdTipoSeg;
      cPlanCob   := Y.PlanCob;
      FOR X IN CLAU_Q LOOP
         SELECT NVL(MAX(Cod_Clausula),0) + 1
           INTO nCod_Clausula
           FROM CLAUSULAS_COBERT_ACT_ASEG
          WHERE CodCia        = nCodCia
            AND IdPoliza      = nIdPoliza
            AND IDetPol       = nIDetPol
            AND Cod_Asegurado = nCod_Asegurado
            AND CodCobert     = cCodCobert;

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

         INSERT INTO CLAUSULAS_COBERT_ACT_ASEG
                (CodCia, IdPoliza, IDetpol, Cod_Asegurado, CodCobert, Cod_Clausula, Tipo_Clausula,
                 Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
         VALUES (nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, cCodCobert, nCod_Clausula, X.CodClausula,
                 cTextoClausula, Y.FecIniVig, Y.FecFinVig, 'SOLICI');
      END LOOP;
   END LOOP;
END INSERTA_CLAUSULAS;

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER) IS    --CLAUREN  INICIO
cIdTipoSeg      COBERT_ACT.IdTipoSeg%TYPE;
cPlanCob        COBERT_ACT.PlanCob%TYPE;
cCodCobert      COBERT_ACT.CodCobert%TYPE;
nCod_Clausula   CLAUSULAS_DETALLE.Cod_Clausula%TYPE;
cTextoClausula  CLAUSULAS.TextoClausula%TYPE;
nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
nCodEmpresa     POLIZAS.CODEMPRESA%TYPE;
nIDetPol        DETALLE_POLIZA.IDETPOL%TYPE;
nCod_Asegurado  ASEGURADO_CERTIFICADO.COD_ASEGURADO%TYPE;

CURSOR DET_Q IS
   SELECT DISTINCT IDetPol
     FROM DETALLE_POLIZA
    WHERE CodCia     = nCodCia
      AND CodEmpresa = nCodEmpresa
      AND IdPoliza   = nIdPoliza;

CURSOR ASE_Q IS
   SELECT DISTINCT COD_ASEGURADO
     FROM ASEGURADO_CERTIFICADO A
    WHERE CodCia     = nCodCia
      AND IdPoliza   = nIdPoliza
      AND IDETPOL    = nIDetPol;

CURSOR COB_Q IS
   SELECT DISTINCT CA.IdTipoSeg, CA.PlanCob, CA.CodCobert, DP.FecIniVig, DP.FecFinVig
     FROM COBERT_ACT_ASEG CA, DETALLE_POLIZA DP
    WHERE DP.IDetPol       = CA.IDetPol
      AND DP.IdPoliza      = CA.IdPoliza
      AND DP.CodEmpresa    = CA.CodEmpresa
      AND DP.CodCia        = CA.CodCia
      AND CA.CodCia        = nCodCia
      AND CA.CodEmpresa    = nCodEmpresa
      AND CA.IdPoliza      = nIdPoliza
      AND CA.IDetPol       = nIDetPol
      AND CA.Cod_Asegurado = nCod_Asegurado;

CURSOR CLAU_Q IS
   SELECT C.CodClausula
     FROM CLAUSULAS_COBERTURAS CC, CLAUSULAS C
    WHERE CC.CodCobert    = cCodCobert
      AND CC.IdTipoSeg    = cIdTipoSeg
      AND CC.CodEmpresa   = nCodEmpresa
      AND CC.CodCia       = nCodCia
      AND CC.IDRENOVACION = 'S'
      AND C.CodClausula   = CC.CodClausula
      AND C.CodCia        = CC.CodCia
      AND C.CodEmpresa    = CC.CodEmpresa
      AND C.StsClausula   = 'ACTIVA'
    MINUS
   SELECT CD.Tipo_Clausula
     FROM CLAUSULAS_COBERT_ACT_ASEG CD
    WHERE CD.CodCobert     = cCodCobert
      AND CD.Cod_Asegurado = nCod_Asegurado
      AND CD.IdPoliza      = nIdPoliza
      AND CD.IDetPol       = nIDetPol
      AND CD.CodCia        = nCodCia;
BEGIN
  nIdPoliza   := nIdPolizaDest;
  nCodEmpresa := nCodCia;
  FOR Z IN DET_Q LOOP
    nIDetPol   := Z.IDetPol;
    FOR A IN ASE_Q LOOP
      nCod_Asegurado := A.COD_ASEGURADO;
      FOR Y IN COB_Q LOOP
        cCodCobert := Y.CodCobert;
        cIdTipoSeg := Y.IdTipoSeg;
        cPlanCob   := Y.PlanCob;
        FOR X IN CLAU_Q LOOP
           SELECT NVL(MAX(Cod_Clausula),0) + 1
             INTO nCod_Clausula
             FROM CLAUSULAS_COBERT_ACT_ASEG
            WHERE CodCia        = nCodCia
              AND IdPoliza      = nIdPoliza
              AND IDetPol       = nIDetPol
              AND Cod_Asegurado = nCod_Asegurado
              AND CodCobert     = cCodCobert;

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

           INSERT INTO CLAUSULAS_COBERT_ACT_ASEG
                   (CodCia, IdPoliza, IDetpol, Cod_Asegurado, CodCobert, Cod_Clausula, Tipo_Clausula,
                   Texto, Inicio_Vigencia, Fin_Vigencia, Estado)
           VALUES (nCodCia, nIdPoliza, nIDetPol, nCod_Asegurado, cCodCobert, nCod_Clausula, X.CodClausula,
                   cTextoClausula, Y.FecIniVig, Y.FecFinVig, 'XRENOV');
        END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;
END RENOVAR;   --CLAUREN  FIN


END OC_CLAUSULAS_COBERT_ACT_ASEG;
/

--
-- OC_CLAUSULAS_COBERT_ACT_ASEG  (Synonym) 
--
--  Dependencies: 
--   OC_CLAUSULAS_COBERT_ACT_ASEG (Package)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_CLAUSULAS_COBERT_ACT_ASEG FOR SICAS_OC.OC_CLAUSULAS_COBERT_ACT_ASEG
/


GRANT EXECUTE ON SICAS_OC.OC_CLAUSULAS_COBERT_ACT_ASEG TO PUBLIC
/
