CREATE OR REPLACE PACKAGE          GT_TABLERO_CONTROL_DERIVA AS
    FUNCTION  NUMERO_PROCESO    (nCodCia IN NUMBER) RETURN NUMBER;
    PROCEDURE INSERTAR          (nCodCia IN NUMBER, nIdProc IN NUMBER, dFechProc IN DATE, cFacturado IN VARCHAR2, cCodUsuarioFac IN VARCHAR2, cDiferencia IN VARCHAR2, cCodUsuarioDer IN VARCHAR2, nCantidad IN NUMBER, cDerivado IN VARCHAR2, dFechEnvio IN DATE, dFechResp IN DATE, nMontoDeriva IN NUMBER, cIdReferencia IN VARCHAR2);
    PROCEDURE MARCAR_PROCESADO  (nCodCia IN NUMBER, nIdProc IN NUMBER);
    PROCEDURE MARCAR_DERIVADO   (nCodCia IN NUMBER, nIdProc IN NUMBER);   
    PROCEDURE MARCAR_ERRORES    (nCodCia IN NUMBER, nIdProc IN NUMBER,cEror IN VARCHAR2); 
    PROCEDURE ACTUALIZA_VALORES (nCodCia IN NUMBER, nIdProc IN NUMBER);
    PROCEDURE EJECUTA_PROCESO_WS_DERIVA(nCodCia NUMBER := 1, pNEsManual NUMBER := 1, pCTipoComprob VARCHAR2 := NULL, pDFecha DATE:= TRUNC(SYSDATE-1));
    PROCEDURE RECIBE_RESULTADO_MIZAR(cMessage IN OUT VARCHAR2);
    PROCEDURE ENVIA_PROCESO_MIZAR;
END GT_TABLERO_CONTROL_DERIVA;
/

