CREATE OR REPLACE PACKAGE OC_APROBACIONES IS
  --
  -- BITACORA DE CAMBIOS
  --  16/12/2021  Reingenieria F2  GRABADO DE FONDEO       
  --
  FUNCTION NUMERO_APROBACION(nIdSiniestro   NUMBER) RETURN NUMBER;
  --
  FUNCTION INSERTA_APROBACION(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nMonto_Local NUMBER,
                              nMonto_Moneda NUMBER, cTipoAprobacion VARCHAR2, cSubTipoAprobacion VARCHAR2,
                              nIdeFactExt NUMBER) RETURN NUMBER;
  --
  PROCEDURE ACTUALIZA_PAGOS(nIdSiniestro NUMBER, nIdPoliza NUMBER, nNum_Aprobacion NUMBER);
  --
  PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, 
                  nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER);
  --
  PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                   nIdPoliza NUMBER, nIdDetSin NUMBER);
  --
  PROCEDURE REVERTIR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                     nIdPoliza NUMBER, nIdDetSin NUMBER , nBenef NUMBER);  
  --
  PROCEDURE ACTUALIZA_FONDEO(nNum_Aprobacion in NUMBER, nIdSiniestro in NUMBER, nIdPoliza in NUMBER, IDDETSIN in NUMBER );
  --
  PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nIdAutorizacion NUMBER);
  --
  FUNCTION  NUMERO_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2) RETURN NUMBER;
END OC_APROBACIONES;
/
create or replace PACKAGE BODY OC_APROBACIONES IS
--
FUNCTION NUMERO_APROBACION(nIdSiniestro   NUMBER) RETURN NUMBER IS
--
nNum_Aprobacion    APROBACIONES.Num_Aprobacion%TYPE;
nNumAprobGen       APROBACIONES.Num_Aprobacion%TYPE;
nNumAprobAseg      APROBACION_ASEG.Num_Aprobacion%TYPE;
--
BEGIN
   SELECT NVL(MAX(Num_Aprobacion),0) + 1
     INTO nNumAprobGen
     FROM APROBACIONES
    WHERE IdSiniestro = nIdSiniestro;

   SELECT NVL(MAX(Num_Aprobacion),0) + 1
     INTO nNumAprobAseg
     FROM APROBACION_ASEG
    WHERE IdSiniestro = nIdSiniestro;

   IF nNumAprobGen > nNumAprobAseg THEN
      nNum_Aprobacion := nNumAprobGen;
   ELSE
      nNum_Aprobacion := nNumAprobAseg;
   END IF;
   RETURN(nNum_Aprobacion);
END NUMERO_APROBACION;
--
--
--
FUNCTION INSERTA_APROBACION(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nMonto_Local NUMBER,
                            nMonto_Moneda NUMBER, cTipoAprobacion VARCHAR2, cSubTipoAprobacion VARCHAR2,
                            nIdeFactExt NUMBER) RETURN NUMBER IS
--
nNum_Aprobacion   APROBACIONES.Num_Aprobacion%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;
--
BEGIN
  --
  BEGIN
    --
    BEGIN
    select NVL(CODEMPRESA,1),NVL(CODCIA,1)
     into cCodEmpresa, cCodCia
     from siniestro
     where idsiniestro = nIdSiniestro
     and idpoliza     = nIdPoliza;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-202,'No existe compañia:'||SQLERRM);
   END;

    nNum_Aprobacion := OC_APROBACIONES.NUMERO_APROBACION(nIdSiniestro);
    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'SINAPR');
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);

    IF cIndFecEquivPro = 'S' THEN

      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;

    ELSE

     dFechaCamb := dFechaReal;

    end if;
    --
    INSERT INTO APROBACIONES
          (Num_Aprobacion, IdSiniestro, IdPoliza, IdDetSin, Tipo_Aprobacion, 
           Monto_Local, Monto_Moneda, StsAprobacion, Tipo_De_Aprobacion,
           IdTransaccion, IndDispersion, IdeFactExt,INDFONDOSINI,FECPAGO )
    VALUES(nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1, cSubTipoAprobacion, 
           nMonto_Local, nMonto_Moneda, 'EMI', cTipoAprobacion, NULL, 'N', nIdeFactExt,'N', dFechaCamb);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'INSERCION APROBACIONES SINIESTRO - Ocurrió el siguiente error: '||SQLERRM);
  END;
  --
  RETURN(nNum_Aprobacion);
  --
END INSERTA_APROBACION;
--
--
--
PROCEDURE ACTUALIZA_PAGOS(nIdSiniestro NUMBER, nIdPoliza NUMBER, nNum_Aprobacion NUMBER) IS
--
dFecHoy              DATE;
nCobertLocal         COBERTURA_SINIESTRO.Monto_Reservado_Local%TYPE;
nCobertMoneda        COBERTURA_SINIESTRO.Monto_Reservado_Moneda%TYPE;
nOtrPagLocal         PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Local%TYPE;
nOtrPagMoneda        PAGOS_POR_OTROS_CONCEPTOS.Monto_Reservado_Moneda%TYPE;
nTotSiniLocal        SINIESTRO.Monto_Reserva_Local%TYPE;
nTotSiniMoneda       SINIESTRO.Monto_Reserva_Moneda%TYPE;
nMtoPagLocal         DETALLE_SINIESTRO.Monto_Pagado_Local%TYPE;
nMtoPagMoneda        DETALLE_SINIESTRO.Monto_Pagado_Moneda%TYPE;
cTipo_de_Aprobacion  APROBACIONES.Tipo_de_Aprobacion%TYPE;
--
CURSOR DET_SIN_Q IS
   SELECT IdDetSin
     FROM DETALLE_SINIESTRO
    WHERE IdSiniestro = nIdSiniestro
      AND IdPoliza    = nIdPoliza;
