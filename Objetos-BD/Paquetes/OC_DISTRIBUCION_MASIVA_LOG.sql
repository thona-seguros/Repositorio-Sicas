CREATE OR REPLACE PACKAGE SICAS_OC.OC_DISTRIBUCION_MASIVA_LOG IS

   PROCEDURE INSERTA_LOG( nCodCia         DISTRIBUCION_MASIVA_LOG.CODCIA%TYPE
                        , nCodEmpresa     DISTRIBUCION_MASIVA_LOG.CODEMPRESA%TYPE
                        , nIdPoliza       DISTRIBUCION_MASIVA_LOG.IDPOLIZA%TYPE
                        , nIdTransaccion  DISTRIBUCION_MASIVA_LOG.IDTRANSACCION%TYPE
                        , cCodigoLog      DISTRIBUCION_MASIVA_LOG.CODIGOLOG%TYPE
                        , cTextoLog       DISTRIBUCION_MASIVA_LOG.TEXTOLOG%TYPE );

   PROCEDURE ELIMINA_LOG( nCodCia         DISTRIBUCION_MASIVA_LOG.CODCIA%TYPE
                        , nCodEmpresa     DISTRIBUCION_MASIVA_LOG.CODEMPRESA%TYPE
                        , nIdPoliza       DISTRIBUCION_MASIVA_LOG.IDPOLIZA%TYPE
                        , nIdTransaccion  DISTRIBUCION_MASIVA_LOG.IDTRANSACCION%TYPE );

END OC_DISTRIBUCION_MASIVA_LOG;
/

CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DISTRIBUCION_MASIVA_LOG IS

   PROCEDURE INSERTA_LOG( nCodCia         DISTRIBUCION_MASIVA_LOG.CODCIA%TYPE
                        , nCodEmpresa     DISTRIBUCION_MASIVA_LOG.CODEMPRESA%TYPE
                        , nIdPoliza       DISTRIBUCION_MASIVA_LOG.IDPOLIZA%TYPE
                        , nIdTransaccion  DISTRIBUCION_MASIVA_LOG.IDTRANSACCION%TYPE
                        , cCodigoLog      DISTRIBUCION_MASIVA_LOG.CODIGOLOG%TYPE
                        , cTextoLog       DISTRIBUCION_MASIVA_LOG.TEXTOLOG%TYPE ) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      INSERT INTO SICAS_OC.DISTRIBUCION_MASIVA_LOG
             ( CODCIA, CODEMPRESA, IDPOLIZA, IDTRANSACCION, NUMSECUENCIA, CODIGOLOG, TEXTOLOG, FECHALOG, CODUSUARIOPROC )
      VALUES ( nCodCia, nCodEmpresa, nIdPoliza, nIdTransaccion, NULL, cCodigoLog, cTextoLog, SYSDATE, USER);
      --
      COMMIT;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20100,'ERROR al insertar LOG de Distribución de Reaseguro de Póliza No. ' || nIdPoliza || ', Transaccion ' || nIdTransaccion || ' - ' || SQLERRM);
   END INSERTA_LOG;

   PROCEDURE ELIMINA_LOG( nCodCia         DISTRIBUCION_MASIVA_LOG.CODCIA%TYPE
                        , nCodEmpresa     DISTRIBUCION_MASIVA_LOG.CODEMPRESA%TYPE
                        , nIdPoliza       DISTRIBUCION_MASIVA_LOG.IDPOLIZA%TYPE
                        , nIdTransaccion  DISTRIBUCION_MASIVA_LOG.IDTRANSACCION%TYPE ) IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      DELETE SICAS_OC.DISTRIBUCION_MASIVA_LOG
      WHERE  CodCia        = nCodCia
        AND  CodEmpresa    = nCodEmpresa
        AND  IdPoliza      = nIdPoliza
        AND  IdTransaccion = nIdTransaccion;
      --
      COMMIT;
   EXCEPTION
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20100,'ERROR al eliminar LOG de Distribución de Reaseguro de Póliza No. ' || nIdPoliza || ', Transaccion ' || nIdTransaccion || ' - ' || SQLERRM);
   END ELIMINA_LOG;
END OC_DISTRIBUCION_MASIVA_LOG;
/
