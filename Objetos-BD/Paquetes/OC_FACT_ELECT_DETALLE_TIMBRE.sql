CREATE OR REPLACE PACKAGE          OC_FACT_ELECT_DETALLE_TIMBRE IS
   FUNCTION NUMERO_TIMBRE(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER;
   FUNCTION EXISTE_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                           nIdNcr NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;
   FUNCTION UUID_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                        nIdNcr NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2;
   FUNCTION FOLIO_FISCAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                         nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2;
   FUNCTION SERIE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                  nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2;
   PROCEDURE ASIGNA_STATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTimbre NUMBER,
                           nIdFactura NUMBER, nIdNcr NUMBER, cCodRespuestaSAT VARCHAR2);
   PROCEDURE INSERTA_DETALLE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER ,
                             nIdNcr NUMBER , cCodProceso VARCHAR2, cUuid VARCHAR2,
                             dFechaUuid DATE, cFolioFiscal VARCHAR2, cSerie VARCHAR2,
                             cCodRespuestaSat VARCHAR2,cUuidCancelado VARCHAR2, 
                             cCve_MotivCancFact VARCHAR2, -- cUuidRelacionado   VARCHAR2, --> 24/01/2022 JALV(+)
                             pIdTimbre   OUT NUMBER,
                             cUUID_SUSTITUYE IN VARCHAR2,
                             cCodigoResp IN VARCHAR2 DEFAULT NULL,
                             cDescResp   IN VARCHAR2 DEFAULT NULL,
                             cFechaResp  IN DATE     DEFAULT NULL
);
   PROCEDURE ACTUALIZA_DETALLE(nCodCia NUMBER,         nCodEmpresa NUMBER, nIdTimbre NUMBER, 
                            cCodProceso VARCHAR2,   cUuid VARCHAR2,   dFECHAUUID DATE,  cCodRespuestaSat VARCHAR2,
                            cUuidCancelado VARCHAR2);
   FUNCTION EXISTE_UUID_CANCELADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER ,
                             nIdNcr NUMBER , cUuidCancelado VARCHAR2) RETURN VARCHAR2;

   PROCEDURE REPORTE_CONCILIACION (cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                            cCodMoneda VARCHAR2, cCodAgente VARCHAR2, DFECDESDE IN DATE, DFECHASTA IN DATE, CURSOR_BASE OUT SYS_REFCURSOR);

   FUNCTION UUIDRELACIONADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                  nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2;
END OC_FACT_ELECT_DETALLE_TIMBRE;

/
create or replace PACKAGE BODY          OC_FACT_ELECT_DETALLE_TIMBRE IS

FUNCTION NUMERO_TIMBRE(nCodCia NUMBER, nCodEmpresa NUMBER) RETURN NUMBER IS
nIdTimbre       FACT_ELECT_DETALLE_TIMBRE.IdTimbre%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdTimbre),0) + 1
        INTO nIdTimbre
        FROM FACT_ELECT_DETALLE_TIMBRE
       WHERE CodCia      = nCodCia
         AND CodEmpresa  = nCodEmpresa;
   EXCEPTION
       WHEN NO_DATA_FOUND THEN
           nIdTimbre := 1;
   END;
   RETURN(nIdTimbre);
END NUMERO_TIMBRE;

FUNCTION EXISTE_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                        nIdNcr NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
nIdPoliza               POLIZAS.IdPoliza%TYPE;   
cIndFactElectronica     FACTURAS.IndFactElectronica%TYPE;                     
cExiste                 VARCHAR2(1);
BEGIN
   IF nIdFactura IS NOT NULL THEN
      SELECT IndFactElectronica,IdPoliza
        INTO cIndFactElectronica,nIdPoliza
        FROM FACTURAS
       WHERE CodCia     = nCodCia
         AND IdFactura  = nIdFactura;
   ELSIF nIdNcr IS NOT NULL THEN
      SELECT IndFactElectronica,IdPoliza
        INTO cIndFactElectronica,nIdPoliza
        FROM NOTAS_DE_CREDITO
       WHERE CodCia     = nCodCia
         AND IdNcr      = nIdNcr;
   END IF;

   IF OC_POLIZAS.FACTURA_ELECTRONICA(nCodCia, nCodEmpresa, nIdPoliza) = 'S' THEN
      IF cIndFactElectronica = 'S' THEN 
         IF cCodProceso = 'CAN' THEN
             BEGIN
                 SELECT 'S'
                  INTO cExiste
                  FROM FACT_ELECT_DETALLE_TIMBRE
                 WHERE CodCia       = nCodCia
                   AND CodEmpresa   = nCodEmpresa
                   AND CodProceso   = cCodProceso
                   AND CodRespuestaSat = '201'
                   AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
                   AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cExiste := 'N';
                WHEN TOO_MANY_ROWS THEN
                   cExiste := 'S';
             END;
         ELSE
             BEGIN
                SELECT 'S'
                  INTO cExiste
                  FROM FACT_ELECT_DETALLE_TIMBRE
                 WHERE CodCia       = nCodCia
                   AND CodEmpresa   = nCodEmpresa
                   AND CodProceso   = cCodProceso
                   AND UUID        IS NOT NULL
                   AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
                   AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0);
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cExiste := 'N';
                WHEN TOO_MANY_ROWS THEN
                   cExiste := 'S';
             END;
         END IF;
      ELSE
         cExiste := 'S';
      END IF;
   ELSE
      cExiste := 'S';
   END IF;
   RETURN(cExiste);
END EXISTE_PROCESO;

