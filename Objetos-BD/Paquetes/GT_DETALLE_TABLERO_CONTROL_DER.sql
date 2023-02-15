CREATE OR REPLACE PACKAGE          GT_DETALLE_TABLERO_CONTROL_DER IS

    FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER, nIdProc IN NUMBER) RETURN NUMBER;
      
    PROCEDURE INSERTAR (nCodcia IN NUMBER, nIdProc IN NUMBER, cIdReferencia IN VARCHAR2, cTipoComprob IN VARCHAR2,
                        cCuenta IN VARCHAR2, cNivelAUx IN VARCHAR2, cMovDebCred IN VARCHAR2, nMtoMovCuentaLocal IN NUMBER,
                        nMtoMovCuentaMoneda IN NUMBER, cRespuesta IN VARCHAR2, cError IN VARCHAR2, nIdmizar IN NUMBER,
                        cTipoDiario IN VARCHAR2, cCODCENTROCOSTO IN VARCHAR2, cCODUNIDADNEGOCIO IN VARCHAR2, cDESCCPTOGENERAL IN VARCHAR2, 
                        cCODMONEDA IN VARCHAR2, nIdProcDeta OUT NUMBER);
    PROCEDURE MARCAR_PROCESADO(nCodCia IN NUMBER, nIdProc IN NUMBER);
    PROCEDURE MARCAR_DERIVADO(nCodCia IN NUMBER, nIdProc IN NUMBER, nIdProcDet IN NUMBER, nIdmizar IN NUMBER);
    PROCEDURE MARCAR_ERRORES(nCodCia IN NUMBER, nIdProc IN NUMBER, nIdProcDet IN NUMBER, cError VARCHAR2);
    PROCEDURE REVERTIR(nCodCia IN NUMBER, nIdProc IN NUMBER);
    FUNCTION  NUMERO_PROCESO_TIPO_DIARIO(nCodCia IN NUMBER, dFecComprob DATE, cTipoDiario VARCHAR2, cTipoComprob VARCHAR2) RETURN NUMBER;
        
END GT_DETALLE_TABLERO_CONTROL_DER;
/