CREATE OR REPLACE PACKAGE BODY          GT_TABLERO_CONTROL_DERIVA AS
    FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER) RETURN NUMBER IS
        nIdProc TABLERO_CONTROL_DERIVA.IdProc%TYPE;
    BEGIN
        SELECT NVL(MAX(IdProc),0) + 1
          INTO nIdProc
          FROM TABLERO_CONTROL_DERIVA
         WHERE CodCia = nCodCia;
        RETURN nIdProc;
    END NUMERO_PROCESO;

    PROCEDURE INSERTAR (nCodCia IN NUMBER, nIdProc IN NUMBER, dFechProc IN DATE, cFacturado IN VARCHAR2, 
                        cCodUsuarioFac IN VARCHAR2, cDiferencia IN VARCHAR2, cCodUsuarioDer IN VARCHAR2, 
                        nCantidad IN NUMBER, cDerivado IN VARCHAR2, dFechEnvio IN DATE, 
                        dFechResp IN DATE, nMontoDeriva IN NUMBER, cIdReferencia IN VARCHAR2) IS
    BEGIN
        INSERT INTO TABLERO_CONTROL_DERIVA (CodCia, IdProc, FechProc, Facturado, CodUsuarioFac, 
                                            Diferencia, CodUsuarioDer, Cantidad, Derivado, FechEnvio, 
                                            FechResp, MontoDerivaLocal, IdReferencia, StsProceso, CodUsuario, 
                                            FecUltModif)
                                    VALUES (nCodCia, nIdProc, dFechProc, cFacturado, cCodUsuarioFac, 
                                            cDiferencia, cCodUsuarioDer, nCantidad, cDerivado, dFechEnvio, 
                                            dFechResp, nMontoDeriva, cIdReferencia, 'XPROC', USER, 
                                            TRUNC(SYSDATE));
    END INSERTAR;

    PROCEDURE MARCAR_PROCESADO(nCodCia IN NUMBER, nIdProc IN NUMBER) IS
    BEGIN 
        UPDATE TABLERO_CONTROL_DERIVA
           SET StsProceso   = 'PROCSR',
               CodUsuario   = USER,
               FecUltModif  = TRUNC(SYSDATE)
         WHERE CodCia   = nCodCia
           AND IdProc   = nIdProc;
    END MARCAR_PROCESADO;

    PROCEDURE MARCAR_DERIVADO(nCodCia IN NUMBER, nIdProc IN NUMBER) IS
    BEGIN
        UPDATE TABLERO_CONTROL_DERIVA
           SET StsProceso       = 'DERIVA',
               FECHRESP         = SYSDATE,   
               CodUsuario       = USER,
               CodUsuarioDer    = USER,
               FecUltModif      = TRUNC(SYSDATE),               
               Derivado         = 'S'
         WHERE CodCia   = nCodCia
           AND IdProc   = nIdProc;
    END MARCAR_DERIVADO;

    PROCEDURE MARCAR_ERRORES(nCodCia IN NUMBER, nIdProc IN NUMBER, cEror IN VARCHAR2) IS
    BEGIN 
        UPDATE TABLERO_CONTROL_DERIVA
           SET StsProceso   = 'ERRDER',
               FECHRESP         = SYSDATE,   
               CodUsuario   = USER,
               FecUltModif  = TRUNC(SYSDATE),
               Error        = cEror
         WHERE CodCia   = nCodCia
           AND IdProc   = nIdProc;
    END MARCAR_ERRORES;

    PROCEDURE ACTUALIZA_VALORES(nCodCia IN NUMBER, nIdProc IN NUMBER) IS
        nMtoMovCuentaLocal  DETALLE_TABLERO_CONTROL_DER.MtoMovCuentaLocal%TYPE;
        nMtoMovCuentaMoneda DETALLE_TABLERO_CONTROL_DER.MtoMovCuentaMoneda%TYPE;
        nNumReg NUMBER;
        nIncompl NUMBER;
    BEGIN

        BEGIN
            SELECT 1
             INTO nIncompl
             FROM TABLERO_CONTROL_DERIVA T
            WHERE CodCia = nCodCia
              AND IdProc = nIdProc
              AND T.STSPROCESO = 'DERIVA' ;
        EXCEPTION WHEN OTHERS THEN
            nIncompl := 0;
        END;          

        UPDATE DETALLE_TABLERO_CONTROL_DER T SET STSGRUPO = 'ERRDER',
                                                 T.ERROR  = 'No hubo respuesta de MIZAR, favor de validarlo con FINANZAS la poliza generada'
         WHERE T.CODCIA     = nCodCia
           AND T.IDPROC     = nIdProc                                                  
           AND T.STSGRUPO   = 'PROCSR'
           AND nIncompl = 1;

        IF SQL%ROWCOUNT > 0 THEN
            nIncompl := 2;
        END IF;           
        BEGIN           
            SELECT SUM(NVL(MtoMovCuentaLocal,0)), 
                   SUM(NVL(MtoMovCuentaMoneda,0)),
                   COUNT(*) NOREG
              INTO nMtoMovCuentaLocal,
                   nMtoMovCuentaMoneda,
                   nNumReg      
              FROM DETALLE_TABLERO_CONTROL_DER T
             WHERE T.CODCIA     = nCodCia
               AND T.IDPROC     = nIdProc
               AND T.STSGRUPO   IN ('XPROC', 'PROCSR', 'DERIVA');
        EXCEPTION WHEN OTHERS THEN
            NULL;
        END;             

        UPDATE TABLERO_CONTROL_DERIVA C 
           SET MontoDerivaLocal  = nMtoMovCuentaLocal,
               MontoDerivaMoneda = nMtoMovCuentaMoneda,
               CANTIDAD = nNumReg,
               C.STSPROCESO = DECODE(nIncompl, 2, 'ERRDER', C.STSPROCESO ),
               C.ERROR = DECODE(nIncompl, 2, 'NO RECIBIO COMPLETO EL LOTE en MIZAR', C.ERROR )
         WHERE CodCia = nCodCia
           AND IdProc = nIdProc;
           --
    END ACTUALIZA_VALORES;
    --
    PROCEDURE EJECUTA_PROCESO_WS_DERIVA(nCodCia          NUMBER      := 1,
                                        pNEsManual       NUMBER      := 1,               -- si es = 1 es automatico, diferente a 1 es manual
                                        pCTipoComprob    VARCHAR2    := NULL,            -- pCTipoComprob si es manual se reuiere el tipo de comprobante a ejecutar
                                        pDFecha          DATE        := TRUNC(SYSDATE-1)-- pDFecha si es automatico o manual, se requiere la fecha a procesar
                                       ) IS   
        --Ejemplo:        
        /*
        BEGIN
            EJECUTA_PROCESO_WS_DERIVA(1,0,'121',TO_DATE('03/11/2018','DD/MM/RRRR'));
        END;                         
        */                    

       cDirectorio             VARCHAR2(10)  := OC_GENERALES.BUSCA_PARAMETRO(1,'044');
       cEmailAuth              VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
       cPwdEmail               VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
       cEmailEnvio             VARCHAR2(100) := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
       cEmailTo                VARCHAR2(1000);
       cEmailCC                VARCHAR2(1000);
       cSubject                VARCHAR2(150);
       cMessage                VARCHAR2(32767);
       cFileAtt                VARCHAR2(50)  := null;
       cError                  VARCHAR2(3000);
       cGlobal_Name            VARCHAR2(30);
       nIdProc                 NUMBER;

        PROCEDURE EJECUTA_NORMAL (nEsManual IN Number := 1, pCTipoComprob IN VARCHAR2 := NULL, pDFecha IN DATE := TRUNC(SYSDATE-1)) IS
            --nEsManual = 1 es automatico, diferente a 1 es manual
            --pCTipoComprob si es manual se reuiere el tipo de comprobante a ejecutar
            --pDFecha si es automatico o manual, se requiere la fecha a procesar
            cLin                 VARCHAR2(32767);
            cResultado           VARCHAR2(32767);
            xMessage             VARCHAR2(32767);
            nCont                NUMBER := 0;

        begin         
            xMessage := cMessage; 
            FOR ENT IN (SELECT *
                         FROM (SELECT 
                               CC.TipoComprob           cTipoComprob,
                               CC.TipoDiario            cTipoDiario,
                               'DERIVACION AUTOMATICA'  cConcepto,
                               CodMoneda                cCodMoneda,
                               TRUNC(CC.FecComprob)     dFecha,
                               count(*)                 nCantidad,       
                               sum(CD.MTOMOVCUENTA)     cMtoMovCuenta
                          FROM COMPROBANTES_CONTABLES CC INNER JOIN COMPROBANTES_DETALLE CD ON CD.CodCia             = CC.CodCia
                                                                                           AND CD.NumComprob         = CC.NumComprob
                                                                                           AND CC.StsComprob         = 'CUA'
                                                                                           AND CC.NumComprobSC      IS NULL
                         WHERE CC.CODCIA = nCodCia  
                               AND TRUNC(CC.FecComprob) = pDFecha 
                               AND NOT EXISTS (SELECT DT.NUMCOMPROB 
                                                 FROM DETALLE_TABLERO_COMPROB DT  INNER JOIN TABLERO_CONTROL_DERIVA DC ON DT.CODCIA = DC.CODCIA 
                                                                                    AND DT.IDPROC = DC.IDPROC 
                                                                                    AND DC.STSPROCESO NOT IN ('ERRDER','DERREV') 
                                                WHERE DT.CODCIA = CC.CodCia AND  DT.NUMCOMPROB = CC.NUMCOMPROB
                                                AND NOT EXISTS (SELECT 1 
                                                                  FROM DETALLE_TABLERO_CONTROL_DER D
                                                                 WHERE D.CODCIA = DT.CODCIA 
                                                                   AND D.IDPROC = DT.IDPROC 
                                                                   AND D.STSGRUPO = 'PROCSR'))
                            GROUP BY CC.CodCia,
                               CC.TipoComprob,
                               CC.TipoDiario,
                               CC.TipoDiario,
                               CodMoneda,
                               TRUNC(CC.FecComprob) 
                            order by TRUNC(CC.FecComprob), TipoComprob)
                    WHERE (case when nEsManual = 1 then case when GT_DERIVACION_AUTO_CONFIG.AUTOMATICO(nCodCia, 'CONTAB', cTipoComprob ) = 'S' then 1 else 0 end else 1 end = 1) 
                    and (nEsManual = 1 OR cTipoComprob = DECODE(nEsManual, 1, cTipoComprob, pCTipoComprob))) LOOP

                BEGIN
                    cError := NULL;
                    nCont := nCont + 1;
                    BEGIN
                        nIdProc := GT_TABLERO_CONTROL_DERIVA.NUMERO_PROCESO(nCodCia);
                        GT_TABLERO_CONTROL_DERIVA.INSERTAR(nCodCia, nIdProc, ENT.dFecha, 'N', NULL, 'N', NULL, ENT.nCantidad , 'N', SYSDATE, null, ENT.cMtoMovCuenta, to_char(ENT.dFecha, 'YYYYMMDD') || TRIM(to_char(nIdProc, '0000')));            
                    EXCEPTION WHEN OTHERS THEN
                        BEGIN
                            nIdProc := GT_TABLERO_CONTROL_DERIVA.NUMERO_PROCESO(nCodCia);
                            GT_TABLERO_CONTROL_DERIVA.INSERTAR(nCodCia, nIdProc, ENT.dFecha, 'N', NULL, 'N', NULL, ENT.nCantidad , 'N', SYSDATE, null, ENT.cMtoMovCuenta, to_char(ENT.dFecha, 'YYYYMMDD') || TRIM(to_char(nIdProc, '0000')));                                
                        EXCEPTION WHEN OTHERS THEN
                            raise_application_error(-20010,'GT_TABLERO_CONTROL_DERIVA.INSERTAR: ' || SQLERRM);
                        END;
                    END;
                    --
                    DBMS_OUTPUT.PUT_LINE('nIdProc: '|| nIdProc);
                    cLin := GT_WEB_SERVICES.Ejecuta_WS(1,1,1000, -1000, cResultado,':nCodCia='     || nCodCia      || 
                                                                                   ',:cTipo_tran='  || ENT.cTipoDiario  ||
                                                                                   ',:dFecDesde='   || TO_CHAR(ENT.dFecha, 'DD/MM/YYYY')       ||
                                                                                   ',:dFecHasta='   || TO_CHAR(ENT.dFecha, 'DD/MM/YYYY')        ||
                                                                                   ',:cTipoComprob='|| ENT.cTipoComprob ||
                                                                                   ',:cCodMoneda='  || ENT.cCodMoneda   ||
                                                                                   ',:cTipoDiario=' || ENT.cTipoDiario  ||
                                                                                   ',:cConcepto='   || ENT.cConcepto    ||
                                                                                   ',:nDiario='     || ENT.nCantidad    || 
                                                                                   ',:cFuente='     || nIdProc          ||
                                                                                   ',:cStsComprob=' || 'CUA'
                                                      ).getClobVal;
                    GT_TABLERO_CONTROL_DERIVA.ACTUALIZA_VALORES(nCodCia, nIdProc);   
                    GT_TABLERO_CONTROL_DERIVA.ENVIA_PROCESO_MIZAR;            
                EXCEPTION WHEN OTHERS THEN
                    CASE SQLCODE 
                        WHEN -31011 THEN
                            cError := 'El servidor del servicio solicitado, no estan activo o se traslado a otra dirección.';
                        WHEN -29273 THEN
                            cError := 'El servidor local, no tiene los permisos necesarios para conectarse al servidor de servicios solicitado. Contacte a su administrador de sistemas.';
                        ELSE
                            cError := sqlerrm;
                    END CASE;
                    GT_TABLERO_CONTROL_DERIVA.MARCAR_ERRORES(nCodCia, nIdProc, cError);           
                END;            
                --
                GT_TABLERO_CONTROL_DERIVA.RECIBE_RESULTADO_MIZAR(cMessage);
                --
                IF pNEsManual = 1 THEN  --SOLO AUTOMATICO
                    BEGIN
                       GT_DERIVACION_AUTO_CONFIG.ENVIAR_CORREOS(nCodCia,'CONTAB', ENT.cTipoComprob, cEmailTo, cEmailCC);            
                       cDirectorio             := OC_GENERALES.BUSCA_PARAMETRO(1,'044');
                       cEmailAuth              := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'021');
                       cPwdEmail               := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');--OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'022');
                       cEmailEnvio             := OC_GENERALES.BUSCA_PARAMETRO(nCodCia,'042');
                       OC_MAIL.INIT_PARAM;
                       OC_MAIL.cCtaEnvio   := cEmailAuth;
                       OC_MAIL.cPwdCtaEnvio:= cPwdEmail;
                       cMessage := cMessage || '</br>';              
                       OC_MAIL.SEND_EMAIL(cDirectorio, cEmailEnvio,TRIM(cEmailTo), TRIM(cEmailCC),NULL, cGlobal_Name || '//' || cSubject || ' ' || ENT.cTipoDiario || '-' || ENT.cTipoComprob, cMessage, cFileAtt,NULL,NULL,NULL,cError);
                    EXCEPTION WHEN OTHERS THEN                        
                        NULL;
                    END;
                    cMessage := xMessage;
                END IF;
            END LOOP;
            --       
            IF nCont = 0 THEN                                
                DBMS_OUTPUT.PUT_LINE('No existen registros en la selección.');
            END IF;                         
        END EJECUTA_NORMAL;    
        --

    BEGIN
        SELECT Global_Name 
          INTO cGlobal_Name  
         FROM Global_Name;     
        IF pNEsManual = 1 then  --AUTOMATICO
           cSubject := 'Proceso automatizado del WS de la derivación contable:';
           cMessage := 'Se ha ejecutado el proceso automático de la derivación para el proceso de Servicio Web';
        ELSE                    --MANUAL
           cSubject := 'Proceso manual del WS de la derivación contable ('|| user ||')';
           cMessage := 'Se ha ejecutado el proceso MANUAL de la derivación para el proceso del Servicio Web';
        END IF;
        EJECUTA_NORMAL(pNEsManual, pCTipoComprob, pDFecha);
        --    
    END EJECUTA_PROCESO_WS_DERIVA;
    --
    PROCEDURE ENVIA_PROCESO_MIZAR IS
        cLin        VARCHAR2(32767);
        xMLResult        XMLTYPE;
        cResultado   VARCHAR2(32767);
    begin 

        FOR ENT IN (SELECT CODCIA, IDPROC
          FROM TABLERO_CONTROL_DERIVA T
         WHERE DERIVADO = 'N'
           AND STSPROCESO = 'XPROC') LOOP

            xMLResult := GT_WEB_SERVICES.Ejecuta_WS(ENT.CODCIA, 1, 1010, -1010, cResultado, ':cFuente=' || ENT.IDPROC);
            cLin := GT_WEB_SERVICES.ExtraeDatos_XML(xMLResult, 'Procesar_polizas_bseResult');
            --
            IF UPPER(cLin) = 'TRUE' THEN
                GT_TABLERO_CONTROL_DERIVA.MARCAR_PROCESADO(ENT.CODCIA, ENT.IDPROC);
                GT_DETALLE_TABLERO_CONTROL_DER.MARCAR_PROCESADO(ENT.CODCIA, ENT.IDPROC);                
            END IF;                       
        END LOOP;
    END ENVIA_PROCESO_MIZAR;    

    --EJEFCUTA LECTURA DEL WS
    PROCEDURE RECIBE_RESULTADO_MIZAR(cMessage IN OUT VARCHAR2) IS
        xMLResult       XMLTYPE;
        cResultado      CLOB;
        cErrores        VARCHAR2(1000);
        cLinea          VARCHAR2(32767);    
    begin 
        FOR ENT IN (SELECT CODCIA nCodCia, IDPROC nIdProc, FECHPROC
                      FROM TABLERO_CONTROL_DERIVA T
                     WHERE DERIVADO = 'N'
                       AND STSPROCESO in ('XPROC', 'PROCSR')) LOOP              
            BEGIN              
                xMLResult := GT_WEB_SERVICES.Ejecuta_WS(ENT.nCodCia, 1, 1020, -1020, cResultado, ':nCodCia=' || ENT.nCodCia || ',:cFuente=' || ENT.nIdProc);
                GT_TABLERO_CONTROL_DERIVA.ACTUALIZA_VALORES(ENT.nCodCia, ENT.nIdProc);
            EXCEPTION WHEN OTHERS THEN
                cErrores := substr(to_char(SQLERRM), 1000);
                GT_TABLERO_CONTROL_DERIVA.MARCAR_ERRORES(ENT.nCodCia, ENT.nIdProc, cErrores);                                 
            END;
            cLinea := cLinea || trunc(ENT.FECHPROC) || chr(10);                        
        END LOOP;        
        cMessage := cMessage || ' -- La derivación se efectuó con la fecha deL: ' || NVL(cLinea, ' No hay comprobantes contables con la fecha solicitada');        
    END RECIBE_RESULTADO_MIZAR;
    --
    PROCEDURE CANCELAR (nCodCia IN NUMBER, nIdProc IN NUMBER) IS
    BEGIN
      UPDATE TABLERO_CONTROL_DERIVA
           SET StsProceso   = 'DERREV',
               CodUsuario   = USER,
               FecUltModif  = TRUNC(SYSDATE)
         WHERE CodCia   = nCodCia
           AND IdProc   = nIdProc;
    END;                
    --
END GT_TABLERO_CONTROL_DERIVA;