--
BEGIN
  --
  SELECT SYSDATE
    INTO dFecHoy
    FROM DUAL;
  --
  nTotSiniLocal  := 0;
  nTotSiniMoneda := 0;
  --
  SELECT NVL(SUM(Monto_Local),0), NVL(SUM(Monto_Moneda),0)
    INTO nMtoPagLocal, nMtoPagMoneda
    FROM DETALLE_APROBACION D, CPTOS_TRANSAC_SINIESTROS J
   WHERE EXISTS (SELECT 1 
                   FROM APROBACIONES A
                  WHERE A.IdSiniestro    = D.IdSiniestro
                    AND D.NUM_APROBACION = A.NUM_APROBACION
                    AND A.IdSiniestro    = nIdSiniestro
                    AND StsAprobacion    = 'PAG')
     AND D.IdSiniestro    = nIdSiniestro
     AND D.CodTransac     = J.CodTransac
     AND D.CodCptoTransac = J.CodCptoTransac
     AND J.IndDisminRva   = 'S';
  --
  /*FOR X IN DET_SIN_Q LOOP
    BEGIN
      SELECT NVL(SUM(Monto_Pagado_Local),0), NVL(SUM(Monto_Pagado_Moneda),0)
        INTO nCobertLocal, nCobertMoneda
        FROM COBERTURA_SINIESTRO
       WHERE IdSiniestro = nIdSiniestro
         AND IdPoliza    = nIdPoliza;

      SELECT NVL(SUM(Monto_Pago_Local),0), NVL(SUM(Monto_Pago_Moneda),0)
        INTO nOtrPagLocal, nOtrPagMoneda
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdPoliza    = nIdPoliza
         AND IdDetSin    = X.IdDetSin;
    END;
  END LOOP;*/
  --
  UPDATE DETALLE_SINIESTRO
     SET Monto_Pagado_Local   = nMtoPagLocal,
         Monto_Pagado_Moneda  = nMtoPagMoneda
   WHERE IdSiniestro  = nIdSiniestro
     AND IdPoliza     = nIdPoliza;
  --
  SELECT Tipo_de_Aprobacion
    INTO cTipo_de_Aprobacion
    FROM APROBACIONES
   WHERE Num_Aprobacion = nNum_Aprobacion
     AND IdSiniestro    = nIdSiniestro
     AND IdPoliza       = nIdPoliza;
  --
  IF cTipo_de_Aprobacion = 'T' THEN 
     UPDATE SINIESTRO
        SET Monto_Pago_Local  = nMtoPagLocal,
            Monto_Pago_Moneda = nMtoPagMoneda,
            Sts_Siniestro     = 'PGT'
      WHERE IdSiniestro  = nIdSiniestro
        AND IdPoliza     = nIdPoliza;
  ELSE
     UPDATE SINIESTRO
        SET Monto_Pago_Local  = nMtoPagLocal,
            Monto_Pago_Moneda = nMtoPagMoneda,
            Sts_Siniestro     = 'PGP'
      WHERE IdSiniestro  = nIdSiniestro
        AND IdPoliza     = nIdPoliza;
  END IF;
  --
END ACTUALIZA_PAGOS;
--
--
--
PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, 
                nIdSiniestro NUMBER, nIdPoliza NUMBER, nIdDetSin NUMBER) IS
--
cCod_Pago            DETALLE_APROBACION.Cod_Pago%TYPE;
nMonto_Local         DETALLE_APROBACION.Monto_Local%TYPE;
nMonto_Moneda        DETALLE_APROBACION.Monto_Moneda%TYPE;
nMaxNumMod           COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva       DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
cStsPag              APROBACIONES.StsAprobacion%TYPE;
nAjuste              DETALLE_APROBACION.Monto_Local%TYPE := 0;
cIndTipoCobert       CPTOS_TRANSAC_SINIESTROS.IndTipoCobert%TYPE;
nIdTransaccion       TRANSACCION.IdTransaccion%TYPE;
cCodTransac          DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTransac      DETALLE_APROBACION.CodCptoTransac%TYPE;
cTipo_de_Aprobacion  APROBACIONES.Tipo_de_Aprobacion%TYPE;
nBenef               APROBACIONES.Benef%TYPE;
cExiste              VARCHAR2(1);
cCpto                VARCHAR2(6);
nRegis               NUMBER(10);
nRegisCobert         NUMBER(10);
nNumMod              COBERTURA_SINIESTRO_ASEG.NumMod%TYPE := 0;
cObservaciones       OBSERVACION_SINIESTRO.Descripcion%TYPE;