CREATE OR REPLACE PACKAGE BODY          GT_DETALLE_TABLERO_CONTROL_DER IS

    FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER, nIdProc IN NUMBER) RETURN NUMBER IS
        nIdProcDet DETALLE_TABLERO_CONTROL_DER.IdProcDet%TYPE;
    BEGIN
        SELECT NVL(MAX(IdProcDet),0) + 1
          INTO nIdProcDet
          FROM DETALLE_TABLERO_CONTROL_DER
         WHERE CodCia = nCodCia
           AND IdProc = nIdProc;
        RETURN nIdProcDet;
    END NUMERO_PROCESO;
    

    PROCEDURE INSERTAR (nCodcia IN NUMBER, nIdProc IN NUMBER, cIdReferencia IN VARCHAR2, cTipoComprob IN VARCHAR2,
                        cCuenta IN VARCHAR2, cNivelAUx IN VARCHAR2, cMovDebCred IN VARCHAR2, nMtoMovCuentaLocal IN NUMBER,
                        nMtoMovCuentaMoneda IN NUMBER, cRespuesta IN VARCHAR2, cError IN VARCHAR2, nIdmizar IN NUMBER,
                        cTipoDiario IN VARCHAR2, cCODCENTROCOSTO IN VARCHAR2, cCODUNIDADNEGOCIO IN VARCHAR2, cDESCCPTOGENERAL IN VARCHAR2, 
                        cCODMONEDA IN VARCHAR2, nIdProcDeta OUT NUMBER) IS
        nIdProcDet DETALLE_TABLERO_CONTROL_DER.IdProcDet%TYPE;
        
    BEGIN
        nIdProcDet := GT_DETALLE_TABLERO_CONTROL_DER.NUMERO_PROCESO(nCodcia, nIdProc);
        INSERT INTO DETALLE_TABLERO_CONTROL_DER (CodCia, IdProc, IdProcDet, TipoComprob, 
                                                Cuenta, NivelAux, MovDebCred, MtoMovCuentaLocal, 
                                                MtoMovCuentaMoneda, IdReferencia, Respuesta, Error, 
                                                IdMizar, StsGrupo, FechaSts, CodUsuario,
                                                TipoDiario, CODCENTROCOSTO, CODUNIDADNEGOCIO, DESCCPTOGENERAL, CODMONEDA)
                                        VALUES (nCodcia, nIdProc, nIdProcDet, cTipoComprob, 
                                                cCuenta, cNivelAux, cMovDebCred, nMtoMovCuentaLocal, 
                                                nMtoMovCuentaMoneda, cIdReferencia, cRespuesta, cError, 
                                                nIdmizar, 'XPROC', TRUNC(SYSDATE), USER,
                                                cTipoDiario, cCODCENTROCOSTO, cCODUNIDADNEGOCIO, cDESCCPTOGENERAL, cCODMONEDA);
        nIdProcDeta :=  nIdProcDet;  
    END INSERTAR;
    
    PROCEDURE MARCAR_DERIVADO(nCodCia IN NUMBER, nIdProc IN NUMBER, nIdProcDet IN NUMBER, nIdmizar IN NUMBER) IS
    BEGIN 
        UPDATE DETALLE_TABLERO_CONTROL_DER
           SET IdMizar      = nIdmizar, 
               StsGrupo     = 'DERIVA', 
               FechaSts     = TRUNC(SYSDATE), 
               CodUsuario   = USER
         WHERE CodCia       = nCodCia
           AND IdProc       = nIdProc
           AND IdProcDet    = nIdProcDet;
    END MARCAR_DERIVADO;
    
    PROCEDURE MARCAR_PROCESADO(nCodCia IN NUMBER, nIdProc IN NUMBER) IS
    BEGIN 
        UPDATE DETALLE_TABLERO_CONTROL_DER
           SET StsGrupo     = 'PROCSR',
               CodUsuario   = USER,
               FechaSts     = TRUNC(SYSDATE)
         WHERE CodCia       = nCodCia
           AND IdProc       = nIdProc;
    END MARCAR_PROCESADO;
    
    PROCEDURE MARCAR_ERRORES(nCodCia IN NUMBER, nIdProc IN NUMBER, nIdProcDet IN NUMBER, cError VARCHAR2) IS
    BEGIN 
        UPDATE DETALLE_TABLERO_CONTROL_DER
           SET StsGrupo     = 'ERRDER',
               CodUsuario   = USER,
               FechaSts     = TRUNC(SYSDATE),
               Error        = cError
         WHERE CodCia       = nCodCia
           AND IdProc       = nIdProc
           AND IdProcDet    = nIdProcDet;
    END MARCAR_ERRORES;
    
    PROCEDURE REVERTIR(nCodCia IN NUMBER, nIdProc IN NUMBER) IS
    BEGIN
      UPDATE DETALLE_TABLERO_CONTROL_DER
           SET StsGrupo     = 'DERREV',
               CodUsuario   = USER,
               FechaSts     = TRUNC(SYSDATE)
         WHERE CodCia       = nCodCia
           AND IdProc       = nIdProc;
    END;

   FUNCTION  NUMERO_PROCESO_TIPO_DIARIO(nCodCia IN NUMBER, dFecComprob DATE, cTipoDiario VARCHAR2, cTipoComprob VARCHAR2) RETURN NUMBER IS
      nIdProc DETALLE_TABLERO_CONTROL_DER.IdProc%TYPE;
   BEGIN
      BEGIN
         SELECT DISTINCT T.IdProc
           INTO nIdProc
           FROM DETALLE_TABLERO_CONTROL_DER D, TABLERO_CONTROL_DERIVA T
          WHERE D.CodCia            = nCodCia
            AND D.TipoComprob       = cTipoComprob
            AND D.TipoDiario        = cTipoDiario
            AND T.FechProc          = dFecComprob
            AND T.StsProceso   NOT IN ('DERREV','ERRDER')
            AND D.CodCia            = T.CodCia
            AND D.IdProc            = T.IdProc;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            nIdProc := 0;
         WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-2000,'Existe más de un proceso de derivación activo o pendiente de respusta de MIZAR para el tipo comprobante '||cTipoComprob||' con fecha '||TO_CHAR(dFecComprob,'DD/MM/YYYY'));
      END;
      RETURN nIdProc;
   END NUMERO_PROCESO_TIPO_DIARIO;
END GT_DETALLE_TABLERO_CONTROL_DER;
