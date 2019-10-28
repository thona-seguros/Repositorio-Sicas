--
-- GT_TABLERO_CTRL_PAGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DBMS_STANDARD (Package)
--   XMLTYPE (Synonym)
--   POLIZAS (Table)
--   PROCESOS_MASIVOS_SEGUIMIENTO (Table)
--   PROCESO_AUTORIZA_USUARIO (Table)
--   DETALLE_NOTAS_DE_CREDITO (Table)
--   DETALLE_SINIESTRO (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   DETALLE_TABLERO_CTRL_PAGO (Table)
--   DETALLE_TRANSACCION (Table)
--   ENTIDAD_FINANCIERA (Table)
--   TABLERO_CTRL_PAGO (Table)
--   TABLERO_CTRL_PAGO (Table)
--   TASAS_CAMBIO (Table)
--   GT_WEB_SERVICES (Package)
--   OC_DETALLE_APROBACION (Package)
--   OC_DETALLE_APROBACION_ASEG (Package)
--   AGENTES (Table)
--   APROBACIONES (Table)
--   APROBACION_ASEG (Table)
--   BENEF_SIN (Table)
--   GT_DETALLE_TABLERO_CTRL_PAGO (Package)
--   INFO_SINIESTRO (Table)
--   MEDIOS_DE_PAGO (Table)
--   NOTAS_DE_CREDITO (Table)
--   TIPOS_DE_SEGUROS (Table)
--   TRANSACCION (Table)
--   SINIESTRO (Table)
--   COMPROBANTES_CONTABLES (Table)
--   COMPROBANTES_DETALLE (Table)
--   CLIENTES (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   OC_AGENTES (Package)
--   OC_CATALOGO_DE_CONCEPTOS (Package)
--   OC_CLIENTES (Package)
--   OC_MONEDA (Package)
--   OC_POLIZAS (Package)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_TABLERO_CTRL_PAGO IS

  FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER) RETURN NUMBER;
  PROCEDURE INSERTAR
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE,
     in_IDPROC          IN OUT TABLERO_CTRL_PAGO.IDPROC%TYPE,
     in_CODCTRLPAGO     IN TABLERO_CTRL_PAGO.CODCTRLPAGO%TYPE,
     in_ESFONDEO        IN TABLERO_CTRL_PAGO.ESFONDEO%TYPE DEFAULT 'N'
    );

  PROCEDURE ACTUALIZA_RESPUESTA
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE
    );
  PROCEDURE MARCAR_ERROR
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_DESCERROR       IN TABLERO_CTRL_PAGO.DESCERROR%TYPE
    );    
  PROCEDURE ELIMINA
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE
    );
    
  
  PROCEDURE EJECUTA_WS_PAGO_FONDEO(PIDWEB NUMBER, PIDWEBRESP NUMBER, PCODCIA NUMBER, PIDPROC IN NUMBER);

  PROCEDURE EJECUTA_RESPUESTA (pCodCia NUMBER := 1, pDesde VARCHAR2 :=NULL, pHasta VARCHAR2 := NULL, pFolio_Solicitud NUMBER := null);
  
  PROCEDURE CREA_LOTE_FONDEO_COMISIONES(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER);

  PROCEDURE CREA_LOTE_FONDEO_SINIEST_IND(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER);

  PROCEDURE CREA_LOTE_FONDEO_INFONACOT(PCODCIA NUMBER, PFECHA DATE, PIDPROC OUT NUMBER);

  PROCEDURE CREA_LOTE_FONDEO_COLECTIVOS(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER);    
  
END GT_TABLERO_CTRL_PAGO;
/