FUNCTION UUID_PROCESO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                      nIdNcr NUMBER, cCodProceso VARCHAR2) RETURN VARCHAR2 IS
cUUID      FACT_ELECT_DETALLE_TIMBRE.UUID%TYPE;
BEGIN
   BEGIN
      SELECT UUID
        INTO cUUID
        FROM FACT_ELECT_DETALLE_TIMBRE
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
         AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0)
         AND CodProceso   = cCodProceso
         AND UUID        IS NOT NULL
         AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_UUID_CANCELADO(nCodCia, nCodEmpresa, nIdFactura, nIdNcr, UUID) = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cUUID := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existe Varios Registros UUID para CodProceso '|| cCodProceso);
   END;
   RETURN(cUUID);
END UUID_PROCESO;

FUNCTION FOLIO_FISCAL(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                      nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2 IS
cFolioFiscal      FACT_ELECT_DETALLE_TIMBRE.FolioFiscal%TYPE;
BEGIN
   BEGIN
      SELECT FolioFiscal
        INTO cFolioFiscal
        FROM FACT_ELECT_DETALLE_TIMBRE
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
         AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0)
         AND UUID         = cUUID;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cFolioFiscal := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existe Varios Registros de Folio Fiscal para UUID '|| cUUID);
   END;
   RETURN(cFolioFiscal);
END FOLIO_FISCAL;

FUNCTION SERIE(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                      nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2 IS
cSerie      FACT_ELECT_DETALLE_TIMBRE.Serie%TYPE;
BEGIN
   BEGIN
      SELECT Serie
        INTO cSerie
        FROM FACT_ELECT_DETALLE_TIMBRE
       WHERE CodCia       = nCodCia
         AND CodEmpresa   = nCodEmpresa
         AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
         AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0)
         AND UUID         = cUUID;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cSerie := NULL;
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existe Varios Registros de Serie para UUID '|| cUUID);
   END;
   RETURN(cSerie);
END SERIE;

PROCEDURE ASIGNA_STATUS(nCodCia NUMBER, nCodEmpresa NUMBER, nIdTimbre NUMBER,
                        nIdFactura NUMBER, nIdNcr NUMBER, cCodRespuestaSAT VARCHAR2) IS
cStsTimbre     FACT_ELECT_DETALLE_TIMBRE.StsTimbre%TYPE;
BEGIN
   IF cCodRespuestaSAT = OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') THEN
      cStsTimbre := 'TIMBRE';
   ELSE
      cStsTimbre := 'ERROR';
   END IF;

   UPDATE FACT_ELECT_DETALLE_TIMBRE
      SET StsTimbre = cStsTimbre,
          FecStatus = TRUNC(SYSDATE),
          CodUsuario= USER
    WHERE CodCia       = nCodCia
      AND CodEmpresa   = nCodEmpresa
      AND IdTimbre     = nIdTimbre
      AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
      AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0);
END ASIGNA_STATUS;


PROCEDURE INSERTA_DETALLE(nCodCia NUMBER,   
                          nCodEmpresa NUMBER,     
                          nIdFactura NUMBER ,
                          nIdNcr NUMBER ,   
                          cCodProceso VARCHAR2,   
                          cUuid VARCHAR2,
                          dFechaUuid DATE,  
                          cFolioFiscal VARCHAR2,  
                          cSerie VARCHAR2,
                          cCodRespuestaSat VARCHAR2,
                          cUuidCancelado VARCHAR2,
                          cCve_MotivCancFact VARCHAR2, 
                          pIdTimbre   OUT NUMBER,
                          cUUID_SUSTITUYE IN VARCHAR2,
                          cCodigoResp IN VARCHAR2 DEFAULT NULL,
                          cDescResp   IN VARCHAR2 DEFAULT NULL,
                          cFechaResp  IN DATE     DEFAULT NULL
                          ) IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   nIdTimbre   NUMBER;
   cStsTimbre  FACT_ELECT_DETALLE_TIMBRE.StsTimbre%TYPE;
BEGIN
    nIdTimbre := OC_FACT_ELECT_DETALLE_TIMBRE.NUMERO_TIMBRE(nCodCia, nCodEmpresa);
    IF cCodRespuestaSAT = OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') THEN
      cStsTimbre := 'TIMBRE';
    ELSE
      cStsTimbre := 'ERROR';
    END IF;
    INSERT INTO FACT_ELECT_DETALLE_TIMBRE (CodCia, CodEmpresa, IdTimbre, IdFactura, IdNcr,
                                          CodProceso, 
                                          Uuid, 
                                          FechaUuid, FolioFiscal, Serie,
                                          CodRespuestaSat, StsTimbre, FecStatus, CodUsuario,
                                          UuidCancelado
                                          ,Cve_MotivCancFact,--, UUIDReracionado --> 24/01/2022 JALV(+)
                                          UUIDRELACIONADO,
                                          SAT_CODRESPUESTAOPC,
                                          SAT_DESRESPUESTAOPC,
                                          SAT_FECRESPUESTAOPC
                                          )
         VALUES (nCodCia, nCodEmpresa, nIdTimbre, nIdFactura, nIdNcr,
                 cCodProceso, 
                 cUuid, 
                 dFechaUuid, cFolioFiscal, cSerie,
                 cCodRespuestaSat, cStsTimbre, TRUNC(SYSDATE), USER,
                 cUuidCancelado
                 ,cCve_MotivCancFact,    --, cUuidRelacionado, --> 24/01/2022 JALV(+)
                 cUUID_SUSTITUYE,
                 cCodigoResp,
                 cDescResp,
                 cFechaResp
                 );
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20200,'Error al insertar detalle timbre: '||SQLERRM);
    END IF;
    pIdTimbre := nIdTimbre;
    COMMIT;
