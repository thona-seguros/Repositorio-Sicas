CREATE OR REPLACE PACKAGE          OC_PAGOS_REFERENCIADOS_REC IS
--    PROCEDURE ACTUA_PAGOS_REF_REC(nCodCia DOMICILIACION.CodCia%TYPE,
--                                nCodEntidad DOMICILIACION.CODENTIDAD%TYPE) ;   

  PROCEDURE GENERA_PAGOS_REF_REC(nCodCia       PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                                 nIdProceso    PAGOS_REFERENCIADOS_REC.IdProceso%TYPE);
  FUNCTION EXISTEN_PAGOS_REF(nCodCia       PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                             nIdProceso    PAGOS_REFERENCIADOS_REC.IdProceso%TYPE) RETURN VARCHAR2;
  FUNCTION FECHA_PAGO_REF(nCodCia       PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                          nIdProceso    PAGOS_REFERENCIADOS_REC.IdProceso%TYPE,
                          cReferencia   PAGOS_REFERENCIADOS_REC.Referencia%TYPE) RETURN DATE;
                          
  FUNCTION NUMERO_DETALLE_REF (nCodCia IN NUMBER, nIdProceso IN NUMBER) RETURN NUMBER;                         

END OC_PAGOS_REFERENCIADOS_REC;
/

CREATE OR REPLACE PACKAGE BODY          OC_PAGOS_REFERENCIADOS_REC IS

--PROCEDURE ACTUA_PAGOS_REF_REC(nCodCia DOMICILIACION.CODCIA%TYPE,
--                              nCodEntidad DOMICILIACION.CODENTIDAD%TYPE) IS
--  CURSOR C_PAGOS_REFERENCIADOS_REC  IS
--    SELECT SUBSTR(REFERENCIA,13,8) IDFACTURA,
--           'REF' ESTADO,
--           REFERENCIA NUM_REFERENCIADO,
--           '1' TIPOAUTORIZACION,
--           TIPO_PAGO CODFORMAPAGO,
--       GUIA_CIE,
--           MONTO
--      FROM PAGOS_REFERENCIADOS_REC
--        WHERE NVL(CONCILIADO,'N') = 'N' AND
--          SUBSTR(REFERENCIA,13,8) IN (SELECT IDFACTURA
--                                           FROM FACTURAS);
--  vCOD_MONEDA       FACTURAS.COD_MONEDA%TYPE;
--  vREFERENCIA       FACTURAS.CODCLIENTE%TYPE;
--  vFECHAVENCIMIENTO FACTURAS.FECVENC%TYPE;
--  vIDPROCESO        DOMICILIACION.IDPROCESO%TYPE;
--  vConteRegistros   NUMBER;
--  vTITULAR_CUENTA   DETALLE_DOMICI_REFERE.TITULAR_CUENTA%TYPE;
--BEGIN
--  SELECT COUNT(*) INTO vConteRegistros
--    FROM PAGOS_REFERENCIADOS_REC
--      WHERE NVL(CONCILIADO,'N') = 'N'
--        AND SUBSTR(REFERENCIA,13,8) IN (SELECT IDFACTURA
--                                           FROM FACTURAS);
-- IF vConteRegistros>0 THEN
--       
--   /**
--   SELECT NVL(MAX(IDPROCESO),0)+1 INTO vIDPROCESO
--     FROM DOMICILIACION
--       WHERE CODCIA = nCodCia;**/
--       /** Cambio  a secuencia XDS **/
--       
--        SELECT SQ_DOMICILIACION.NEXTVAL     
--        INTO vIDPROCESO
--        FROM DUAL;       
--       
--    INSERT INTO DOMICILIACION (CODCIA,IDPROCESO,USUARIOCREA,FECHACREA,
--                               USUARIOGEN,FECHAGEN,OBSERVACION,CODENTIDAD,
--                               FECPROCESO,CODUSUARIOENVIO,HORAENVIO,ESTADO,
--                               FECMAXVENC)
--                        VALUES( nCodCia,vIDPROCESO,USER,SYSDATE,
--                                NULL,NULL,'Registro Creado Automaticamente en Carga de Archivo de Texto',nCodEntidad,
--                                SYSDATE,NULL,NULL,'GEN',
--                                NULL);
--    FOR D IN C_PAGOS_REFERENCIADOS_REC LOOP
--      --
--      -- Inicializando Variables
--      --
--      vCOD_MONEDA := NULL;
--      vREFERENCIA := NULL;
--      vTITULAR_CUENTA := NULL;
--      --
--      -- Reviso que Exista la Factura
--      --
--      BEGIN
--        SELECT COD_MONEDA,CODCLIENTE,TRUNC(FECVENC) INTO vCOD_MONEDA,vREFERENCIA,vFECHAVENCIMIENTO
--          FROM FACTURAS
--            WHERE IdFactura = d.IDFACTURA;
--      EXCEPTION WHEN NO_DATA_FOUND THEN
--         vCOD_MONEDA := NULL;
--         vREFERENCIA := NULL;
--         vFECHAVENCIMIENTO := NULL;
--      END;
--      vTITULAR_CUENTA := OC_CLIENTES.NOMBRE_CLIENTE(vREFERENCIA);
--      --
--      -- INSERTO EL REGISTRO PARA QUE SEA PAGADO
--      --
--      INSERT INTO DETALLE_DOMICI_REFERE
--                  (CODCIA,IDPROCESO,IDFACTURA,MONTO,COD_MONEDA,
--                   FECVENCIMIENTO,CODFORMAPAGO,NUMTARJETA,FECVENTARJETA,ESTADO,
--                   INDFALTADATOS,INDNOTRASL,INDCONTABILIZADA,MOTANULCOB,FECAPLICA,
--                   REFERENCIA,IMPORTESINIVA,IVA,REFERENCIANUMERICA,CODCLIENTE,
--                   TITULAR_CUENTA,TIPOAUTORIZACION,NUMAPROB,CANTIDAD_INTENTOS,NUM_REFERENCIADO)
--          VALUES (nCodCia,vIDPROCESO,d.IDFACTURA,d.monto,vCOD_MONEDA,
--                  vFECHAVENCIMIENTO,d.CODFORMAPAGO,NULL,NULL,'GEN',
--                  'N','S',NULL,NULL,NULL,
--                  vREFERENCIA,D.MONTO,NULL,NULL,vREFERENCIA,
--                  vTITULAR_CUENTA,D.TIPOAUTORIZACION,d.GUIA_CIE,0,D.NUM_REFERENCIADO);
--      --
--      -- Actualizo DET_DOMICI_REC como conciliado
--      --
--      UPDATE PAGOS_REFERENCIADOS_REC
--        SET CONCILIADO = 'S'
--          WHERE REFERENCIA = D.NUM_REFERENCIADO;
--    COMMIT;
--  END LOOP;
--  END IF;
-- END ACTUA_PAGOS_REF_REC;