HabemusReserva       COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
ReservaCobertura     COBERTURA_SINIESTRO.MONTO_RESERVADO_MONEDA%TYPE;
cIndFecEquivPro      PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv         SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb           APROBACIONES.FECPAGO%TYPE;
dFechaCont           FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal           FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa          SINIESTRO.CODEMPRESA%TYPE;
cCodCia              SINIESTRO.CODCIA%TYPE;
PMENSAJE             VARCHAR2(2000);
CIDTIPO_PAGO         BENEF_SIN.IDTIPO_PAGO%TYPE;   -- FONDEO
MONTO_MONEDA_FONDEO  DETALLE_APROBACION_ASEG.Monto_Moneda%type;  -- FONDEO
cExisteCodPagoNoCob  VARCHAR2(1);
--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO C
   WHERE C.IdSiniestro  =  nIdSiniestro
     AND C.IdPoliza     =  nIdPoliza
     AND C.StsCobertura = 'EMI'
     AND C.NumMod       IN (SELECT MAX(NumMod)
                              FROM COBERTURA_SINIESTRO CC
                             WHERE CC.IdSiniestro = nIdSiniestro
                               AND CC.IdPoliza    = nIdPoliza
                               AND C.StsCobertura = 'EMI'
                               AND CC.CodCobert   = C.CodCobert)
     AND C.CodCobert IN (SELECT COD_PAGO
                           FROM DETALLE_APROBACION DA
                          WHERE DA.IdSiniestro = C.IdSiniestro
                            AND Num_Aprobacion = (SELECT MAX(Num_Aprobacion)
                                                    FROM APROBACIONES AA
                                                   WHERE AA.IdSiniestro   = nIdSiniestro
                                                     AND AA.IdPoliza      = nIdPoliza))
   GROUP BY C.CodCobert, C.NumMod;