END INSERTA_DETALLE;

PROCEDURE ACTUALIZA_DETALLE(nCodCia NUMBER,         nCodEmpresa NUMBER, nIdTimbre NUMBER, 
                            cCodProceso VARCHAR2,   cUuid VARCHAR2,   dFECHAUUID DATE,  cCodRespuestaSat VARCHAR2,
                            cUuidCancelado VARCHAR2) IS
    cStsTimbre  FACT_ELECT_DETALLE_TIMBRE.StsTimbre%TYPE;
BEGIN
    IF cCodRespuestaSAT = OC_GENERALES.BUSCA_PARAMETRO(nCodCia, '026') THEN
      cStsTimbre := 'TIMBRE';
    ELSE
      cStsTimbre := 'ERROR';
    END IF;
    UPDATE FACT_ELECT_DETALLE_TIMBRE  F SET     
            CODPROCESO    = cCodProceso,
            UUID          = cUuid,
            FECHAUUID     = dFECHAUUID,
            CODRESPUESTASAT = cCodRespuestaSat,
            STSTIMBRE       = cStsTimbre,
            UUIDCANCELADO = cUuidCancelado,
            FecStatus    = TRUNC(SYSDATE),
            CodUsuario   = USER
    WHERE  CODCIA       = nCodCia
      AND  CODEMPRESA   = nCodEmpresa
      AND  IDTIMBRE     = nIdTimbre;

END ACTUALIZA_DETALLE;


FUNCTION EXISTE_UUID_CANCELADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER ,
                             nIdNcr NUMBER , cUuidCancelado VARCHAR2) RETURN VARCHAR2 IS
   cExiste        VARCHAR2(1) := 'N';
BEGIN
   BEGIN
   SELECT 'S'
     INTO cExiste
     FROM FACT_ELECT_DETALLE_TIMBRE
    WHERE CodCia        = nCodCia
      AND CodEmpresa    = nCodEmpresa
      AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
      AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0)
      AND UuidCancelado = cUuidCancelado;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20200,'Existe Más de Una Cnacelación Para UUID '|| cUuidCancelado);
   END;
   RETURN cExiste;
END EXISTE_UUID_CANCELADO;

PROCEDURE REPORTE_CONCILIACION (cIdTipoSeg VARCHAR2, cPlanCob VARCHAR2,
                           cCodMoneda VARCHAR2, cCodAgente VARCHAR2, DFECDESDE IN DATE, DFECHASTA IN DATE,CURSOR_BASE OUT SYS_REFCURSOR) IS

BEGIN 


    OPEN CURSOR_BASE FOR
    SELECT 
        PROCESO,
        IDPOLIZA,
        NUMPOLUNICO,
        FEC_EMI_POL,
        FECINIVIG,
        FECFINVIG,
        CONTRATANTE,
        TIPO_SEG,
        DESCSUBRAMO,
        ENDOSO,
        TIPO_RECIBO,
        NUM_RECIBO,
        NUMCUOTA,
        FORMPAGO,
        FECEMISION,
        FECANUL,
        FECHA_CONTA,
        FECINIVIGFAC,
        FECFINVIGFAC,
        STSFACT,
        MOTIVANUL,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN PRIMA_NETA ELSE 0 END        * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))   PRIMA_NETA,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN RECARGOS ELSE 0 END          * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))  RECARGOS,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN DERECHO_POLIZA ELSE 0 END    * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))  DERECHO_POLIZA,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN IMPUESTOS ELSE 0 END         * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))   IMPUESTOS,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN SUBTOTAL ELSE 0 END          * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))   SUBTOTAL,
        CASE WHEN PROCFISCAL = 'EMI' AND FOLIOFISCAL_ANT IS NULL THEN PRIMA_TOTAL ELSE 0 END       * DECODE(PROCESO,' EMISION', 1,  DECODE(STSFACT, 'ANU', -1, 'SUS', -1, 1))   PRIMA_TOTAL,
        COD_AGENTE,
        COD_MONEDA,
        PROCFISCAL,
        FOLIOFACTELEC,
        FOLIOFISCAL,                
        --FOLIOFISCAL_ANT,
        SERIE,
        UUID,
        FECHAUUID,
        STSTIMBRE,
        UUIDCANCELADO,
        TIMBRES_CANCELADOS