PROCEDURE GENERA_PAGOS_REF_REC(nCodCia       PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                               nIdProceso    PAGOS_REFERENCIADOS_REC.IdProceso%TYPE) IS

cCod_Moneda          FACTURAS.Cod_Moneda%TYPE;
nCodCliente          FACTURAS.CodCliente%TYPE;
dFechaVencimiento    FACTURAS.FecVenc%TYPE;
nConteRegistros      NUMBER;
cTitular_Cuenta      DETALLE_DOMICI_REFERE.Titular_Cuenta%TYPE;
nIdExcepcion         REGISTRO_EXCEPCION.IdExcepcion%TYPE;
cCodEntidad          DOMICILIACION.CodEntidad%TYPE;
nMonto_Fact_Moneda   FACTURAS.Monto_Fact_Moneda%TYPE;
cDescExcepcion       VARCHAR2(100);
cMotivoExclu         VARCHAR2(6);

nCodEmpresa          POLIZAS.CodEmpresa%TYPE;
nIdTransac           TRANSACCION.IdTransaccion%TYPE;
nIDetPol             DETALLE_POLIZA.IDetPol%TYPE;
nCodAsegurado        DETALLE_POLIZA.Cod_Asegurado%TYPE;
--nIdTransaccionFond   TRANSACCION.IdTransaccion%TYPE;
nIdFondo             FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
nPrimaNivelada       FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
nAporteFondo         DETALLE_POLIZA.MontoAporteFondo%TYPE;
nNumCuota            FACTURAS.NumCuota%TYPE;
nCobrar              NUMBER;
nIdFactura           FACTURAS.IdFactura%TYPE;
nIdPoliza            POLIZAS.IdPoliza%TYPE;

