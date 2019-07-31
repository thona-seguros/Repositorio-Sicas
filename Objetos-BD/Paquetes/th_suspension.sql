--
-- TH_SUSPENSION  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   POLIZAS (Table)
--   FACTURAS (Table)
--   DETALLE_POLIZA (Table)
--   DETALLE_SUSPENSION (Table)
--   ENDOSOS (Table)
--   OC_DETALLE_POLIZA (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   ASEGURADO_CERTIFICADO (Table)
--   ASISTENCIAS_ASEGURADO (Table)
--   ASISTENCIAS_DETALLE_POLIZA (Table)
--   BENEFICIARIO (Table)
--   NOTAS_DE_CREDITO (Table)
--   TRANSACCION (Table)
--   SUSPENSION (Table)
--   CLAUSULAS_DETALLE (Table)
--   CLAUSULAS_POLIZA (Table)
--   COBERTURAS (Table)
--   COBERTURA_ASEG (Table)
--   COBERT_ACT (Table)
--   COBERT_ACT_ASEG (Table)
--   OC_ENDOSO (Package)
--   OC_TRANSACCION (Package)
--   OC_ASEGURADO_CERTIFICADO (Package)
--   OC_ASISTENCIAS_ASEGURADO (Package)
--   OC_ASISTENCIAS_DETALLE_POLIZA (Package)
--   OC_BENEFICIARIO (Package)
--   OC_CLAUSULAS_POLIZA (Package)
--   OC_COBERT_ACT (Package)
--   OC_COBERT_ACT_ASEG (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.TH_SUSPENSION IS

PROCEDURE SUSPENDE_POLIZA(P_CODCIA       NUMBER,
                          P_CODEMPRESA   NUMBER,
                          P_IDPOLIZA     NUMBER);
--
PROCEDURE ANULA_SUSPENDIDA(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_ANULA        VARCHAR);
--
PROCEDURE REHABILITACION(nCodCia     NUMBER,
                         nCodEmpresa NUMBER,
                         nIdPoliza   NUMBER);
--
PROCEDURE REHABILITA_FACTURAS(nCodCia        NUMBER,
                              nCodEmpresa    NUMBER,
                              nIdFacturaAnu  NUMBER,
                              nIdTransaccion NUMBER);
--
PROCEDURE REHABILITA_NOTAS_DE_CREDITO(nCodCia        NUMBER,
                                      nCodEmpresa    NUMBER,
                                      nIdNcrAnu      NUMBER,
                                      nIdTransaccion NUMBER);
--
END TH_SUSPENSION;
/

--
-- TH_SUSPENSION  (Package Body) 
--
--  Dependencies: 
--   TH_SUSPENSION (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.TH_SUSPENSION IS
---
-- CREACION      12/10/2018                        -- JICO
-- MODIFICACION  14/11/2018
-- MODIFICACION  SE CAMBIO LA VALIDACION POR UPDATES DIRECTOS E INSERT POR FACTURA Y NO TRANSACCION  03/06/2019
-- MODIFICACION  DEL PROCEDURE REHABILITACION EN EL CURSOR FACT_Q SE AGREGO EL ROWNUM EN EL "ORDER BY" 13/06/2019  --MLJS
PROCEDURE SUSPENDE_POLIZA(P_CODCIA       NUMBER,
                          P_CODEMPRESA   NUMBER,
                          P_IDPOLIZA     NUMBER) IS
--
W_FECSTS                 POLIZAS.FECSTS%TYPE;
--
CURSOR DETALLE IS
 SELECT IDETPOL,     COD_ASEGURADO
   FROM DETALLE_POLIZA
  WHERE IDPOLIZA   = P_IDPOLIZA
    AND STSDETALLE = 'ANU'
    AND MOTIVANUL  = 'CAFP';
--
CURSOR ASEGURADO IS
 SELECT IDETPOL,     COD_ASEGURADO
   FROM ASEGURADO_CERTIFICADO
  WHERE IDPOLIZA       = P_IDPOLIZA
    AND CODCIA         = P_CODCIA
    AND ESTADO         = 'ANU'
    AND MOTIVANULEXCLU = 'CAFP';
--
CURSOR FACTURA IS
 SELECT IDETPOL,     IDFACTURA
   FROM FACTURAS F
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSFACT   = 'ANU'
    AND MOTIVANUL = 'CAFP'
    AND F.FECSTS  = W_FECSTS;
--
CURSOR NOTAS_CRED IS
 SELECT IDETPOL,     IDNCR
   FROM NOTAS_DE_CREDITO N
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSNCR    = 'ANU'
    AND MOTIVANUL = 'CAFP'
    AND N.FECSTS  = W_FECSTS;
--
CURSOR NOTAS_CRED_EMI IS
 SELECT IDETPOL,     IDNCR
   FROM NOTAS_DE_CREDITO N
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSNCR    = 'EMI'
    AND N.FECSTS  = W_FECSTS;
BEGIN
 --
 BEGIN
  SELECT P.FECSTS
    INTO W_FECSTS
    FROM POLIZAS P
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSPOLIZA = 'ANU'
    AND MOTIVANUL = 'CAFP';
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20225,'Error NO EXISTE Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error MAS DE UN REGISTRO Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error OTRO Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
 END;
 --
 FOR D IN DETALLE LOOP
     --
     UPDATE COBERTURAS
        SET STSCOBERTURA = 'SUS'
      WHERE CODCIA       = P_CODCIA
        AND IDPOLIZA     = P_IDPOLIZA
        AND IDETPOL      = D.IDETPOL
        AND STSCOBERTURA = 'ANU';
     --
     UPDATE COBERT_ACT
        SET STSCOBERTURA = 'SUS'
      WHERE CODCIA       = P_CODCIA
        AND IDPOLIZA     = P_IDPOLIZA
        AND IDETPOL      = D.IDETPOL
        AND STSCOBERTURA = 'ANU';
     --
     UPDATE ASISTENCIAS_DETALLE_POLIZA
        SET STSASISTENCIA = 'SUSPEN'
      WHERE CODCIA        = P_CODCIA
        AND CODEMPRESA    = P_CODEMPRESA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = D.IDETPOL
        AND STSASISTENCIA = 'ANULAD';
     --
     UPDATE BENEFICIARIO
        SET ESTADO = 'SUSPEN'
      WHERE IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = D.IDETPOL
        AND COD_ASEGURADO = D.COD_ASEGURADO
        AND ESTADO        = 'ANULAD';
     --
     UPDATE CLAUSULAS_DETALLE
        SET ESTADO = 'SUSPEN'
      WHERE CODCIA   = P_CODCIA
        AND IDPOLIZA = P_IDPOLIZA
        AND IDETPOL  = D.IDETPOL
        AND ESTADO = 'ANULAD';
     --
 END LOOP;
 --
 FOR A IN ASEGURADO LOOP
     --
     UPDATE COBERTURA_ASEG
        SET STSCOBERTURA = 'SUS'
      WHERE CODCIA        = P_CODCIA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND STSCOBERTURA  = 'ANU'
        AND COD_ASEGURADO = A.COD_ASEGURADO;
     --
     UPDATE COBERT_ACT_ASEG
        SET STSCOBERTURA = 'SUS'
      WHERE CODCIA        = P_CODCIA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND STSCOBERTURA  = 'ANU'
        AND COD_ASEGURADO = A.COD_ASEGURADO;
     --
     UPDATE ASEGURADO_CERTIFICADO AC
        SET AC.ESTADO = 'SUS'
      WHERE CODCIA         = P_CODCIA
        AND IDPOLIZA       = P_IDPOLIZA
        AND IDETPOL        = A.IDETPOL
        AND COD_ASEGURADO  = A.COD_ASEGURADO
        AND ESTADO         = 'ANU';
     --
     UPDATE ASISTENCIAS_ASEGURADO
        SET STSASISTENCIA = 'SUSPEN'
      WHERE CODCIA        = P_CODCIA
        AND CODEMPRESA    = P_CODEMPRESA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND COD_ASEGURADO = A.COD_ASEGURADO
        AND STSASISTENCIA = 'ANULAD';
     --
     UPDATE BENEFICIARIO
        SET ESTADO = 'SUSPEN'
      WHERE IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND COD_ASEGURADO = A.COD_ASEGURADO
        AND ESTADO        = 'ANULAD';
     --
 END LOOP;
 --
 UPDATE POLIZAS
    SET STSPOLIZA = 'SUS'
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSPOLIZA = 'ANU'
    AND MOTIVANUL = 'CAFP';
 --
 UPDATE DETALLE_POLIZA DP
    SET STSDETALLE = 'SUS'
  WHERE IDPOLIZA   = P_IDPOLIZA
    AND STSDETALLE = 'ANU'
    AND MOTIVANUL  = 'CAFP';
 --
 UPDATE CLAUSULAS_POLIZA CP
    SET ESTADO = 'SUSPEN'
  WHERE CODCIA   = P_CODCIA
    AND IDPOLIZA = P_IDPOLIZA
    AND ESTADO   = 'ANULAD';
 --
 UPDATE ENDOSOS E
    SET STSENDOSO = 'SUS'
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSENDOSO = 'ANU'
    AND MOTIVANUL = 'CAFP'
    AND E.FECSTS  = W_FECSTS;
 --
 INSERT INTO SUSPENSION
  (CODCIA,        CODEMPRESA,      IDPOLIZA,
   STSUSPENSION,  FE_SUSPENSION)
 VALUES
  (P_CODCIA,      P_CODEMPRESA,    P_IDPOLIZA,
   'SUS',         SYSDATE);
 --
 FOR F IN FACTURA LOOP
     --
     UPDATE FACTURAS FA
        SET STSFACT            = 'SUS',
            INDFACTELECTRONICA = 'N'
      WHERE IDFACTURA  = F.IDFACTURA
        AND CODCIA     = P_CODCIA
        AND STSFACT    = 'ANU'
        AND FA.FECSTS  = W_FECSTS;
     --
     INSERT INTO DETALLE_SUSPENSION
      (CODCIA,               CODEMPRESA,           IDPOLIZA,
       STSUSPENSION,         IDTRANSACCION,        FE_TRANSACCION,
       USUARIO_TRANSACCION,  ORIGEN_TRANSACCION)
     VALUES
      (P_CODCIA,             P_CODEMPRESA,         P_IDPOLIZA,
       'SUS',                F.IDFACTURA,          SYSDATE,
       USER,                 'FACT');
     --
 END LOOP;
 --
 FOR N IN NOTAS_CRED LOOP
     --
     UPDATE NOTAS_DE_CREDITO NC
        SET STSNCR             = 'SUS',
            INDFACTELECTRONICA = 'N'
      WHERE IDNCR     = N.IDNCR
        AND CODCIA    = P_CODCIA
        AND STSNCR    = 'ANU'
        AND NC.FECSTS = W_FECSTS;
     --
     INSERT INTO DETALLE_SUSPENSION
      (CODCIA,               CODEMPRESA,           IDPOLIZA,
       STSUSPENSION,         IDTRANSACCION,        FE_TRANSACCION,
       USUARIO_TRANSACCION,  ORIGEN_TRANSACCION)
     VALUES
      (P_CODCIA,             P_CODEMPRESA,         P_IDPOLIZA,
       'SUS',                N.IDNCR,              SYSDATE,
       USER,                 'NCRE');
     --
 END LOOP;
 --
 FOR NE IN NOTAS_CRED_EMI LOOP
     --
     UPDATE NOTAS_DE_CREDITO NC
        SET STSNCR             = 'SUE',
            INDFACTELECTRONICA = 'N'
      WHERE IDNCR     = NE.IDNCR
        AND CODCIA    = P_CODCIA
        AND STSNCR    = 'EMI'
        AND NC.FECSTS = W_FECSTS;
     --
     INSERT INTO DETALLE_SUSPENSION
      (CODCIA,               CODEMPRESA,           IDPOLIZA,
       STSUSPENSION,         IDTRANSACCION,        FE_TRANSACCION,
       USUARIO_TRANSACCION,  ORIGEN_TRANSACCION)
     VALUES
      (P_CODCIA,             P_CODEMPRESA,         P_IDPOLIZA,
       'SUE',                NE.IDNCR,             SYSDATE,
       USER,                 'NCREMI');
     --
 END LOOP;
 --
 --
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al SUSPENDER Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   --
END SUSPENDE_POLIZA;
--
--
--
PROCEDURE ANULA_SUSPENDIDA(P_CODCIA       NUMBER,
                           P_CODEMPRESA   NUMBER,
                           P_IDPOLIZA     NUMBER,
                           P_ANULA        VARCHAR) IS
--
W_FECSTS                 POLIZAS.FECSTS%TYPE;
--
CURSOR DETALLE IS
 SELECT IDETPOL,     COD_ASEGURADO
   FROM DETALLE_POLIZA
  WHERE IDPOLIZA   = P_IDPOLIZA
    AND STSDETALLE = 'SUS';
--
CURSOR ASEGURADO IS
 SELECT IDETPOL,     COD_ASEGURADO
   FROM ASEGURADO_CERTIFICADO
  WHERE IDPOLIZA       = P_IDPOLIZA
    AND CODCIA         = P_CODCIA
    AND ESTADO         = 'SUS';
--
CURSOR FACTURA IS
 SELECT IDETPOL,     IDFACTURA,   IDTRANSACCIONANU
   FROM FACTURAS
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSFACT   = 'SUS';
--
CURSOR NOTAS_CRED IS
 SELECT IDETPOL,     IDNCR  ,     IDTRANSACCIONANU
   FROM NOTAS_DE_CREDITO N
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSNCR    = 'SUS';
--
CURSOR NOTAS_CRED_EMI IS
 SELECT IDETPOL,     IDNCR  ,     IDTRANSACCIONANU
   FROM NOTAS_DE_CREDITO N
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSNCR    = 'SUE';
--
BEGIN
 --
 BEGIN
  SELECT P.FECSTS
    INTO W_FECSTS
    FROM POLIZAS P
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSPOLIZA = 'SUS';
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20225,'Error NO EXISTE Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error MAS DE UN REGISTRO Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error OTRO Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
 END;
 --
 FOR D IN DETALLE LOOP
     --
     UPDATE COBERTURAS
        SET STSCOBERTURA = 'ANU'
      WHERE CODCIA       = P_CODCIA
        AND IDPOLIZA     = P_IDPOLIZA
        AND IDETPOL      = D.IDETPOL
        AND STSCOBERTURA = 'SUS';
     --
     UPDATE COBERT_ACT
        SET STSCOBERTURA = 'ANU'
      WHERE CODCIA       = P_CODCIA
        AND IDPOLIZA     = P_IDPOLIZA
        AND IDETPOL      = D.IDETPOL
        AND STSCOBERTURA = 'SUS';
     --
     UPDATE ASISTENCIAS_DETALLE_POLIZA
        SET STSASISTENCIA = 'ANULAD'
      WHERE CODCIA        = P_CODCIA
        AND CODEMPRESA    = P_CODEMPRESA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = D.IDETPOL
        AND STSASISTENCIA = 'SUSPEN';
     --
     UPDATE BENEFICIARIO
        SET ESTADO = 'ANULAD'
      WHERE IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = D.IDETPOL
        AND COD_ASEGURADO = D.COD_ASEGURADO
        AND ESTADO        = 'SUSPEN';
     --
     UPDATE CLAUSULAS_DETALLE
        SET ESTADO = 'ANULAD'
      WHERE CODCIA   = P_CODCIA
        AND IDPOLIZA = P_IDPOLIZA
        AND IDETPOL  = D.IDETPOL
        AND ESTADO = 'SUSPEN';
     --
 END LOOP;
 --
 FOR A IN ASEGURADO LOOP
     --
     UPDATE COBERTURA_ASEG
        SET STSCOBERTURA = 'ANU'
      WHERE CODCIA        = P_CODCIA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND STSCOBERTURA  = 'SUS'
        AND COD_ASEGURADO = A.COD_ASEGURADO;
     --
     UPDATE COBERT_ACT_ASEG
        SET STSCOBERTURA = 'ANU'
      WHERE CODCIA        = P_CODCIA
        AND IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND STSCOBERTURA  = 'SUS'
        AND COD_ASEGURADO = A.COD_ASEGURADO;
     --
     UPDATE ASEGURADO_CERTIFICADO AC
        SET AC.ESTADO = 'ANU'
      WHERE CODCIA         = P_CODCIA
        AND IDPOLIZA       = P_IDPOLIZA
        AND IDETPOL        = A.IDETPOL
        AND COD_ASEGURADO  = A.COD_ASEGURADO
        AND ESTADO         = 'SUS';
     --
     UPDATE ASISTENCIAS_ASEGURADO
        SET StsAsistencia = 'ANULAD'
      WHERE CodCia        = P_CODCIA
        AND CodEmpresa    = P_CODEMPRESA
        AND IdPoliza      = P_IDPOLIZA
        AND IDetPol       = A.IDETPOL
        AND Cod_Asegurado = A.COD_ASEGURADO
        AND StsAsistencia = 'SUSPEN';
     --
     UPDATE BENEFICIARIO
        SET ESTADO = 'ANULAD'
      WHERE IDPOLIZA      = P_IDPOLIZA
        AND IDETPOL       = A.IDETPOL
        AND COD_ASEGURADO = A.COD_ASEGURADO
        AND ESTADO        = 'SUSPEN';
     --
 END LOOP;
 --
 UPDATE POLIZAS
    SET STSPOLIZA = 'ANU'
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSPOLIZA = 'SUS';
 --
 UPDATE DETALLE_POLIZA DP
    SET STSDETALLE = 'ANU'
  WHERE IDPOLIZA   = P_IDPOLIZA
    AND STSDETALLE = 'SUS';
 --
 UPDATE CLAUSULAS_POLIZA CP
    SET ESTADO = 'ANULAD'
  WHERE CODCIA   = P_CODCIA
    AND IDPOLIZA = P_IDPOLIZA
    AND ESTADO   = 'SUSPEN';
 --
 UPDATE ENDOSOS E
    SET STSENDOSO = 'ANU'
  WHERE IDPOLIZA  = P_IDPOLIZA
    AND STSENDOSO = 'SUS';
 --
 IF P_ANULA = 'S' THEN
    FOR F IN FACTURA LOOP
        --
        UPDATE FACTURAS FA
           SET STSFACT              = 'ANU',
               CODUSUARIOENVFACTANU = 'XENVIAR',
               INDFACTELECTRONICA   = 'S'
         WHERE IDFACTURA = F.IDFACTURA
           AND CODCIA    = P_CODCIA
           AND STSFACT   = 'SUS';
        --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUSANU'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = F.IDFACTURA
           AND STSUSPENSION    = 'SUS';
        --
    END LOOP;
    --
    FOR N IN NOTAS_CRED LOOP
        --
        UPDATE NOTAS_DE_CREDITO NC
           SET STSNCR               = 'ANU',
               CODUSUARIOENVFACTANU = 'XENVIAR',
               INDFACTELECTRONICA   = 'S'
         WHERE IDNCR = N.IDNCR
          AND CODCIA = P_CODCIA
          AND STSNCR = 'SUS';
        --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUSANU'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = N.IDNCR
           AND STSUSPENSION    = 'SUS';
        --
    END LOOP;
    --
    FOR N IN NOTAS_CRED_EMI LOOP
        --
        UPDATE NOTAS_DE_CREDITO NC
           SET STSNCR               = 'EMI',
               CODUSUARIOENVFACTANU = 'XENVIAR',
               INDFACTELECTRONICA   = 'S'
         WHERE IDNCR = N.IDNCR
          AND CODCIA = P_CODCIA
          AND STSNCR = 'SUE';
       --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUEANU'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = N.IDNCR
           AND STSUSPENSION    = 'SUE';
       --
    END LOOP;
    --
 ELSE
    FOR F IN FACTURA LOOP
        --
        UPDATE FACTURAS FA
           SET STSFACT            = 'ANU',
               INDFACTELECTRONICA = 'S'
         WHERE IDFACTURA = F.IDFACTURA
           AND CODCIA    = P_CODCIA
           AND STSFACT   = 'SUS';
        --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUSSUS'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = F.IDFACTURA
           AND STSUSPENSION    = 'SUS';
        --
    END LOOP;
    --
    FOR N IN NOTAS_CRED LOOP
        --
        UPDATE NOTAS_DE_CREDITO NC
           SET STSNCR             = 'ANU',
               INDFACTELECTRONICA = 'S'
         WHERE IDNCR = N.IDNCR
          AND CODCIA = P_CODCIA
          AND STSNCR = 'SUS';
       --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUSSUS'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = N.IDNCR
           AND STSUSPENSION    = 'SUS';
        --
    END LOOP;
    --
    FOR N IN NOTAS_CRED_EMI LOOP
        --
        UPDATE NOTAS_DE_CREDITO NC
           SET STSNCR               = 'EMI',
               CODUSUARIOENVFACTANU = 'XENVIAR',
               INDFACTELECTRONICA   = 'S'
         WHERE IDNCR = N.IDNCR
          AND CODCIA = P_CODCIA
          AND STSNCR = 'SUE';
        --
        UPDATE DETALLE_SUSPENSION DS
           SET DS.STSUSPENSION = 'SUESUE'
         WHERE IDPOLIZA        = P_IDPOLIZA
           AND IDTRANSACCION   = N.IDNCR
           AND STSUSPENSION    = 'SUE';
        --
    END LOOP;
 END IF;
 --
EXCEPTION
   WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al SUSPENDER Póliza: '||TRIM(TO_CHAR(P_IDPOLIZA))|| ' ' ||SQLERRM);
   --
END ANULA_SUSPENDIDA;
--
--
--
PROCEDURE REHABILITACION(nCodCia NUMBER, nCodEmpresa NUMBER, nIdPoliza NUMBER) IS
nIdTransaccionEmiNc   FACTURAS.IdTransaccionAnu%TYPE;
nIdTransaccion        TRANSACCION.IdTransaccion%TYPE;
nPrimaNeta_Moneda     POLIZAS.PrimaNeta_Moneda%TYPE;
cStsPoliza            POLIZAS.StsPoliza%TYPE;
dFecAnul              POLIZAS.FecAnul%TYPE;
nIdTransacNcRehab     TRANSACCION.IdTransaccion%TYPE;


CURSOR ASEG_Q IS
   SELECT IDetPol, Cod_Asegurado
     FROM ASEGURADO_CERTIFICADO
    WHERE IdPoliza = nIdPoliza;

CURSOR DET_Q IS
   SELECT IDetPol, Cod_Asegurado
     FROM DETALLE_POLIZA
    WHERE IdPoliza = nIdPoliza
      AND CodCia   = nCodCia;

CURSOR FACT_Q IS
   SELECT ROWNUM, F.IDFACTURA, MONTO_FACT_MONEDA
     FROM FACTURAS F,
          DETALLE_SUSPENSION DS
    WHERE F.IDPOLIZA = nIdPoliza
      --
      AND DS.IDPOLIZA           = F.IDPOLIZA
      AND DS.IDTRANSACCION      = F.IDFACTURA
      AND DS.STSUSPENSION       = 'SUSSUS'
      AND DS.ORIGEN_TRANSACCION = 'FACT'
    ORDER BY ROWNUM,F.IDFACTURA;

CURSOR NCR_Q IS
   SELECT ROWNUM, NC.IDNCR, NC.IDETPOL, NC.IDENDOSO, NC.MONTO_NCR_MONEDA
     FROM NOTAS_DE_CREDITO NC,
          DETALLE_SUSPENSION DS
    WHERE NC.IDPOLIZA = nIdPoliza
      --
      AND DS.IDPOLIZA           = NC.IDPOLIZA
      AND DS.IDTRANSACCION      = NC.IDNCR
      AND DS.STSUSPENSION       = 'SUSSUS'
      AND DS.ORIGEN_TRANSACCION = 'NCRE';

CURSOR NCR_EMI_Q IS
   SELECT ROWNUM, NC.IDNCR, NC.IDETPOL, NC.IDENDOSO, NC.MONTO_NCR_MONEDA
     FROM NOTAS_DE_CREDITO NC,
          DETALLE_SUSPENSION DS
    WHERE NC.IDPOLIZA = nIdPoliza
      --
      AND DS.IDPOLIZA           = NC.IDPOLIZA
      AND DS.IDTRANSACCION      = NC.IDNCR
      AND DS.STSUSPENSION       = 'SUESUE'
      AND DS.ORIGEN_TRANSACCION = 'NCREMI';
--
--
--
BEGIN
   BEGIN
      SELECT StsPoliza,  FecAnul
        INTO cStsPoliza, dFecAnul
        FROM POLIZAS
       WHERE CodCia    = nCodCia
         AND IdPoliza  = nIdPoliza;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO existe la Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' para Rehabilitarla');
   END;
   --
   IF cStsPoliza = 'ANU' THEN
      UPDATE POLIZAS
         SET StsPoliza = 'EMI',
             Fecanul   = NULL,
             MotivAnul = NULL,
             FecSts    = TRUNC(SYSDATE)
       WHERE IdPoliza = nIdPoliza;
      --
      FOR W IN DET_Q LOOP
         OC_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_COBERT_ACT.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_ASISTENCIAS_DETALLE_POLIZA.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, W.IDetPol);
         OC_BENEFICIARIO.REHABILITAR(nIdPoliza, W.IDetPol, W.Cod_Asegurado);
      END LOOP;
      --
      FOR X IN ASEG_Q LOOP
         OC_ASEGURADO_CERTIFICADO.REHABILITAR(nCodCia, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_COBERT_ACT_ASEG.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_ASISTENCIAS_ASEGURADO.REHABILITAR(nCodCia, nCodEmpresa, nIdPoliza, X.IdetPol, X.Cod_Asegurado);
         OC_BENEFICIARIO.REHABILITAR(nIdPoliza, X.IDetPol, X.Cod_Asegurado);
      END LOOP;
      --
      UPDATE ENDOSOS
         SET StsEndoso = 'EMI',
             FecAnul   = NULL,
             MotivAnul = NULL,
             FecSts    = TRUNC(SYSDATE)
       WHERE IdPoliza  = nIdPoliza
         AND StsEndoso = 'ANU'
         AND FecAnul   = dFecAnul;
      --
      OC_ENDOSO.ENDOSO_REHABILITACION(nCodCia, nCodEmpresa , nIdPoliza);
      OC_CLAUSULAS_POLIZA.EMITIR_TODAS(nCodCia, nIdPoliza);
      --
      -- FACTURAS
      --
      nIdTransaccion    := 0;
      nPrimaNeta_Moneda := 0;
      --
      FOR F IN FACT_Q LOOP
          IF F.ROWNUM = 1 THEN
             --
             nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');
             --
          END IF;
          --
          TH_SUSPENSION.REHABILITA_FACTURAS(nCodCia, nCodEmpresa, F.IdFactura, nIdTransaccion);
          nPrimaNeta_Moneda := nPrimaNeta_Moneda + F.MONTO_FACT_MONEDA;
          --
      END LOOP;
      --
      IF nIdTransaccion > 0 THEN
         --
         OC_DETALLE_TRANSACCION.CREA (nIdTransaccion, nCodCia,  nCodEmpresa, 18, 'REHAB', 'POLIZAS',
                                      nIdPoliza, NULL, NULL, NULL, nPrimaNeta_Moneda);
         --
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, '100');
         --
         UPDATE DETALLE_SUSPENSION DS
            SET DS.ORIGEN_TRANSACCION = 'FACT-FIN',
                DS.STSUSPENSION       = 'SUSFIN',
                DS.FE_TRANSACCION     = SYSDATE
          WHERE DS.IDPOLIZA           = nIdPoliza
            AND DS.STSUSPENSION       = 'SUSSUS'
            AND DS.ORIGEN_TRANSACCION = 'FACT';
      END IF;
      --
      -- NOTAS DE CREDITO
      --
      nIdTransacNcRehab := 0;
      nPrimaNeta_Moneda := 0;
      --
      FOR NC IN NCR_Q LOOP
          IF NC.ROWNUM = 1 THEN
             --
             nIdTransacNcRehab := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');
             --
          END IF;
          --
          TH_SUSPENSION.REHABILITA_NOTAS_DE_CREDITO(nCodCia, nCodEmpresa, NC.IDNCR, nIdTransacNcRehab);
          nPrimaNeta_Moneda := nPrimaNeta_Moneda + NC.MONTO_NCR_MONEDA;
          --
      END LOOP;
      --
      IF nIdTransacNcRehab > 0 THEN
          --
          OC_DETALLE_TRANSACCION.CREA (nIdTransacNcRehab, nCodCia,  nCodEmpresa, 18, 'REHAB', 'POLIZAS',
                                       nIdPoliza, NULL, NULL, NULL, nPrimaNeta_Moneda);
          --
          OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransacNcRehab, '100');
          --
          UPDATE DETALLE_SUSPENSION DS
             SET DS.ORIGEN_TRANSACCION = 'NCRE-FIN',
                 DS.STSUSPENSION       = 'SUSFIN',
                DS.FE_TRANSACCION      = SYSDATE
           WHERE DS.IDPOLIZA           = nIdPoliza
             AND DS.STSUSPENSION       = 'SUSSUS'
             AND DS.ORIGEN_TRANSACCION = 'NCRE';
      END IF;
      --
      -- NOTAS DE CREDITO EMI
      --
      nIdTransaccionEmiNc := 0;
      nPrimaNeta_Moneda   := 0;
      --
      FOR NCE IN NCR_EMI_Q LOOP
          IF NCE.ROWNUM = 1 THEN
             --
             nIdTransaccionEmiNc := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 18, 'REHAB');
             --
          END IF;
          --
          TH_SUSPENSION.REHABILITA_NOTAS_DE_CREDITO(nCodCia, nCodEmpresa, NCE.IDNCR, nIdTransaccionEmiNc);
          nPrimaNeta_Moneda := nPrimaNeta_Moneda + NCE.MONTO_NCR_MONEDA;
          --
      END LOOP;
      --
      IF nIdTransaccionEmiNc > 0 THEN
         --
         OC_DETALLE_TRANSACCION.CREA (nIdTransaccionEmiNc, nCodCia,  nCodEmpresa, 18, 'REHAB', 'POLIZAS',
                                      nIdPoliza, NULL, NULL, NULL, nPrimaNeta_Moneda);
         --
         OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionEmiNc, '100');
         --
         UPDATE DETALLE_SUSPENSION DS
            SET DS.ORIGEN_TRANSACCION = 'NCREMI-FIN',
                DS.STSUSPENSION       = 'SUEFIN',
                DS.FE_TRANSACCION     = SYSDATE
          WHERE DS.IDPOLIZA           = nIdPoliza
            AND DS.STSUSPENSION       = 'SUESUE'
            AND DS.ORIGEN_TRANSACCION = 'NCREMI';
      END IF;
      --
      --
   ELSE
      RAISE_APPLICATION_ERROR(-20225,'La Póliza No. ' || TRIM(TO_CHAR(nIdPoliza)) || ' NO está Anulada para Rehabilitarse');
   END IF;