--   
CURSOR COB_Q IS
  SELECT NVL(SUM(DA.Monto_Local),0) Monto_Local, NVL(SUM(DA.Monto_Moneda),0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
    FROM DETALLE_APROBACION DA, APROBACIONES AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Num_Aprobacion = DA.Num_Aprobacion
     AND AP.IdSiniestro    = DA.IdSiniestro
     AND AP.IdPoliza       = nIdPoliza
     AND DA.CodTransac     = CT.CodTransac
     AND DA.CodCptoTransac = CT.CodCptoTransac
     AND CT.IndDisminRva   = 'S'
   GROUP BY DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac;
--

--CURSOR SLDO_Q IS
--  SELECT NVL(SUM(DA.Monto_Local),0) Monto_Local, NVL(SUM(DA.Monto_Moneda),0) Monto_Moneda, 
--         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
--    FROM DETALLE_APROBACION DA, APROBACIONES AP, CPTOS_TRANSAC_SINIESTROS CT
--   WHERE DA.Num_Aprobacion = nNum_Aprobacion
--     AND DA.IdSiniestro    = nIdSiniestro
--     AND AP.Num_Aprobacion = DA.Num_Aprobacion
--     AND AP.IdSiniestro    = DA.IdSiniestro
--     AND AP.IdPoliza       = nIdPoliza
--     AND DA.CodTransac     = CT.CodTransac
--     AND DA.CodCptoTransac = CT.CodCptoTransac
--     AND CT.IndDisminRva   = 'N'
--   GROUP BY DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac;


BEGIN
  --
  BEGIN
    SELECT COUNT(*)
      INTO nRegis
      FROM REQUISITOS_SINIESTRO
     WHERE IdPoliza      = nIdPoliza
       AND IdSiniestro   = nIdSiniestro
       AND FecEntregaReq IS NULL
       AND CodRequisito IN (SELECT CodRequisito
                              FROM REQUISITOS
                             WHERE IndOblig = 'S');
  END;
  --
  BEGIN
    SELECT COUNT(*)
      INTO nRegisCobert
      FROM REQ_COBERT_SIN
     WHERE IdPoliza      = nIdPoliza
       AND IdSiniestro   = nIdSiniestro
       AND CodRequisito IN (SELECT CodRequisito 
                              FROM REQUISITOS
                             WHERE IndOblig = 'S')
       AND FecEntregaReq IS NULL; 
  END;
  --
  IF NVL(nRegis,0) != 0 THEN
     RAISE_APPLICATION_ERROR(-20225,'No puede Pagar el Siniestro porque tiene Requisitos Pendientes de Entregar');
  END IF;
  --
  IF NVL(nRegisCobert,0) != 0 THEN
     RAISE_APPLICATION_ERROR(-20225,'No puede Pagar el Siniestro porque tiene Requisitos por Cobertura Pendientes de Entregar');
  END IF;
  --
  nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 6, 'SIN');

  --se grega fecha equivalente--
   BEGIN
    select NVL(CODEMPRESA,1),NVL(CODCIA,1)
     into cCodEmpresa, cCodCia
     from siniestro
     where idsiniestro = nIdSiniestro
     and idpoliza     = nIdPoliza;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
     RAISE_APPLICATION_ERROR(-202,'No existe compañia:'||SQLERRM);
   END;


    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'SINAPR');
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(cCodCia, cCodEmpresa);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(cCodCia, cCodEmpresa);

    IF cIndFecEquivPro = 'S' THEN

      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;

    ELSE

     dFechaCamb := dFechaReal;

    end if;
  --
  BEGIN
    UPDATE APROBACIONES
       SET StsAprobacion  = 'PAG',
           IdTransaccion  = nIdTransaccion, 
           fecpago        = dFechaCamb
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  BEGIN
    SELECT Monto_Local, Monto_Moneda, Nvl(Benef,0)
      INTO nMonto_Local, nMonto_Moneda, nBenef
      FROM APROBACIONES
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 6, 'APRSIN', 'APROBACIONES',
                              nIdSiniestro, nIdPoliza, nIdDetSin, nNum_Aprobacion, nMonto_Moneda);

  GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransaccion, TRUNC(SYSDATE));
  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
  --
  BEGIN
    SELECT Tipo_de_Aprobacion
     INTO cTipo_de_Aprobacion
     FROM APROBACIONES
    WHERE Num_Aprobacion = nNum_Aprobacion
      AND IdSiniestro    = nIdSiniestro
      AND IdPoliza       = nIdPoliza;
  END;
  --
  FOR W IN COB_Q LOOP
     cCod_Pago := W.Cod_Pago;
     MONTO_MONEDA_FONDEO := NVL(W.Monto_Moneda,0);  -- FONDEO
     --
        BEGIN
          SELECT 'S'
            INTO cExiste
            FROM PAGOS_POR_OTROS_CONCEPTOS
           WHERE IdSiniestro = nIdSiniestro
             AND IdDetSin    = nIdDetSin
             AND Concepto    = cCod_Pago;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            cExiste := 'N';
          WHEN TOO_MANY_ROWS THEN
            cExiste := 'S';
        END;
    --
      SELECT SUM(C.Saldo_Reserva) INTO HabemusReserva
        FROM COBERTURA_SINIESTRO C
       WHERE C.IdSiniestro   = nIdSiniestro
         AND C.IdPoliza      = nIdPoliza
         --AND C.Cod_Asegurado = nCod_Asegurado
         AND C.StsCobertura  = 'EMI'
         --AND C.CODCOBERT     = cCod_Pago
         AND (C.CODCOBERT     = cCod_Pago
                OR cCod_Pago     IN (SELECT CodValor
                                       FROM VALORES_DE_LISTAS L
                                      WHERE L.CodLista = 'CONDED'
                                        AND CodValor = cCod_Pago)
            )
         AND C.NumMod        IN (SELECT MAX(NumMod) 
                                   FROM COBERTURA_SINIESTRO_ASEG CC
                                  WHERE CC.IdSiniestro   = nIdSiniestro
                                    AND CC.IdPoliza      = nIdPoliza
                                    ---AND CC.Cod_Asegurado = nCod_Asegurado
                                    AND C.StsCobertura   = 'EMI'
                                    AND CC.CodCobert     = C.CodCobert);

    ReservaCobertura := (W.Monto_Local - HabemusReserva);
    IF W.Monto_Local > HabemusReserva  THEN
       RAISE_APPLICATION_ERROR(-20225,'Error El monto de Pago supera la Reserva de la Cobertura por : '||ReservaCobertura||'  pesos. ');
    END IF;

    FOR J IN C_RESERVA LOOP
      BEGIN
        SELECT 'S'
          INTO cExisteCodPagoNoCob
          FROM VALORES_DE_LISTAS L
         WHERE L.CodLista = 'CONDED'
           AND CodValor = cCod_Pago;
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            cExisteCodPagoNoCob := 'N';
      END;
      --
      IF cCod_Pago = J.CodCobert OR cExisteCodPagoNoCob = 'S' THEN 
       --IF cCod_Pago = J.CodCobert THEN 
          nMonto_Reserva := nMonto_Reserva  + J.nMonto;
          nNumMod        := J.NumMod;
      END IF;   
    END LOOP;
    --

    IF cExiste = 'N' THEN
       -- Actualiza Coberturas
      BEGIN
          UPDATE COBERTURA_SINIESTRO C
             SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) + NVL(nMonto_Local,0),
                 Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) + NVL(nMonto_Moneda,0),
                 Saldo_Reserva       = NVL(Saldo_Reserva,0) - NVL(nMonto_Moneda,0),
                 Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) - NVL(nMonto_Local,0)
           WHERE IdPoliza    = nIdPoliza
             AND IdSiniestro = nIdSiniestro
             AND IdDetSin    = nIdDetSin
             --AND CodCobert   = cCod_Pago
             AND (CodCobert    = cCod_Pago 
                     OR cCod_Pago IN (SELECT CodValor
                                       FROM VALORES_DE_LISTAS L
                                      WHERE L.CodLista = 'CONDED'
                                        AND CodValor = cCod_Pago)
                    )
             AND C.CodCobert IN (SELECT COD_PAGO
                           FROM DETALLE_APROBACION DA
                          WHERE DA.IdSiniestro = C.IdSiniestro
                            AND Num_Aprobacion = (SELECT MAX(Num_Aprobacion)
                                                    FROM APROBACIONES AA
                                                   WHERE AA.IdSiniestro   = nIdSiniestro
                                                     AND AA.IdPoliza      = nIdPoliza))
             AND NumMod      = nNumMod;
      END;
    ELSE
         -- Actualiza Otros Conceptos de Pago
        UPDATE PAGOS_POR_OTROS_CONCEPTOS
           SET Monto_Pago_Local  = NVL(Monto_Pago_Local,0) + NVL(W.Monto_Local,0),
               Monto_Pago_Moneda = NVL(Monto_Pago_Moneda,0) + NVL(W.Monto_Moneda,0)
         WHERE IdSiniestro = nIdSiniestro
           AND IdDetSin    = nIdDetSin
           AND Concepto    = cCod_Pago;
    END IF;

    nMonto_Reserva := 0;

  END LOOP;
  --  

