CREATE OR REPLACE PACKAGE          OC_COBERTURA_SINIESTRO IS
  --
  PROCEDURE MONTO_RESERVA(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                          nMto_Rva_Moneda OUT NUMBER, nMonto_Rva_Local OUT NUMBER);
  --
  PROCEDURE SALDO_RESERVA(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                          nSaldoRvaMoneda OUT NUMBER, nSaldoRvaLocal OUT NUMBER);
  --
  PROCEDURE EMITE_RESERVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER,
                          nIdDetSin NUMBER, cCodCobert VARCHAR2, nNumMod NUMBER, nIdTransaccion NUMBER);
  --
  PROCEDURE ANULAR_RESERVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER,
                           nIdDetSin NUMBER, cCodCobert VARCHAR2, nNumMod NUMBER);
  --
  FUNCTION VALIDA_SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cCodCobert VARCHAR2,
                                 cCodTransac VARCHAR2, nMtoReservarMoneda NUMBER) RETURN VARCHAR2;

  FUNCTION EXISTE_COBERTURA (nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2;
  --
  PROCEDURE MONTO_PAGADO(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                          nMontoPagadoMoneda OUT NUMBER, nMontoPagadoLocal OUT NUMBER);
  --
  -- AEVS 02102017
  FUNCTION RESERVA_DE_COB_SINIESTRO (nCodCia NUMBER,nIdSiniestro NUMBER, cCodCobert VARCHAR2)RETURN NUMBER;
  --
  FUNCTION PAGO_DE_COB_SINIESTRO (nCodCia NUMBER,nIdSiniestro NUMBER, cCodCobert VARCHAR2)RETURN NUMBER;
  --
  PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER,
                                   cCodCobert VARCHAR2, nNumMod NUMBER, nIdAutorizacion NUMBER);
  --
END OC_COBERTURA_SINIESTRO;

/

CREATE OR REPLACE PACKAGE BODY          OC_COBERTURA_SINIESTRO IS
--
--
--
FUNCTION VALIDA_SUMA_ASEGURADA(nCodCia NUMBER, nIdPoliza NUMBER, nIDetPol NUMBER, cCodCobert VARCHAR2,
                               cCodTransac VARCHAR2, nMtoReservarMoneda NUMBER) RETURN VARCHAR2 IS
--
nMontoRvaMoneda  COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMontoResAct     COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nSuma            DETALLE_POLIZA.Suma_Aseg_Moneda%TYPE;
cSigno           CONFIG_TRANSAC_SINIESTROS.signo%TYPE;
cRespuesta       VARCHAR2(1) := 'S';
--
BEGIN
  BEGIN
    SELECT NVL(SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),0)
      INTO nMontoRvaMoneda
      FROM COBERTURA_SINIESTRO CS,
           CONFIG_TRANSAC_SINIESTROS CTS
     WHERE CS.CodTransac     = CTS.CodTransac
       AND CS.IdPoliza       = nIdPoliza
       AND CS.CodCobert      = cCodCobert
       AND CS.StsCobertura  != 'ANU';
  END;
  --
  BEGIN
     SELECT CTS.Signo
      INTO cSigno
      FROM CONFIG_TRANSAC_SINIESTROS CTS
     WHERE CTS.CodTransac     = cCodTransac;
  EXCEPTION
    WHEN OTHERS THEN
      cRespuesta := 'N';
      RAISE_APPLICATION_ERROR(-20225,'Error al obtener el Signo de la Transacción: '||SQLERRM);
  END;
  --
  IF NVL(cSigno,'*') = '-' THEN
     nMontoResAct := NVL(nMtoReservarMoneda,0) * -1;
  ELSE
     nMontoResAct := NVL(nMtoReservarMoneda,0);
  END IF;
  --

  nSuma := OC_COBERT_ACT.SUMA_ASEGURADA(nCodCia, nIdPoliza, nIDetPol, cCodCobert);
  --
  IF NVL(nMontoRvaMoneda,0) + NVL(nMontoResAct,0) > NVL(nSuma,0) THEN
     RETURN('N');
  ELSIF NVL(nMontoRvaMoneda,0) + NVL(nMontoResAct,0) < 0 THEN
        RETURN('N');
  ELSE
     RETURN('S');
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
    RETURN('N');
    RAISE_APPLICATION_ERROR(-20225,'Error en Validar Suma Asegurada: '||SQLERRM);