from (
SELECT    
        BASE.QRY,
        CASE WHEN NVL(NVL(TNC.STSTIMBRE,       TIM.STSTIMBRE), 'VACIA') = 'ERROR' THEN 'ERROR' ELSE  CASE WHEN BASE.QRY IN (1,2,3) AND MAX(NVL(TNC.UUIDCANCELADO,   TIM.UUIDCANCELADO)) IS NULL  THEN ' EMISION' ELSE 'ANULACION' END END PROCESO,
        BASE.IDPOLIZA,                     
        BASE.NUMPOLUNICO,        
        BASE.FEC_EMI_POL,                              
        BASE.FECINIVIG,
        BASE.FECFINVIG,
        BASE.CONTRATANTE,
        BASE.IDTIPOSEG          TIPO_SEG, --|| '-' || BASE.PlanCob PLAN,                     
        BASE.DESCSUBRAMO,
        NVL(BASE.IDENDOSO, 0) ENDOSO,                     
        BASE.TIPO_RECIBO,
        BASE.IDFACTURA          NUM_RECIBO,
        BASE.NUMCUOTA,                     
        DECODE(BASE.TIPO_RECIBO, 'NC', NULL, OC_FACTURAS.FRECUENCIA_PAGO(BASE.CODCIA, BASE.IDFACTURA)) FORMPAGO,
        BASE.FECEMISION   FECEMISION,                                                
        BASE.FECANUL,       
        BASE.FECCONTABILIZADA   FECHA_CONTA,
        BASE.FECINIVIGFAC,
        BASE.FECFINVIGFAC,
        BASE.STSFACT,
        BASE.MOTIVANUL,
         SUM(CASE WHEN (NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='S' OR  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='S')                                                                                                            THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END)   * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END    PRIMA_NETA,           
        --
         SUM(CASE WHEN  NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N' AND NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='N'  AND  NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)     = 'N' AND NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG)='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END)   * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END    RECARGOS,           
        --
         SUM(CASE WHEN  NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG) ='S' AND NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N'  AND  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) = 'N' AND NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)    ='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END)   * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END    DERECHO_POLIZA,           
         --
         SUM(CASE WHEN  NVL(C.INDESIMPUESTO,   CNC.INDESIMPUESTO)   ='S'                                                                                                                                                                  THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END)   * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END    IMPUESTOS,                  
        --SUM(CASE WHEN NVL(C.IndCptoServicio, CNC.IndCptoServicio) ='S' THEN D.Monto_Det_Moneda ELSE 0 END) Monto_Moneda_Servicio
        (SUM(CASE WHEN (NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='S' OR  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='S')                                                                                                            THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END) +
         SUM(CASE WHEN  NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N' AND NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='N'  AND  NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)     = 'N' AND NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG)='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END) +           
         SUM(CASE WHEN  NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG) ='S' AND NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N'  AND  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) = 'N' AND NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)    ='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END))  * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END   SUBTOTAL,
         --           
        (SUM(CASE WHEN (NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='S' OR  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='S')                                                                                                            THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END) +
         SUM(CASE WHEN  NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N' AND NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) ='N'  AND  NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)     = 'N' AND NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG)='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END) +           
         SUM(CASE WHEN  NVL(C.INDRANGOSTIPSEG, CNC.INDRANGOSTIPSEG) ='S' AND NVL(C.INDCPTOPRIMAS,   CNC.INDCPTOPRIMAS)   ='N'  AND  NVL(C.INDCPTOSERVICIO, CNC.INDCPTOSERVICIO) = 'N' AND NVL(C.INDESIMPUESTO, CNC.INDESIMPUESTO)    ='N' THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END) +
         SUM(CASE WHEN (NVL(C.INDESIMPUESTO,   CNC.INDESIMPUESTO)   ='S' )                                                                                                                                                                THEN NVL(D.MONTO_DET_MONEDA, DNC.MONTO_DET_MONEDA) ELSE 0 END))  * CASE WHEN BASE.QRY  IN (1,2,3) THEN 1 ELSE -1 END  PRIMA_TOTAL,
         --         
       (SELECT MAX(COM.COD_AGENTE)
             FROM COMISIONES       COM INNER JOIN DETALLE_COMISION DCO  ON  COM.CODCIA     = DCO.CODCIA 
                                                                        AND COM.IDCOMISION = DCO.IDCOMISION
                                                                        AND DCO.CODCONCEPTO IN ('HONORA','COMISI','COMIPF','COMIPM','UDI') 
                                       INNER JOIN AGENTES          AGE  ON  AGE.COD_AGENTE = COM.COD_AGENTE
                                                                        AND AGE.CODNIVEL   = 3
            WHERE COM.IDPOLIZA   = BASE.IDPOLIZA
              AND DECODE(BASE.TIPO_RECIBO, 'NC', COM.IDNCR, COM.IDFACTURA)   =  BASE.IDFACTURA) COD_AGENTE,        
        BASE.COD_MONEDA,
        NVL(TNC.CODPROCESO,     TIM.CODPROCESO)      PROCFISCAL, 
        BASE.FOLIOFACTELEC,                
        NVL(TNC.FOLIOFISCAL,     TIM.FOLIOFISCAL)    FOLIOFISCAL,
        (SELECT MIN(FOLIOFISCAL) 
           FROM FACT_ELECT_DETALLE_TIMBRE FT 
          WHERE FT.CODCIA       = CODCIA 
            AND FT.CODEMPRESA   = CODEMPRESA 
            AND (FT.IDFACTURA    = DECODE(BASE.TIPO_RECIBO, 'NC', NULL, BASE.IDFACTURA ) 
            OR  FT.IDNCR        = DECODE(BASE.TIPO_RECIBO, 'NC', BASE.IDFACTURA , NULL))  
            AND FT.FOLIOFISCAL <  NVL(TNC.FOLIOFISCAL,     TIM.FOLIOFISCAL)
            AND FT.CODRESPUESTASAT = '201'
             )  FOLIOFISCAL_ANT,        
        NVL(TNC.SERIE,           TIM.SERIE)          SERIE,
        NVL(TNC.UUID,            TIM.UUID)           UUID,
        NVL(TNC.FECHAUUID,       TIM.FECHAUUID)      FECHAUUID,
        NVL(TNC.STSTIMBRE,       TIM.STSTIMBRE)      STSTIMBRE,
        NVL(TNC.UUIDCANCELADO,   TIM.UUIDCANCELADO)  UUIDCANCELADO,        
        CASE WHEN NVL(TNC.UUID, TIM.UUID) IS NOT NULL THEN (
        NVL((SELECT COUNT(1) FROM FACT_ELECT_DETALLE_TIMBRE WHERE CODCIA        = BASE.CODCIA 
                                                              AND CODEMPRESA    = BASE.CODEMPRESA 
                                                              AND DECODE(BASE.TIPO_RECIBO, 'NC', IDNCR, IDFACTURA)     =  BASE.IDFACTURA                                                               
                                                              AND UUIDCANCELADO = NVL(NVL(TNC.UUID, TIM.UUID), 'X')
                                                              ), 0)) ELSE CASE WHEN NVL(TNC.UUIDCANCELADO,   TIM.UUIDCANCELADO) IS NOT NULL THEN 1 ELSE 0 END END TIMBRES_CANCELADOS