--    nMonto_Moneda:= 0;
--    nMonto_Local := 0;
--    FOR W IN SLDO_Q LOOP 
--         nMonto_Moneda := NVL(nMonto_Moneda,0) + NVL(W.Monto_Moneda,0);
--         nMonto_Local  := NVL(nMonto_Local,0) + NVL(W.Monto_Local,0);
--    END LOOP;
--    
--    UPDATE COBERTURA_SINIESTRO ---ACTUALIZANDO SALDOS, ESTOS DEBEN CONSIDERAR TODOS LOS CONCEPTOS PARA PODER GENERAR LA DIFERENCIA DE LOS CONCEPTOS DE NO DISMINUYEN RESERVA
--           SET Saldo_Reserva       = nMonto_Moneda,
--               Saldo_Reserva_Local = nMonto_LocalMSTS
--         WHERE IdSiniestro   = nIdSiniestro
--           AND IdDetSin      = nIdDetSin
--           AND NumMod        = nNumMod;

  BEGIN
    OC_APROBACIONES.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nNum_Aprobacion);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error Actualizando Pagos :'||SQLERRM);
  END;
  --
  -- FONDEO
  --
  BEGIN
    SELECT B.IDTIPO_PAGO
      INTO CIDTIPO_PAGO
      FROM BENEF_SIN B
     WHERE B.IDSINIESTRO = nIdSiniestro
       AND B.BENEF       = nBenef
       AND B.CODCIA      = nCodCia;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
         CIDTIPO_PAGO := 'NDFXXX';
    WHEN OTHERS THEN
         CIDTIPO_PAGO := 'OTHXXX';
  END;
  --
  BEGIN
    TH_FONDEO.INSERTA(nCodCia, cCodEmpresa, nIdSiniestro, nIdDetSin, nNum_Aprobacion, nBenef, dFechaCamb, CIDTIPO_PAGO, MONTO_MONEDA_FONDEO,PMENSAJE);
  END;
  --
  -- FONDEO
  --
  BEGIN
    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'APRSIN');
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(nCodCia, nCodEmpresa);

    IF cIndFecEquivPro = 'S' THEN

      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;

    ELSE

     dFechaCamb := dFechaReal;

    end if;

    UPDATE TAREA
       SET Estado_Final     = 'EJE',
           FechadeRealizado = dFechaCamb,
           UsuarioRealizo   = USER,
           Estado           = 'EJE'
     WHERE IdSiniestro      = nIdSiniestro
       AND CodCia           = nCodCia
       AND CodSubProceso    = 'APRSIN'
       AND IdProceso        = 6
       AND Estado           = 'PRO';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en Tarea de Siniestro No. '|| nIdSiniestro ||SQLERRM);
  END;

  BEGIN
    OC_BENEF_SIN_PAGOS.INSERTA(nIdSiniestro, nIdPoliza, nBenef, nNum_Aprobacion, nIdDetSin);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en Registrar Benef_Sin_Pagos: '||SQLERRM);
  END;
  --
  cObservaciones := 'Efectúa el Pago del Siniestro de la Aprobacion No. '||nNum_Aprobacion||' con el Monto '||nMonto_Moneda;
  OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, cObservaciones);
  --
END PAGAR;

PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                 nIdPoliza NUMBER, nIdDetSin NUMBER) IS
--
cCod_Pago            DETALLE_APROBACION.Cod_Pago%TYPE;
nMonto_Local         DETALLE_APROBACION.Monto_Local%TYPE;
nMonto_Moneda        DETALLE_APROBACION.Monto_Moneda%TYPE;
nMaxNumMod           COBERTURA_SINIESTRO.NumMod%TYPE;
nMonto_Reserva       DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
cStsPag              APROBACIONES.StsAprobacion%TYPE;
nAjuste              DETALLE_APROBACION.Monto_Local%TYPE := 0;
cIndTipoCobert       CPTOS_TRANSAC_SINIESTROS.IndTipoCobert%TYPE;
nIdTransaccionAnul   TRANSACCION.IdTransaccion%TYPE;
cCodTransac          DETALLE_APROBACION.CodTransac%TYPE;
cCodCptoTransac      DETALLE_APROBACION.CodCptoTransac%TYPE;
cTipo_de_Aprobacion  APROBACIONES.Tipo_de_Aprobacion%TYPE;
nBenef               APROBACIONES.Benef%TYPE;
cExiste              VARCHAR2(1);
cCpto                VARCHAR2(6);
nRegis               NUMBER(10);
nRegisCobert         NUMBER(10);
nNumMod              COBERTURA_SINIESTRO_ASEG.NumMod%TYPE := 0;
cObservaciones       OBSERVACION_SINIESTRO.Descripcion%TYPE;
cIndFecEquivPro      PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv         SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb           APROBACIONES.FECPAGO%TYPE;
dFechaCont           FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal           FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
--
PAGOTOTAL            COBERTURA_SINIESTRO.MONTO_PAGADO_MONEDA%TYPE;
--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO C
   WHERE C.IdSiniestro   = nIdSiniestro
     AND C.IdPoliza      = nIdPoliza
     AND C.StsCobertura  = 'EMI'
     AND C.NumMod IN  (SELECT MAX(NumMod) 
                         FROM COBERTURA_SINIESTRO CC
                        WHERE CC.IdSiniestro   = nIdSiniestro
                          AND CC.IdPoliza      = nIdPoliza
                          AND C.StsCobertura   = 'EMI'
                          AND CC.CodCobert     = C.CodCobert)
  GROUP BY  C.CodCobert, C.NumMod;
