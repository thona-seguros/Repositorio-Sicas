--
-- OC_APROBACION_ASEG  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DUAL (Table)
--   DBMS_STANDARD (Package)
--   PROCESOS_MASIVOS_SEGUIMIENTO (Table)
--   PROC_TAREA (Table)
--   FECHA_CONTABLE_EQUIVALENTE (Table)
--   DETALLE_APROBACION (Table)
--   DETALLE_APROBACION_ASEG (Table)
--   DETALLE_SINIESTRO (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   TAREA (Table)
--   GT_FECHA_CONTABLE_EQUIVALENTE (Package)
--   GT_REA_DISTRIBUCION (Package)
--   OC_DETALLE_SINIESTRO_ASEG (Package)
--   OC_DETALLE_TRANSACCION (Package)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   TRANSACCION (Table)
--   VALORES_DE_LISTAS (Table)
--   OC_PROC_TAREA (Package)
--   OC_SUB_PROCESO (Package)
--   SINIESTRO (Table)
--   SUB_PROCESO (Table)
--   COMPROBANTES_CONTABLES (Table)
--   CPTOS_TRANSAC_SINIESTROS (Table)
--   COBERTURA_SINIESTRO (Table)
--   COBERTURA_SINIESTRO_ASEG (Table)
--   OC_TRANSACCION (Package)
--   PAGOS_POR_OTROS_CONCEPTOS (Table)
--   OBSERVACION_SINIESTRO (Table)
--   OC_APROBACIONES (Package)
--   OC_BENEF_SIN_PAGOS (Package)
--   OC_COBERTURA_SINIESTRO_ASEG (Package)
--   OC_COMPROBANTES_CONTABLES (Package)
--   REQUISITOS (Table)
--   REQUISITOS_SINIESTRO (Table)
--   REQ_COBERT_SIN (Table)
--   OC_OBSERVACION_SINIESTRO (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.OC_APROBACION_ASEG IS
  --
  FUNCTION INSERTA_APROBACION(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCodAsegurado NUMBER, nMonto_Local NUMBER,
                              nMonto_Moneda NUMBER, cTipoAprobacion VARCHAR2, cSubTipoAprobacion VARCHAR2,
                              nIdeFactExt NUMBER) RETURN NUMBER;
  --
  PROCEDURE ACTUALIZA_PAGOS(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER, nNum_Aprobacion NUMBER);
  --
  PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, 
                  nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER, nIdDetSin NUMBER);
  --
  PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                   nIdPoliza NUMBER, nCod_Asegurado NUMBER, nIdDetSin NUMBER);
  --
  PROCEDURE REVERTIR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                     nIdPoliza NUMBER, nIdDetSin NUMBER, nCod_Asegurado NUMBER, nBenef NUMBER);
  --
  PROCEDURE ACTUALIZA_FONDEO(nNum_Aprobacion in NUMBER, nIdSiniestro in NUMBER, nIdPoliza in NUMBER, IDDETSIN in NUMBER );
  --
  PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nCod_Asegurado NUMBER,  nIdAutorizacion NUMBER);
  --
  FUNCTION  NUMERO_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nCod_Asegurado NUMBER) RETURN NUMBER;
END OC_APROBACION_ASEG;
/

--
-- OC_APROBACION_ASEG  (Package Body) 
--
--  Dependencies: 
--   OC_APROBACION_ASEG (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_APROBACION_ASEG IS
--
--
--
FUNCTION INSERTA_APROBACION(nIdSiniestro  NUMBER, nIdPoliza  NUMBER, nCodAsegurado NUMBER, nMonto_Local NUMBER,
                            nMonto_Moneda NUMBER, cTipoAprobacion VARCHAR2, cSubTipoAprobacion VARCHAR2,
                            nIdeFactExt NUMBER) RETURN NUMBER IS
--
nNum_Aprobacion   APROBACION_ASEG.Num_Aprobacion%TYPE;
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;
--
BEGIN
  --
  BEGIN
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
    
    
    INSERT INTO APROBACION_ASEG
          (Num_Aprobacion, IdSiniestro, IdPoliza, IdDetSin, Cod_Asegurado, Tipo_Aprobacion, 
           Monto_Local, Monto_Moneda, StsAprobacion, Tipo_De_Aprobacion,
           IdTransaccion, IndDispersion, IdeFactExt, indfondosini,FECPAGO )
    VALUES(nNum_Aprobacion, nIdSiniestro, nIdPoliza, 1, nCodAsegurado, cSubTipoAprobacion, 
           nMonto_Local, nMonto_Moneda, 'EMI', cTipoAprobacion, NULL, 'N', nIdeFactExt,'N',dFechaCamb);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'INSERCION APROBACIONES ASEG SINIESTRO - Ocurrió el siguiente error: '||SQLERRM);
  END;
  --
  RETURN(nNum_Aprobacion);
  --
