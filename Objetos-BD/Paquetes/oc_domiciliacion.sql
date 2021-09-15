CREATE OR REPLACE PACKAGE SICAS_OC.OC_DOMICILIACION IS
  PROCEDURE PROVISION_FACTURAS_VENC(nCodCia NUMBER, dFecha date, P_CodEntidad Varchar2, P_IdProceso NUMBER);
  FUNCTION SIG_IDEPROCESO(nCodCia NUMBER) RETURN NUMBER;
  FUNCTION COBRAR_FACTURAS (nCodCia NUMBER, nIdProceso NUMBER) RETURN NUMBER;
  PROCEDURE REVERTIR(nCodCia NUMBER, P_IdProceso NUMBER);
  FUNCTION CODIGO_ENTIDAD(nCodCia NUMBER, nIdProceso NUMBER) RETURN VARCHAR2;
  FUNCTION TIPO_PROCESO(nCodCia NUMBER, nIdProceso NUMBER) RETURN VARCHAR2;
  FUNCTION CANTIDAD_RESPUESTAS(nCodCia NUMBER, nIdProceso NUMBER) RETURN NUMBER;
  PROCEDURE INSERTAR(nCodCia NUMBER, nIdProceso NUMBER, cUsuarioCrea VARCHAR2, dFechaCrea DATE, cUsuarioGen VARCHAR2, 
                     dFechagGen DATE, cObservacion VARCHAR2, cCodEntidad VARCHAR2, dFecProceso DATE, cCodUsuarioEnvio VARCHAR2, 
                     dHoraEnvio DATE, cEstado VARCHAR2, cCorrelativo VARCHAR2, cTipo_Configuracion VARCHAR2, cIndDomiciliado VARCHAR2, 
                     dFecMaxVenc DATE, nCantRespBco NUMBER);
  PROCEDURE GENERA_ARCHIVO_DOMICILIACION (nCodCia NUMBER, nCodEmpresa NUMBER, cNomArchivo VARCHAR2, nIdProceso NUMBER);
  PROCEDURE GENERA_ARCHIVO_TEXTO (nCodCia NUMBER, nCodEmpresa NUMBER, cNomArchivo VARCHAR2, nIdProceso NUMBER);  
  PROCEDURE PROC_REGISTRA_EXCEPCION (nCodCia NUMBER, nIdProceso NUMBER, nIdExcepcion NUMBER, nIdFactura NUMBER, dFechaProbCobro DATE, 
                                     cMot_Excepcion VARCHAR2, cCodEntidad VARCHAR2, cTipo_Configuracion VARCHAR2, dFecProceso DATE); 
  PROCEDURE ENVIA_ARCHIVO(nCodCia NUMBER, nIdProceso NUMBER, dFecProceso DATE, cNomArchivo VARCHAR2, cDirectorio VARCHAR2);   
  PROCEDURE REPORTE_COBRANZA_DIARIA(nCodCia NUMBER, dFecProceso DATE, cCodEntidad VARCHAR2, cNomArchivo VARCHAR2);                             