--
CURSOR COB_Q IS
  SELECT NVL(DA.Monto_Local,0) Monto_Local, NVL(DA.Monto_Moneda,0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
    FROM DETALLE_APROBACION DA, APROBACIONES AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Num_Aprobacion = DA.Num_Aprobacion
     AND AP.IdSiniestro    = DA.IdSiniestro
     AND AP.IdPoliza       = nIdPoliza
     AND DA.CodTransac     = CT.CodTransac
     AND DA.CodCptoTransac = CT.CodCptoTransac
     AND CT.IndDisminRva   = 'S';
--
BEGIN
 --- RAISE_APPLICATION_ERROR(-20225,'Error  No se permiten Anular Pagos. '); 
  --
  nIdTransaccionAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 6, 'ANUAPR');

  --
  BEGIN
    UPDATE APROBACIONES
       SET StsAprobacion     = 'ANU',
           IdTransaccionAnul = nIdTransaccionAnul 
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  BEGIN
    SELECT Monto_Moneda, Nvl(Benef,0), Tipo_de_Aprobacion
      INTO nMonto_Moneda, nBenef, cTipo_de_Aprobacion
      FROM APROBACIONES
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;

  OC_DETALLE_TRANSACCION.CREA(nIdTransaccionAnul, nCodCia, nCodEmpresa, 6, 'ANUAPR', 'APROBACIONES',
                              nIdSiniestro, nIdPoliza, nIdDetSin, nNum_Aprobacion, nMonto_Moneda);

  GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransaccionAnul, TRUNC(SYSDATE));
  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccionAnul, 'C');
  --
  FOR W IN COB_Q LOOP
    --
    cCod_Pago := W.Cod_Pago;
    --
    BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = nIdDetSin
         AND Concepto    = cCod_Pago;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
        cExiste := 'S';
    END;
    --
    FOR J IN C_RESERVA LOOP
      IF cCod_Pago = J.CodCobert THEN 
         nMonto_Reserva := nMonto_Reserva  + J.nMonto;
         nNumMod        := J.NumMod;
      END IF;   
    END LOOP;
    --
    IF cExiste = 'N' THEN
       -- Actualiza Coberturas
       UPDATE COBERTURA_SINIESTRO
          SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) - NVL(W.Monto_Moneda,0),
              Saldo_Reserva       = NVL(Saldo_Reserva,0) + NVL(W.Monto_Moneda,0),
              Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) + NVL(W.Monto_Local,0)
        WHERE IdSiniestro = nIdSiniestro
          AND IdDetSin    = nIdDetSin
          AND CodCobert   = cCod_Pago
          AND NumMod      = nNumMod;

          SELECT (SUM(NVL(T3.MONTO_PAGADO_MONEDA,0)) - NVL(W.MONTO_LOCAL,0) ) INTO PAGOTOTAL  --  AEVS 06102016
            FROM COBERTURA_SINIESTRO T3
            WHERE T3.IDSINIESTRO   = nIdSiniestro;

            UPDATE DETALLE_SINIESTRO DS
            SET   DS.MONTO_PAGADO_MONEDA = PAGOTOTAL
                 ,DS.MONTO_PAGADO_LOCAL  = PAGOTOTAL
            WHERE DS.IDSINIESTRO  = nIdSiniestro
            AND   DS.IDPOLIZA     = nIdPoliza 
            AND   DS.IDDETSIN     = 1 ;   

            UPDATE  SINIESTRO S1
            SET   S1.MONTO_PAGO_MONEDA = PAGOTOTAL
                 ,S1.MONTO_PAGO_LOCAL  = PAGOTOTAL
            WHERE S1.IDSINIESTRO  = nIdSiniestro
            AND   S1.IDPOLIZA     = nIdPoliza 
            ;   



    ELSE
       -- Actualiza Otros Conceptos de Pago
       UPDATE PAGOS_POR_OTROS_CONCEPTOS
          SET Monto_Pago_Local  = NVL(Monto_Pago_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pago_Moneda = NVL(Monto_Pago_Moneda,0) - NVL(W.Monto_Moneda,0)
        WHERE IdSiniestro = nIdSiniestro
          AND IdDetSin    = nIdDetSin
          AND Concepto    = cCod_Pago;
    END IF;
    --
    IF cTipo_de_Aprobacion = 'T' THEN
       BEGIN
         SELECT NumMod, Monto_Reservado_Moneda
           INTO nMaxNumMod, nAjuste
           FROM COBERTURA_SINIESTRO
          WHERE IdPoliza      = nIdpoliza
            AND IdSiniestro   = nIdSiniestro
            AND CodCobert     = cCod_Pago
            AND CodTransac    = 'AJURES';
       EXCEPTION
         WHEN OTHERS THEN
           nMaxNumMod := 0;
       END;
       --
       IF nMaxNumMod > 0 THEN
          OC_COBERTURA_SINIESTRO.ANULAR_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                                                nIdDetSin, cCod_Pago, nMaxNumMod);
          OC_DETALLE_SINIESTRO.ACTUALIZA_RESERVAS(nIdSiniestro);
       END IF;
       --
    END IF;
    --
  END LOOP;
  --
  BEGIN
    OC_APROBACIONES.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nNum_Aprobacion);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error Actualizando Pagos :'||SQLERRM);
  END;
  --
  BEGIN
    cIndFecEquivPro := OC_PROC_TAREA.INDICA_FEC_EQUIVALENTE_PRO(6);
    cIndFecEquiv    := OC_SUB_PROCESO.INDICA_FEC_EQUIVALENTE_SUBPROC(6,'ANUAPR');
    dFechaCont      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_CONTABLE(nCodCia, nCodEmpresa);
    dFechaReal      := GT_FECHA_CONTABLE_EQUIVALENTE.FECHA_REAL(nCodCia, nCodEmpresa);

   IF cIndFecEquivPro = 'S' THEN

      IF cIndFecEquiv = 'S' then
         dFechaCamb:= dFechaCont;  
      else
        dFechaCamb := dFechaReal;
      end if;

    ELSE

     dFechaCamb := dFechaReal;

    end if;

    UPDATE TAREA
       SET Estado_Final     = NULL,
           FechadeRealizado = dFechaCamb,
           UsuarioRealizo   = USER,
           Estado           = 'SOL'
     WHERE IdSiniestro      = nIdSiniestro
       AND CodCia           = nCodCia
       AND CodSubProceso    = 'ANUAPR'
       AND IdProceso        = 6
       AND Estado           = 'PRO';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en Tarea de Siniestro No. '|| nIdSiniestro ||SQLERRM);
  END;
  --
  BEGIN
    OC_BENEF_SIN_PAGOS.ANULAR(nIdSiniestro, nIdPoliza, nBenef, nNum_Aprobacion, nIdDetSin);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Anular Benef_Sin_Pagos: '||SQLERRM);
  END;
  --

  cObservaciones := 'Efectúa la Anulación del Pago del Siniestro de la Aprobacion No. '||nNum_Aprobacion||' con el Monto '||nMonto_Moneda;

  OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, cObservaciones);