END VALIDA_SUMA_ASEGURADA;
--
--
--
PROCEDURE MONTO_RESERVA(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                        nMto_Rva_Moneda OUT NUMBER, nMonto_Rva_Local OUT NUMBER) IS
--
BEGIN
  --
  BEGIN
    SELECT SUM(CS.Monto_Reservado_Moneda * Decode(CTS.Signo,'-',-1,1)),
           SUM(CS.Monto_Reservado_Local * Decode(CTS.Signo,'-',-1,1))
      INTO nMto_Rva_Moneda, nMonto_Rva_Local
      FROM COBERTURA_SINIESTRO CS,
           CONFIG_TRANSAC_SINIESTROS CTS
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IddetSin       = nIdDetSin
       AND CodCobert      = cCodCobert
       AND CS.CodTransac  = CTS.CodTransac;
  EXCEPTION
    WHEN OTHERS THEN
      nMto_Rva_Moneda  := 0;
      nMonto_Rva_Local := 0;
  END;
  --
END MONTO_RESERVA;
--
--
--
PROCEDURE SALDO_RESERVA(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                        nSaldoRvaMoneda OUT NUMBER, nSaldoRvaLocal OUT NUMBER) IS
--
BEGIN
  --
  BEGIN
    SELECT NVL(Saldo_Reserva,0), NVL(Saldo_Reserva_Local,0)
      INTO nSaldoRvaMoneda, nSaldoRvaLocal
      FROM COBERTURA_SINIESTRO_ASEG
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IdDetSin       = nIdDetSin
       AND CodCobert      = cCodCobert
       AND NumMod         = (SELECT MAX(NumMod)
                               FROM COBERTURA_SINIESTRO_ASEG
                              WHERE IdSiniestro    = nIdSiniestro
                                AND IdPoliza       = nIdPoliza
                                AND IddetSin       = nIdDetSin
                                AND CodCobert      = cCodCobert
                                AND StsCobertura   = 'EMI')
       AND NumMod        >= 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'NO Existe Reserva de la Cobertura: '||cCodCobert);
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al obtener el Monto Resevado de la Cobertura: '||SQLERRM);
  END;
  --
END SALDO_RESERVA;
--
--
--
PROCEDURE EMITE_RESERVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER,
                        nIdDetSin NUMBER, cCodCobert VARCHAR2, nNumMod NUMBER, nIdTransaccion NUMBER) IS