END INSERTA_APROBACION;
--
--
--
PROCEDURE ACTUALIZA_PAGOS(nIdSiniestro NUMBER, nIdPoliza NUMBER, nCod_Asegurado NUMBER, nNum_Aprobacion NUMBER) IS
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
     FROM DETALLE_SINIESTRO_ASEG
    WHERE IdSiniestro   = nIdSiniestro
      AND IdPoliza      = nIdPoliza
      AND Cod_Asegurado = nCod_Asegurado;
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
    FROM DETALLE_APROBACION_ASEG D, CPTOS_TRANSAC_SINIESTROS J
   WHERE EXISTS (SELECT 1 
                   FROM APROBACION_ASEG A
                  WHERE A.IdSiniestro    = D.IdSiniestro
                    AND D.Num_Aprobacion = A.Num_Aprobacion
                    AND A.IdSiniestro    = nIdSiniestro
                    AND A.Cod_Asegurado  = nCod_Asegurado
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
        FROM COBERTURA_SINIESTRO_ASEG
       WHERE IdSiniestro   = nIdSiniestro
         AND IdPoliza      = nIdPoliza
         AND Cod_Asegurado = nCod_Asegurado;
      --
      SELECT NVL(SUM(Monto_Pago_Local),0), NVL(SUM(Monto_Pago_Moneda),0)
        INTO nOtrPagLocal, nOtrPagMoneda
        FROM PAGOS_POR_OTROS_CONCEPTOS
       WHERE IdSiniestro = nIdSiniestro
         AND IdPoliza    = nIdPoliza
         AND IdDetSin    = X.IdDetSin;
    END;
  END LOOP;*/
  --
  UPDATE DETALLE_SINIESTRO_ASEG
     SET Monto_Pagado_Local   = nMtoPagLocal,
         Monto_Pagado_Moneda  = nMtoPagMoneda
   WHERE IdSiniestro   = nIdSiniestro
     AND IdPoliza      = nIdPoliza
     AND Cod_Asegurado = nCod_Asegurado;
  --
  SELECT Tipo_de_Aprobacion
    INTO cTipo_de_Aprobacion
    FROM APROBACION_ASEG
   WHERE Num_Aprobacion = nNum_Aprobacion
     AND IdSiniestro   = nIdSiniestro
     AND IdPoliza      = nIdPoliza
     AND Cod_Asegurado = nCod_Asegurado;
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
PROCEDURE PAGAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                nIdPoliza NUMBER, nCod_Asegurado NUMBER, nIdDetSin NUMBER) IS
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


HabemusReserva       COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%type;
ReservaCobertura     COBERTURA_SINIESTRO_ASEG.MONTO_RESERVADO_MONEDA%type;
 
HabemusCodigus       NUMBER:=0;

wMntoMoneda          DETALLE_APROBACION_ASEG.Monto_Moneda%type :=0 ;

cExisteCodPagoNoCob VARCHAR2(1);
cIndFecEquivPro   PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv      SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb        APROBACIONES.FECPAGO%TYPE;
dFechaCont        FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal        FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
cCodEmpresa       SINIESTRO.CODEMPRESA%TYPE;
cCodCia           SINIESTRO.CODCIA%TYPE;