END ANULAR;

PROCEDURE REVERTIR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                   nIdPoliza NUMBER, nIdDetSin NUMBER ,nBenef NUMBER) IS                  


--
cCod_Pago            DETALLE_APROBACION.Cod_Pago%TYPE;
cExiste              VARCHAR2(1);
nNumComprob          COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdTransaccion       APROBACIONES.IdTransaccion%TYPE;
nNumMod              COBERTURA_SINIESTRO.NumMod%TYPE := 0;
nMonto_Reserva       DETALLE_APROBACION.Monto_Moneda%TYPE := 0;
cTipo_de_Aprobacion  APROBACIONES.Tipo_de_Aprobacion%TYPE;
nMaxNumMod           COBERTURA_SINIESTRO.NumMod%TYPE;
nAjuste              DETALLE_APROBACION.Monto_Local%TYPE := 0;
cObservaciones       OBSERVACION_SINIESTRO.Descripcion%TYPE;
--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO C
   WHERE C.IdSiniestro   = nIdSiniestro
     AND C.IdPoliza      = nIdPoliza
     AND C.StsCobertura  = 'EMI'
     AND C.NumMod IN  (SELECT MAX(NumMod) 
                         FROM COBERTURA_SINIESTRO CC
                        WHERE CC.IdSiniestro   = nIdSiniestro
                          AND CC.IdPoliza      = nIdPoliza
                          AND C.StsCobertura   = 'EMI'
                          AND CC.CodCobert     = C.CodCobert)
  GROUP BY  C.CodCobert, C.NumMod;