END REHABILITACION;
--
--
--
PROCEDURE REHABILITA_FACTURAS(nCodCia        NUMBER,
                              nCodEmpresa    NUMBER,
                              nIdFacturaAnu  NUMBER,
                              nIdTransaccion NUMBER) IS
--
W_IDPOLIZA          FACTURAS.IDPOLIZA%TYPE;
W_IDETPOL           FACTURAS.IDETPOL%TYPE;
W_MONTO_FACT_MONEDA FACTURAS.MONTO_FACT_MONEDA%TYPE;
--
BEGIN
   SELECT IDPOLIZA,    IDETPOL,    MONTO_FACT_MONEDA
     INTO W_IDPOLIZA,  W_IDETPOL,  W_MONTO_FACT_MONEDA
     FROM FACTURAS F
    WHERE F.CODCIA    = nCodCia
      AND F.IDFACTURA = nIdFacturaAnu;
   --
   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 18, 'REHAB', 'FACTURAS',
                               W_IDPOLIZA, W_IDETPOL, NULL, nIdFacturaAnu, W_MONTO_FACT_MONEDA);
   --
   BEGIN
     UPDATE FACTURAS F
        SET F.STSFACT = 'EMI',
            F.IDTRANSACCONTAB = nIdTransaccion   ---diferencias
      WHERE F.CODCIA    = nCodCia
        AND F.IDFACTURA = nIdFacturaAnu;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'No Existe la Factura No. ' || nIdFacturaAnu);
     WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Problemas en la Factura No. ' || nIdFacturaAnu);
   END;