CURSOR PAGOS_Q IS
   SELECT CodCia, SUBSTR(Referencia,6,7) IdPoliza,
          SUBSTR(Referencia,13,7) IdFactura, 'REF' Estado,
          Referencia, '1' TipoAutorizacion,
          Forma_Pago CodFormaPago, Numero_CIE, Monto,
          Fecha_Deposito
     FROM PAGOS_REFERENCIADOS_REC
    WHERE NVL(IndConciliado,'N')   = 'N'
      AND NVL(IndAplicado,'N')     = 'N'
      AND NVL(IndDuplicado,'N')    = 'N'
      AND CodCia                   = nCodCia
      AND IdProceso                = nIdProceso
      AND (SUBSTR(Referencia,13,7) IN (SELECT IdFactura
                                        FROM FACTURAS
                                       WHERE StsFact IN ('EMI','ANU'))
       OR SUBSTR(Referencia,13,7) IN ('REGULAR')
          );
                                       
CURSOR APORTES_Q IS
   SELECT CodCia, SUBSTR(Referencia,6,7) IdPoliza,
          SUBSTR(Referencia,13,7) TipoAporte, 'REF' Estado,
          Referencia, '1' TipoAutorizacion,
          Forma_Pago CodFormaPago, Numero_CIE, Monto,
          IdDetPagoRef,0 Numaprob, Fecha_Deposito
     FROM PAGOS_REFERENCIADOS_REC
    WHERE NVL(IndConciliado,'N')   = 'N'
      AND NVL(IndAplicado,'N')     = 'N'
      AND NVL(IndDuplicado,'N')    = 'N'
      AND CodCia                   = nCodCia
      AND IdProceso                = nIdProceso
      AND SUBSTR(Referencia,13,7) IN ('EXTRAOR','REGULAR');   
      
CURSOR FACTAPO_Q IS
   SELECT MAX(IdFactura) IdFactura
     FROM FACTURAS
    WHERE CodCia      = nCodCia
      AND IdPoliza    = nIdPoliza
      AND GT_FAI_CONCENTRADORA_FONDO.ES_FACTURA_DE_FONDOS(nCodCia, nCodEmpresa, IdPoliza, IDetPol, IdFactura) = 'S';
   
BEGIN
   NULL;
   FOR W IN APORTES_Q LOOP
      nIdPoliza   := W.IdPoliza;
      BEGIN
         SELECT P.CodEmpresa,D.IDetPol,D.Cod_Asegurado
           INTO nCodEmpresa,nIDetPol,nCodAsegurado
           FROM POLIZAS P,DETALLE_POLIZA D
          WHERE P.CodCia      = nCodCia
            AND P.IdPoliza    = nIdPoliza
            AND P.IdPoliza    = D.IdPoliza
            AND P.CodCia      = D.CodCia;
      END;
      
      BEGIN
         SELECT MIN(IdFactura)
           INTO nIdFactura
           FROM FACTURAS 
          WHERE CodCia      = nCodCia
            AND IdPoliza    = nIdPoliza;
      END;
      
      --nIdTransac  := OC_TRANSACCION.CREA(nCodCia, nCodEmpresa, 12, 'PAG');
      nIdTransac  := 0;
      cCodEntidad := OC_DOMICILIACION.CODIGO_ENTIDAD(nCodCia, nIdProceso);
      
      IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, W.IdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
         nAporteFondo   := W.Monto;
         nIdFondo       := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, W.IdPoliza, nIDetPol, nCodAsegurado);
         nPrimaNivelada := 0;
         nCobrar        := OC_FACTURAS.PAGAR_FONDOS(nIdFactura, W.Numaprob, W.Fecha_Deposito, 0, W.CodFormaPago, cCodEntidad, nIdTransac, nPrimaNivelada, nAporteFondo);
      END IF;
      
      IF nCobrar = 1 THEN
         UPDATE PAGOS_REFERENCIADOS_REC
            SET IndConciliado = 'S'
          WHERE CodCia      = nCodCia
            AND IdProceso   = nIdProceso
            AND Referencia  = W.Referencia;
         
         ---BUSCAR FACTURAS GENERADAS DE FONDOS E INSERTARLAS EN DETALLE DE LOTE
         FOR J IN FACTAPO_Q LOOP  
            nIdFactura := J.IdFactura;
            BEGIN
               SELECT Cod_Moneda,FecVenc,CodCliente
                 INTO cCod_Moneda,dFechaVencimiento,nCodCliente
                 FROM FACTURAS
                WHERE CodCia     = nCodCia
                  AND IdFactura  = nIdFactura;
            END;
            cTitular_Cuenta := OC_CLIENTES.NOMBRE_CLIENTE(nCodCliente);
            INSERT INTO DETALLE_DOMICI_REFERE
                   (CodCia, IdProceso, IdFactura, Monto, Cod_Moneda,
                    FecVencimiento, CodFormaPago, NumTarjeta, FecVenTarjeta, Estado,
                    IndFaltaDatos, IndNoTrasl, IndContabilizada, MotAnulCob, FecAplica,
                    Referencia, ImporteSinIva, Iva, ReferenciaNumerica, CodCliente,
                    Titular_Cuenta, TipoAutorizacion, NumAprob, Cantidad_Intentos,
                    Num_Referenciado, FechaCobro)
            VALUES (nCodCia, nIdProceso, nIdFactura, W.Monto, cCod_Moneda,
                    dFechaVencimiento, W.CodFormaPago, NULL, NULL,'GEN',
                    'N', 'S', 'N', NULL, NULL,
                    W.Referencia, W.Monto, NULL, NULL, nCodCliente,
                    cTitular_Cuenta, W.TipoAutorizacion, TO_CHAR(W.Numero_CIE), 0,
                    W.Referencia, W.Fecha_Deposito);
            
            UPDATE DETALLE_DOMICI_REFERE
               SET Estado     = 'PAG',
                   FechaCobro = W.Fecha_Deposito
             WHERE IdProceso  = nIdProceso
               AND CodCia     = nCodCia
               AND IdFactura  = nIdFactura;
         END LOOP;
         --OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
      END IF;
   END LOOP;