--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO_ASEG C
   WHERE C.IdSiniestro   = nIdSiniestro
     AND C.IdPoliza      = nIdPoliza
     AND C.Cod_Asegurado = nCod_Asegurado
     AND C.StsCobertura  = 'EMI'
     AND C.NumMod        IN (SELECT MAX(NumMod) 
                               FROM COBERTURA_SINIESTRO_ASEG CC
                              WHERE CC.IdSiniestro   = nIdSiniestro
                                AND CC.IdPoliza      = nIdPoliza
                                AND CC.Cod_Asegurado = nCod_Asegurado
                                AND C.StsCobertura   = 'EMI'
                                AND CC.CodCobert     = C.CodCobert)
     AND C.CodCobert IN (SELECT COD_PAGO
                           FROM DETALLE_APROBACION_ASEG DA
                          WHERE DA.IdSiniestro = C.IdSiniestro
                            AND Num_Aprobacion = (SELECT MAX(Num_Aprobacion)
                                                    FROM APROBACION_ASEG AA
                                                   WHERE AA.IdSiniestro   = nIdSiniestro
                                                     AND AA.IdPoliza      = nIdPoliza
                                                     AND AA.Cod_Asegurado = nCod_Asegurado))
   GROUP BY  C.CodCobert, C.NumMod;