END REHABILITA_FACTURAS;
--
--
--
PROCEDURE REHABILITA_NOTAS_DE_CREDITO(nCodCia        NUMBER,
                                      nCodEmpresa    NUMBER,
                                      nIdNcrAnu      NUMBER,
                                      nIdTransaccion NUMBER) IS
--
W_IDPOLIZA         NOTAS_DE_CREDITO.IDPOLIZA%TYPE;
W_IDETPOL          NOTAS_DE_CREDITO.IDETPOL%TYPE;
W_MONTO_NCR_MONEDA NOTAS_DE_CREDITO.MONTO_NCR_MONEDA%TYPE;
--
BEGIN
   SELECT N.IDPOLIZA,   N.IDETPOL,   N.MONTO_NCR_MONEDA
     INTO W_IDPOLIZA,   W_IDETPOL,   W_MONTO_NCR_MONEDA
     FROM NOTAS_DE_CREDITO N
    WHERE N.CODCIA = nCodCia
      AND N.IDNCR  = nIdNcrAnu;
   --
   OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 18, 'REHNCR', 'NOTAS_DE_CREDITO',
                               W_IDPOLIZA, W_IDETPOL, NULL, nIdNcrAnu, W_MONTO_NCR_MONEDA);
   --
   BEGIN
     UPDATE NOTAS_DE_CREDITO N
        SET IdNcrRehab = nIdNcrAnu,
            N.STSNCR   = 'EMI'
      WHERE CodCia = nCodCia
        AND IdNcr  = nIdNcrAnu;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR (-20100,'No Existe la Nota de Credito Anulada No. ' || nIdNcrAnu);
     WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR (-20100,'Problemas en la Nota de Credito Anulada No. ' || nIdNcrAnu);
   END;
   --
END REHABILITA_NOTAS_DE_CREDITO;
--
--
--
END TH_SUSPENSION;
/