--
nMtoAproT                APROBACIONES.Monto_Moneda%TYPE;
nSaldoReservaAnterior    COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nSaldoRvaAnteriorLocal   COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
nSaldo_Reserva           COBERTURA_SINIESTRO.Saldo_Reserva%TYPE;
nSaldo_Reserva_Local     COBERTURA_SINIESTRO.Saldo_Reserva_Local%TYPE;
cSigno                   CONFIG_TRANSAC_SINIESTROS.SIGNO%TYPE;
nIdTransac               TRANSACCION.IdTransaccion%TYPE;
nMontoRes                COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMtoPago                 SINIESTRO.Monto_Pago_Local%TYPE;
cCodTransac              COBERTURA_SINIESTRO.CodTransac%TYPE;
nMonto_Reservado_Moneda  COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nMonto_Reservado_Local   COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
cObservaciones           OBSERVACION_SINIESTRO.Descripcion%TYPE;
dFechaTransaccion        TRANSACCION.FechaTransaccion%TYPE;
BEGIN
  BEGIN
    SELECT CodTransac, Monto_Reservado_Moneda, Monto_Reservado_Local
      INTO cCodTransac, nMonto_Reservado_Moneda, nMonto_Reservado_Local
      FROM COBERTURA_SINIESTRO
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IddetSin       = nIdDetSin
       AND CodCobert      = cCodCobert
       AND NumMod         = nNumMod;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'NO Existe Reserva de COBERTURA SINIESTRO No.: '||nNumMod);
    WHEN TOO_MANY_ROWS THEN
      RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Reserva de COBERTURA SINIESTRO No.: '||nNumMod);
  END;

  IF NVL(nIdTransaccion,0) = 0 THEN
     nIdTransac := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa,  6, 'SIN');
  ELSE
     nIdTransac := nIdTransaccion;
  END IF;

  dFechaTransaccion := OC_TRANSACCION.FECHATRANSACCION(nIdTransac);

  BEGIN
    SELECT Signo
      INTO cSigno
      FROM CONFIG_TRANSAC_SINIESTROS
     WHERE CodTransac = cCodTransac;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20225,'No Existe Configuración de Transacciones de Siniestros '||cCodTransac);
  END;

  BEGIN
    SELECT NVL(Saldo_Reserva,0), NVL(Saldo_Reserva_Local,0)
      INTO nSaldoReservaAnterior, nSaldoRvaAnteriorLocal
      FROM COBERTURA_SINIESTRO
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IddetSin       = nIdDetSin
       AND CodCobert      = cCodCobert
       AND NumMod         = (SELECT MAX(NumMod)
                               FROM COBERTURA_SINIESTRO
                              WHERE IdSiniestro    = nIdSiniestro
                                AND IdPoliza       = nIdPoliza
                                AND IddetSin       = nIdDetSin
                                AND CodCobert      = cCodCobert
                                AND StsCobertura   = 'EMI')
       AND NumMod        >= 0;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      nSaldoReservaAnterior := 0;
  END;

  IF cSigno = '+' THEN
     nSaldo_Reserva       :=   NVL(nSaldoReservaAnterior,0) + NVL(nMonto_Reservado_Moneda,0);
     nSaldo_Reserva_Local :=   NVL(nSaldoRvaAnteriorLocal,0) + NVL(nMonto_Reservado_Local,0);
  ELSIF cSigno = '-' THEN
     nSaldo_Reserva       :=   NVL(nSaldoReservaAnterior,0) - NVL(nMonto_Reservado_Moneda,0);
     nSaldo_Reserva_Local :=   NVL(nSaldoRvaAnteriorLocal,0) - NVL(nMonto_Reservado_Local,0);
  END IF;

  BEGIN
    UPDATE COBERTURA_SINIESTRO
       SET IdTransaccion       = nIdTransac,
           Saldo_Reserva       = nSaldo_Reserva,
           Saldo_Reserva_Local = nSaldo_Reserva_Local,
           StsCobertura        = 'EMI'
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IddetSin       = nIdDetSin
       AND CodCobert      = cCodCobert
       AND NumMod         = nNumMod;
  END;

  OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 6,'EMIRES', 'COBERTURA_SINIESTRO',
                              nIdSiniestro, nIdPoliza, cCodCobert, nNumMod, nMonto_Reservado_Moneda);

  IF NVL(nIdTransaccion,0) = 0 THEN
     GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransac, dFechaTransaccion);
     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
  END IF;

  OC_DETALLE_SINIESTRO.ACTUALIZA_RESERVAS(nIdSiniestro);

  cObservaciones := 'Emite la Reserva de la Cobertura '||cCodCobert||' de la Modificacion '||nNumMod||' con el Monto '||
                    nMonto_Reservado_Moneda;
  OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, cObservaciones);
END EMITE_RESERVA;
--
--
--
PROCEDURE ANULAR_RESERVA(nCodCia NUMBER, nCodEmpresa NUMBER, nIdSiniestro NUMBER, nIdPoliza NUMBER,
                         nIdDetSin NUMBER, cCodCobert VARCHAR2, nNumMod NUMBER) IS