--
CURSOR COB_Q IS
  SELECT NVL(SUM(DA.Monto_Local),0) Monto_Local, NVL(SUM(DA.Monto_Moneda),0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
           ,ap.monto_local Mnto_aprob, AP.Tipo_De_Aprobacion
    FROM DETALLE_APROBACION_ASEG DA, APROBACION_ASEG AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Cod_Asegurado  = nCod_Asegurado
     AND AP.Num_Aprobacion = DA.Num_Aprobacion
     AND AP.IdSiniestro    = DA.IdSiniestro
     AND AP.IdPoliza       = nIdPoliza
     AND DA.CodTransac     = CT.CodTransac
     AND DA.CodCptoTransac = CT.CodCptoTransac
     AND CT.IndDisminRva   = 'S'
   GROUP BY DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac,ap.monto_local, AP.Tipo_De_Aprobacion;


--CURSOR SLDO_Q IS
--  SELECT NVL(SUM(DA.Monto_Local),0) Monto_Local, NVL(SUM(DA.Monto_Moneda),0) Monto_Moneda, 
--         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
--           ,ap.monto_local Mnto_aprob, AP.Tipo_De_Aprobacion
--    FROM DETALLE_APROBACION_ASEG DA, APROBACION_ASEG AP, CPTOS_TRANSAC_SINIESTROS CT
--   WHERE DA.Num_Aprobacion = nNum_Aprobacion
--     AND DA.IdSiniestro    = nIdSiniestro
--     AND AP.Cod_Asegurado  = nCod_Asegurado
--     AND AP.Num_Aprobacion = DA.Num_Aprobacion
--     AND AP.IdSiniestro    = DA.IdSiniestro
--     AND AP.IdPoliza       = nIdPoliza
--     AND DA.CodTransac     = CT.CodTransac
--     AND DA.CodCptoTransac = CT.CodCptoTransac
--     AND CT.IndDisminRva   = 'N'
--   GROUP BY DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac,ap.monto_local, AP.Tipo_De_Aprobacion;

--
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
     RAISE_APPLICATION_ERROR(-20225,'No puede Pagar el Siniestro porque tiene Requisitos Pendientes de Entregar del Siniestro');
  END IF;
  --
  IF NVL(nRegisCobert,0) != 0 THEN
     RAISE_APPLICATION_ERROR(-20225,'No puede Pagar el Siniestro porque tiene Requisitos Pendientes de Entregar de la Cobertura');
  END IF;
  --
  nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 6, 'SIN');
  --  Nota...cambiar  hasta abajo.
  ---se agrega cambio fecha--
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
    
  BEGIN
    UPDATE APROBACION_ASEG
       SET StsAprobacion  = 'PAG',
           IdTransaccion  = nIdTransaccion,
           fecpago        = dFechaCamb
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND Cod_Asegurado  = nCod_Asegurado
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
                ----   ACTUALIZO  EL SEGUIMIENTO DE LAS CARGAS MASIVAS   ----
                  BEGIN
                    UPDATE PROCESOS_MASIVOS_SEGUIMIENTO PMSA 
                    SET   PMSA.IDTRANSACCION  = nIdTransaccion                         
                    WHERE PMSA.IDPOLIZA       = nIdPoliza
                    AND   PMSA.NUM_APROBACION = nNum_Aprobacion
                    AND   PMSA.IDSINIESTRO    = nIdSiniestro
                    AND   PMSA.COD_ASEGURADO  = nCod_Asegurado                     
                    ;     
                  EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                       RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
                    WHEN OTHERS  THEN
                       RAISE_APPLICATION_ERROR(-20225,' 1 Error en ACTUALIZA_STATUS UPDATE PROCESOS_MASIVOS_SEGUIMIENTO  '||SQLERRM);
                  END;    
  
  
  BEGIN
    SELECT Monto_Moneda, Nvl(Benef,0)
      INTO nMonto_Moneda, nBenef
      FROM APROBACION_ASEG
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND Cod_Asegurado  = nCod_Asegurado
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;

  OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, nCodEmpresa, 6, 'APRSIN', 'APROBACION_ASEG',
                              nIdSiniestro, nIdPoliza, nIdDetSin, nNum_Aprobacion, nMonto_Moneda);

  GT_REA_DISTRIBUCION.DISTRIBUYE_SINIESTROS(nCodCia, nCodEmpresa, nIdSiniestro, nIdTransaccion, TRUNC(SYSDATE));
  OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');

  BEGIN
    SELECT Tipo_de_Aprobacion
      INTO cTipo_de_Aprobacion
      FROM APROBACION_ASEG
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND IdSiniestro    = nIdSiniestro
       AND IdPoliza       = nIdPoliza;
  END;
  --
  FOR W IN COB_Q LOOP
  
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
    --
     SELECT SUM(C.Saldo_Reserva) INTO HabemusReserva
       FROM COBERTURA_SINIESTRO_ASEG C
      WHERE C.IdSiniestro   = nIdSiniestro
        AND C.IdPoliza      = nIdPoliza
        AND C.Cod_Asegurado = nCod_Asegurado
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
                                   AND CC.Cod_Asegurado = nCod_Asegurado
                                   AND C.StsCobertura   = 'EMI'
                                   AND CC.CodCobert     = C.CodCobert);
                                   
                                   
        ----  Valida que el Codigo sea una Cobertura  ---                           
        SELECT COUNT(*) INTO HabemusCodigus
          FROM COBERTURA_SINIESTRO_ASEG C
         WHERE C.IdSiniestro   = nIdSiniestro
           AND C.IdPoliza      = nIdPoliza
           AND C.Cod_Asegurado = nCod_Asegurado
           AND C.StsCobertura  = 'EMI'
           AND (C.CODCOBERT     = cCod_Pago
                OR cCod_Pago     IN (SELECT CodValor
                                       FROM VALORES_DE_LISTAS L
                                      WHERE L.CodLista = 'CONDED'
                                        AND CodValor = cCod_Pago)
               );
        
        
                                    
    
    ReservaCobertura := (W.Monto_Local - HabemusReserva);
   -- ReservaCobertura := (W.Mnto_aprob - HabemusReserva);
    IF W.Tipo_De_Aprobacion = 'P' THEN
      IF W.Monto_Local > HabemusReserva  THEN
         RAISE_APPLICATION_ERROR(-20225,'Error El monto de Pago '||HabemusReserva||' supera la Reserva de la Cobertura por : '||ReservaCobertura||'  pesos. '||W.Monto_Local);
      END IF;
    END IF;
    FOR J IN C_RESERVA LOOP
        --cCodPagoNoCobert    DETALLE_APROBACION_ASEG.Cod_Pago%TYPE;
        --cExisteCodPagoNoCob VARCAHR2(1);
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
         nMonto_Reserva := nMonto_Reserva  + J.nMonto;
         nNumMod        := J.NumMod;
      END IF;   
      --
    END LOOP;
    
    
    IF cExiste = 'N' THEN
      
      wMntoMoneda :=  wMntoMoneda + nvl(w.Monto_Local,0);
      
      IF   HabemusCodigus > 0 THEN
         -- Actualiza Coberturas
             UPDATE COBERTURA_SINIESTRO_ASEG C
                SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) + NVL(W.Monto_Local,0),
                    Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) + NVL(W.Monto_Moneda,0),
                    Saldo_Reserva       = NVL(Saldo_Reserva,0)       - wMntoMoneda, --NVL(W.Monto_Moneda,0),
                    Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) - wMntoMoneda  --NVL(W.Monto_Local,0)
              WHERE IdSiniestro   = nIdSiniestro
                AND IdDetSin      = nIdDetSin
                AND Cod_Asegurado = nCod_Asegurado
                AND (CodCobert    = cCod_Pago 
                     OR cCod_Pago IN (SELECT CodValor
                                       FROM VALORES_DE_LISTAS L
                                      WHERE L.CodLista = 'CONDED'
                                        AND CodValor = cCod_Pago)
                    )
                AND C.CodCobert IN (SELECT COD_PAGO
                                       FROM DETALLE_APROBACION_ASEG DA
                                      WHERE DA.IdSiniestro = C.IdSiniestro
                                        AND Num_Aprobacion = (SELECT MAX(Num_Aprobacion)
                                                                FROM APROBACION_ASEG AA
                                                               WHERE AA.IdSiniestro   = nIdSiniestro
                                                                 AND AA.IdPoliza      = nIdPoliza
                                                                 AND AA.Cod_Asegurado = nCod_Asegurado))
                AND NumMod        = nNumMod;
            wMntoMoneda:= 0;               
       END IF;          
    ELSE 
    -- Actualiza Otros Conceptos de Pago
        UPDATE PAGOS_POR_OTROS_CONCEPTOS
           SET Monto_Pago_Local  = NVL(Monto_Pago_Local,0) + NVL(W.Monto_Local,0),
               Monto_Pago_Moneda = NVL(Monto_Pago_Moneda,0) + NVL(W.Monto_Moneda,0)
         WHERE IdSiniestro = nIdSiniestro
           AND IdDetSin    = nIdDetSin
           AND Concepto    = cCod_Pago;
    END IF;
  END LOOP;
  
