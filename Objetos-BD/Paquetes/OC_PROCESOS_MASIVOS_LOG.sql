CREATE OR REPLACE PACKAGE OC_PROCESOS_MASIVOS_LOG IS

PROCEDURE INSERTA_LOG(nIdProcMasivo NUMBER, cTipoProcReg VARCHAR2, cCodError VARCHAR2,
                      cTxtError VARCHAR2);

FUNCTION NUMERO_LOG(nIdProcMasivo NUMBER) RETURN NUMBER;

END OC_PROCESOS_MASIVOS_LOG;
 
 
 
 
 
 
/

CREATE OR REPLACE PACKAGE BODY OC_PROCESOS_MASIVOS_LOG IS

PROCEDURE INSERTA_LOG(nIdProcMasivo NUMBER, cTipoProcReg VARCHAR2, cCodError VARCHAR2,
                      cTxtError VARCHAR2) IS
nIdLogProceso   PROCESOS_MASIVOS_LOG.IdLogProceso%TYPE;
nDummy          NUMBER;
BEGIN
   BEGIN
      nIdLogProceso  := OC_PROCESOS_MASIVOS_LOG.NUMERO_LOG(nIdProcMasivo);
      INSERT INTO PROCESOS_MASIVOS_LOG
             (IdProcMasivo, IdLogProceso, TipoProcReg, CodError,
              TxtError, FecLog, CodUsuarioProc)
      VALUES (nIdProcMasivo, nIdLogProceso, cTipoProcReg, cCodError,
              cTxtError, TRUNC(SYSDATE), USER);
   EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
         RAISE_APPLICATION_ERROR(-20225,'Ya Existe el Log para el Registro No. : '||TRIM(TO_CHAR(nIdProcMasivo)));
   END;
END INSERTA_LOG;

FUNCTION NUMERO_LOG(nIdProcMasivo NUMBER) RETURN NUMBER IS
nIdLogProceso   PROCESOS_MASIVOS_LOG.IdLogProceso%TYPE;
BEGIN
   SELECT NVL(MAX(IdLogProceso),0)+1
     INTO nIdLogProceso
     FROM PROCESOS_MASIVOS_LOG
    WHERE IdProcMasivo = nIdProcMasivo;
   RETURN(nIdLogProceso);
END NUMERO_LOG;

END OC_PROCESOS_MASIVOS_LOG;