--
nMtoAproT                APROBACIONES.Monto_Moneda%TYPE;
nSaldoReservaAnterior    COBERTURA_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE;
nSaldoRvaAnteriorLocal   COBERTURA_SINIESTRO_ASEG.Monto_Reservado_Local%TYPE;
nSaldo_Reserva           COBERTURA_SINIESTRO_ASEG.Saldo_Reserva%TYPE;
nSaldo_Reserva_Local     COBERTURA_SINIESTRO_ASEG.Saldo_Reserva_Local%TYPE;
cSigno                   CONFIG_TRANSAC_SINIESTROS.SIGNO%TYPE;
nIdTransac               TRANSACCION.IdTransaccion%TYPE;
nMontoRes                COBERTURA_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE;
nMtoPago                 SINIESTRO.Monto_Pago_Local%TYPE;
cCodTransac              COBERTURA_SINIESTRO_ASEG.CodTransac%TYPE;
nMonto_Reservado_Moneda  COBERTURA_SINIESTRO_ASEG.Monto_Reservado_Moneda%TYPE;
nMonto_Reservado_Local   COBERTURA_SINIESTRO_ASEG.Monto_Reservado_Local%TYPE;
nTotPagos                NUMBER;
cObservaciones           OBSERVACION_SINIESTRO.Descripcion%TYPE;
dFechaTransaccion        TRANSACCION.FechaTransaccion%TYPE;

BEGIN
  BEGIN
    SELECT COUNT(*)
      INTO nTotPagos
      FROM APROBACIONES
     WHERE IdPoliza      = nIdPoliza
       AND IdSiniestro   = nIdSiniestro
       AND StsAprobacion IN ('PAG','EMI','SOL');
  END;
  --
  IF nTotPagos = 0 THEN
     --
     BEGIN
       SELECT CodTransac, Monto_Reservado_Moneda, Monto_Reservado_Local
         INTO cCodTransac, nMonto_Reservado_Moneda, nMonto_Reservado_Local
         FROM COBERTURA_SINIESTRO
        WHERE IdSiniestro    = nIdSiniestro
          AND IdPoliza       = nIdPoliza
          AND IddetSin       = nIdDetSin
          AND CodCobert      = cCodCobert
          AND NumMod         = nNumMod;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Reserva de Cobertura, No de Modificacion: '||nNumMod);
       WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registros de Reserva de Cobertura, No de Modificacion: '||nNumMod);
     END;
     --
     nIdTransac        := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa,  6, 'ANURES');
     dFechaTransaccion := OC_TRANSACCION.FECHATRANSACCION(nIdTransac);

     BEGIN
       SELECT Signo
         INTO cSigno
         FROM CONFIG_TRANSAC_SINIESTROS
        WHERE CodTransac = cCodTransac;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'No Existe Configuración de Transacciones de Siniestros '||cCodTransac);
     END;
     --
     BEGIN
       SELECT NVL(Saldo_Reserva,0), NVL(Saldo_Reserva_Local,0)
         INTO nSaldoReservaAnterior, nSaldoRvaAnteriorLocal
         FROM COBERTURA_SINIESTRO
        WHERE IdSiniestro    = nIdSiniestro
          AND IdPoliza       = nIdPoliza
          AND IdDetSin       = nIdDetSin
          AND CodCobert      = cCodCobert
          AND NumMod         = (SELECT MAX(NumMod)
                                  FROM COBERTURA_SINIESTRO
                                 WHERE IdSiniestro    = nIdSiniestro
                                   AND IdPoliza       = nIdPoliza
                                   AND IddetSin       = nIdDetSin
                                   AND CodCobert      = cCodCobert
                                   AND StsCobertura   = 'EMI')
          AND NumMod        >= 0;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
         nSaldoReservaAnterior := 0;
     END;
     --
     IF cSigno = '-' THEN
        nSaldo_Reserva       :=   NVL(nSaldoReservaAnterior,0) + NVL(nMonto_Reservado_Moneda,0);
        nSaldo_Reserva_Local :=   NVL(nSaldoRvaAnteriorLocal,0) + NVL(nMonto_Reservado_Local,0);
     ELSIF cSigno = '+' THEN
           nSaldo_Reserva       :=   NVL(nSaldoReservaAnterior,0) - NVL(nMonto_Reservado_Moneda,0);
           nSaldo_Reserva_Local :=   NVL(nSaldoRvaAnteriorLocal,0) - NVL(nMonto_Reservado_Local,0);
     END IF;
     --
     BEGIN
       UPDATE COBERTURA_SINIESTRO
          SET IdTransaccionAnul   = nIdTransac,
              Saldo_Reserva       = nSaldo_Reserva,
              Saldo_Reserva_Local = nSaldo_Reserva_Local,
              StsCobertura        = 'ANU'
        WHERE IdSiniestro    = nIdSiniestro
          AND IdPoliza       = nIdPoliza
          AND IddetSin       = nIdDetSin
          AND CodCobert      = cCodCobert
          AND NumMod         = nNumMod;
     END;
     --
     OC_DETALLE_TRANSACCION.CREA(nIdTransac, nCodCia, nCodEmpresa, 6,'ANURES', 'COBERTURA_SINIESTRO',
                                 nIdSiniestro, nIdPoliza, cCodCobert, nNumMod, nMonto_Reservado_Moneda);
     --
     OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
     --
     OC_DETALLE_SINIESTRO_ASEG.ACTUALIZA_RESERVAS(nIdSiniestro);
     --
     cObservaciones := 'Anula la Reserva de la Cobertura '||cCodCobert||' de la Modificacion '||nNumMod||' con el Monto '||
                       nMonto_Reservado_Moneda;
     OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, cObservaciones);
     GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransac, dFechaTransaccion);
  ELSE
     --
     RAISE_APPLICATION_ERROR(-20225,'Existen Pagos en estado de Solicitud, Pagado ó Emitido, No procede la Anulación de la Reserva.');
     --
  END IF;
  --
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20225,'Error al Anular la Reserva: '||SQLERRM);
END ANULAR_RESERVA;
--
--
--
FUNCTION EXISTE_COBERTURA (nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2) RETURN VARCHAR2 IS
    cExiste  VARCHAR2(1);