/******************************************************/   

   FOR D IN PAGOS_Q LOOP
   --RAISE_APPLICATION_ERROR(-20225,'ENTRO A PAGOS');
      cCod_Moneda      := NULL;
      nCodCliente      := NULL;
      cTitular_Cuenta  := NULL;
      BEGIN
         SELECT Cod_Moneda, CodCliente, TRUNC(FecVenc), Monto_Fact_Moneda, NumCuota
           INTO cCod_Moneda, nCodCliente, dFechaVencimiento, nMonto_Fact_Moneda, nNumCuota
           FROM FACTURAS
          WHERE IdFactura = D.IdFactura
            AND StsFact   = 'EMI';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            cCod_Moneda       := NULL;
            nCodCliente       := NULL;
            dFechaVencimiento := NULL;
      END;
      cTitular_Cuenta := OC_CLIENTES.NOMBRE_CLIENTE(nCodCliente);
      
      nIdPoliza   := D.IdPoliza;
      BEGIN
         SELECT P.CodEmpresa,DP.IDetPol,DP.Cod_Asegurado
           INTO nCodEmpresa,nIDetPol,nCodAsegurado
           FROM POLIZAS P,DETALLE_POLIZA DP
          WHERE P.CodCia      = nCodCia
            AND P.IdPoliza    = nIdPoliza
            AND P.IdPoliza    = DP.IdPoliza
            AND P.CodCia      = DP.CodCia;
      END;
      
      IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado) = 'S' THEN
         nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, nIdPoliza,  nIDetPol);
         nIdFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado);
         IF NVL(nIdFondo,0) > 0 THEN
            nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, nCodEmpresa, nIdPoliza, nIDetPol, nCodAsegurado, nIdFondo, nNumCuota);
         ELSE
            nPrimaNivelada := 0;
         END IF;
      nMonto_Fact_Moneda := nMonto_Fact_Moneda + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0);
      END IF;

      INSERT INTO DETALLE_DOMICI_REFERE
             (CodCia, IdProceso, IdFactura, Monto, Cod_Moneda,
              FecVencimiento, CodFormaPago, NumTarjeta, FecVenTarjeta, Estado,
              IndFaltaDatos, IndNoTrasl, IndContabilizada, MotAnulCob, FecAplica,
              Referencia, ImporteSinIva, Iva, ReferenciaNumerica, CodCliente,
              Titular_Cuenta, TipoAutorizacion, NumAprob, Cantidad_Intentos,
              Num_Referenciado, FechaCobro)
      VALUES (nCodCia, nIdProceso, D.IdFactura, D.Monto, cCod_Moneda,
              dFechaVencimiento, D.CodFormaPago, NULL, NULL,'GEN',
              'N', 'S', 'N', NULL, NULL,
              D.Referencia, D.Monto, NULL, NULL, nCodCliente,
              cTitular_Cuenta, D.TipoAutorizacion, TO_CHAR(D.Numero_CIE), 0,
              D.Referencia, D.Fecha_Deposito);

      IF nCodCliente IS NULL OR nMonto_Fact_Moneda != D.Monto THEN
         nIdExcepcion := OC_REGISTRO_EXCEPCION.NUMERO_EXCEPCION;

         IF nMonto_Fact_Moneda != D.Monto THEN
            cDescExcepcion := 'Esta Factura fue Excluida porque NO Coincide el Monto con el Depósito';
            cMotivoExclu   := '004';
         ELSE
            cDescExcepcion := 'Esta Factura fue Excluida porque NO Esta EMI';
            cMotivoExclu   := '003';
         END IF;

         OC_REGISTRO_EXCEPCION.INSERTAR(nCodCia, nIdProceso, D.IdFactura, nIdExcepcion,
                                        TRUNC(SYSDATE), cMotivoExclu);
         cCodEntidad := OC_DOMICILIACION.CODIGO_ENTIDAD(nCodCia, nIdProceso);
         

         OC_LOG_TRANSAC_DOM.INSERTA(nCodCia, cCodEntidad, nIdProceso,
                                    'EXC', cDescExcepcion);   
         UPDATE DETALLE_DOMICI_REFERE
            SET Estado = 'EXC'
          WHERE CodCia    = nCodCia
            AND IdProceso = nIdProceso
            AND IdFactura = D.IdFactura;
      ELSE
         UPDATE FACTURAS
            SET IndDomiciliado = 'S',
                IdProceso      = nIdProceso
          WHERE IdFactura      = D.IdFactura;
      END IF;

      -- Actualizo DET_DOMICI_REC como conciliado
      UPDATE PAGOS_REFERENCIADOS_REC
         SET IndConciliado = 'S'
       WHERE CodCia      = nCodCia
         AND IdProceso   = nIdProceso
         AND Referencia  = D.Referencia;
   END LOOP;