--
CURSOR COB_Q IS
  SELECT NVL(DA.Monto_Local,0) Monto_Local, NVL(DA.Monto_Moneda,0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
    FROM DETALLE_APROBACION DA, APROBACIONES AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Num_Aprobacion = DA.Num_Aprobacion
     AND AP.IdSiniestro    = DA.IdSiniestro
     AND AP.IdPoliza       = nIdPoliza
     AND DA.CodTransac     = CT.CodTransac
     AND DA.CodCptoTransac = CT.CodCptoTransac
     AND CT.IndDisminRva   = 'S';
--
BEGIN
  --
  RAISE_APPLICATION_ERROR(-20225,'Error  No se permiten Revertir  Pagos. ');
  /*BEGIN
    SELECT AA.IdTransaccion, CC.NumComprob, AA.Tipo_De_Aprobacion
      INTO nIdTransaccion, nNumComprob, cTipo_de_Aprobacion
      FROM APROBACIONES AA, COMPROBANTES_CONTABLES CC
     WHERE AA.Num_Aprobacion = nNum_Aprobacion
       AND AA.IdPoliza       = nIdPoliza
       AND AA.IdSiniestro    = nIdSiniestro
       AND AA.IdTransaccion  = CC.NumTransaccion;
  END;
  --
  BEGIN
    UPDATE APROBACIONES
       SET StsAprobacion     = 'SOL'
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  BEGIN
    DELETE FROM COMPROBANTES_DETALLE
     WHERE NumComprob = nNumComprob;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Borrar los Comprobantes Detalle No. : '||nNumComprob||' Error: '||SQLERRM);
  END;
  --
  BEGIN
    DELETE FROM COMPROBANTES_CONTABLES
     WHERE NumComprob = nNumComprob
       AND NumComprobSC   IS NULL
       AND FecEnvioSC     IS NULL;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Borrar la Contabilidad del comprobante No. : '||nNumComprob||' Error: '||SQLERRM);
  END;
  --
  BEGIN
    DELETE FROM DETALLE_TRANSACCION
     WHERE IdTransaccion = nIdTransaccion;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Borrar el detalle de las Transacciones de la Transaccion No. : '||nIdTransaccion||' Error: '||SQLERRM);
  END;
  --
  BEGIN
    DELETE FROM TRANSACCION
     WHERE IdTransaccion = nIdTransaccion;
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Borrar la Transaccion No. : '||nIdTransaccion||' Error: '||SQLERRM);
  END;
  --
  FOR W IN COB_Q LOOP
    --
    cCod_Pago := W.Cod_Pago;
    --
    BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdDetSin    = nIdDetSin
         AND Concepto    = cCod_Pago;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        cExiste := 'N';
      WHEN TOO_MANY_ROWS THEN
        cExiste := 'S';
    END;
    --
    FOR J IN C_RESERVA LOOP
      IF cCod_Pago = J.CodCobert THEN 
         nMonto_Reserva := nMonto_Reserva  + J.nMonto;
         nNumMod        := J.NumMod;
      END IF;   
    END LOOP;
    --
    IF cExiste = 'N' THEN
       -- Actualiza Coberturas
       UPDATE COBERTURA_SINIESTRO
          SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) - NVL(W.Monto_Moneda,0),
              Saldo_Reserva       = NVL(Saldo_Reserva,0) + NVL(W.Monto_Moneda,0),
              Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) + NVL(W.Monto_Local,0)
        WHERE IdSiniestro   = nIdSiniestro
          AND IdDetSin      = nIdDetSin
          AND CodCobert     = cCod_Pago
          AND NumMod        = nNumMod;
    ELSE
       -- Actualiza Otros Conceptos de Pago
       UPDATE PAGOS_POR_OTROS_CONCEPTOS
          SET Monto_Pago_Local  = NVL(Monto_Pago_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pago_Moneda = NVL(Monto_Pago_Moneda,0) - NVL(W.Monto_Moneda,0)
        WHERE IdSiniestro = nIdSiniestro
          AND IdDetSin    = nIdDetSin
          AND Concepto    = cCod_Pago;
    END IF;
    --
    IF cTipo_de_Aprobacion = 'T' THEN
       --
       BEGIN
         SELECT NumMod, Monto_Reservado_Moneda
           INTO nMaxNumMod, nAjuste
           FROM COBERTURA_SINIESTRO
          WHERE IdPoliza      = nIdpoliza
            AND IdSiniestro   = nIdSiniestro
            AND CodCobert     = cCod_Pago
            AND CodTransac    = 'AJURES';
       EXCEPTION
         WHEN OTHERS THEN
           nMaxNumMod := 0;
       END;
       --
       IF nMaxNumMod > 0 THEN 
          OC_COBERTURA_SINIESTRO.ANULAR_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                                                nIdDetSin, cCod_Pago, nMaxNumMod);
          OC_DETALLE_SINIESTRO.ACTUALIZA_RESERVAS(nIdSiniestro);
       END IF;
       --
    END IF;
    --
  END LOOP;
  --
  BEGIN
    OC_APROBACIONES.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nNum_Aprobacion);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error Actualizando Pagos :'||SQLERRM);
  END;
  --
  BEGIN
    UPDATE TAREA
       SET Estado_Final     = NULL,
           FechadeRealizado = SYSDATE,
           UsuarioRealizo   = USER,
           Estado           = 'SOL'
     WHERE IdSiniestro      = nIdSiniestro
       AND CodCia           = nCodCia
       AND CodSubProceso    = 'APRSIN'
       AND IdProceso        = 6
       AND Estado           = 'PRO';
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error en Tarea de Siniestro No. '|| nIdSiniestro ||' Error '||SQLERRM);
  END;
  --
  BEGIN
    OC_BENEF_SIN_PAGOS.REVERTIR(nIdSiniestro, nIdPoliza, nBenef, nNum_Aprobacion, nIdDetSin);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error al Revertir Benef_Sin_Pagos: '||SQLERRM);
  END;
  --
  cObservaciones := 'Efectúa la Reversion del Pago del Siniestro de la Aprobacion No. '||nNum_Aprobacion;
  OC_OBSERVACION_SINIESTRO.INSERTA_OBSERVACION(nIdSiniestro, nIdPoliza, cObservaciones);*/
  --
END REVERTIR;
--
--
PROCEDURE  ACTUALIZA_FONDEO(nNum_Aprobacion in NUMBER, nIdSiniestro in NUMBER, nIdPoliza in NUMBER, IDDETSIN in NUMBER ) IS

USUSARIO   VARCHAR2(50);
TERMINAL   VARCHAR2(50);

BEGIN
    SELECT  USER, USERENV('TERMINAL')
    INTO    USUSARIO,TERMINAL 
    FROM    SYS.DUAL; 
    BEGIN
      UPDATE APROBACIONES UA
      SET UA.INDFONDOSINI  = 'S',
          UA.FECHFONDOSINI = SYSDATE,
          UA.CODUSUARIO    = USUSARIO,
          UA.TERMINAL      = TERMINAL
      WHERE UA.NUM_APROBACION = nNum_Aprobacion
      AND   UA.IDSINIESTRO    = nIdSiniestro
      AND   UA.IDPOLIZA       = nIdPoliza
      AND   UA.IDDETSIN       = IDDETSIN;
    EXCEPTION  WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'APROBACIONES Error NDF ACTUALIZA_FONDEO: '||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'APROBACIONES Error Others ACTUALIZA_FONDEO: '||SQLERRM);
    END;           
EXCEPTION
   WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20225,'Error General ACTUALIZA_FONDEO: '||SQLERRM);
END ACTUALIZA_FONDEO;
--
PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nIdAutorizacion NUMBER) IS
BEGIN
    UPDATE APROBACIONES
       SET IdAutorizacion = nIdAutorizacion
     WHERE IdSiniestro    = nIdSiniestro
       AND IdDetSin       = nIdDetSin
       AND IdPoliza       = nIdPoliza
       AND Num_Aprobacion = cNum_Aprobacion;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error al Asignar Autorización: '||nIdAutorizacion||' '||SQLERRM);
END ACTUALIZA_AUTORIZACION;
--
FUNCTION  NUMERO_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2) RETURN NUMBER IS
nIdAutorizacion APROBACION_ASEG.IdAutorizacion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdAutorizacion,0)
        INTO nIdAutorizacion 
        FROM APROBACIONES
       WHERE IdSiniestro    = nIdSiniestro
         AND IdDetSin       = nIdDetSin
         AND IdPoliza       = nIdPoliza
         AND Num_Aprobacion = cNum_Aprobacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdAutorizacion := 0;
   END;  
   RETURN nIdAutorizacion;    
END NUMERO_AUTORIZACION;
END OC_APROBACIONES;