create or replace PACKAGE SICAS_OC.OC_PROCESOS_MASIVOS_LOG IS

PROCEDURE INSERTA_LOG(nIdProcMasivo NUMBER, cTipoProcReg VARCHAR2, cCodError VARCHAR2,
                      cTxtError VARCHAR2);

FUNCTION NUMERO_LOG(nIdProcMasivo NUMBER) RETURN NUMBER;

END OC_PROCESOS_MASIVOS_LOG;

/

create or replace PACKAGE BODY SICAS_OC.OC_PROCESOS_MASIVOS_LOG IS

PROCEDURE INSERTA_LOG(nIdProcMasivo NUMBER, cTipoProcReg VARCHAR2, cCodError VARCHAR2,
                      cTxtError VARCHAR2) IS
nIdLogProceso   PROCESOS_MASIVOS_LOG.IdLogProceso%TYPE;
nDummy          NUMBER;
cUsuario        varchar2(100);
BEGIN
   BEGIN
      BEGIN --PST 27-11-2023 TODO EL QUERY
        SELECT APEX_CUSTOM_AUTH.GET_USERNAME INTO cUsuario FROM DUAL;
		IF(cUsuario IS NULL)THEN
			cUsuario := USER;
		END IF;
      EXCEPTION WHEN OTHERS THEN
        cUsuario := USER;
      END;
IF cUsuario IS NULL THEN
cUsuario := USER;
END IF;
      nIdLogProceso  := OC_PROCESOS_MASIVOS_LOG.NUMERO_LOG(nIdProcMasivo);
      INSERT INTO PROCESOS_MASIVOS_LOG
             (IdProcMasivo, IdLogProceso, TipoProcReg, CodError,
              TxtError, FecLog, CodUsuarioProc)
      VALUES (nIdProcMasivo, nIdLogProceso, cTipoProcReg, cCodError,
              cTxtError, TRUNC(SYSDATE), cUsuario);
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