--    wMntoMoneda:= 0;
--    FOR W IN SLDO_Q LOOP 
--         wMntoMoneda := NVL(wMntoMoneda,0) + NVL(W.Monto_Moneda,0);
--    END LOOP;
--    
--    UPDATE COBERTURA_SINIESTRO_ASEG ---ACTUALIZANDO SALDOS, ESTOS DEBEN CONSIDERAR TODOS LOS CONCEPTOS PARA PODER GENERAR LA DIFERENCIA DE LOS CONCEPTOS DE NO DISMINUYEN RESERVA
--           SET Saldo_Reserva       = wMntoMoneda,
--               Saldo_Reserva_Local = wMntoMoneda
--         WHERE IdSiniestro   = nIdSiniestro
--           AND IdDetSin      = nIdDetSin
--           AND Cod_Asegurado = nCod_Asegurado
--           AND NumMod        = nNumMod;
 --
  BEGIN
    OC_APROBACION_ASEG.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nCod_Asegurado, nNum_Aprobacion);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE_APPLICATION_ERROR(-20225,'Error Actualizando Pagos :'||SQLERRM);
  END;
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
  --
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
--
--
--
PROCEDURE ANULAR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                 nIdPoliza NUMBER, nCod_Asegurado NUMBER, nIdDetSin NUMBER) IS
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
--
PAGOTOTAL            SINIESTRO.MONTO_PAGO_MONEDA%TYPE;
cIndFecEquivPro      PROC_TAREA.IndFecEquiv%TYPE;
cIndFecEquiv         SUB_PROCESO.IndFecEquiv%TYPE;
dFechaCamb           APROBACIONES.FECPAGO%TYPE;
dFechaCont           FECHA_CONTABLE_EQUIVALENTE.FECHACONTABLE%TYPE;
dFechaReal           FECHA_CONTABLE_EQUIVALENTE.FECHAREAL%TYPE;
--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO_ASEG C
   WHERE C.IdSiniestro   = nIdSiniestro
     AND C.IdPoliza      = nIdPoliza
     AND C.Cod_Asegurado = nCod_Asegurado
     AND C.StsCobertura  = 'EMI'
     AND C.NumMod IN  (SELECT MAX(NumMod) 
                         FROM COBERTURA_SINIESTRO_ASEG CC
                        WHERE CC.IdSiniestro   = nIdSiniestro
                          AND CC.IdPoliza      = nIdPoliza
                          AND CC.Cod_Asegurado = nCod_Asegurado
                          AND C.StsCobertura   = 'EMI'
                          AND CC.CodCobert     = C.CodCobert)
  GROUP BY  C.CodCobert, C.NumMod;