END GENERA_PAGOS_REF_REC;

FUNCTION EXISTEN_PAGOS_REF(nCodCia        PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                           nIdProceso     PAGOS_REFERENCIADOS_REC.IdProceso%TYPE) RETURN VARCHAR2 IS
cExiste   VARCHAR2(1);
BEGIN
   BEGIN
      SELECT 'S'
        INTO cExiste
        FROM PAGOS_REFERENCIADOS_REC
       WHERE CodCia      = nCodCia
         AND IdProceso   = nIdProceso;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         cExiste  := 'N';
      WHEN TOO_MANY_ROWS THEN
         cExiste  := 'S';
   END;
   RETURN(cExiste);
END EXISTEN_PAGOS_REF;

FUNCTION FECHA_PAGO_REF(nCodCia       PAGOS_REFERENCIADOS_REC.CodCia%TYPE,
                        nIdProceso    PAGOS_REFERENCIADOS_REC.IdProceso%TYPE,
                        cReferencia   PAGOS_REFERENCIADOS_REC.Referencia%TYPE) RETURN DATE IS
dFecha_Deposito   PAGOS_REFERENCIADOS_REC.Fecha_Deposito%TYPE;
BEGIN
   BEGIN
      SELECT Fecha_Deposito
        INTO dFecha_Deposito
        FROM PAGOS_REFERENCIADOS_REC
       WHERE CodCia      = nCodCia
         AND IdProceso   = nIdProceso
         AND Referencia  = cReferencia;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RAISE_APPLICATION_ERROR(-20225,'NO Existe Referencia de Pago '|| cReferencia);
      WHEN TOO_MANY_ROWS THEN
         RAISE_APPLICATION_ERROR(-20225,'Existen Varios Registro de la Referencia de Pago '|| cReferencia);
   END;
   RETURN(dFecha_Deposito);
END FECHA_PAGO_REF;

FUNCTION NUMERO_DETALLE_REF (nCodCia IN NUMBER, nIdProceso IN NUMBER) RETURN NUMBER IS
nIdDetPagoRef PAGOS_REFERENCIADOS_REC.IdDetPagoRef%TYPE;
BEGIN
   BEGIN
      SELECT NVL(MAX(IdDetPagoRef),0) + 1
        INTO nIdDetPagoRef
        FROM PAGOS_REFERENCIADOS_REC
       WHERE CodCia      = nCodCia
         AND IdProceso   = nIdProceso;
   END;
   RETURN nIdDetPagoRef;
END NUMERO_DETALLE_REF;


END OC_PAGOS_REFERENCIADOS_REC;