END OC_DOMICILIACION;
/
CREATE OR REPLACE PACKAGE BODY SICAS_OC.OC_DOMICILIACION IS
    PROCEDURE PROVISION_FACTURAS_VENC(nCodCia NUMBER, dFecha DATE, P_CodEntidad VARCHAR2, P_IdProceso NUMBER) IS

    cIndFaltaDatos           DETALLE_DOMICI_REFERE.IndFaltaDatos%TYPE;
    cEstado                  DETALLE_DOMICI_REFERE.Estado%TYPE;
    nImporteSinIva           DETALLE_DOMICI_REFERE.ImporteSinIva%TYPE;
    nMtoIva                  DETALLE_FACTURAS.Monto_Det_Local%TYPE;
    cTitular_Cuenta          DETALLE_DOMICI_REFERE.Titular_Cuenta%TYPE;
    cTipo_Configuracion      DOMICILIACION.Tipo_Configuracion%TYPE;
    cCadenaEspOrig           VARCHAR2(100) := 'áéíóúÀÁÂÃÄÅÈÉÊËÌÍÎÏÒÓÔÕÖÙÚÛÜñÑ,.';
    cCadenaNormal            VARCHAR2(100) := 'aeiouAAAAAAEEEEIIIIOOOOOUUUUnN';
    cReferencia              VARCHAR2(40);
    nMonto                   DETALLE_DOMICI_REFERE.Monto%TYPE;
    nCodEmpresa              EMPRESAS_DE_SEGUROS.CodEmpresa%TYPE;
    nCodAsegurado            DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nAporteFondo             DETALLE_POLIZA.MontoAporteFondo%TYPE;
    nIdFondo                 FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
    nPrimaNivelada           FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
    nTasaCambio              NUMBER(18,2) := 0;

    CURSOR C_FACTURAS_VENCIDAS_DET IS
       SELECT FAC.*,MDC.*,NULL CodResultado,NULL RespDomiciliacion,NULL DescRespDomiciliacion,
              P.CodEmpresa
         FROM FACTURAS FAC, CLIENTES CL, POLIZAS P,
              PERSONA_NATURAL_JURIDICA PNJ, MEDIOS_DE_COBRO MDC
        WHERE FAC.CodCia                  = P.CodCia
          AND FAC.IdPoliza                = P.IdPoliza
          AND FAC.CodCliente              = CL.CodCliente
          AND PNJ.Tipo_Doc_Identificacion = CL.Tipo_Doc_Identificacion
          AND PNJ.Num_Doc_Identificacion  = CL.Num_Doc_Identificacion
          AND MDC.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
          AND MDC.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
          AND TO_DATE(CASE WHEN OC_POLIZAS.DIA_COBRO(FAC.CodCia, P.CodEmpresa, FAC.IdPoliza) > EXTRACT(DAY FROM LAST_DAY(FAC.FecVenc)) THEN  
                        TRIM(TO_CHAR(EXTRACT(DAY FROM LAST_DAY(FAC.FecVenc)), '00')) || '/' ||  TO_CHAR(FAC.FecVenc, 'MM/YYYY')  
                      ELSE 
                           TRIM(TO_CHAR(DECODE(OC_POLIZAS.DIA_COBRO(FAC.CodCia, P.CodEmpresa, FAC.IdPoliza), 0, TO_CHAR(FAC.FecVenc, 'DD'), OC_POLIZAS.DIA_COBRO(FAC.CodCia, P.CodEmpresa, FAC.IdPoliza)) , '00')) || '/' ||  TO_CHAR(FAC.FecVenc, 'MM/YYYY')  
                      END, 'DD/MM/YYYY') <= dFecha
          --AND FAC.FecVenc                <= dFecha
          --AND MDC.CODENTIDADFINAN = P_CodEntidad
          AND ((MDC.CodFormaCobro         = 'CTC'
          AND cTipo_Configuracion         = 'D')
           OR (MDC.CodFormaCobro         IN ('DOMI','CLAB')
          AND cTipo_Configuracion         = 'T'))
          AND FAC.StsFact                 = 'EMI'
          AND NVL(FAC.IndDomiciliado,'N') = 'N'
          AND OC_FACTURAS.INTENTOS_COBRANZA_CUMPLIDOS(FAC.IdFactura,FAC.CodCia) = 'N'
          AND MDC.IdFormaCobro            = (SELECT NVL(IdFormaCobro,1)
                                               FROM POLIZAS
                                              WHERE CodCia   = FAC.CodCia
                                                AND IdPoliza = FAC.IdPoliza);
    BEGIN
       cTipo_Configuracion := OC_DOMICILIACION.TIPO_PROCESO(nCodCia, P_IdProceso);

       FOR D IN C_FACTURAS_VENCIDAS_DET LOOP
          /***************************/
          /* Inicializando Variables */
          /***************************/
          cIndFaltaDatos  := NULL;
          cEstado         := NULL;
          nImporteSinIva  := NULL;
          nMtoIva         := NULL;
          cTitular_Cuenta := NULL;
          nCodEmpresa     := D.CodEmpresa;
          IF cTipo_Configuracion = 'D' AND D.CodFormaCobro IS NULL OR 
             (D.NumTarjeta IS NULL OR D.FechaVencTarjeta IS NULL) THEN
             cIndFaltaDatos := 'S';
          ELSIF cTipo_Configuracion = 'T' AND D.CodFormaCobro = 'DOMI' AND 
             D.NumTarjeta IS NULL OR D.FechaVencTarjeta IS NULL THEN
             cIndFaltaDatos := 'S';
          ELSIF cTipo_Configuracion = 'T' AND D.CodFormaCobro = 'CLAB' AND 
             D.NumCuentaClabe IS NULL THEN
             cIndFaltaDatos := 'S';
          ELSE
             cIndFaltaDatos := 'N';
          END IF;

          SELECT NVL(SUM(Monto_Det_MONEDA),0)
            INTO nMtoIva
            FROM DETALLE_FACTURAS
           WHERE IdFactura  = D.IdFactura
             AND CodCpto    = 'IVASIN';

          SELECT NVL(SUM(Monto_Det_MONEDA),0)
            INTO nImporteSinIva
            FROM DETALLE_FACTURAS
           WHERE IdFactura  = D.IdFactura
             AND CodCpto   != 'IVASIN';

          cTitular_Cuenta := TRANSLATE(SUBSTR(OC_CLIENTES.Nombre_Cliente(D.CodCliente),1,40),cCadenaEspOrig,cCadenaNormal);
          IF cTipo_Configuracion = 'D' THEN
             cReferencia := D.CodCliente;
          ELSE
             BEGIN
                SELECT --TRIM(P.NumPolUnico) || ' ' ||
                       TRIM(TO_CHAR(P.IdPoliza))-- || ' ' ||
                       --TRIM(TO_CHAR(D.IdFactura))
                  INTO cReferencia
                  FROM FACTURAS F, POLIZAS P
                 WHERE F.CodCia    = D.CodCia
                   AND F.IdFactura = D.IdFactura
                   AND F.IdPoliza  = D.IdPoliza
                   AND P.IdPoliza  = F.IdPoliza
                   AND P.CodCia    = F.CodCia;
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   cReferencia := ' ';
             END;
          END IF;
          
          /*BEGIN
             SELECT P.CodEmpresa
               INTO nCodEmpresa
               FROM POLIZAS P
              WHERE P.CodCia    = nCodCia
                AND P.IdPoliza  = D.IdPoliza;
          END;*/
          /*SE VALIDA SI LA POLIZA TIENE FONDOS, SI ES ASI SE SUMA AL MONTO A COBRAR LA PRIMA DE RIESGO + LOS MOVIMIENTOS DE FONDOS*/
          IF OC_POLIZAS.POLIZA_COLECTIVA(nCodCia, nCodEmpresa, D.IdPoliza) = 'N' THEN
             BEGIN
                 SELECT DP.Cod_Asegurado
                   INTO nCodAsegurado
                   FROM POLIZAS P,DETALLE_POLIZA DP
                  WHERE P.CodCia     = nCodCia
                    AND P.IdPoliza   = D.IdPoliza
                    AND DP.IDetPol   = D.IDetPol
                    AND P.CodCia     = DP.CodCia
                    AND P.CodEmpresa = DP.CodEmpresa
                    AND P.IdPoliza   = DP.IdPoliza;
             END;
             IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, nCodEmpresa, D.IdPoliza, D.IDetPol, nCodAsegurado) = 'S' THEN
                 nAporteFondo  := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, nCodEmpresa, D.IdPoliza,  D.IDetPol);
                 nIdFondo      := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, nCodEmpresa, D.IdPoliza, D.IDetPol, nCodAsegurado);
                 IF NVL(nIdFondo,0) > 0 THEN
                    nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, nCodEmpresa, D.IdPoliza, D.IDetPol, nCodAsegurado, nIdFondo, D.NumCuota);
                 ELSE
                    nPrimaNivelada := 0;
                 END IF;
             ELSE
                 nAporteFondo   := 0;
                 nPrimaNivelada := 0;
             END IF;
          ELSE 
             nAporteFondo   := 0;
             nPrimaNivelada := 0;
          END IF;
         
          nMonto         := NVL(D.Monto_Fact_moneda,0) + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0); 
          nImporteSinIva := NVL(nImporteSinIva,0) + NVL(nAporteFondo,0) + NVL(nPrimaNivelada,0); 
          /*************************************************************************************************************************/
          INSERT INTO DETALLE_DOMICI_REFERE
                 (CodCia, IdProceso, IdFactura, Monto, Cod_Moneda, FecVencimiento, CodFormaPago, NumTarjeta,
                  FecVenTarjeta, Estado, IndFaltaDatos, IndNoTrasl, IndContabilizada, FecAplica, Referencia,
                  ImporteSinIva, Iva, ReferenciaNumerica, CodCliente, Titular_Cuenta, TipoAutorizacion,
                  NumAprob, Cantidad_Intentos, Num_Referenciado, NumCuentaClabe, CodEntidadFinan, CAMBIO_MONEDA_ENVIO)
          VALUES (D.CodCia, P_IdProceso, D.IdFactura, nMonto, D.Cod_Moneda, D.FecVenc, D.CodFormaCobro, D.NumTarjeta,
                  D.FechaVencTarjeta, 'GEN', cIndFaltaDatos, 'S', 'N', SYSDATE, cReferencia, 
                  nImporteSinIva, nMtoIva, TO_CHAR(D.FecVenc,'DDMMYY'), D.CodCliente,
                  cTitular_Cuenta, NULL, NULL, 0, NULL, D.NumCuentaClabe, D.CodEntidadFinan, 0);
          
          UPDATE FACTURAS
             SET IndDomiciliado = 'S',
                 IdProceso = P_IdProceso
           WHERE IdFactura = D.IdFactura;
       END LOOP;
    END PROVISION_FACTURAS_VENC;

    FUNCTION SIG_IDEPROCESO(nCodCia NUMBER) RETURN NUMBER IS
    nSiguiente    DOMICILIACION.IdProceso%TYPE;
    BEGIN
       BEGIN
          SELECT NVL(MAX(IdProceso),0)
            INTO nSiguiente
            FROM DOMICILIACION
           WHERE CodCia = nCodcia;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             nSiguiente := 0;
       END;
       nSiguiente := NVL(nSiguiente,0)+1;
       RETURN(nSiguiente);
    END SIG_IDEPROCESO;

    FUNCTION COBRAR_FACTURAS (nCodCia NUMBER, nIdProceso NUMBER) RETURN NUMBER IS
    nCobrar          NUMBER(1);
    nIdTransac       TRANSACCION.IdTransaccion%TYPE;
    nIdTransaccion   TRANSACCION.IdTransaccion%TYPE;
    nCodAsegurado    DETALLE_POLIZA.Cod_Asegurado%TYPE;
    nIdFondo         FAI_FONDOS_DETALLE_POLIZA.IdFondo%TYPE;
    nPrimaNivelada   FAI_CONFIG_APORTE_FONDO_DET.MontoAporteMoneda%TYPE;
    nAporteFondo     DETALLE_POLIZA.MontoAporteFondo%TYPE;

    CURSOR FACTCOB IS
        SELECT DMR.IdFactura, DMR.Monto, DMR.Cod_Moneda, DMR.CodFormaPago, 
               DMR.NumTarjeta, DMR.TipoAutorizacion, DMR.NumAprob,
               DMR.FecAplica, DOM.CodEntidad, POL.CodEmpresa, FAC.IndContabilizada,
               FAC.Monto_Fact_Moneda, FAC.IdPoliza, FAC.IDetPol,FAC.NumCuota,
               NVL(DMR.FechaCobro,TRUNC(SYSDATE)) FechaCobro
          FROM DETALLE_DOMICI_REFERE DMR, DOMICILIACION DOM, FACTURAS FAC, POLIZAS POL        
         WHERE DMR.CodCia           = DOM.CodCia
           AND DMR.IdProceso        = DOM.IdProceso
           AND DMR.IdFactura        = FAC.IdFactura
           AND FAC.CodCia           = POL.CodCia
           AND FAC.IdPoliza         = POL.IdPoliza
           AND DMR.CodCia           = nCodCia
           AND DMR.TipoAutorizacion = '1'
           AND DMR.NumAprob    IS NOT NULL
           AND DMR.Estado           = 'GEN'
           AND DOM.IdProceso        = nIdProceso;
    BEGIN
       FOR FC IN FACTCOB LOOP
          BEGIN
             SELECT D.Cod_Asegurado
               INTO nCodAsegurado
               FROM DETALLE_POLIZA D
              WHERE D.CodCia   = nCodCia
                AND D.IdPoliza = FC.IdPoliza
                AND D.IDetPol  = FC.IDetPol;
          END;
          IF FC.IndContabilizada = 'N' THEN
             nIdTransaccion := OC_TRANSACCION.CREA(nCodCia, FC.CodEmpresa, 14, 'CONFAC');
             OC_DETALLE_TRANSACCION.CREA(nIdTransaccion, nCodCia, FC.CodEmpresa, 14, 'CONFAC',
                                         'FACTURAS', FC.IdPoliza, FC.IDetPol, NULL, FC.IdFactura, FC.Monto_Fact_Moneda);
             UPDATE FACTURAS
                SET IdTransacContab  = nIdTransaccion,
                    IndContabilizada = 'S',
                    FecContabilizada = TRUNC(SYSDATE)
              WHERE IdFactura = FC.IdFactura;
             OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransaccion, 'C');
          END IF;

          nIdTransac := OC_TRANSACCION.CREA(nCodCia,  FC.CodEmpresa, 12, 'PAG');
          
          IF GT_FAI_FONDOS_DETALLE_POLIZA.EXISTEN_FONDOS(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado) = 'N' THEN
             nCobrar := OC_FACTURAS.PAGAR (FC.IdFactura, FC.Numaprob, TRUNC(SYSDATE), FC.Monto, 
                                           FC.CodFormaPago, FC.CodEntidad, nIdTransac);
          ELSE
             nAporteFondo := OC_DETALLE_POLIZA.MONTO_APORTE_FONDOS(nCodCia, FC.CodEmpresa, FC.IdPoliza,  FC.IDetPol);
             nIdFondo     := GT_FAI_FONDOS_DETALLE_POLIZA.FONDO_PAGO_PRIMA(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado);
             IF NVL(nIdFondo,0) > 0 THEN
                nPrimaNivelada := GT_FAI_CONFIG_APORTE_FONDO_DET.MONTO_APORTE_ESPECIFICO(nCodCia, FC.CodEmpresa, FC.IdPoliza, FC.IDetPol, nCodAsegurado, nIdFondo, FC.NumCuota);
             ELSE
                nPrimaNivelada := 0;
             END IF;
             nCobrar := OC_FACTURAS.PAGAR_FONDOS(FC.IdFactura, FC.Numaprob, FC.FechaCobro, FC.Monto, FC.CodFormaPago, FC.CodEntidad, nIdTransac, nPrimaNivelada, nAporteFondo);
             
             IF NVL(FC.NumCuota,0) = 1 THEN 
                   NOTIFICAREGISTRO (nCodCia, FC.CodEmpresa, FC.IdPoliza);
                END IF;
             END IF;
          
          IF nCobrar = 1 THEN
             UPDATE DETALLE_DOMICI_REFERE
                SET Estado     = 'PAG',
                    FechaCobro = TRUNC(SYSDATE)
              WHERE IdProceso  = nIdProceso
                AND CodCia     = nCodCia
                AND IdFactura  = FC.IdFactura;

             UPDATE FACTURAS
                SET FecSts         = TRUNC(SYSDATE),
                    IndDomiciliado = NULL
              WHERE IdProceso = nIdProceso
                AND CodCia    = nCodCia
                AND IdFactura = FC.IdFactura;

             OC_COMPROBANTES_CONTABLES.CONTABILIZAR(nCodCia, nIdTransac, 'C');
          END IF;
       END LOOP;
       RETURN (1);
    EXCEPTION
       WHEN OTHERS THEN
          RETURN (0);
    END COBRAR_FACTURAS;

    PROCEDURE REVERTIR(nCodCia NUMBER, P_IdProceso NUMBER) IS
    BEGIN
       UPDATE FACTURAS FAC
          SET IndDomiciliado = NULL,
              IdProceso      = NULL
        WHERE EXISTS (SELECT  *
                        FROM DETALLE_DOMICI_REFERE DDR
                       WHERE DDR.IdFactura  = FAC.IdFactura
                         AND DDR.CodCia     = nCodCia 
                         AND DDR.IdProceso  = P_IdProceso);

       DELETE DETALLE_DOMICI_REFERE
        WHERE CodCia = nCodCia
          AND IdProceso = P_IdProceso;

       UPDATE DOMICILIACION
          SET Estado     = 'REV',
              FechaGen   = SYSDATE,
              UsuarioGen = USER
        WHERE CodCia    = nCodCia
          AND IdProceso = P_IdProceso;
      END REVERTIR;

      FUNCTION CODIGO_ENTIDAD(nCodCia NUMBER, nIdProceso NUMBER) RETURN VARCHAR2 IS
      cCodEntidad    DOMICILIACION.CodEntidad%TYPE;
      BEGIN
         BEGIN
            SELECT CodEntidad
              INTO cCodEntidad
              FROM DOMICILIACION
             WHERE CodCia     = nCodCia
               AND IdProceso  = nIdProceso;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cCodEntidad := NULL;
         END;
         RETURN(cCodEntidad);
      END CODIGO_ENTIDAD;

      FUNCTION TIPO_PROCESO(nCodCia NUMBER, nIdProceso NUMBER) RETURN VARCHAR2 IS
      cTipo_Configuracion    DOMICILIACION.Tipo_Configuracion%TYPE;
      BEGIN
         BEGIN
            SELECT Tipo_Configuracion
              INTO cTipo_Configuracion
              FROM DOMICILIACION
             WHERE CodCia     = nCodCia
               AND IdProceso  = nIdProceso;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               cTipo_Configuracion := NULL;
         END;
         RETURN(cTipo_Configuracion);
      END TIPO_PROCESO;

      FUNCTION CANTIDAD_RESPUESTAS(nCodCia NUMBER, nIdProceso NUMBER) RETURN NUMBER IS
      nCantRespBco    DOMICILIACION.CantRespBco%TYPE;
      BEGIN
         BEGIN
            SELECT NVL(CantRespBco,0)
              INTO nCantRespBco
              FROM DOMICILIACION
             WHERE CodCia     = nCodCia
               AND IdProceso  = nIdProceso;
         EXCEPTION
            WHEN NO_DATA_FOUND THEN
               nCantRespBco := 0;
         END;
         RETURN(nCantRespBco);
      END CANTIDAD_RESPUESTAS;
      
    PROCEDURE INSERTAR(nCodCia NUMBER, nIdProceso NUMBER, cUsuarioCrea VARCHAR2, dFechaCrea DATE, cUsuarioGen VARCHAR2, 
                       dFechagGen DATE, cObservacion VARCHAR2, cCodEntidad VARCHAR2, dFecProceso DATE, cCodUsuarioEnvio VARCHAR2, 
                       dHoraEnvio DATE, cEstado VARCHAR2, cCorrelativo VARCHAR2, cTipo_Configuracion VARCHAR2, cIndDomiciliado VARCHAR2, 
                       dFecMaxVenc DATE, nCantRespBco NUMBER) IS
    BEGIN
       INSERT INTO DOMICILIACION (CodCia, IdProceso, UsuarioCrea, FechaCrea, UsuarioGen, 
                                  FechaGen, Observacion, CodEntidad, FecProceso, CodUsuarioEnvio, 
                                  HoraEnvio, Estado, Correlativo, Tipo_Configuracion, IndDomiciliado, 
                                  FecMaxVenc, CantRespBco)
                          VALUES (nCodCia, nIdProceso, cUsuarioCrea, dFechaCrea, cUsuarioGen,
                                  dFechagGen, cObservacion, cCodEntidad, dFecProceso, cCodUsuarioEnvio,
                                  dHoraEnvio, cEstado, cCorrelativo, cTipo_Configuracion, cIndDomiciliado,
                                  dFecMaxVenc, nCantRespBco);
    END INSERTAR;  

    PROCEDURE GENERA_ARCHIVO_DOMICILIACION (nCodCia NUMBER, nCodEmpresa NUMBER, cNomArchivo VARCHAR2, nIdProceso NUMBER) IS
    cLimitador     VARCHAR2(1) := ',';
    cCadena        VARCHAR2(4000);
    cCadena_Enca   VARCHAR2(4000);
    cReferencia    VARCHAR2(40);
    nLinea         NUMBER;
    --nCodEmpresa    EMPRESAS_DE_SEGUROS.CodEmpresa%TYPE;
    cDirectorio    VARCHAR2(20) := 'DOMICI';
    fArchivo       UTL_FILE.FILE_TYPE;

    CURSOR FACT_Q IS             
      SELECT IdFactura, Monto, ImporteSinIva, Iva,
             Titular_Cuenta, CodCia, CodEntidadFinan,
             DECODE(CodFormaPago,'DOMI',3,40) TipoCta,
             DECODE(CodFormaPago,'DOMI',LPAD(LTRIM(TO_CHAR(NumTarjeta)),16,'0'),
                    LPAD(LTRIM(TO_CHAR(NumCuentaCLABE)),18,'0')) NumCuenta
        FROM DETALLE_DOMICI_REFERE
       WHERE IdProceso          = nIdProceso
         AND CodCia             = nCodCia
         AND Estado             = 'GEN'
         AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(CodCia, nCodEmpresa, IdFactura, '', 'EMI') = 'S';
         
    CURSOR C_EXCEPCIONES IS             
      SELECT D.IdFactura, DOM.FecProceso, DOM.CodEntidad, 
             DOM.Tipo_Configuracion
        FROM DETALLE_DOMICI_REFERE D, DOMICILIACION DOM,
             FACTURAS F
       WHERE DOM.IdProceso        = nIdProceso
         AND DOM.CodCia           = nCodCia
         AND D.Estado             = 'GEN'
         AND D.CodCia             = DOM.CodCia
         AND D.IdProceso          = DOM.IdProceso
         AND D.CodCia             = F.CodCia
         AND D.IdFactura          = F.IdFactura
         AND (F.IndFactElectronica = 'S' OR OC_POLIZAS.FACTURA_ELECTRONICA(DOM.CodCia, nCodEmpresa, F.IdPoliza) = 'S')
         AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(DOM.CodCia, nCodEmpresa, D.IdFactura, '', 'EMI') = 'N';     
    BEGIN 
         
    --   SELECT CodEmpresa 
    --     INTO nCodEmpresa 
    --     FROM EMPRESAS_DE_SEGUROS
    --    WHERE CodCia = nCodCia;
        
       fArchivo := UTL_FILE.FOPEN(cDirectorio, cNomArchivo, 'w');    
       nLinea := 1;
       FOR D in FACT_Q LOOP
          BEGIN
             SELECT --TRIM(P.NumPolUnico) || ' ' ||
                    TRIM(TO_CHAR(P.IdPoliza)) --|| ' ' ||
                    --TRIM(TO_CHAR(D.IdFactura))
               INTO cReferencia
               FROM FACTURAS F, POLIZAS P
              WHERE F.CodCIa    = D.CodCia
                AND F.IdFactura = D.IdFactura
                AND P.IdPoliza  = F.IdPoliza
                AND P.CodCIa    = F.CodCia;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                cReferencia := ' ';
          END;
          
          cCadena :=  TRIM(TO_CHAR(nLinea))         ||cLimitador||
                      cReferencia                   ||cLimitador||
                      TRIM(TO_CHAR(D.ImporteSinIva))||cLimitador||
                      TRIM(TO_CHAR(D.Iva))          ||cLimitador||
                      TRIM(TO_CHAR(D.IdFactura))    ||cLimitador||
                      D.Titular_Cuenta              ||cLimitador||
                      D.CodEntidadFinan             ||cLimitador||
                      TRIM(TO_CHAR(D.TipoCta))      ||cLimitador||
                      D.NumCuenta                   ||cLimitador||
                      D.Titular_Cuenta              ||cLimitador;---|| CHR(13);

          --UTL_FILE.PUT(fArchivo, cCadena||CHR(10));
          UTL_FILE.PUT(fArchivo, cCadena);
          nLinea := nLinea + 1;
       END LOOP;
       UTL_FILE.FCLOSE(fArchivo); 
       FOR X IN C_EXCEPCIONES LOOP
          OC_DOMICILIACION.PROC_REGISTRA_EXCEPCION (nCodCia, nIdProceso, OC_REGISTRO_EXCEPCION.NUMERO_EXCEPCION, X.IdFactura, X.FecProceso, '005', X.CodEntidad, X.Tipo_Configuracion, X.FecProceso);
       END LOOP;   
    EXCEPTION 
       WHEN OTHERS THEN 
          UTL_FILE.FCLOSE(fArchivo);
          RAISE_APPLICATION_ERROR(-20000,'Error en Generación de Archivo de Cobranza Proceso No. '||nIdProceso|| ' ' ||SQLERRM); 
    END GENERA_ARCHIVO_DOMICILIACION;

    PROCEDURE GENERA_ARCHIVO_TEXTO (nCodCia NUMBER, nCodEmpresa NUMBER, cNomArchivo VARCHAR2, nIdProceso NUMBER) IS
    cLimitador      VARCHAR2(1) := '|';
    cCadena         VARCHAR2(4000);
    cCadena_Enca    VARCHAR2(4000);
    --nCodEmpresa    EMPRESAS_DE_SEGUROS.CodEmpresa%TYPE;
    cDirectorio    VARCHAR2(20) := 'WEBTRANS';
    fArchivo       UTL_FILE.FILE_TYPE;

    CURSOR C_ENCABEZAD_TEXTO IS 
       SELECT 'H' Indicador_Encabezado, 'WEBFT2.00' Layout,
              'ENT' Tipo_Archivo, COM.NumAfiliacion, COM.NomComercio,
              'BANCOMER' Banco_Adquiriente, TO_CHAR(SYSDATE,'MMDDYYYY') Fecha_Proceso,
              LPAD('0',18,' ') Filler, '.' Indicador_Fin
         FROM DOMICILIACION DOM, CONFIGURACION_DOMICILIACION COM
        WHERE DOM.CodCia             = COM.CodCia
          AND DOM.CodEntidad         = COM.CodEntidad
          AND DOM.Tipo_Configuracion = COM.Tipo_Configuracion
          AND DOM.IdProceso          = nIdProceso;

    CURSOR C_DETALLE_TEXTO IS             
       SELECT 'D' Indicador_Detalle, '5' Tipo_transaccion,
              LPAD(LTRIM(TO_CHAR(DMR.NumTarjeta)),16,'0') No_Cuenta,
              LPAD(LTRIM(TO_CHAR(DMR.Monto,'9999999V99')),12,'0') Importe,
              DECODE(Cod_Moneda,'PS','484','840') Codigo_Moneda,
              LPAD(LTRIM(TO_CHAR(DMR.IdFactura,'9999999999999999999')),19,'0') Numero_Referencia,
              '00' Codigo_Resultado, '0'  Tipo_Autorizacion,
              '      ' Numero_Autorizacion,
              '   ' Filler, '.' Indicador_Fin
         FROM DETALLE_DOMICI_REFERE DMR, DOMICILIACION DOM,
              CONFIGURACION_DOMICILIACION COM
        WHERE DMR.CodCia             = DOM.CodCia
          AND DMR.IdProceso          = DOM.IdProceso
          AND DOM.CodCia             = COM.CodCia 
          AND DOM.CodEntidad         = COM.CodEntidad
          AND DOM.Tipo_Configuracion = COM.Tipo_Configuracion
          AND DMR.IdProceso          = nIdProceso
          AND DMR.CodCia             = nCodCia
          AND DMR.Estado             = 'GEN'
          AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(DMR.CodCia, nCodCia, DMR.IdFactura, '', 'EMI') = 'S';   

    CURSOR C_DETALLE_TOTAL IS             
       SELECT 'T' Indicador_Total,
              LPAD(COUNT(*),6,'0') Total_Transaccion,
              LPAD(TO_NUMBER(REPLACE(TO_CHAR(SUM(DMR.Monto),'999999999.99'),'.')),15,'0') Total,
              LPAD('0',6,'0') No_Trans_Ap,
              LPAD('0',15,'0') Monto_Trans_Ap,
              LPAD('0',6,'0') No_Trans_Rec,
              LPAD('0',15,'0') Monto_Trans_Rec,
              '.' Indicador_Fin
        FROM DETALLE_DOMICI_REFERE DMR, DOMICILIACION DOM,
             CONFIGURACION_DOMICILIACION COM
       WHERE DMR.CodCia     = DOM.CodCia
         AND DMR.IdProceso  = DOM.IdProceso
         AND DOM.CodCia     = COM.CodCia 
         AND DOM.CodEntidad = COM.CodEntidad
         AND DOM.Tipo_Configuracion = COM.Tipo_Configuracion
         AND DMR.IdProceso  = nIdProceso
         AND DMR.CodCia     = nCodCia
         AND DMR.Estado     = 'GEN'
         AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(DMR.CodCia, nCodCia, DMR.IdFactura, '', 'EMI') = 'S';  
           
    CURSOR C_EXCEPCIONES IS
       SELECT LPAD(LTRIM(TO_CHAR(DMR.Idfactura,'9999999999999999999')),19,'0') Numero_Referencia,
              MaxDiasExcepcion,DMR.IdFactura,DOM.FecProceso, DOM.CodEntidad, 
              DOM.Tipo_Configuracion
         FROM DETALLE_DOMICI_REFERE DMR, DOMICILIACION DOM,
              CONFIGURACION_DOMICILIACION COM, FACTURAS F
        WHERE DMR.CodCia             = DOM.CodCia
          AND DMR.IdProceso          = DOM.IdProceso
          AND DOM.CodCia             = COM.CodCia 
          AND DOM.CodEntidad         = COM.CodEntidad
          AND DOM.Tipo_Configuracion = COM.Tipo_Configuracion
          AND DMR.IdProceso          = nIdProceso
          AND DMR.CodCia             = nCodCia
          AND DMR.Estado             = 'GEN'
          AND DMR.CodCia             = F.CodCia
          AND DMR.IdFactura          = F.IdFactura
          AND (F.IndFactElectronica = 'S' OR OC_POLIZAS.FACTURA_ELECTRONICA(DOM.CodCia, nCodEmpresa, F.IdPoliza) = 'S')
          AND OC_FACT_ELECT_DETALLE_TIMBRE.EXISTE_PROCESO(DMR.CodCia, nCodEmpresa, DMR.IdFactura, '', 'EMI') = 'N';
           
    BEGIN 

       fArchivo := UTL_FILE.FOPEN(cDirectorio, cNomArchivo, 'w');       
       /*****************************/
       /* Escribiendo el Encabezado */
       /*****************************/
       FOR E IN  C_ENCABEZAD_TEXTO LOOP
          cCadena_Enca := E.Indicador_Encabezado||E.Layout||E.Tipo_Archivo||E.Numafiliacion||E.Nomcomercio||E.Banco_Adquiriente||E.Fecha_Proceso||E.Filler||E.Indicador_Fin;
       END LOOP;
       cCadena     := cCadena_Enca;
       UTL_FILE.PUT(fArchivo, cCadena||CHR(10));
       /*****************************/
       /* Escribiendo el Detalle    */
       /*****************************/
       FOR D in C_DETALLE_TEXTO LOOP
         cCadena := D.Indicador_Detalle    ||
                    D.Tipo_Transaccion     ||
                    D.No_Cuenta            ||
                    D.Importe              ||
                    D.Codigo_Moneda        ||
                    D.Numero_Referencia    ||
                    D.Codigo_Resultado     ||
                    D.Tipo_Autorizacion    ||
                    D.Numero_Autorizacion  ||
                    D.Filler               ||
                    D.Indicador_Fin;
         
          UTL_FILE.PUT(fArchivo, cCadena||CHR(10));
       END LOOP;
       /*****************************/
       /* Escribiendo el TOTAL      */
       /*****************************/
       FOR T IN  C_DETALLE_TOTAL LOOP
          cCadena  := T.Indicador_Total    || 
                      T.Total_Transaccion  || 
                      T.Total              || 
                      T.No_Trans_Ap        || 
                      T.Monto_Trans_Ap     || 
                      T.No_Trans_Rec       || 
                      T.Monto_Trans_Rec    || 
                      T.Indicador_Fin;
       END LOOP;
       UTL_FILE.PUT(fArchivo, cCadena||CHR(10));
       UTL_FILE.FCLOSE(fArchivo); 
       FOR X IN C_EXCEPCIONES LOOP
          OC_DOMICILIACION.PROC_REGISTRA_EXCEPCION (nCodCia, nIdProceso, OC_REGISTRO_EXCEPCION.NUMERO_EXCEPCION, X.IdFactura, X.FecProceso, '005', X.CodEntidad, X.Tipo_Configuracion, X.FecProceso);                                                  
       END LOOP;
    EXCEPTION 
       WHEN OTHERS THEN 
          UTL_FILE.FCLOSE(fArchivo); 
          RAISE_APPLICATION_ERROR(-20000,'Error en Generación de Archivo WebTransfer Proceso No. '||nIdProceso|| ' ' ||SQLERRM);  
    END GENERA_ARCHIVO_TEXTO;


    PROCEDURE PROC_REGISTRA_EXCEPCION (nCodCia NUMBER, nIdProceso NUMBER, nIdExcepcion NUMBER, nIdFactura NUMBER, dFechaProbCobro DATE, 
                                       cMot_Excepcion VARCHAR2, cCodEntidad VARCHAR2, cTipo_Configuracion VARCHAR2, dFecProceso DATE) IS
    nMaxDiasExc   NUMBER(2,0);
    BEGIN
       BEGIN
          SELECT MaxDiasExcepcion 
            INTO nMaxDiasExc
            FROM CONFIGURACION_DOMICILIACION
           WHERE CodCia             = nCodCia
             AND CodEntidad         = cCodEntidad
             AND Tipo_Configuracion = cTipo_Configuracion;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN 
             RAISE_APPLICATION_ERROR(-20000,'No Existe Posible Determinar los Dias Maximos de Exclusion ');
       END;

       IF dFechaProbCobro > dFecProceso + nMaxDiasExc THEN 
          RAISE_APPLICATION_ERROR(-20000,'La Fecha de Excepción Excede lo Establecido, no Debe Pasar de la Fecha del Proceso '||
                          TO_CHAR(dFecProceso,'DD/MM/YYYY')||' + '||TO_CHAR(nMaxDiasExc)||' Días de Gracia de Excepción');
       END IF;

       IF NVL(cMot_Excepcion,'0')='0' THEN
          RAISE_APPLICATION_ERROR(-20000,'Debe Ingresar un Motivo de Excepción');
       END IF;

       BEGIN
          OC_REGISTRO_EXCEPCION.INSERTAR(nCodCia, nIdProceso, nIdFactura, nIdExcepcion, dFechaProbCobro, cMot_Excepcion);
          OC_LOG_TRANSAC_DOM.INSERTA(nCodCia, cCodEntidad, nIdProceso,'EXC', 'Esta Factura fue Excluida por Excepción');   
          UPDATE DETALLE_DOMICI_REFERE
             SET Estado = 'EXC'
           WHERE CodCia    = nCodCia
             AND IdProceso = nIdProceso
             AND IdFactura = nIdFactura;
          --
          -- Libero la factura marcada como excepcion.
          --
          UPDATE FACTURAS
             SET IndDomiciliado = NULL,
                 IdProceso      = NULL
           WHERE IdFactura = nIdFactura;
          --
          --
       EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20000,'No fue Posible Insertar la Excepción, Ocurrió el Siguiente Error: '||SQLERRM);
       END;
    END PROC_REGISTRA_EXCEPCION;

    PROCEDURE ENVIA_ARCHIVO(nCodCia NUMBER, nIdProceso NUMBER, dFecProceso DATE, cNomArchivo VARCHAR2, cDirectorio VARCHAR2) IS
    cEmailDest              VARCHAR2(1000);
    cEmailCC                USUARIOS.Email%TYPE;
    cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
    cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'043');
    cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
    cError                  VARCHAR2(3000);
    cSubject                VARCHAR2(1000);
    cMessage                VARCHAR2(3000);
    cHTMLHeader             VARCHAR2(2000) := '<html><head><meta http-equiv="Content-Language" content="en-us" />'             ||CHR(13)||
                                                 '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252" />'||CHR(13)||
                                                 '</head><body>'                                                               ||CHR(13);
    cHTMLFooter             VARCHAR2(100)  := '</body></html>';
    cSaltoLinea             VARCHAR2(5)    := '<br>';
    cTextoImportanteOpen    VARCHAR2(10)   := '<strong>';
    cTextoImportanteClose   VARCHAR2(10)   := '</strong>';

    cCodEntidad             DOMICILIACION.CodEntidad%TYPE;
    cTipo_Configuracion     DOMICILIACION.Tipo_Configuracion%TYPE;
    cDescripcion            CONFIGURACION_DOMICILIACION.Descripcion%TYPE;

    CURSOR MAIL_Q IS  
       SELECT Correlativo, Correo_Electronico
         FROM CORREOS_DOMICILIACION
        WHERE CodCia        = nCodCia
          AND Cod_Entidad   = cCodEntidad;
    BEGIN
       cEmailDest := NULL;
       IF nIdProceso <> 0 THEN
          BEGIN
             SELECT CodEntidad,Tipo_Configuracion
               INTO cCodEntidad,cTipo_Configuracion
               FROM DOMICILIACION
              WHERE CodCia        = nCodCia
                AND IdProceso     = nIdProceso;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20100,'No es Posible Determinar la Entidad Financiera del Proceso');
          END;
          BEGIN
             SELECT Descripcion
               INTO cDescripcion
               FROM CONFIGURACION_DOMICILIACION
              WHERE CodCia              = nCodCia
                AND CodEntidad          = cCodEntidad
                AND Tipo_Configuracion  = cTipo_Configuracion;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20100,'No es Posible Determinar el Nombre del Proceso');
          END;
       ELSE
          BEGIN
             SELECT DISTINCT CodEntidad
               INTO cCodEntidad
               FROM DOMICILIACION
              WHERE CodCia        = nCodCia
                AND FecProceso    = dFecProceso;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20100,'Existen multiples procesos de cobranza para la fecha '||dFecProceso);
          END;
       END IF;
       
       FOR W IN MAIL_Q LOOP
          cEmailDest := cEmailDest||W.Correo_Electronico||',';   
       END LOOP;
       cEmailCC := NULL;
       IF nIdProceso <> 0 THEN
          cSubject := cDescripcion||' del día '||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecProceso));
          cMessage := cHTMLHeader                                                                                                                                                                                    ||
                      'Se ha generado el Lote número: '||nIdProceso||' para el proceso de '||cTextoImportanteOpen||cDescripcion||cTextoImportanteClose||' para la fecha '                                            ||
                      OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecProceso))||'.'                                                                                                                 ||cSaltoLinea||cSaltoLinea||
                      'Se adjunta archivo de envio a cobro: '||cTextoImportanteOpen||cNomArchivo||cTextoImportanteClose||'.'                                                               ||cSaltoLinea||cSaltoLinea||               
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose                                           ||cSaltoLinea||cSaltoLinea||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)                                                                                                                                              ||cSaltoLinea||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '                        ||cSaltoLinea||cHTMLFooter;
       ELSE
          cSubject := 'Reporte Cobranza Diaria del día '||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecProceso));
          cMessage := cHTMLHeader                                                                                                                                                                                    ||
                      'Se ha generado el reporte de cobranza diaria para la fecha '||OC_GENERALES.FECHA_EN_LETRA(TRUNC(dFecProceso))||'.'                                                  ||cSaltoLinea||cSaltoLinea||
                      'Se adjunta archivo que incluye todos los procesos de cobranza generados del dia.'                                                                                   ||cSaltoLinea||cSaltoLinea||               
                      cTextoImportanteOpen||'    Este Correo es Generado de Manera Automática, Por Favor no lo Responda.'||cTextoImportanteClose                                           ||cSaltoLinea||cSaltoLinea||
                      OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)                                                                                                                                              ||cSaltoLinea||
                      ' <img src="'||OC_ADICIONALES_EMPRESA.RUTA_LOGOTIPO(nCodCia)||'" alt="'||OC_EMPRESAS.NOMBRE_COMPANIA(nCodCia)||'" height="120" width="280"> '                        ||cSaltoLinea||cHTMLFooter;
       END IF;
       
       OC_MAIL.INIT_PARAM;
       OC_MAIL.cCtaEnvio   := cEmailAuth;
       OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
               
       OC_MAIL.SEND_EMAIL(cDirectorio,cEmailEnvio,TRIM(cEmailDest),cEmailCC,NULL,cSubject,cMessage,cNomArchivo,NULL,NULL,NULL,cError);
    END ENVIA_ARCHIVO;

    PROCEDURE REPORTE_COBRANZA_DIARIA(nCodCia NUMBER, dFecProceso DATE, cCodEntidad VARCHAR2, cNomArchivo VARCHAR2) IS
    cDirectorio          VARCHAR2(20) := 'REPODIARIO';
    fArchivo             UTL_FILE.FILE_TYPE;
    cCadena              VARCHAR2(32000);
    cAbreCelda           VARCHAR2(20) := '<ss:Cell>';
    cCierraCelda         VARCHAR2(20) := '</ss:Cell>';
    cAbreContenidoString VARCHAR2(40) := '<ss:Data ss:Type="String">';
    cAbreContenidoNumber VARCHAR2(40) := '<ss:Data ss:Type="Number">';
    cCierraContenido     VARCHAR2(20) := '</ss:Data>';
    CURSOR COBRANZA_Q IS 
       SELECT P.IdPoliza,P.NumPolUnico,F.IdFactura,F.NumCuota,D.Tipo_Configuracion,
              OC_CONFIGURACION_DOMICILIACION.DESCRIPCION(D.CodCia, D.CodEntidad, D.Correlativo) TipoProceso,
              F.CodCliente,OC_CLIENTES.NOMBRE_CLIENTE(F.CodCliente) NomClienteFact,
              DR.CodFormaPago,DR.Monto,DR.ImporteSinIva,D.FecProceso,F.FecVenc,
              RE.Mot_Excepcion,DECODE(RE.Mot_Excepcion,NULL,NULL,OC_VALORES_DE_LISTAS.BUSCA_LVALOR('MOTEXC', RE.Mot_Excepcion)) DescExcepcion,
              DP.IdTipoSeg,OC_TIPOS_DE_SEGUROS.TIPO_DE_SEGURO(DP.CodCia, DP.CodEmpresa,DP.IdTipoSeg) DescTipoSeg
         FROM DOMICILIACION D,DETALLE_DOMICI_REFERE DR,
              REGISTRO_EXCEPCION RE,FACTURAS F,POLIZAS P,
              DETALLE_POLIZA DP
        WHERE D.CodCia      = nCodCia
          AND D.CodEntidad  = cCodEntidad
          --AND OC_POLIZAS.FACTURA_POR_POLIZA(P.CodCia, P.CodEmpresa, P.IdPoliza) = 'S'
          AND D.FecProceso  = dFecProceso
          AND D.CodCia      = DR.CodCia
          AND D.IdProceso   = DR.IdProceso
          AND DR.CodCia     = RE.CodCia(+)
          AND DR.IdProceso  = RE.IdProceso(+)  
          AND DR.IdFactura  = RE.IdFactura(+)
          AND DR.CodCia     = F.CodCia 
          AND DR.IdProceso  = F.IdProceso  
          AND DR.IdFactura  = F.IdFactura
          AND F.CodCia      = P.CodCia
          AND F.IdPoliza    = P.IdPoliza
          AND P.CodCia      = DP.CodCia
          AND P.CodEmpresa  = DP.CodEmpresa
          AND P.IdPoliza    = DP.IdPoliza
          AND F.CodCia      = DP.CodCia
          AND F.IdPoliza    = DP.IdPoliza
          AND F.IDetPol     = DP.IDetPol;    
    BEGIN
       fArchivo := UTL_FILE.FOPEN(cDirectorio, cNomArchivo, 'w',32767);

       UTL_FILE.PUT_LINE(fArchivo,'<?xml version="1.0"?>');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Workbook xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Styles>');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Style ss:ID="OracleDate">');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:NumberFormat ss:Format="dd/mm/yyyy\ hh:mm:ss"/>');
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Style>');
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Styles>');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Worksheet ss:Name="'||'COBRO_DIARIO'||'">');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Table>');
       UTL_FILE.PUT_LINE(fArchivo,'<ss:Row>'); 
       
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'No. de Poliza'                          ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Consecutivo'                            ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Recibo'                                 ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'No. Cuota'                              ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Monto Recibo Mas Aportaciones'          ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Monto Sin Impuestos'                    ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Fecha Vencimiento Recibo'               ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Forma de Pago'                          ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Codigo Tipo Seguro'                     ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Tipo Seguro'                            ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Excepcion'                              ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Motivo Excepcion'                       ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Codigo Cliente Factura'                 ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Nombre o Razon Social Cliente Factura'  ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Dia De Cobro'                           ||cCierraContenido||cCierraCelda);
       UTL_FILE.PUT_LINE(fArchivo, cAbreCelda||cAbreContenidoString||'Tipo Proceso'                           ||cCierraContenido||cCierraCelda);  
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Row>');
       FOR W IN COBRANZA_Q LOOP
          UTL_FILE.PUT_LINE(fArchivo,'<ss:Row>');
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.NumPolUnico)                       ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdPoliza)                          ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.IdFactura)                         ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.NumCuota)                          ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.Monto)         ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.ImporteSinIva) ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.FecVenc,'DD/MM/YYYY')              ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.CodFormaPago)                      ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.IdTipoSeg)                         ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.DescTipoSeg)                       ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.Mot_Excepcion)                     ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.DescExcepcion)                     ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoNumber||TO_CHAR(W.CodCliente)                        ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.NomClienteFact)                    ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR('0')                                 ||cCierraContenido||cCierraCelda);
             UTL_FILE.PUT(fArchivo, cAbreCelda||cAbreContenidoString||TO_CHAR(W.TipoProceso)                       ||cCierraContenido||cCierraCelda);
          UTL_FILE.PUT_LINE(fArchivo,'</ss:Row>');
       END LOOP;   
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Table>');
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Worksheet>');
       UTL_FILE.PUT_LINE(fArchivo,'</ss:Workbook>'); 
       UTL_FILE.FCLOSE(fArchivo); 
    EXCEPTION
          WHEN OTHERS THEN
             UTL_FILE.FCLOSE(fArchivo);
             RAISE_APPLICATION_ERROR(-20000,'No fue Posible Generar Reporte de Cobranza, Ocurrió el Siguiente Error: '||SQLERRM);   
    END REPORTE_COBRANZA_DIARIA;

END OC_DOMICILIACION;
/