--
CURSOR COB_Q IS
  SELECT NVL(DA.Monto_Local,0) Monto_Local, NVL(DA.Monto_Moneda,0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
    FROM DETALLE_APROBACION_ASEG DA, APROBACION_ASEG AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Cod_Asegurado  = nCod_Asegurado
     AND AP.Num_Aprobacion = DA.Num_Aprobacion
     AND AP.IdSiniestro    = DA.IdSiniestro
     AND AP.IdPoliza       = nIdPoliza
     AND DA.CodTransac     = CT.CodTransac
     AND DA.CodCptoTransac = CT.CodCptoTransac
     AND CT.IndDisminRva   = 'S';
BEGIN
  --
   --RAISE_APPLICATION_ERROR(-20225,'Error  No se permiten Anular Pagos. ');
  nIdTransaccionAnul := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 6, 'ANUAPR');
  --
  BEGIN
    UPDATE APROBACION_ASEG
       SET StsAprobacion     = 'ANU',
           IdTransaccionAnul = nIdTransaccionAnul 
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND Cod_Asegurado  = nCod_Asegurado
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  BEGIN
    SELECT Monto_Moneda, Nvl(Benef,0), Tipo_de_Aprobacion
      INTO nMonto_Moneda, nBenef, cTipo_de_Aprobacion
      FROM APROBACION_ASEG
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND Cod_Asegurado  = nCod_Asegurado
       AND IdPoliza       = nIdPoliza
       AND IdSiniestro    = nIdSiniestro;
  END;
  --
  OC_DETALLE_TRANSACCION.CREA(nIdTransaccionAnul, nCodCia, nCodEmpresa, 6, 'ANUAPR', 'APROBACION_ASEG',
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
       UPDATE COBERTURA_SINIESTRO_ASEG
          SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) - NVL(W.Monto_Moneda,0),
              Saldo_Reserva       = NVL(Saldo_Reserva,0) + NVL(W.Monto_Moneda,0),
              Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) + NVL(W.Monto_Local,0)
        WHERE IdSiniestro   = nIdSiniestro
          AND IdDetSin      = nIdDetSin
          AND Cod_Asegurado = nCod_Asegurado
          AND CodCobert     = cCod_Pago
          AND NumMod        = nNumMod;
          
           SELECT (SUM(NVL(T3.MONTO_PAGADO_MONEDA,0)) - NVL(W.MONTO_LOCAL,0) ) INTO PAGOTOTAL
            FROM COBERTURA_SINIESTRO_ASEG T3
            WHERE T3.IDSINIESTRO   = nIdSiniestro;
          
            UPDATE DETALLE_SINIESTRO_ASEG DS
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
       --
       BEGIN
         SELECT NumMod, Monto_Reservado_Moneda
           INTO nMaxNumMod, nAjuste
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdPoliza      = nIdpoliza
            AND IdSiniestro   = nIdSiniestro
            AND Cod_Asegurado = nCod_Asegurado
            AND CodCobert     = cCod_Pago
            AND CodTransac    = 'AJURES';
       EXCEPTION
         WHEN OTHERS THEN
           nMaxNumMod := 0;
       END;
       --
       IF nMaxNumMod > 0 THEN 
          OC_COBERTURA_SINIESTRO_ASEG.ANULAR_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                         nIdDetSin, nCod_Asegurado, cCod_Pago, nMaxNumMod);
          OC_DETALLE_SINIESTRO_ASEG.ACTUALIZA_RESERVAS(nIdSiniestro);
       END IF;
       --
    END IF;
    --
  END LOOP;
  --
  BEGIN
    OC_APROBACION_ASEG.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nCod_Asegurado, nNum_Aprobacion);
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
  --
