CREATE OR REPLACE PACKAGE OC_CLAUSULAS_POLIZA IS

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

CREATE OR REPLACE PACKAGE BODY OC_CLAUSULAS_POLIZA IS
--
-- BITACORA DE CAMBIO
-- SE AGREGO LA FUNCIONALIDAD PARA RENOVACION DE CLAUSULAS 31/08/2017  CLAUREN
-- SE CORRIGIO PROCEDIMIENTO DE RENOVACION                 01/12/2019  RENOV   JICO
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

PROCEDURE RENOVAR(nCodCia NUMBER, nIdPolizaOrig NUMBER, nIdPolizaDest NUMBER) IS   --RENOV INICIO
--
dFecIniVig      POLIZAS.FecIniVig%TYPE;
dFecFinVig      POLIZAS.FecFinVig%TYPE;
nIdPoliza       POLIZAS.IDPOLIZA%TYPE;
nIdPoliza_ren   POLIZAS.IDPOLIZA%TYPE;
--
CURSOR CLAU_Q IS
 SELECT *
   FROM CLAUSULAS_POLIZA CP
  WHERE CP.IdPoliza  = nIdPoliza_ren
    AND CP.CodCia    = nCodCia;
--
BEGIN
  nIdPoliza     := nIdPolizaDest;
  nIdPoliza_ren := nIdPolizaOrig;
  --
  BEGIN
    SELECT FecIniVig,  FecFinVig
      INTO dFecIniVig, dFecFinVig
      FROM POLIZAS
     WHERE IdPoliza   = nIdPoliza
       AND CodCia     = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No. de Póliza: '||TRIM(TO_CHAR(nIdPoliza))|| ' NO Existe');
  END;
  --
  FOR X IN CLAU_Q LOOP
      INSERT INTO CLAUSULAS_POLIZA
        (CodCia,    IdPoliza,        Cod_Clausula,    Tipo_Clausula,
         Texto,     Inicio_Vigencia, Fin_Vigencia,    Estado)
      VALUES
        (X.CodCia,  nIdPoliza,       X.Cod_Clausula,  X.Tipo_Clausula,
         X.Texto,   dFecIniVig,      dFecFinVig,      'SOLICI');
   END LOOP;
   --
END RENOVAR;   --RENOV FIN

END OC_CLAUSULAS_POLIZA;