BEGIN
    BEGIN
      SELECT 'S'
        INTO cExiste
        FROM COBERTURA_SINIESTRO
       WHERE IdSiniestro    = nIdSiniestro
         AND IdDetSin       = nIdDetSin
         AND IdPoliza       = nIdPoliza
         AND CodCobert      = cCodCobert;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste := 'S';
   END;
   RETURN(cExiste);
END EXISTE_COBERTURA;
--
--
--
PROCEDURE MONTO_PAGADO(nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER, cCodCobert VARCHAR2,
                          nMontoPagadoMoneda OUT NUMBER, nMontoPagadoLocal OUT NUMBER) IS
--
BEGIN
  --
  BEGIN
    SELECT SUM(CS.MONTO_PAGADO_MONEDA),
           SUM(CS.MONTO_PAGADO_LOCAL)
      INTO nMontoPagadoMoneda, nMontoPagadoLocal
      FROM COBERTURA_SINIESTRO CS
     WHERE IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza
       AND IddetSin       = nIdDetSin
       AND CodCobert      = cCodCobert;
  EXCEPTION
    WHEN OTHERS THEN
      nMontoPagadoMoneda  := 0;
      nMontoPagadoLocal := 0;
  END;
  --
END MONTO_PAGADO;
--
--
--
FUNCTION RESERVA_DE_COB_SINIESTRO (nCodCia NUMBER,nIdSiniestro NUMBER, cCodCobert VARCHAR2) RETURN NUMBER IS

OCURRIDO         COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
SUMA_ASEGURADA   ASEGURADO_CERTIFICADO.SUMAASEG%TYPE;
DEDUCILBE        SINIESTRO.DEDUCIBLE%TYPE;
PAGADO           APROBACION_ASEG.MONTO_MONEDA%TYPE;
SUM_ASEG_REM     NUMBER;
wHabemus         NUMBER;
wHayPagos        NUMBER;

BEGIN

      SELECT  SUM(DECODE(CTS.SIGNO,'-',NVL(D.MONTO_RESERVADO_MONEDA,0)*(-1),NVL(D.MONTO_RESERVADO_MONEDA,0)))
       INTO   OCURRIDO
        FROM  COBERTURA_SINIESTRO D,
              CONFIG_TRANSAC_SINIESTROS CTS
       WHERE D.CODCOBERT     = cCodCobert
         AND D.STSCOBERTURA  = 'EMI'
         AND D.IDSINIESTRO   = nIdSiniestro
      --
         AND CTS.CODTRANSAC = D.CODCPTOTRANSAC;

    SUM_ASEG_REM := (OCURRIDO);

    RETURN(SUM_ASEG_REM);