END ANULAR;
--
--
--
PROCEDURE REVERTIR(nCodCia NUMBER, nCodEmpresa NUMBER, nNum_Aprobacion NUMBER, nIdSiniestro NUMBER, 
                   nIdPoliza NUMBER, nIdDetSin NUMBER, nCod_Asegurado NUMBER, nBenef NUMBER) IS
--
cCod_Pago            DETALLE_APROBACION_ASEG.Cod_Pago%TYPE;
cExiste              VARCHAR2(1);
nNumComprob          COMPROBANTES_CONTABLES.NumComprob%TYPE;
nIdTransaccion       APROBACION_ASEG.IdTransaccion%TYPE;
nNumMod              COBERTURA_SINIESTRO_ASEG.NumMod%TYPE := 0;
nMonto_Reserva       DETALLE_APROBACION_ASEG.Monto_Moneda%TYPE := 0;
cTipo_de_Aprobacion  APROBACION_ASEG.Tipo_de_Aprobacion%TYPE;
nMaxNumMod           COBERTURA_SINIESTRO_ASEG.NumMod%TYPE;
nAjuste              DETALLE_APROBACION_ASEG.Monto_Local%TYPE := 0;
cObservaciones       OBSERVACION_SINIESTRO.Descripcion%TYPE;
--
CURSOR C_RESERVA IS
  SELECT SUM(C.Saldo_Reserva) nMonto, C.CodCobert, C.NumMod
    FROM COBERTURA_SINIESTRO_ASEG C
   WHERE C.IdSiniestro   = nIdSiniestro
     AND C.IdPoliza      = nIdPoliza
     AND C.Cod_Asegurado = nCod_Asegurado
     AND C.StsCobertura  = 'EMI'
     AND C.NumMod IN  (SELECT MAX(NumMod) 
                         FROM COBERTURA_SINIESTRO_ASEG CC
                        WHERE CC.IdSiniestro   = nIdSiniestro
                          AND CC.IdPoliza      = nIdPoliza
                          AND CC.Cod_Asegurado = nCod_Asegurado
                          AND C.StsCobertura   = 'EMI'
                          AND CC.CodCobert     = C.CodCobert)
  GROUP BY  C.CodCobert, C.NumMod;