--
-- GT_TABLERO_CTRL_PAGO  (Package Body) 
--
--  Dependencies: 
--   GT_TABLERO_CTRL_PAGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_TABLERO_CTRL_PAGO IS

    FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER) RETURN NUMBER IS
        nIdProc TABLERO_CTRL_PAGO.IdProc%TYPE;
    BEGIN
        SELECT NVL(MAX(IdProc),0) + 1
          INTO nIdProc
          FROM TABLERO_CTRL_PAGO
         WHERE CodCia = nCodCia;
        RETURN nIdProc;
    END NUMERO_PROCESO;


  PROCEDURE INSERTAR
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE,
     in_IDPROC          IN OUT TABLERO_CTRL_PAGO.IDPROC%TYPE,
     in_CODCTRLPAGO     IN TABLERO_CTRL_PAGO.CODCTRLPAGO%TYPE,
     in_ESFONDEO        IN TABLERO_CTRL_PAGO.ESFONDEO%TYPE DEFAULT 'N'
    ) IS    
  BEGIN
  
    in_IDPROC := NUMERO_PROCESO(in_CODCIA);
    
    INSERT INTO TABLERO_CTRL_PAGO
      (
       CODCIA
      ,IDPROC
      ,NUMREG
      ,NUMREGERR
      ,TOTAL_PAG
      ,TOTAL_ERR
      ,DESCERROR
      ,ESFONDEO
      ,CODCTRLPAGO
      )
    VALUES
      (
       in_CODCIA
      ,in_IDPROC
      ,0
      ,0
      ,0
      ,0
      ,NULL
      ,in_ESFONDEO
      ,IN_CODCTRLPAGO
      );
      
      
  END INSERTAR;

  PROCEDURE ACTUALIZA_RESPUESTA
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE    
    ) IS
  
      nNUMREG        NUMBER;
      nNUMREGERR     NUMBER;
      nTOTAL_PAG     NUMBER(25,0); 
      nTOTAL_ERR     NUMBER(25,0);  
      nTOTAL_REG     NUMBER; 
      cDescError     VARCHAR2(4000);
      nConceptos     NUMBER;
      dConcepto      TABLERO_CTRL_PAGO.CONCEPTO%TYPE;
  BEGIN
  
  
      SELECT 
             SUM(CASE WHEN decode(TCP.ERROR, 0, 'PROCSR', 'ERRDER') = 'PROCSR' THEN 1 ELSE 0 END),
             SUM(CASE WHEN decode(TCP.ERROR, 0, 'PROCSR', 'ERRDER') = 'ERRDER' THEN 1 ELSE 0 END),
             SUM(CASE WHEN decode(TCP.ERROR, 0, 'PROCSR', 'ERRDER') = 'PROCSR' THEN TCP.TOTAL_MO ELSE 0 END),
             SUM(CASE WHEN decode(TCP.ERROR, 0, 'PROCSR', 'ERRDER') = 'ERRDER' THEN TCP.TOTAL_MO ELSE 0 END),
             MAX(COMENTARIO),
             SUM(CASE WHEN ESTA_PAGADO = 'S' THEN 1 ELSE 0 END )
        INTO
             nNUMREG        
            ,nNUMREGERR     
            ,nTOTAL_PAG      
            ,nTOTAL_ERR
            ,cDescError
            ,nTOTAL_REG                    
        FROM DETALLE_TABLERO_CTRL_PAGO TCP
       WHERE     
             CODCIA            = in_CODCIA
         AND IDPROC            = in_IDPROC;
      --

      SELECT COUNT(DISTINCT CONCEPTO)
        INTO nConceptos
        FROM DETALLE_TABLERO_CTRL_PAGO TCP
       WHERE     
             CODCIA            = in_CODCIA
         AND IDPROC            = in_IDPROC;

      IF nConceptos > 1 THEN
            dConcepto := 'DIVERSOS';
      ELSE
            SELECT MAX(CONCEPTO)
              INTO dConcepto
              FROM DETALLE_TABLERO_CTRL_PAGO TCP
             WHERE CODCIA            = in_CODCIA
               AND IDPROC            = in_IDPROC;
      END IF;
      
        UPDATE TABLERO_CTRL_PAGO
        SET 
            NUMREG            = nNUMREG
           ,NUMREGERR         = nNUMREGERR
           ,TOTAL_PAG         = nTOTAL_PAG
           ,TOTAL_ERR         = nTOTAL_ERR
           ,DESCERROR         = cDescError
           ,STSPROCESO        = decode(nNUMREGERR, 0, DECODE(nTOTAL_REG, nNUMREG, 'CERRAD', DECODE(ESFONDEO, 'S', DECODE(FONDEAR, 'N', 'XPROC', 'PROCSR'), 'PROCSR')), 'ERRDER')
           ,CODUSUARIO        = user
           ,FECULTMODIF       = sysdate
           ,CONCEPTO          = dConcepto
        WHERE
            CODCIA            = in_CODCIA
        AND IDPROC            = in_IDPROC;
  END ACTUALIZA_RESPUESTA;

  PROCEDURE MARCAR_ERROR
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_DESCERROR       IN TABLERO_CTRL_PAGO.DESCERROR%TYPE
    ) IS
  BEGIN
    UPDATE TABLERO_CTRL_PAGO P SET P.STSPROCESO  = 'ERRDER'
                                  ,P.FECULTMODIF = SYSDATE
                                  ,P.CODUSUARIO  = USER
                                  ,P.DESCERROR   = in_DESCERROR
    WHERE
        CODCIA            = in_CODCIA
    AND IDPROC            = in_IDPROC;
  END MARCAR_ERROR;

 PROCEDURE ELIMINA
    (
     in_CODCIA          IN TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN TABLERO_CTRL_PAGO.IDPROC%TYPE
    ) IS
  BEGIN
    DELETE FROM TABLERO_CTRL_PAGO
    WHERE
        CODCIA            = in_CODCIA
    AND IDPROC            = in_IDPROC;
  END ELIMINA;


    PROCEDURE EJECUTA_WS_PAGO_FONDEO(PIDWEB NUMBER, PIDWEBRESP NUMBER, PCODCIA NUMBER, PIDPROC IN NUMBER) IS
          RetVal        XMLTYPE;
          PCODEMPRESA   NUMBER;
          RESULTADO     VARCHAR2(32767);
          PPARAMSQL     VARCHAR2(32767);
        --  PFECHA        DATE;
    BEGIN 
          PCODEMPRESA := 1;  
          RESULTADO   := NULL;  
          PPARAMSQL   := ':nCodCia=' || PCODCIA ||',:nIdProc='   || PIDPROC ;        
          RetVal := GT_WEB_SERVICES.EJECUTA_WS ( PCODCIA, PCODEMPRESA, PIDWEB, PIDWEBRESP, RESULTADO, PPARAMSQL);
                    
    END EJECUTA_WS_PAGO_FONDEO;
    
    PROCEDURE EJECUTA_RESPUESTA (pCodCia NUMBER := 1, pDesde VARCHAR2 :=NULL, pHasta VARCHAR2 := NULL, pFolio_Solicitud NUMBER := null) IS
        --SI pFolio_Solicitud ESTA VACIO, UTILIZA EL PERIODO DE LAS FECHAS
        --NO pFolio_Solicitud ESTA VACIO, SOLO CONSULTA EL FOLIO ENVÍADO OMITIENDO EL RESTO DE LOS PARAMETROS 
        xMLResult            XMLTYPE;
        cLin                 VARCHAR2(32767);
        cResultado           VARCHAR2(32767);
        cError               VARCHAR2(4000);
        nReg                 NUMBER :=0;
    BEGIN 
        FOR TAB IN (  SELECT DISTINCT T.CODCIA, T.IDPROC, DECODE(pFolio_Solicitud, NULL, NULL, D.IDPROCDET) IDPROCDET
                        FROM TABLERO_CTRL_PAGO T INNER JOIN DETALLE_TABLERO_CTRL_PAGO D ON D.CODCIA = T.CODCIA AND D.IDPROC = T.IDPROC 
                       WHERE T.STSPROCESO <> 'CERRAD'
                         AND  T.CODCIA = pCodCia 
                         AND (DECODE(pFolio_Solicitud, NULL, T.FECPROC, NULL)              >= DECODE(pFolio_Solicitud, NULL, TO_DATE(pDesde,'DD/MM/YYYY'), NULL)
                         AND  DECODE(pFolio_Solicitud, NULL, T.FECPROC, NULL)              <= DECODE(pFolio_Solicitud, NULL, TO_DATE(pHasta,'DD/MM/YYYY'), NULL))
                          OR  (DECODE(pFolio_Solicitud, NULL, 1,         D.FOLIO_SOLICITUD)  = DECODE(pFolio_Solicitud, NULL, 2,                            pFolio_Solicitud))) LOOP
            FOR ENT IN (  SELECT D.IDPROCDET, D.FOLIO_SOLICITUD, D.REFERENCIA, D.FECHA, D.FACTURA
                            FROM DETALLE_TABLERO_CTRL_PAGO D 
                            WHERE D.CODCIA = TAB.CODCIA
                                 AND D.IDPROC= TAB.IDPROC
                                 AND DECODE(TAB.IDPROCDET, NULL, 1, D.IDPROCDET) = DECODE(TAB.IDPROCDET, NULL, 1, TAB.IDPROCDET)) LOOP

                BEGIN
                    xMLResult := GT_WEB_SERVICES.Ejecuta_WS(1, 1, 2020, -0, cResultado, ':FOLIO=' || ENT.FOLIO_SOLICITUD);                
                    GT_WEB_SERVICES.INICIALIZADOM (xMLResult);
                    GT_DETALLE_TABLERO_CTRL_PAGO.ACTUALIZA_PAGO(TAB.CODCIA
                                                               ,TAB.IDPROC
                                                               ,ENT.IDPROCDET
                                                               ,GT_WEB_SERVICES.ExtraeDatos_XmlDom('estatus')
                                                               ,GT_WEB_SERVICES.ExtraeDatos_XmlDom('cuenta')
                                                               ,GT_WEB_SERVICES.ExtraeDatos_XmlDom('referencia')
                                                               ,GT_WEB_SERVICES.ExtraeDatos_XmlDom('fechapago')
                                                               );
                    IF MOD(nReg, 10) = 0 THEN
                        COMMIT;
                    END IF;             
                    
                    IF INSTR(GT_WEB_SERVICES.ExtraeDatos_XmlDom('referencia'), 'SINIESTRO INFONACOT') > 0 THEN -- ACTUALIZA EL DETALLE DE LAS APROBACIONES DE SINIESTROS PARA INDICAR EL LOTE QUE PERTENECE
                        FOR APR IN (SELECT A.IDPOLIZA, A.IDSINIESTRO, A.IDDETSIN, A.NUM_APROBACION               
                                      FROM TRANSACCION T INNER JOIN APROBACIONES        A ON  T.IdTransaccion= A.IdTransaccion
                                                         INNER JOIN BENEF_SIN           B ON  A.IdPoliza    = B.IdPoliza
                                                                                          AND A.IdSiniestro = B.IdSiniestro
                                                                                          AND A.Benef       = B.Benef    
                                                         INNER JOIN SINIESTRO           S ON  S.IdPoliza    = A.IdPoliza
                                                                                          AND S.IdSiniestro = A.IdSiniestro 
                                                         INNER JOIN INFO_SINIESTRO      I ON  T.FechaTransaccion >= I.Fe_Carga  
                                                                                          AND I.Siniestro   = S.IdSiniestro
                                    WHERE I.ID_CODCIA = TAB.CODCIA
                                      AND (I.FE_CARGA, I.ID_ENVIO) IN (SELECT D.FECHA, D.FACTURA
                                                                         FROM DETALLE_TABLERO_CTRL_PAGO D 
                                                                        WHERE D.CODCIA = TAB.CODCIA
                                                                          AND D.IDPROC    = TAB.IDPROC
                                                                          AND D.IDPROCDET = ENT.IDPROCDET)) LOOP                    
                            NULL; --OC_APROBACIONES.ACTUALIZA_IDLOTE_MIZAR(APR.IDPOLIZA, APR.IDSINIESTRO, APR.IDDETSIN, APR.NUM_APROBACION, TAB.IDPROC, ENT.IDPROCDET);  
                        END LOOP;
                    END IF;                                            
                EXCEPTION WHEN OTHERS THEN
                    case SQLCODE 
                        when -31011 THEN
                            cError := 'El servidor del servicio solicitado, no estan activo o se traslado a otra dirección.';
                        WHEN -29273 THEN
                            cError := 'El servidor local, no tiene los permisos necesarios para conectarse al servidor de servicios solicitado. Contacte a su administrador de sistemas.';
                        ELSE
                            cError := sqlerrm;
                    END CASE;
                    GT_TABLERO_CTRL_PAGO.MARCAR_ERROR(TAB.CODCIA, TAB.IDPROC, substr(cError, 1, 500));                                       
                END;                    
            END LOOP;       
            COMMIT;
            GT_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA(TAB.CODCIA, TAB.IDPROC);                                 
        END LOOP;       
    END EJECUTA_RESPUESTA;
    --
    PROCEDURE CREA_LOTE_FONDEO_COMISIONES(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER) IS 
        nCodCia     number(1) := PCODCIA;
        nSwLote     NUMBER(1) := 0;
        nIdProc     NUMBER;
        nIDPROCDET  NUMBER;
        dFecDesde   VARCHAR2(10) := TO_CHAR(PFECHA, 'DD/MM/YYYY');
        dFecHasta   VARCHAR2(10) := TO_CHAR(PFECHA2,'DD/MM/YYYY');
        
        CURSOR QRY_COM IS
                        SELECT  
                                5                                                                                   compania,
                                SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD') || '.' || nIdProc || '.' || nIdProcDet, 1, 32)  folio_agrup,
                                '4000'                                                                              auxiliar,      
                                OC_AGENTES.NOMBRE_AGENTE(NC.CodCia, NC.Cod_Agente)                                  nombre,       
                                TRUNC(NC.FecDevol)                                                                  fecha,        
                                OC_MONEDA.CODIGO_SISTEMA_CONTABLE(NC.CodMoneda)                                     moneda,       
                                NC.TASA_CAMBIO                                                                      tipo_cambio,  
                                OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(NC.CODCIA, 'IVASIN')                   tasa_iva,                                     
                                SUM(CASE WHEN DN.CodCpto = 'HONORA' THEN DN.Monto_Det_Moneda ELSE 0 END)            sub_total_mo,
                                SUM(CASE WHEN DN.IndCptoPrima != 'S' AND DN.CodCpto = 'IVASIN' THEN  DN.Monto_Det_Moneda ELSE 0 END)       iva_mo,       
                                SUM(DN.Monto_Det_Moneda )                                                           total_mo,     
                                OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(NC.CODCIA, 'RETIVA')                   tasa_ret_iva, 
                                SUM(CASE WHEN DN.CodCpto = 'RETIVA' THEN DN.Monto_Det_Moneda ELSE 0 END)            imp_ret_iva,  
                                OC_CATALOGO_DE_CONCEPTOS.PORCENTAJE_CONCEPTO(NC.CODCIA, 'RETISR')               tasa_ret_isr, 
                                SUM(CASE WHEN DN.CodCpto = 'RETISR' THEN  DN.Monto_Det_Moneda ELSE 0 END)       imp_ret_isr,                                
                                (SELECT MAX(CD.CodCentroCosto)   FROM  COMPROBANTES_DETALLE CD WHERE  CD.CodCia = nCodCia AND CD.NumComprob = CC.NumComprob) ccs,
                                (SELECT MAX(CD.CodUnidadNegocio) FROM  COMPROBANTES_DETALLE CD WHERE  CD.CodCia = nCodCia AND CD.NumComprob = CC.NumComprob) uen,
                                 '*'                                           pys,          
                                'COM01'                                       concepto,     
                                'Comisiones (ws-auto)-Agente: '||NC.Cod_Agente|| '.' || NC.IDNOMINA  referencia,   
                                NVL(NC.CTALIQUIDADORA,0)                      grupo,        
                                9                                             flujo,        
                                NC.IdNcr                                      factura,      
                                NVL((SELECT E.CODBCOMIZAR FROM ENTIDAD_FINANCIERA E WHERE E.CODENTIDAD = CodEntidadFinan ), CodEntidadFinan)   CTA_BANCO, 
                                NVL(NumCuentaBancaria, NumCuentaClabe)        clabe,        
                                1                                            plaza_cta,    
                                DECODE(A.codformapago, 'TRS', 0, 'CLAB', 0, 1)  tipo_pago,
                                1                                             fuente,       
                                ''                                            folio_solicitud,
                                '0'                                           error,        
                                '1'                                           comentario
                       FROM NOTAS_DE_CREDITO NC INNER JOIN DETALLE_NOTAS_DE_CREDITO DN  ON  DN.IdNcr                    = NC.IDNCR
                                                LEFT JOIN CLIENTES                  CLI ON  CLI.CodCliente              = NC.CodCliente
                                                LEFT JOIN PERSONA_NATURAL_JURIDICA  PNJ ON  CLI.Tipo_Doc_Identificacion = PNJ.Tipo_Doc_Identificacion
                                                                                        AND CLI.Num_Doc_Identificacion  = PNJ.Num_Doc_Identificacion
                                                LEFT JOIN AGENTES                   AGE ON  AGE.Cod_Agente              = NC.COD_AGENTE 
                                                LEFT JOIN MEDIOS_DE_PAGO            A   ON  A.Tipo_Doc_Identificacion   = AGE.Tipo_Doc_Identificacion
                                                                                        AND A.Num_Doc_Identificacion    = AGE.Num_Doc_Identificacion
                                                                                        AND A.IdFormaPago               = AGE.IdFormaPago          
                                                LEFT JOIN TRANSACCION               T   ON  T.CODCIA                    = NC.CODCIA
                                                                                        AND T.CODEMPRESA                = AGE.CODEMPRESA 
                                                                                        AND T.IDTRANSACCION             = NC.IDTRANSACAPLIC
                                                LEFT JOIN COMPROBANTES_CONTABLES    CC  ON  CC.CODCIA                   = NC.CODCIA
                                                                                        AND CC.NUMTRANSACCION           = T.IDTRANSACCION                                                                                                                                                                                        
                    WHERE NC.CodCia          = nCodCia
                      AND NC.STSNCR          = 'PAG'
                      AND NC.IDNOMINA        IS NOT NULL
                      AND TRUNC(NC.FecDevol) between TO_DATE(dFecDesde, 'DD/MM/YYYY') and TO_DATE(dFecHasta, 'DD/MM/YYYY') 
                      AND NOT EXISTS (SELECT 1 FROM  DETALLE_TABLERO_CTRL_PAGO TCP WHERE TCP.CODCIA = NC.CODCIA AND TCP.FACTURA = TO_CHAR(NC.IDNCR) AND TCP.ERROR = 0)
                    GROUP BY NC.CODCIA,
                             NC.IdNcr,
                             TRUNC(NC.FecDevol),
                             NVL(PNJ.AUXCONTABLE , OC_AGENTES.AUXILIAR_CONTABLE(NC.CodCia, NC.Cod_Agente)),
                             NC.CodCliente, 
                             NC.Cod_Agente, 
                             NC.IDNOMINA,
                             NC.CTALIQUIDADORA,
                             NC.CodMoneda,                 
                             NC.TASA_CAMBIO,                                                 
                             CC.NUMCOMPROB, 
                             A.CodFormaPago,
                             AGE.CodCia,
                             CodEntidadFinan,
                             NumCuentaBancaria, 
                             NumCuentaClabe, 
                             Aba_Swift_Intermediario,
                             NombreBancoIntermediario, 
                             CuentaBancoIntermediario
                     order by TO_CHAR(TRUNC(NC.FecDevol),'MM-DD-YYYY');                  

    LINEA VARCHAR2(100);
                     
    BEGIN
        
        FOR ENT IN QRY_COM LOOP
            IF nSwLote  = 0 THEN
                GT_TABLERO_CTRL_PAGO.INSERTAR(nCodCia, nIdProc, '2000', 'S');
                nSwLote := 1;
            END IF;
            LINEA := 'INSERTO DETALLE';

            GT_DETALLE_TABLERO_CTRL_PAGO.INSERTAR(  nCodCia, 
                                                    nIdProc, 
                                                    nIDPROCDET,
                                                    ENT.FOLIO_AGRUP,
                                                    ENT.AUXILIAR,
                                                    ENT.NOMBRE,
                                                    ENT.FECHA,
                                                    ENT.MONEDA,
                                                    ENT.TIPO_CAMBIO,
                                                    ENT.TASA_IVA,
                                                    ENT.SUB_TOTAL_MO,
                                                    ENT.IVA_MO,
                                                    ENT.TOTAL_MO,
                                                    ENT.TASA_RET_IVA,
                                                    ENT.IMP_RET_IVA,
                                                    ENT.TASA_RET_ISR,
                                                    ENT.IMP_RET_ISR,
                                                    ENT.CCS,
                                                    ENT.UEN,
                                                    ENT.PYS,
                                                    ENT.CONCEPTO,
                                                    ENT.REFERENCIA,
                                                    ENT.GRUPO,
                                                    ENT.FLUJO,
                                                    ENT.FACTURA,
                                                    ENT.CTA_BANCO,
                                                    ENT.clabe,
                                                    ENT.PLAZA_CTA,
                                                    ENT.TIPO_PAGO,
                                                    ENT.FUENTE,
                                                    ENT.FOLIO_SOLICITUD,
                                                    ENT.ERROR,
                                                    ENT.COMENTARIO);
            LINEA := 'SALGO DETALLE';                                                    
            
        END LOOP;    
        LINEA := 'ACTUALIZO RESPUESTA';
        GT_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA(nCodCia, nIdProc);    
        PIDPROC := nIdProc;
    EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20201, SQLERRM);     
    END CREA_LOTE_FONDEO_COMISIONES;
    --
 PROCEDURE CREA_LOTE_FONDEO_SINIEST_IND(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER) IS 
        nCodCia     number(1) := PCODCIA;
        nSwLote     NUMBER(1) := 0;
        nIdProc     NUMBER;
        nIDPROCDET  NUMBER;
        dFecDesde   VARCHAR2(10) := TO_CHAR(PFECHA, 'DD/MM/YYYY');
        dFecHasta   VARCHAR2(10) := TO_CHAR(PFECHA2,'DD/MM/YYYY');
        
        CURSOR QRY_SIN IS
        SELECT /*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, , 
         A.IDPOLIZA                                                             POLIZA,
         SI.IDSINIESTRO                                                         NUM_SINIESTRO,
         '#FOLIO_AGRUPADOR'                                                     FOLIO_AGRUP,
         8601                                                                   AUXILIAR,  
         BES.NOMBRE||' '||BES.APELLIDO_PATERNO||' '||BES.APELLIDO_MATERNO       NOMBRE_BENEFICIARIO,
         trunc(T.FECHATRANSACCION)                                              FECHA,
         OC_MONEDA.CODIGO_SISTEMA_CONTABLE(SI.Cod_Moneda)                       MONEDA,
          (SELECT Tasa_Cambio
            FROM TASAS_CAMBIO CAS
            WHERE Fecha_Hora_Cambio = C.FECCOMPROB 
            AND Cod_Moneda        = SI.Cod_Moneda)                              TIPO_CAMBIO, 
         0                                                                      TASA_IVA,
         NVL(A.Monto_Local,0)                                                   SUB_TOTAL_MO,
         0                                                                      IVA_MO,
         NVL(A.Monto_Local,0)                                                   TOTAL_MO,
         0                                                                      TASA_RET_IVA,
         0                                                                      IMP_RET_IVA,
         0                                                                      TASA_RET_ISR,
         0                                                                      IMP_RET_ISR,
         '5'                                                                    CCS,
         '000'                                                                  UEN,        
         '*'                                                                    PYS,       
         'SINTS01'                                                              CONCEPTO, 
         'Siniestro(WS)-P:'||A.IDPOLIZA || '.' || A.IDSINIESTRO || '.' || A.IDDETSIN || '.' ||A.NUM_APROBACION ||'.'|| A.COD_ASEGURADO            REFERENCIA,
         11                                                                     GRUPO,        
         8                                                                      FLUJO, 
         C.numcomprob                                                           FACTURA,
         NVL(BES.ENT_FINANCIERA , decode(NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE) , null, 0, '4000'))                                            CTA_BANCO,
         NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE)                            CLAVE,
         1                                                                      PLAZA_CTA,
         nvl(DECODE(BES.TIPO_PAGO,'TRANSFERENCIA BANCARIA','1','CHEQUE','0'), '0')  TIPO_PAGO,      
         9                                                                      FUENTE,
         '0'                                                                    FOLIO_SOLICITUD,
         '0'                                                                    ERROR,
         '1'                                                                    COMENTARIO,     
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                  RAMO,                           
         --A.MONTO_MONEDA                                                         MONTO_PAGO,         
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                              NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                                        USUARIO,              
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION                                                       APROBACION,
         A.IDDETSIN                                                             IDDETSIN
    FROM  TRANSACCION               T
         ,APROBACION_ASEG           A 
         ,SINIESTRO                 SI
         ,DETALLE_SINIESTRO_ASEG    DS
         ,BENEF_SIN                 BES   
         ,POLIZAS                   PP
         ,TIPOS_DE_SEGUROS          TS
         ,COMPROBANTES_CONTABLES    C
    WHERE TRUNC(T.FECHATRANSACCION) >= to_date(dFecDesde,'dd/mm/yyyy') --to_date('01/02/2018','dd/mm/yyyy') --dFecDesde  
     AND TRUNC(T.FECHATRANSACCION)  <= to_date(dFecHasta,'dd/mm/yyyy') --to_date('01/02/2018','dd/mm/yyyy')  --dFecHasta  
     ---
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     ---
     AND T.CODCIA           = nCodCia --NVL(:BK_DATOS.CODCIA,1)
     AND T.CODEMPRESA       = 1 --NVL(:BK_DATOS.CODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     AND NOT EXISTS (SELECT F.IDSINIESTRO                      
                     FROM PROCESOS_MASIVOS_SEGUIMIENTO F
                     WHERE F.NUM_APROBACION  = A.NUM_APROBACION  
                     AND   F.IDSINIESTRO     = A.IDSINIESTRO
                     AND   F.IDPOLIZA        = A.IDPOLIZA                                
                     AND   F.COD_ASEGURADO   = A.COD_ASEGURADO
                     AND   F.EMI_TIPOPROCESO = 'PAGSIN'
                     AND   F.IDTRANSACCION   = A.IDTRANSACCION)
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     AND  SI.COD_ASEGURADO  = A.COD_ASEGURADO
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.COD_ASEGURADO   = SI.COD_ASEGURADO
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = nCodCia--NVL(:BK_DATOS.CODCIA,1)
     AND PP.CODEMPRESA      = 1--NVL(:BK_DATOS.CODEMPRESA,1) 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = 1--NVL(:BK_DATOS.CODEMPRESA,1)
     AND TS.CODCIA          = nCodCia--NVL(:BK_DATOS.CODCIA,1)
     AND C.CODCIA           = T.CODCIA
     AND C.NUMTRANSACCION   = T.IDTRANSACCION
     AND NOT EXISTS (SELECT 1 FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA AND CP.IDPROC = P.IDPROC WHERE P.CODCIA = T.CODCIA AND P.FACTURA = C.NUMCOMPROB)     
    --
     --SEGUNDO
  UNION
   SELECT /*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, ,
         A.IDPOLIZA                                                             POLIZA,
         SI.IDSINIESTRO                                                         NUM_SINIESTRO,
          '#FOLIO_AGRUPADOR'                                                     FOLIO_AGRUP,
         8601                                                                   AUXILIAR,  
         BES.NOMBRE||' '||BES.APELLIDO_PATERNO||' '||BES.APELLIDO_MATERNO     NOMBRE_BENEFICIARIO,
         trunc(T.FECHATRANSACCION)                                              FECHA,
         OC_MONEDA.CODIGO_SISTEMA_CONTABLE(SI.Cod_Moneda)                       MONEDA,
          (SELECT Tasa_Cambio
            FROM TASAS_CAMBIO CAS
            WHERE Fecha_Hora_Cambio = C.FECCOMPROB 
            AND Cod_Moneda        = SI.Cod_Moneda)                              TIPO_CAMBIO, 
         0                                                                      TASA_IVA,
         NVL(A.Monto_Local,0)                                                   SUB_TOTAL_MO,
         0                                                                      IVA_MO,
         NVL(A.Monto_Local,0)                                                   TOTAL_MO,
         0                                                                      TASA_RET_IVA,
         0                                                                      IMP_RET_IVA,
         0                                                                      TASA_RET_ISR,
         0                                                                      IMP_RET_ISR,
         '5'                                                                    CCS,
         '000'                                                                  UEN,        
         '*'                                                                    PYS,       
         'SINTS01'                                                              CONCEPTO, 
         'Siniestro(WS)-P:'||A.IDPOLIZA || '.' || A.IDSINIESTRO || '.' || A.IDDETSIN || '.' ||A.NUM_APROBACION ||'.'            REFERENCIA,
         11                                                                     GRUPO,        
         8                                                                      FLUJO, 
         C.numcomprob                                                           FACTURA,
         NVL(BES.ENT_FINANCIERA , decode(NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE) , null, 0, '4000'))                                            CTA_BANCO,
         NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE)                            CLAVE,
         1                                                                      PLAZA_CTA,
         DECODE(BES.TIPO_PAGO,'TRANSFERENCIA BANCARIA','1','CHEQUE','0')        TIPO_PAGO,      
         9                                                                      FUENTE,
         '0'                                                                    FOLIO_SOLICITUD,
         '0'                                                                    ERROR,
         '1'                                                                    COMENTARIO,     
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                  RAMO,                           
         --A.MONTO_MONEDA                                                         MONTO_PAGO,         
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                              NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                                        USUARIO,              
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION                                                       APROBACION,
         A.IDDETSIN                                                             IDDETSIN              
    FROM TRANSACCION          T  ,  
         APROBACIONES         A  , 
         SINIESTRO            SI , 
         DETALLE_SINIESTRO    DS ,
         BENEF_SIN            BES, 
         POLIZAS              PP ,
         TIPOS_DE_SEGUROS     TS,
         COMPROBANTES_CONTABLES C
                
   WHERE TRUNC(T.FECHATRANSACCION) >= to_date(dFecDesde,'dd/mm/yyyy')--to_date('01/02/2018','dd/mm/yyyy')        --dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <= to_date(dFecHasta,'dd/mm/yyyy')--to_date('01/02/2018','dd/mm/yyyy')        --dFecHasta  
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     AND T.CODCIA           = nCodCia --NVL(:BK_DATOS.CODCIA,1)
     AND T.CODEMPRESA       = 1 --NVL(:BK_DATOS.CODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     --
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.IDTIPOSEG       NOT IN ('FONACO')
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = 1--NVL(:BK_DATOS.CODCIA,1)
     AND PP.CODEMPRESA      = 1 --NVL(:BK_DATOS.CODEMPRESA,1) 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = 1--NVL(:BK_DATOS.CODEMPRESA,1)
     AND TS.CODCIA          = 1--NVL(:BK_DATOS.CODCIA,1)
     AND C.CODCIA           = T.CODCIA
     AND C.NUMTRANSACCION   = T.IDTRANSACCION
     AND NOT EXISTS (SELECT 1 FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA AND CP.IDPROC = P.IDPROC WHERE P.CODCIA = T.CODCIA AND P.FACTURA = C.NUMCOMPROB)
   --
   --TERCERO 
 UNION 
   SELECT /*+ RULE +*/ -- T.IDTRANSACCION NUM_TRANSACCION, ,
         A.IDPOLIZA                                                             POLIZA,
         SI.IDSINIESTRO                                                         NUM_SINIESTRO,
          '#FOLIO_AGRUPADOR'                                                    FOLIO_AGRUP,
         8601                                                                   AUXILIAR,  
         BES.NOMBRE||' '||BES.APELLIDO_PATERNO||' '||BES.APELLIDO_MATERNO     NOMBRE_BENEFICIARIO,
         trunc(T.FECHATRANSACCION)                                              FECHA,
         OC_MONEDA.CODIGO_SISTEMA_CONTABLE(SI.Cod_Moneda)                       MONEDA,
          (SELECT Tasa_Cambio
            FROM TASAS_CAMBIO CAS
            WHERE Fecha_Hora_Cambio = C.FECCOMPROB 
            AND Cod_Moneda        = SI.Cod_Moneda)                              TIPO_CAMBIO, 
         0                                                                      TASA_IVA,
         NVL(A.Monto_Local,0)                                                   SUB_TOTAL_MO,
         0                                                                      IVA_MO,
         NVL(A.Monto_Local,0)                                                   TOTAL_MO,
         0                                                                      TASA_RET_IVA,
         0                                                                      IMP_RET_IVA,
         0                                                                      TASA_RET_ISR,
         0                                                                      IMP_RET_ISR,
         '5'                                                                    CCS,
         '000'                                                                  UEN,        
         '*'                                                                    PYS,       
         'SINTS01'                                                              CONCEPTO, 
         'Siniestro(WS)-P:'||A.IDPOLIZA || '.' || A.IDSINIESTRO || '.' || A.IDDETSIN || '.' ||A.NUM_APROBACION ||'.'            REFERENCIA,
         11                                                                     GRUPO,        
         8                                                                      FLUJO, 
         C.numcomprob                                                           FACTURA,
         NVL(BES.ENT_FINANCIERA , decode(NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE) , null, 0, '4000'))                                            CTA_BANCO,
         NVL(BES.NUMCUENTABANCARIA, BES.CUENTA_CLAVE)                           CLAVE,
         1                                                                      PLAZA_CTA,
         DECODE(BES.TIPO_PAGO,'TRANSFERENCIA BANCARIA','1','CHEQUE','0')        TIPO_PAGO,      
         9                                                                      FUENTE,
         '0'                                                                    FOLIO_SOLICITUD,
         '0'                                                                    ERROR,
         '1'                                                                    COMENTARIO,     
         DECODE(TS.CODTIPOPLAN,10,'VIDA','AP')                                  RAMO,                           
         --A.MONTO_MONEDA                                                         MONTO_PAGO,         
         OC_CLIENTES.NOMBRE_CLIENTE(PP.CODCLIENTE)                              NOMBRE_CONTRATANTE,                   
         T.USUARIOGENERO                                                        USUARIO,              
         --- Datos para Actualizar Fondeo  ---
         A.NUM_APROBACION                                                       APROBACION,
         A.IDDETSIN                                                             IDDETSIN       
    FROM TRANSACCION             T  , 
         APROBACIONES            A  , 
         SINIESTRO               SI , 
         DETALLE_SINIESTRO       DS ,
         BENEF_SIN               BES,   
         POLIZAS                 PP ,
         TIPOS_DE_SEGUROS        TS,
         COMPROBANTES_CONTABLES  C
   WHERE TRUNC(T.FECHATRANSACCION) >= to_date(dFecDesde,'dd/mm/yyyy') --to_date('01/02/2018','dd/mm/yyyy')        --dFecDesde  
     AND TRUNC(T.FECHATRANSACCION) <= to_date(dFecHasta,'dd/mm/yyyy') --to_date('01/02/2018','dd/mm/yyyy')        --dFecHasta  
     AND T.USUARIOGENERO IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
     AND T.CODCIA           = nCodCia--NVL(:BK_DATOS.CODCIA,1)
     AND T.CODEMPRESA       = 1--NVL(:BK_DATOS.CODEMPRESA,1)
     AND T.IDPROCESO        = 6
     --
     AND A.IDTRANSACCION    = T.IDTRANSACCION
     AND A.STSAPROBACION    = 'PAG'
     AND  SI.IDSINIESTRO    = A.IDSINIESTRO
     AND  SI.IDPOLIZA       = A.IDPOLIZA
     --
     AND DS.IDSINIESTRO     = SI.IDSINIESTRO
     AND DS.IDPOLIZA        = SI.IDPOLIZA
     AND DS.IDDETSIN        = 1
     AND DS.IDTIPOSEG      IN ('FONACO')
     --
     AND BES.IDSINIESTRO    = A.IDSINIESTRO
     AND BES.IDPOLIZA       = A.IDPOLIZA
     AND BES.BENEF          = A.BENEF 
     --
     AND PP.IDPOLIZA        = a.idpoliza
     AND PP.CODCIA          = nCodCia--NVL(:BK_DATOS.CODCIA,1)
     AND PP.CODEMPRESA      = 1--NVL(:BK_DATOS.CODEMPRESA,1) 
     --
     AND TS.IDTIPOSEG       = DS.IDTIPOSEG
     AND TS.CODEMPRESA      = 1--NVL(:BK_DATOS.CODEMPRESA,1)
     AND TS.CODCIA          = nCodCia--NVL(:BK_DATOS.CODCIA,1)
     AND C.CODCIA           = T.CODCIA
     AND C.NUMTRANSACCION   = T.IDTRANSACCION
     AND NOT EXISTS (SELECT 1 FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA AND CP.IDPROC = P.IDPROC WHERE P.CODCIA = T.CODCIA AND P.FACTURA = C.NUMCOMPROB); 
                     
    BEGIN
        
        FOR ENT IN QRY_SIN LOOP
            IF nSwLote  = 0 THEN
                GT_TABLERO_CTRL_PAGO.INSERTAR(nCodCia, nIdProc, '2010', 'S');
                nSwLote := 1;
            END IF;
            GT_DETALLE_TABLERO_CTRL_PAGO.INSERTAR(  nCodCia, 
                                                    nIdProc, 
                                                    nIDPROCDET,
                                                    ENT.FOLIO_AGRUP,
                                                    ENT.AUXILIAR,
                                                    ENT.NOMBRE_BENEFICIARIO,
                                                    ENT.FECHA,
                                                    ENT.MONEDA,
                                                    ENT.TIPO_CAMBIO,
                                                    ENT.TASA_IVA,
                                                    ENT.SUB_TOTAL_MO,
                                                    ENT.IVA_MO,
                                                    ENT.TOTAL_MO,
                                                    ENT.TASA_RET_IVA,
                                                    ENT.IMP_RET_IVA,
                                                    ENT.TASA_RET_ISR,
                                                    ENT.IMP_RET_ISR,
                                                    ENT.CCS,
                                                    ENT.UEN,
                                                    ENT.PYS,
                                                    ENT.CONCEPTO,
                                                    ENT.REFERENCIA,
                                                    ENT.GRUPO,
                                                    ENT.FLUJO,
                                                    ENT.FACTURA,
                                                    ENT.CTA_BANCO,
                                                    ENT.CLAVE,
                                                    ENT.PLAZA_CTA,
                                                    ENT.TIPO_PAGO,
                                                    ENT.FUENTE,
                                                    ENT.FOLIO_SOLICITUD,
                                                    ENT.ERROR,
                                                    ENT.COMENTARIO);
            
        END LOOP;    
        GT_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA(nCodCia, nIdProc);    
        PIDPROC := nIdProc;
    END CREA_LOTE_FONDEO_SINIEST_IND;
    --          
    PROCEDURE CREA_LOTE_FONDEO_INFONACOT(PCODCIA NUMBER, PFECHA DATE, PIDPROC OUT NUMBER) IS 
        nCodCia     number(1) := PCODCIA;
        nSwLote     NUMBER(1) := 0;
        nIdProc     NUMBER;
        nIDPROCDET  NUMBER;
        dFecDesde   VARCHAR2(10) := TO_CHAR(PFECHA, 'DD/MM/YYYY');
        
        CURSOR QRY_SIN IS
                    SELECT 
                     5                                                              COMPANIA
                    ,'#FOLIO_AGRUPADOR'                                             FOLIO_AGRUP
                    ,8601                                                           AUXILIAR
                    ,B.Nombre||' '||B.Apellido_Paterno||' '||B.Apellido_Materno     NOMBRE
                    ,I.Fe_Carga                                                     FECHA
                    ,OC_MONEDA.CODIGO_SISTEMA_CONTABLE(S.Cod_Moneda)                MONEDA
                    ,(SELECT Tasa_Cambio
                        FROM TASAS_CAMBIO CAS
                       WHERE Fecha_Hora_Cambio = I.Fe_Carga  
                         AND Cod_Moneda        = S.Cod_Moneda
                                                   )                                TASA_CAMBIO
                    ,0                                                              tasa_iva
                    ,SUM(NVL(A.Monto_Local,0))                                      sub_total_mo
                    ,0                                                              iva_mo
                    ,SUM(NVL(A.Monto_Local,0))                                      total_mo
                    ,0                                                              tasa_ret_iva
                    ,0                                                              imp_ret_iva
                    ,0                                                              tasa_ret_isr
                    ,0                                                              imp_ret_isr
                    ,5                                                              ccs        
                    ,'000'                                                          uen        
                    ,'*'                                                            pys        
                    ,'SINTS01'                                                      concepto        
                    ,'Siniestro Infonacot(WS.' || COUNT(*) ||')-No.Envio:' ||I.ID_ENVIO REFERENCIA        
                    ,11                                                             grupo        
                    ,8                                                              flujo        
                    ,I.ID_ENVIO                                                     factura
                    ,MAX(F.CODBCOMIZAR)                                         id_cta_banco
                    ,CASE WHEN MAX(N.NUMCUENTACLABE) IS NULL THEN MAX(N.NUMCUENTABANCARIA) ELSE MAX(N.NUMCUENTABANCARIA) END   CLABE
                    ,'1'                                                            plaza_cta
                    ,0                                                              tipo_pago  --  TRANSFERENCIA
                    ,9                                                              fuente
                    ,'0'                                                            folio_solicitud
                    ,'0'                                                            error
                    ,'1'                                                            comentario      
              FROM TRANSACCION T INNER JOIN APROBACIONES        A ON  T.IdTransaccion= A.IdTransaccion
                                 INNER JOIN BENEF_SIN           B ON  A.IdPoliza    = B.IdPoliza
                                                                  AND A.IdSiniestro = B.IdSiniestro
                                                                  AND A.Benef       = B.Benef    
                                 INNER JOIN SINIESTRO           S ON  S.IdPoliza    = A.IdPoliza
                                                                  AND S.IdSiniestro = A.IdSiniestro 
                                 INNER JOIN INFO_SINIESTRO      I ON  T.FechaTransaccion >= I.Fe_Carga and
                                                                      I.Siniestro   = S.IdSiniestro
                                 INNER JOIN POLIZAS             P ON P.CODCIA = S.CODCIA AND P.IDPOLIZA = S.IDPOLIZA
                                 INNER JOIN CLIENTES            G ON G.CODCLIENTE   = P.CODCLIENTE                                                            
                                 INNER JOIN MEDIOS_DE_PAGO      N ON N.TIPO_DOC_IDENTIFICACION = G.TIPO_DOC_IDENTIFICACION AND N.NUM_DOC_IDENTIFICACION = G.NUM_DOC_IDENTIFICACION AND N.IDFORMAPAGO  = N.IDFORMAPAGO AND INDMEDIOPRINCIPAL = 'S'
                                 INNER JOIN ENTIDAD_FINANCIERA  F ON F.CODCIA = S.CODCIA AND F.CODENTIDAD = N.CODENTIDADFINAN                                                                          
            WHERE I.ID_CODCIA = nCodCia
              AND I.FE_CARGA = to_date(dFecDesde, 'DD/MM/YYYY')
              AND NOT EXISTS (SELECT 1 FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA AND CP.IDPROC = P.IDPROC WHERE P.CODCIA = T.CODCIA AND P.FACTURA = I.ID_ENVIO AND CP.ESFONDEO = 'S') 
            GROUP BY I.ID_ENVIO,  I.Fe_Carga,       
                     B.Nombre||' '||B.Apellido_Paterno||' '||B.Apellido_Materno,
                     B.Ent_Financiera, I.Ref_Banca, B.NumCuentaBancaria,
                     S.Cod_Moneda, OC_MONEDA.DESCRIPCION_MONEDA(S.Cod_Moneda); 
                     
    BEGIN
        
        FOR ENT IN QRY_SIN LOOP
            IF nSwLote  = 0 THEN
                GT_TABLERO_CTRL_PAGO.INSERTAR(nCodCia, nIdProc, '2030', 'S');
                nSwLote := 1;
            END IF;
            GT_DETALLE_TABLERO_CTRL_PAGO.INSERTAR(  nCodCia, 
                                                    nIdProc, 
                                                    nIDPROCDET,
                                                    ENT.FOLIO_AGRUP,
                                                    ENT.AUXILIAR,
                                                    ENT.NOMBRE,
                                                    ENT.FECHA,
                                                    ENT.MONEDA,
                                                    ENT.TASA_CAMBIO,
                                                    ENT.tasa_iva,
                                                    ENT.sub_total_mo,
                                                    ENT.iva_mo,
                                                    ENT.total_mo,
                                                    ENT.tasa_ret_iva,
                                                    ENT.imp_ret_iva,
                                                    ENT.tasa_ret_isr,
                                                    ENT.imp_ret_isr,
                                                    ENT.ccs,
                                                    ENT.uen,
                                                    ENT.pys,
                                                    ENT.concepto,
                                                    ENT.REFERENCIA,
                                                    ENT.grupo,
                                                    ENT.flujo,
                                                    ENT.factura,
                                                    ENT.id_cta_banco,
                                                    ENT.clabe,
                                                    ENT.plaza_cta,
                                                    ENT.tipo_pago,
                                                    ENT.fuente,
                                                    ENT.folio_solicitud,
                                                    ENT.error,
                                                    ENT.comentario);
            
        END LOOP;    
        GT_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA(nCodCia, nIdProc);    
        PIDPROC := nIdProc;
    END CREA_LOTE_FONDEO_INFONACOT;
    --
 PROCEDURE CREA_LOTE_FONDEO_COLECTIVOS(PCODCIA NUMBER, PFECHA DATE, PFECHA2 DATE,PIDPROC OUT NUMBER) IS 
        nCodCia     number(1) := PCODCIA;
        nSwLote     NUMBER(1) := 0;
        nIdProc     NUMBER;
        nIDPROCDET  NUMBER;
        dFecDesde   VARCHAR2(10) := TO_CHAR(PFECHA, 'DD/MM/YYYY');
        dFecHasta   VARCHAR2(10) := TO_CHAR(PFECHA2,'DD/MM/YYYY');
        
        CURSOR QRY_SIN IS
            SELECT  IDPOLIZA                                                     POLIZA,
                    IDSINIESTRO                                                  NUM_SINIESTRO,
                     NUM_APROBACION                                              APROBACION,
                     IDDETSIN                                                    IDDETSIN,                                                                
                    5                                                            compania,
                     '#FOLIO_AGRUPADOR'                                          FOLIO_AGRUP,
                     8601                                                        AUXILIAR,  
                     NOMBRE_BENEFICIARIO                                         nombre,
                     FechaTransaccion                                            FECHA,
                     MONEDA                                                      MONEDA,
                     TIPO_CAMBIO                                                 TIPO_CAMBIO, 
                     0                                                                      TASA_IVA,
                     NVL(Monto_Local,0)                                                     SUB_TOTAL_MO,
                     0                                                                      IVA_MO,
                     NVL(Monto_Local,0)                                                     TOTAL_MO,
                     0                                                                      TASA_RET_IVA,
                     0                                                                      IMP_RET_IVA,
                     0                                                                      TASA_RET_ISR,
                     0                                                                      IMP_RET_ISR,
                     '5'                                                                    CCS,
                     '000'                                                                  UEN,        
                     '*'                                                                    PYS,       
                     'SINTS01'                                                              CONCEPTO, 
                     REFERENCIA                                                             REFERENCIA,
                     11                                                                     GRUPO,        
                     8                                                                      FLUJO, 
                     NUMCOMPROB                                                             FACTURA,
                     CTA_BANCO                                                              id_cta_banco,
                     CLAVE                                                                  CLABE,
                     1                                                                      PLAZA_CTA,
                     TIPO_PAGO                                                              TIPO_PAGO,      
                     9                                                                      FUENTE,
                     '0'                                                                    FOLIO_SOLICITUD,
                     '0'                                                                    ERROR,
                     '1'                                                                    COMENTARIO     
            FROM (                        
                        SELECT /*+ RULE +*/ UNIQUE(T.IdTransaccion), SI.IdPoliza, 
                          OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik, 
                          SI.IdSiniestro,
                          BES.NOMBRE||' '||BES.APELLIDO_PATERNO||' '||BES.APELLIDO_MATERNO     NOMBRE_BENEFICIARIO,
                         OC_MONEDA.CODIGO_SISTEMA_CONTABLE(SI.Cod_Moneda)                       MONEDA,
                          (SELECT Tasa_Cambio
                            FROM TASAS_CAMBIO CAS
                            WHERE Fecha_Hora_Cambio = C.FECCOMPROB 
                            AND Cod_Moneda        = SI.Cod_Moneda)                              TIPO_CAMBIO,                                   
                          OC_DETALLE_APROBACION.CONCEPTO_DE_PAGO(SI.IdSiniestro, A.Num_Aprobacion, 1) Cod_Pago,
                          TRUNC(T.FechaTransaccion) FechaTransaccion, 
                         NVL(BES.ENT_FINANCIERA , decode(NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE) , null, 0, '4000'))                                            CTA_BANCO,
                         NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE)                            CLAVE,
                         DECODE(BES.TIPO_PAGO,'TRANSFERENCIA BANCARIA','1','CHEQUE','0')        TIPO_PAGO,      
                        'Siniestro(WS)-P:'||A.IDPOLIZA || '.' || A.IDSINIESTRO || '.' || A.IDDETSIN || '.' ||A.NUM_APROBACION ||'.'|| NULL  REFERENCIA,          
                          C.NUMCOMPROB,
                          A.Num_Aprobacion, 
                          A.Tipo_Aprobacion, 
                          SI.CodCia, 
                          SI.CodEmpresa ,
                          DS.IDDETSIN,
                          A.Monto_Local             
                     FROM TRANSACCION T, DETALLE_TRANSACCION D, APROBACIONES A,   
                          SINIESTRO SI, DETALLE_SINIESTRO DS,
                          COMPROBANTES_CONTABLES C,
                          BENEF_SIN                 BES  
                    WHERE T.CodCia                  = nCodCia
                      AND T.CodEmpresa              = 1
                      AND T.IdTransaccion           > 0
                      AND TRUNC(T.FechaTransaccion) BETWEEN to_date(dFecDesde, 'DD/MM/YYYY') AND     to_date(dFecHasta, 'DD/MM/YYYY')
                      AND T.IdProceso               = 6                                             
                      AND T.USUARIOGENERO NOT IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
                      AND D.Valor2                  IS NOT NULL
                      AND D.IdTransaccion           =  T.IdTransaccion
                      AND D.Correlativo             = 1
                      AND D.CodSubProceso          IN ('APRSIN','ANUAPR')
                      AND DECODE('PAG','PAG',A.IdTransaccion, A.IdTransaccionAnul) = D.IdTransaccion
                      AND A.IdSiniestro             = D.Valor1
                      AND A.IdPoliza                = D.Valor2
                      AND A.IdDetSin                = D.Valor3
                      AND A.StsAprobacion          IN ('PAG','ANU')
                      AND A.Num_Aprobacion          > 0
                      
                      AND BES.IDSINIESTRO    = A.IDSINIESTRO
                      AND BES.IDPOLIZA       = A.IDPOLIZA
                      AND BES.BENEF          = A.BENEF 
                      
                      AND SI.IdSiniestro            = A.IdSiniestro
                      AND DS.IdSiniestro            = SI.IdSiniestro
                      AND DS.IdDetSin               = A.IdDetSin
                      AND C.CODCIA = T.CODCIA
                      AND C.NUMTRANSACCION = T.IDTRANSACCION
                      AND NOT EXISTS (SELECT 1 
                                        FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA 
                                                                                                         AND CP.IDPROC = P.IDPROC 
                                       WHERE P.CODCIA = T.CODCIA AND P.FACTURA = C.NUMCOMPROB)                              
                    UNION                                
                  SELECT /*+ RULE +*/ T.IdTransaccion, SI.IdPoliza, 
                          OC_POLIZAS.NUMERO_UNICO(SI.CodCia, SI.IdPoliza) PolUnik, 
                          SI.IdSiniestro,
                          BES.NOMBRE||' '||BES.APELLIDO_PATERNO||' '||BES.APELLIDO_MATERNO     NOMBRE_BENEFICIARIO,
                             OC_MONEDA.CODIGO_SISTEMA_CONTABLE(SI.Cod_Moneda)                       MONEDA,
                              (SELECT Tasa_Cambio
                                FROM TASAS_CAMBIO CAS
                                WHERE Fecha_Hora_Cambio = C.FECCOMPROB 
                                AND Cod_Moneda        = SI.Cod_Moneda)                              TIPO_CAMBIO, 
                          OC_DETALLE_APROBACION_ASEG.CONCEPTO_DE_PAGO(SI.IdSiniestro, A.Num_Aprobacion, 1) Cod_Pago,
                          TRUNC(T.FechaTransaccion) FechaTransaccion, 
                         NVL(BES.ENT_FINANCIERA , decode(NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE) , null, 0, '4000'))                                            CTA_BANCO,
                         NVL(BES.NUMCUENTABANCARIA,BES.CUENTA_CLAVE)                            CLAVE,
                         DECODE(BES.TIPO_PAGO,'TRANSFERENCIA BANCARIA','1','CHEQUE','0')        TIPO_PAGO,      
                        'Siniestro(WS)-P:'||A.IDPOLIZA || '.' || A.IDSINIESTRO || '.' || A.IDDETSIN || '.' ||A.NUM_APROBACION ||'.'|| A.COD_ASEGURADO  REFERENCIA,          
                          C.NUMCOMPROB,
                          A.Num_Aprobacion, 
                          A.Tipo_Aprobacion, 
                          SI.CodCia, 
                          SI.CodEmpresa ,
                          DS.IDDETSIN,
                          A.Monto_Local
                     FROM TRANSACCION T, DETALLE_TRANSACCION D, APROBACION_ASEG A,   
                          SINIESTRO SI, DETALLE_SINIESTRO_ASEG DS, PROCESOS_MASIVOS_SEGUIMIENTO PMS,
                          COMPROBANTES_CONTABLES C,
                          BENEF_SIN                 BES  
                    WHERE T.CodCia                  = nCodCia
                      AND T.CodEmpresa              = 1
                      AND T.IdTransaccion           > 0
                      AND TRUNC(T.FechaTransaccion) BETWEEN to_date(dFecDesde, 'DD/MM/YYYY') AND to_date(dFecHasta, 'DD/MM/YYYY')
                      AND T.IdProceso               = 6                                             
                      AND T.USUARIOGENERO NOT IN (  SELECT CODUSUARIO 
                                 FROM PROCESO_AUTORIZA_USUARIO
                                WHERE CodCia               = T.CODCIA
                                  AND CodProceso           = 9040
                                  AND IdTipoSeg            = 'NOAPLI')
                      AND D.Valor2                  IS NOT NULL      
                      AND D.IdTransaccion           =  T.IdTransaccion
                      AND D.Correlativo             = 1
                      AND D.CodSubProceso           IN ('APRSIN','ANUAPR')
                      AND DECODE('PAG','PAG',A.IdTransaccion,a.IdTransaccionAnul) = d.IdTransaccion
                      AND A.IdSiniestro             = D.Valor1
                      AND A.IdPoliza                = D.Valor2
                      AND A.IdDetSin                = D.Valor3
                      AND A.StsAprobacion          IN ('PAG','ANU')
                      AND A.Num_Aprobacion          > 0
                      AND SI.IdSiniestro            = A.IdSiniestro
                      AND DS.IdSiniestro            = SI.IdSiniestro
                      AND DS.IdDetSin               = A.IdDetSin
                      AND DS.Cod_Asegurado          = SI.Cod_Asegurado
                      AND C.CODCIA                  = T.CODCIA
                      AND C.NUMTRANSACCION          = T.IDTRANSACCION
                      --
                      AND BES.IDSINIESTRO    = A.IDSINIESTRO
                      AND BES.IDPOLIZA       = A.IDPOLIZA
                      AND BES.BENEF          = A.BENEF 
                      --
                      AND PMS.CodCia           (+) = 1
                      AND PMS.CodEmpresa       (+) = 1
                      AND PMS.IdPoliza         (+) = A.IdPoliza
                      AND PMS.Num_Aprobacion   (+) = A.Num_Aprobacion
                      AND PMS.IdSiniestro      (+) = A.IdSiniestro
                      AND PMS.Cod_Asegurado    (+) = A.Cod_Asegurado
                      AND PMS.IdTransaccion    (+) = A.IdTransaccion
                      AND PMS.Emi_TipoProceso  (+) = 'PAGSIN'                              
                      AND NOT EXISTS (SELECT 1 
                                        FROM TABLERO_CTRL_PAGO  CP INNER JOIN DETALLE_TABLERO_CTRL_PAGO P ON CP.CODCIA = P.CODCIA 
                                                                                                         AND CP.IDPROC = P.IDPROC 
                                       WHERE P.CODCIA = T.CODCIA AND P.FACTURA = C.NUMCOMPROB))                                                           ; 
                     
    BEGIN
        
        FOR ENT IN QRY_SIN LOOP
            IF nSwLote  = 0 THEN
                GT_TABLERO_CTRL_PAGO.INSERTAR(nCodCia, nIdProc, '2015', 'S');
                nSwLote := 1;
            END IF;
            GT_DETALLE_TABLERO_CTRL_PAGO.INSERTAR(  nCodCia, 
                                                    nIdProc, 
                                                    nIDPROCDET,
                                                    ENT.FOLIO_AGRUP,
                                                    ENT.AUXILIAR,
                                                    ENT.NOMBRE,
                                                    ENT.FECHA,
                                                    ENT.MONEDA,
                                                    ENT.TIPO_CAMBIO,
                                                    ENT.TASA_IVA,
                                                    ENT.SUB_TOTAL_MO,
                                                    ENT.IVA_MO,
                                                    ENT.TOTAL_MO,
                                                    ENT.TASA_RET_IVA,
                                                    ENT.IMP_RET_IVA,
                                                    ENT.TASA_RET_ISR,
                                                    ENT.IMP_RET_ISR,
                                                    ENT.CCS,
                                                    ENT.UEN,
                                                    ENT.PYS,
                                                    ENT.CONCEPTO,
                                                    ENT.REFERENCIA,
                                                    ENT.GRUPO,
                                                    ENT.FLUJO,
                                                    ENT.FACTURA,
                                                    ENT.ID_CTA_BANCO,
                                                    ENT.CLABE,
                                                    ENT.PLAZA_CTA,
                                                    ENT.TIPO_PAGO,
                                                    ENT.FUENTE,
                                                    ENT.FOLIO_SOLICITUD,
                                                    ENT.ERROR,
                                                    ENT.COMENTARIO);
            
        END LOOP;    
        GT_TABLERO_CTRL_PAGO.ACTUALIZA_RESPUESTA(nCodCia, nIdProc);    
        PIDPROC := nIdProc;
    END CREA_LOTE_FONDEO_COLECTIVOS;    
    --          
END GT_TABLERO_CTRL_PAGO;
/