EXCEPTION  WHEN OTHERS THEN
           RETURN(0);
               RAISE_APPLICATION_ERROR(-20225,'Error en Validar Suma Asegurada Remanente : '||SQLERRM);
END RESERVA_DE_COB_SINIESTRO;
--
--
--
FUNCTION PAGO_DE_COB_SINIESTRO (nCodCia NUMBER,nIdSiniestro NUMBER, cCodCobert VARCHAR2) RETURN NUMBER IS

OCURRIDO         COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%TYPE;
SUMA_ASEGURADA   ASEGURADO_CERTIFICADO.SUMAASEG%TYPE;
DEDUCILBE        SINIESTRO.DEDUCIBLE%TYPE;
PAGADO           APROBACION_ASEG.MONTO_MONEDA%TYPE;
SUM_ASEG_REM     NUMBER;
wHabemus         NUMBER;
wHayPagos        NUMBER;

BEGIN

     SELECT COUNT(*) INTO wHayPagos
    FROM   DETALLE_APROBACION  S
    WHERE  S.IDSINIESTRO = nIdSiniestro
    AND  S.COD_PAGO      = cCodCobert;


    IF wHayPagos >  0 THEN
                -- INC-2600 MLJ SE AGREGA TABLA CPTOS_TRANSAC_SINIESTROS PARA IDENTIFICAR LOS CONCEPTOS
                -- QUE APLICAN AL IMPORTE PAGADO 
                BEGIN
                   SELECT SUM(S.MONTO_LOCAL) PAGADO INTO       PAGADO
                   FROM   DETALLE_APROBACION  S
                         ,CPTOS_TRANSAC_SINIESTROS CT
                   WHERE  S.IDSINIESTRO = NIDSINIESTRO
                   AND  S.CODTRANSAC = CT.CODTRANSAC
                   AND  S.CODCPTOTRANSAC = CT.CODCPTOTRANSAC
                   AND  CT.INDDISMINRVA = 'S' 
                   AND  NUM_APROBACION IN (SELECT NUM_APROBACION
                                           FROM   APROBACIONES
                                           WHERE  IDSINIESTRO = NIDSINIESTRO
                                           AND    STSAPROBACION IN ('PAG') )  
                   ;                                   
                EXCEPTION WHEN NO_DATA_FOUND THEN
                           RAISE_APPLICATION_ERROR(-20225,'NDF  Error en PAGADO: '||SQLERRM);
                          WHEN OTHERS THEN
                           RAISE_APPLICATION_ERROR(-20225,'OTHERS Error en PAGADO: '||SQLERRM);
               END;
    ELSIF wHayPagos = 0 THEN
         PAGADO := 0;
    END IF;
    SUM_ASEG_REM := (PAGADO);
    RETURN(SUM_ASEG_REM);

EXCEPTION  WHEN OTHERS THEN
           RETURN(0);
               RAISE_APPLICATION_ERROR(-20225,'Error en Validar Suma Asegurada Remanente : '||SQLERRM);
END PAGO_DE_COB_SINIESTRO;
--
PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER,
                                 cCodCobert VARCHAR2, nNumMod NUMBER, nIdAutorizacion NUMBER) IS
BEGIN
    UPDATE COBERTURA_SINIESTRO
       SET IdAutorizacion = nIdAutorizacion
     WHERE IdSiniestro   = nIdSiniestro
       AND IdDetSin      = nIdDetSin
       AND IdPoliza      = nIdPoliza
       AND CodCobert     = cCodCobert
       AND NumMod        = nNumMod;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error al Asignar Autorización: '||nIdAutorizacion||' '||SQLERRM);
END ACTUALIZA_AUTORIZACION;
--
--
END OC_COBERTURA_SINIESTRO;