--
CURSOR COB_Q IS
  SELECT NVL(DA.Monto_Local,0) Monto_Local, NVL(DA.Monto_Moneda,0) Monto_Moneda, 
         DA.Cod_Pago, DA.CodTransac, DA.CodCptoTransac
    FROM DETALLE_APROBACION_ASEG DA, APROBACION_ASEG AP, CPTOS_TRANSAC_SINIESTROS CT
   WHERE DA.Num_Aprobacion = nNum_Aprobacion
     AND DA.IdSiniestro    = nIdSiniestro
     AND AP.Cod_Asegurado  = nCod_Asegurado
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
 /* BEGIN
    SELECT AA.IdTransaccion, CC.NumComprob
      INTO nIdTransaccion, nNumComprob
      FROM APROBACION_ASEG AA, COMPROBANTES_CONTABLES CC
     WHERE AA.Num_Aprobacion = nNum_Aprobacion
       AND AA.IdPoliza       = nIdPoliza
       AND AA.IdSiniestro    = nIdSiniestro
       AND AA.IdTransaccion  = CC.NumTransaccion;
  END;
  --
  BEGIN
    UPDATE APROBACION_ASEG
       SET StsAprobacion     = 'SOL' 
     WHERE Num_Aprobacion = nNum_Aprobacion
       AND Cod_Asegurado  = nCod_Asegurado
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
       UPDATE COBERTURA_SINIESTRO_ASEG
          SET Monto_Pagado_Local  = NVL(Monto_Pagado_Local,0) - NVL(W.Monto_Local,0),
              Monto_Pagado_Moneda = NVL(Monto_Pagado_Moneda,0) - NVL(W.Monto_Moneda,0),
              Saldo_Reserva       = NVL(Saldo_Reserva,0) + NVL(W.Monto_Moneda,0),
              Saldo_Reserva_Local = NVL(Saldo_Reserva_Local,0) + NVL(W.Monto_Local,0)
        WHERE IdSiniestro   = nIdSiniestro
          AND IdDetSin      = nIdDetSin
          AND Cod_Asegurado = nCod_Asegurado
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
           FROM COBERTURA_SINIESTRO_ASEG
          WHERE IdPoliza      = nIdpoliza
            AND IdSiniestro   = nIdSiniestro
            AND Cod_Asegurado = nCod_Asegurado
            AND CodCobert     = cCod_Pago
            AND CodTransac    = 'AJURES';
       EXCEPTION
         WHEN OTHERS THEN
           nMaxNumMod := 0;
       END;
       --
       IF nMaxNumMod > 0 THEN 
          OC_COBERTURA_SINIESTRO_ASEG.ANULAR_RESERVA(nCodCia, nCodEmpresa, nIdSiniestro, nIdPoliza,
                         nIdDetSin, nCod_Asegurado, cCod_Pago, nMaxNumMod);
          OC_DETALLE_SINIESTRO_ASEG.ACTUALIZA_RESERVAS(nIdSiniestro);
       END IF;
       --
    END IF;
    --
  END LOOP;
  --
  BEGIN
    OC_APROBACION_ASEG.ACTUALIZA_PAGOS(nIdSiniestro, nIdPoliza, nCod_Asegurado, nNum_Aprobacion);
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
      UPDATE APROBACION_ASEG  AA
      SET AA.INDFONDOSINI = 'S',
          AA.FECHFONDOSINI = SYSDATE,
          AA.CODUSUARIO       = USUSARIO,    
          AA.TERMINAL      = TERMINAL         
      WHERE AA.NUM_APROBACION = nNum_Aprobacion
      AND   AA.IDSINIESTRO    = nIdSiniestro
      AND   AA.IDPOLIZA       = nIdPoliza
      AND   AA.IDDETSIN       = IDDETSIN;
    EXCEPTION  WHEN NO_DATA_FOUND THEN
                  RAISE_APPLICATION_ERROR(-20225,'APROBACION_ASEG Error NDF ACTUALIZA_FONDEO: '||SQLERRM);
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20225,'APROBACION_ASEG Error Others ACTUALIZA_FONDEO: '||SQLERRM);
    END;           
EXCEPTION
   WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20225,'Error General ACTUALIZA_FONDEO: '||SQLERRM);
END ACTUALIZA_FONDEO;
--
PROCEDURE ACTUALIZA_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nCod_Asegurado NUMBER,  nIdAutorizacion NUMBER) IS
BEGIN
    UPDATE APROBACION_ASEG
       SET IdAutorizacion = nIdAutorizacion
     WHERE IdSiniestro    = nIdSiniestro
       AND IdDetSin       = nIdDetSin
       AND IdPoliza       = nIdPoliza
       AND Cod_Asegurado  = nCod_Asegurado
       AND Num_Aprobacion = cNum_Aprobacion;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20225,'Error al Asignar Autorización: '||nIdAutorizacion||' '||SQLERRM);
END ACTUALIZA_AUTORIZACION; 
--
FUNCTION  NUMERO_AUTORIZACION(nIdSiniestro NUMBER, nIdDetSin NUMBER, nIdPoliza NUMBER, 
                                   cNum_Aprobacion VARCHAR2, nCod_Asegurado NUMBER) RETURN NUMBER IS
nIdAutorizacion APROBACION_ASEG.IdAutorizacion%TYPE;
BEGIN
   BEGIN
      SELECT NVL(IdAutorizacion,0)
        INTO nIdAutorizacion 
        FROM APROBACION_ASEG
       WHERE IdSiniestro    = nIdSiniestro
         AND IdDetSin       = nIdDetSin
         AND IdPoliza       = nIdPoliza
         AND Cod_Asegurado  = nCod_Asegurado
         AND Num_Aprobacion = cNum_Aprobacion;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         nIdAutorizacion := 0;
   END;  
   RETURN nIdAutorizacion;    
END NUMERO_AUTORIZACION;

END OC_APROBACION_ASEG;
/