FROM (
            SELECT QRY,
                   NUMPOLUNICO,               
                   IDPOLIZA, 
                   FEC_EMI_POL,
                   TO_CHAR(FECINIVIG,'DD/MM/YYYY') FECINIVIG, 
                   TO_CHAR(FECFINVIG,'DD/MM/YYYY') FECFINVIG,
                   CONTRATANTE,            
                   IDTIPOSEG,              
                   PLANCOB, 
                   CODTIPOPLAN,            
                   DESCSUBRAMO,
                   IDENDOSO, 
                   TIPO_RECIBO,
                   IDFACTURA,
                   NUMCUOTA,              
                   MULTI,
                   COD_MONEDA,
                   FORMPAGO,              
                   FECHATRANSACCION,
                   TRUNC(FECEMISION) FECEMISION,               
                   FECANUL,       
                   FECCONTABILIZADA, 
                   FECINIVIGFAC,
                   FECFINVIGFAC,
                   STSFACT,
                   MOTIVANUL,
                   COD_AGENTE,
                   FOLIOFACTELEC,              
                   CODCIA,
                   CODEMPRESA
            FROM 
            (       
               SELECT 1 QRY,
                      P.NUMPOLUNICO,
                      P.IDPOLIZA,       
                      P.FECEMISION FEC_EMI_POL,                          
                      P.FECINIVIG, 
                      P.FECFINVIG,                     
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' || OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                      DP.IDTIPOSEG, 
                      DP.PLANCOB,                      
                      PC.CODTIPOPLAN,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                      F.IDENDOSO,                                
                     'RECIBO'              TIPO_RECIBO,           
                      F.IDFACTURA, 
                      F.NUMCUOTA,                      
                      F.COD_MONEDA,
                      F.CODPLANPAGO FORMPAGO,                    
                      T.FECHATRANSACCION,       
                      T.FECHATRANSACCION FECEMISION,                      
                      F.FECANUL,          
                      F.FECCONTABILIZADA, 
                      F.FECVENC         FECINIVIGFAC,
                      F.FECFINVIG       FECFINVIGFAC,
                      F.STSFACT,
                      F.MOTIVANUL,
                      P.COD_AGENTE,
                      F.FOLIOFACTELEC,                    
                      P.CODCIA,
                      P.CODEMPRESA,
                      1 MULTI
                 FROM FACTURAS        F, 
                      TRANSACCION     T, 
                      POLIZAS         P, 
                      DETALLE_POLIZA  DP, 
                      PLAN_COBERTURAS PC
                WHERE PC.PLANCOB                 = DP.PLANCOB
                  AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                  AND PC.CODEMPRESA              = DP.CODEMPRESA
                  AND PC.CODCIA                  = DP.CODCIA
                  AND DP.CODCIA                  = F.CODCIA
                  AND DP.IDETPOL                 = F.IDETPOL
                  AND DP.IDPOLIZA                = F.IDPOLIZA
                  AND P.CODCIA                   = F.CODCIA
                  AND P.IDPOLIZA                 = F.IDPOLIZA
                  AND P.CODEMPRESA               = T.CODEMPRESA
                  AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))                  
                  AND T.IDPROCESO               IN (7, 8, 14, 18, 21) -- Emisión, Endosos, Contabilizacion y Rehabilitaciones
                  AND T.IDTRANSACCION          = F.IDTRANSACCION 
                  AND F.IDTRANSACCONTAB IS NULL
            UNION
                  SELECT 2 QRY,
                      P.NUMPOLUNICO,
                      P.IDPOLIZA,                                 
                      P.FECEMISION FEC_EMI_POL,                          
                      P.FECINIVIG, 
                      P.FECFINVIG,                     
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' || OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                      DP.IDTIPOSEG, 
                      DP.PLANCOB,                      
                      PC.CODTIPOPLAN,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                      F.IDENDOSO,                                
                     'RECIBO'              TIPO_RECIBO,           
                      F.IDFACTURA, 
                      F.NUMCUOTA,                      
                      F.COD_MONEDA,
                      F.CODPLANPAGO FORMPAGO,                    
                      T.FECHATRANSACCION,       
                      T.FECHATRANSACCION FECEMISION,                      
                      F.FECANUL,          
                      F.FECCONTABILIZADA, 
                      F.FECVENC         FECINIVIGFAC,
                      F.FECFINVIG       FECFINVIGFAC,
                      F.STSFACT,
                      F.MOTIVANUL,
                      P.COD_AGENTE,
                      F.FOLIOFACTELEC,                    
                       P.CODCIA,
                       P.CODEMPRESA,
                      1 MULTI
                 FROM FACTURAS        F, 
                      TRANSACCION     T, 
                      POLIZAS         P, 
                      DETALLE_POLIZA  DP, 
                      PLAN_COBERTURAS PC
                WHERE PC.PLANCOB                 = DP.PLANCOB
                  AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                  AND PC.CODEMPRESA              = DP.CODEMPRESA
                  AND PC.CODCIA                  = DP.CODCIA
                  AND DP.CODCIA                  = F.CODCIA
                  AND DP.IDETPOL                 = F.IDETPOL
                  AND DP.IDPOLIZA                = F.IDPOLIZA
                  AND P.CODCIA                   = F.CODCIA
                  AND P.IDPOLIZA                 = F.IDPOLIZA
                  AND P.CODEMPRESA               = T.CODEMPRESA
                  AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))                  
                  AND T.IDPROCESO               IN (7, 8, 14, 18, 21) -- Emisión, Endosos, Contabilizacion y Rehabilitaciones
                  AND T.IDTRANSACCION           = F.IDTRANSACCONTAB
            UNION ALL
            SELECT 3 QRY,
                      P.NUMPOLUNICO,
                      P.IDPOLIZA,                 
                      P.FECEMISION FEC_EMI_POL,                          
                      P.FECINIVIG, 
                      P.FECFINVIG,               
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                      DP.IDTIPOSEG,
                      DP.PLANCOB,                
                      PC.CODTIPOPLAN,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                      F.IDENDOSO,       
                      'NC'              TIPO_RECIBO,         
                      F.IDNCR           IDFACTURA,           
                      NULL              NUMCUOTA,
                      F.CODMONEDA       COD_MONEDA,
                      NULL              FORMPAGO,      
                      T.FECHATRANSACCION,
                      T.FECHATRANSACCION  FECEMISION,        
                      F.FECANUL,          
                      T.FECHATRANSACCION FECCONTABILIZADA,
                      F.FECDEVOL         FECINIVIGFAC,   ----REVISAR ESTA FECHA
                      F.FECFINVIG        FECFINVIGFAC,
                      F.STSNCR STSFACT,          
                      F.MOTIVANUL,
                      P.COD_AGENTE,
                      F.FOLIOFACTELEC,
                      P.CODCIA,
                      P.CODEMPRESA,
                      1 MULTI
                 FROM NOTAS_DE_CREDITO F, 
                      TRANSACCION      T, 
                      POLIZAS          P, 
                      DETALLE_POLIZA   DP, 
                      PLAN_COBERTURAS  PC
                WHERE PC.PLANCOB                 = DP.PLANCOB
                  AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                  AND PC.CODEMPRESA              = DP.CODEMPRESA
                  AND PC.CODCIA                  = DP.CODCIA
                  AND DP.CODCIA                  = F.CODCIA
                  AND DP.IDETPOL                 = F.IDETPOL
                  AND DP.IDPOLIZA                = F.IDPOLIZA
                  AND P.CODCIA                   = F.CODCIA
                  AND P.IDPOLIZA                 = F.IDPOLIZA
                  AND P.CODEMPRESA               = T.CODEMPRESA
                  AND T.IDTRANSACCION            = F.IDTRANSACCIONANU
                  AND T.IDPROCESO               IN (2, 8)   -- Anulaciones y Endoso
                  AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (F.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (F.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))            --- Anulados
            UNION ALL
               SELECT 4 QRY,
                      P.NUMPOLUNICO,
                      P.IDPOLIZA,                                 
                      P.FECEMISION FEC_EMI_POL,                          
                      P.FECINIVIG, 
                      P.FECFINVIG,                     
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' || OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                      DP.IDTIPOSEG, 
                      DP.PLANCOB,                      
                      PC.CODTIPOPLAN,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                      F.IDENDOSO,                                
                     'RECIBO'              TIPO_RECIBO,           
                      F.IDFACTURA, 
                      F.NUMCUOTA,                      
                      F.COD_MONEDA,
                      F.CODPLANPAGO FORMPAGO,                    
                      T.FECHATRANSACCION,       
                      T.FECHATRANSACCION FECEMISION,                      
                      F.FECANUL,          
                      F.FECCONTABILIZADA, 
                      F.FECVENC         FECINIVIGFAC,
                      F.FECFINVIG       FECFINVIGFAC,
                      F.STSFACT,
                      F.MOTIVANUL,
                      P.COD_AGENTE,
                      F.FOLIOFACTELEC,                    
                      P.CODCIA,
                      P.CODEMPRESA,
                      -1 MULTI
                 FROM FACTURAS        F, 
                      TRANSACCION     T, 
                      POLIZAS         P, 
                      DETALLE_POLIZA  DP, 
                      PLAN_COBERTURAS PC
                WHERE PC.PLANCOB                 = DP.PLANCOB
                  AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                  AND PC.CODEMPRESA              = DP.CODEMPRESA
                  AND PC.CODCIA                  = DP.CODCIA
                  AND DP.CODCIA                  = F.CODCIA
                  AND DP.IDETPOL                 = F.IDETPOL
                  AND DP.IDPOLIZA                = F.IDPOLIZA
                  AND P.CODCIA                   = F.CODCIA
                  AND P.IDPOLIZA                 = F.IDPOLIZA
                  AND P.CODEMPRESA               = T.CODEMPRESA
                  AND T.IDTRANSACCION            = F.IDTRANSACCIONANU
                  AND F.FECCONTABILIZADA        <= DFECHASTA 
                  AND F.INDCONTABILIZADA         = 'S'
                  AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.Cod_Moneda             = cCodMoneda AND cCodMoneda != '%')
       OR  (F.Cod_Moneda          LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.CodGenerador           = cCodAgente AND cCodAgente != '%')
       OR  (F.CodGenerador        LIKE cCodAgente AND cCodAgente = '%'))                    
                  AND F.STSFACT                  IN ('ANU','SUS')
                  AND F.IDFACTURA                > 0       
                  AND NOT EXISTS (SELECT 1 
                                    FROM FACTURAS        FF, 
                                         TRANSACCION     TF,
                                         FACT_ELECT_DETALLE_TIMBRE TIM                                         
                                   WHERE TRUNC(TF.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA   
                                     AND FF.IDTRANSACCION     = TF.IDTRANSACCION
                                     AND TIM.CODCIA          = FF.CODCIA
                                     AND TIM.CODEMPRESA      = TF.CODEMPRESA 
                                     AND TIM.IDFACTURA       = FF.IDFACTURA     
                                     AND TIM.CODRESPUESTASAT = OC_GENERALES.BUSCA_PARAMETRO(1, '026')      
                                     AND TIM.CODPROCESO      = 'EMI' 
                                     AND FF.IDFACTURA        = F.IDFACTURA 
                                     AND EXISTS (SELECT 1 
                                                   FROM FACTURAS        FFF, 
                                                        TRANSACCION     TFF,
                                                        FACT_ELECT_DETALLE_TIMBRE TIMF                                         
                                                WHERE TRUNC(TFF.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA   
                                                  AND FFF.IDTRANSACCION    = TFF.IDTRANSACCION
                                                  AND TIMF.CODCIA          = FFF.CODCIA
                                                  AND TIMF.CODEMPRESA      = TFF.CODEMPRESA 
                                                  AND TIMF.IDFACTURA       = FFF.IDFACTURA     
                                                  AND TIMF.CODRESPUESTASAT = OC_GENERALES.BUSCA_PARAMETRO(1, '026')      
                                                  AND TIMF.CODPROCESO      = 'CAN'                       
                                                  AND FFF.IDFACTURA        = FF.IDFACTURA ))                           
            UNION ALL
               SELECT 5 QRY,
                      P.NUMPOLUNICO,
                      P.IDPOLIZA,                 
                      P.FECEMISION FEC_EMI_POL,                          
                      P.FECINIVIG, 
                      P.FECFINVIG,               
                      OC_CLIENTES.NOMBRE_CLIENTE(P.CODCLIENTE) || ' ' ||OC_FILIALES.NOMBRE_ADICIONAL(P.CODCIA, P.CODGRUPOEC, DP.CODFILIAL) CONTRATANTE,
                      DP.IDTIPOSEG,
                      DP.PLANCOB,                
                      PC.CODTIPOPLAN,
                      OC_VALORES_DE_LISTAS.BUSCA_LVALOR('SUBRAMOS', PC.CODTIPOPLAN) DESCSUBRAMO,
                      F.IDENDOSO,       
                      'NC'              TIPO_RECIBO,         
                      F.IDNCR           IDFACTURA,           
                      NULL              NUMCUOTA,
                      F.CODMONEDA       COD_MONEDA,
                      NULL              FORMPAGO,      
                      T.FECHATRANSACCION,
                      T.FECHATRANSACCION  FECEMISION,        
                      F.FECANUL,          
                      T.FECHATRANSACCION FECCONTABILIZADA,
                      F.FECDEVOL         FECINIVIGFAC,   ----REVISAR ESTA FECHA
                      F.FECFINVIG        FECFINVIGFAC,
                      F.STSNCR STSFACT,          
                      F.MOTIVANUL,
                      P.COD_AGENTE,
                      F.FOLIOFACTELEC,
                      P.CODCIA,
                      P.CODEMPRESA,
                      -1 MULTI
                 FROM NOTAS_DE_CREDITO F, 
                      TRANSACCION      T, 
                      POLIZAS          P, 
                      DETALLE_POLIZA   DP, 
                      PLAN_COBERTURAS  PC
                WHERE PC.PLANCOB                 = DP.PLANCOB
                  AND PC.IDTIPOSEG               = DP.IDTIPOSEG
                  AND PC.CODEMPRESA              = DP.CODEMPRESA
                  AND PC.CODCIA                  = DP.CODCIA
                  AND DP.CODCIA                  = F.CODCIA
                  AND DP.IDETPOL                 = F.IDETPOL
                  AND DP.IDPOLIZA                = F.IDPOLIZA
                  AND P.CODCIA                   = F.CODCIA
                  AND P.IDPOLIZA                 = F.IDPOLIZA
                  AND P.CODEMPRESA               = T.CODEMPRESA
                  AND T.IDTRANSACCION            = F.IDTRANSACCION 
                  AND T.IDPROCESO               IN (2, 8, 18)   -- Anulaciones y Endoso
                  AND TRUNC(T.FECHATRANSACCION) BETWEEN DFECDESDE AND DFECHASTA
      AND ((DP.IdTipoSeg             = cIdTipoSeg AND cIdTipoSeg != '%')
       OR  (DP.IdTipoSeg          LIKE cIdTipoSeg AND cIdTipoSeg = '%'))
      AND ((DP.PlanCob               = cPlanCob AND cPlanCob != '%')
       OR  (DP.PlanCob            LIKE cPlanCob AND cPlanCob = '%'))
      AND ((F.CodMoneda              = cCodMoneda AND cCodMoneda != '%')
       OR  (F.CodMoneda           LIKE cCodMoneda AND cCodMoneda = '%'))
      AND ((F.Cod_Agente             = cCodAgente AND cCodAgente != '%')
       OR  (F.Cod_Agente          LIKE cCodAgente AND cCodAgente = '%'))
       ) )    BASE
       --------------------------------------------------------------------------------------------------------------------------------------
             LEFT JOIN FACTURAS                  F    ON F.IDFACTURA      = DECODE(BASE.TIPO_RECIBO, 'NC', NULL, BASE.IDFACTURA)
             LEFT JOIN DETALLE_FACTURAS          D    ON D.IDFACTURA      = F.IDFACTURA                             
             LEFT JOIN CATALOGO_DE_CONCEPTOS     C    ON C.CODCONCEPTO    = D.CODCPTO
                                                      AND C.CODCIA        = F.CODCIA
             LEFT  JOIN FACT_ELECT_DETALLE_TIMBRE TIM  ON TIM.CODCIA      = BASE.CODCIA
                                                      AND TIM.CODEMPRESA  = BASE.CODEMPRESA
                                                      AND TIM.IDFACTURA   = F.IDFACTURA
                                                      AND TIM.CODRESPUESTASAT = OC_GENERALES.BUSCA_PARAMETRO(1, '026')                                                       
       --------------------------------------------------------------------------------------------------------------------------------------
             LEFT  JOIN NOTAS_DE_CREDITO          FNC ON  FNC.IDNCR       = DECODE(BASE.TIPO_RECIBO, 'NC', BASE.IDFACTURA, NULL)
             LEFT  JOIN DETALLE_NOTAS_DE_CREDITO  DNC ON  DNC.IDNCR       = FNC.IDNCR                
             LEFT  JOIN CATALOGO_DE_CONCEPTOS     CNC ON  CNC.CODCONCEPTO = DNC.CODCPTO
                                                      AND CNC.CODCIA      = FNC.CODCIA 
             LEFT  JOIN FACT_ELECT_DETALLE_TIMBRE TNC  ON TNC.CODCIA      = BASE.CODCIA
                                                      AND TNC.CODEMPRESA  = BASE.CODEMPRESA
                                                      AND TNC.IDNCR       = FNC.IDNCR
                                                      AND TIM.CODRESPUESTASAT = OC_GENERALES.BUSCA_PARAMETRO(1, '026')
                                                      AND TNC.CODPROCESO = 'CAN'
    --WHERE BASE.IDPOLIZA = 24149
       --AND BASE.IDFACTURA = 220665
    GROUP BY BASE.QRY ,
        BASE.NUMPOLUNICO,        
        BASE.IDPOLIZA,   
        BASE.FEC_EMI_POL,                                            
        BASE.FECINIVIG,
        BASE.FECFINVIG,
        BASE.CONTRATANTE,
        BASE.IDTIPOSEG,                      
        BASE.DESCSUBRAMO,
        BASE.IDENDOSO,                     
        BASE.TIPO_RECIBO,
        BASE.IDFACTURA,
        BASE.NUMCUOTA,                     
        BASE.FECHATRANSACCION,                  
        BASE.FECEMISION,        
        BASE.FECANUL,       
        BASE.FECCONTABILIZADA,
        BASE.FECINIVIGFAC,
        BASE.FECFINVIGFAC,
        BASE.STSFACT,
        BASE.MULTI,
        BASE.MOTIVANUL,
        BASE.COD_AGENTE,
        BASE.COD_MONEDA,
        BASE.FOLIOFACTELEC,
        BASE.CODCIA,
        BASE.CODEMPRESA,
        NVL(TNC.CODPROCESO,     TIM.CODPROCESO), 
        NVL(TNC.FOLIOFISCAL,     TIM.FOLIOFISCAL)    ,
        NVL(TNC.SERIE,           TIM.SERIE)          ,
        NVL(TNC.UUID,            TIM.UUID)           ,
        NVL(TNC.FECHAUUID,       TIM.FECHAUUID)      ,
        NVL(TNC.STSTIMBRE,       TIM.STSTIMBRE)      ,
        NVL(TNC.UUIDCANCELADO,   TIM.UUIDCANCELADO)                
        ) base                                       
    ORDER BY NUMPOLUNICO,
             num_recibo,
             PROCESO,
             NUMCUOTA,
             FOLIOFACTELEC,
             FECEMISION,
             FECHAUUID,
             FOLIOFISCAL,
             SERIE;

    END REPORTE_CONCILIACION;
    --
    FUNCTION UUIDRELACIONADO(nCodCia NUMBER, nCodEmpresa NUMBER, nIdFactura NUMBER,
                          nIdNcr NUMBER, cUUID VARCHAR2) RETURN VARCHAR2 IS
    cUUIDRELACIONADO      FACT_ELECT_DETALLE_TIMBRE.UUIDRELACIONADO%TYPE;
    BEGIN
       BEGIN
          SELECT D.UUIDRELACIONADO
            INTO cUUIDRELACIONADO
            FROM FACT_ELECT_DETALLE_TIMBRE D
           WHERE CodCia       = nCodCia
             AND CodEmpresa   = nCodEmpresa
             AND NVL(IdFactura, 0)  = NVL(nIdFactura, 0)
             AND NVL(IdNcr, 0)      = NVL(nIdNcr, 0)
             AND UUID         = cUUID;
       EXCEPTION
          WHEN OTHERS THEN
             cUUIDRELACIONADO := NULL;
       END;
       RETURN(CUUIDRELACIONADO);
    END UUIDRELACIONADO;

END OC_FACT_ELECT_DETALLE_TIMBRE;
