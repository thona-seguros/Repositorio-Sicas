--
-- ADMONEVALUARFONDOS  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   VALORES_DE_LISTAS (Table)
--   OC_ADMON_ACTIVI_FONDOS (Package)
--   OC_ADMON_ACTIVI_FONDOS_H (Package)
--   OC_ADMON_RIESGO (Package)
--   PLAN_DE_PAGOS (Table)
--   POLIZAS (Table)
--   FAI_CONCENTRADORA_FONDO (Table)
--   FAI_CONF_MOVIMIENTOS_FONDO (Table)
--   CONTROL_PROCESOS_AUTOMATICOS (Table)
--   PERSONA_NATURAL_JURIDICA (Table)
--   CLIENTES (Table)
--   CLIENTE_ASEG (Table)
--   TASAS_CAMBIO (Table)
--   DETALLE_POLIZA (Table)
--   TIPOS_DE_SEGUROS (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.ADMONEVALUARFONDOS  IS

cIdtiposeg            TIPOS_DE_SEGUROS.idtiposeg%TYPE;
cTipo_riesgo          TIPOS_DE_SEGUROS.tipo_riesgo%TYPE;
nCodCia               POLIZAS.CODCIA%TYPE;
nCodcliente           CLIENTES.CODCLIENTE%TYPE;
cTipoCliente          CLIENTES.TIPOCLIENTE%TYPE;
cTipoDocIdent         CLIENTES.TIPO_DOC_IDENTIFICACION%TYPE;
cNumDocIdent          CLIENTES.NUM_DOC_IDENTIFICACION%TYPE;
nCodEmpresa           POLIZAS.CODEMPRESA%TYPE;
cCodMoneda            POLIZAS.cod_moneda%TYPE;
nIdpoliza             POLIZAS.idpoliza%TYPE;
nIdetpol              DETALLE_POLIZA.idetpol%TYPE;
nCod_asegurado        DETALLE_POLIZA.cod_Asegurado%TYPE;
dFecMovimiento        FAI_CONCENTRADORA_FONDO.FECMOVIMIENTO%TYPE;
dFecIniVig            POLIZAS.FECINIVIG%TYPE;
dFecFinVig            POLIZAS.FECFINVIG%TYPE;
dFechaEval1           POLIZAS.FECINIVIG%TYPE;
dFechaEval2           POLIZAS.FECFINVIG%TYPE;
dFecha1               POLIZAS.FECFINVIG%TYPE;
dFecha2               POLIZAS.FECFINVIG%TYPE;
cCodPlanPago          DETALLE_POLIZA.CODPLANPAGO%TYPE;
nNumPagos             PLAN_DE_PAGOS.NUMPAGOS%TYPE;
cNombreAsegurado      PERSONA_NATURAL_JURIDICA.NOMBRE%TYPE;
nErroresdetectados    NUMBER;
nMeses                NUMBER;
nMesesCiclo           NUMBER;
nAportaCrit           NUMBER;
nAportaCritOK         NUMBER;
nAportaPlan           NUMBER;
nAportaReal           NUMBER;
nImportePlan          NUMBER(18,2);
nImporteReal          NUMBER(18,2);
nImporteCrit          NUMBER(18,2);
nImporteCritOK        NUMBER(18,2);
nImporteAcumulado     NUMBER(18,2);
nImporteMaximo        NUMBER(18,2);
nImporteMes           NUMBER(18,2);
nTasaCambio           NUMBER(18,2);
nNumRetiros           NUMBER;
nNumRetirosReal       NUMBER;
nNumRetirosOK         NUMBER;
cObservaciones        VARCHAR2(500);
cResulEvalua          VARCHAR2(500);
SW_FIN                NUMBER;
SW_SPV                NUMBER;


CURSOR EVALUAR IS 

SELECT DISTINCT ts.idtiposeg, ts.tipo_riesgo, fcf.codcia, fcf.codempresa, fcf.idpoliza, 
                fcf.idetpol, dp.cod_asegurado, TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
             DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada), fcf.fecmovimiento, p.fecinivig, p.fecfinvig,
                p.cod_moneda, dp.codplanpago, pp.numpagos 
FROM fai_concentradora_fondo fcf
     , polizas p
     , detalle_poliza dp
     , tipos_de_seguros ts
     , plan_de_pagos pp
     , cliente_aseg ca
     , clientes c
     ,persona_natural_juridica pnj     
WHERE fcf.idpoliza           = p.idpoliza
AND fcf.codcptomov           IN( 'APOADI','RETPAR')
AND p.stspoliza              = 'EMI'
AND (TRUNC(SYSDATE) = (SELECT ADD_MONTHS(TRUNC(P.FECINIVIG),nMeses) FROM DUAL)
   OR TRUNC(SYSDATE )     = (SELECT ADD_MONTHS(TRUNC(P.FECINIVIG),12) FROM DUAL))
--AND (TRUNC(SYSDATE - 11)      = (SELECT ADD_MONTHS(TRUNC(P.FECINIVIG),4) FROM DUAL)
--   OR TRUNC(SYSDATE - 11)     = (SELECT ADD_MONTHS(TRUNC(P.FECINIVIG),12) FROM DUAL))
AND dp.idpoliza              = p.idpoliza
AND dp.idetpol               = (SELECT min(dpo.idetpol)
                                  FROM detalle_poliza dpo
                                 WHERE dpo.idpoliza = dp.idpoliza)
AND ts.idtiposeg             = dp.idtiposeg                   
AND ts.codempresa            = fcf.codempresa
AND ts.codcia                = fcf.codcia
AND (ts.tipo_riesgo          = 'ALTO' OR ts.tipo_riesgo IS NULL)
AND ts.ststipseg             = 'ACT'   
AND pp.codplanpago           = dp.codplanpago
AND ca.cod_asegurado         = dp.cod_asegurado
AND c.codcliente             = ca.codcliente
AND pnj.tipo_doc_identificacion = c.tipo_doc_identificacion
AND pnj.num_doc_identificacion = c.num_doc_identificacion
GROUP BY ts.idtiposeg, ts.tipo_riesgo, fcf.codcia, fcf.codempresa, fcf.idpoliza, fcf.idetpol, dp.cod_asegurado, 
TRIM(PNJ.Nombre) ||' ' || TRIM(PNJ.Apellido_Paterno) || ' ' || TRIM(PNJ.Apellido_Materno) || ' ' || 
             DECODE(PNJ.ApeCasada,NULL,'', ' de ' ||PNJ.ApeCasada),
       fcf.fecmovimiento,  p.fecinivig,p.fecfinvig, p.cod_moneda, p.stspoliza,  dp.codplanpago, pp.numpagos          
ORDER BY IDTIPOSEG, TIPO_RIESGO,CODCIA,CODEMPRESA, IDPOLIZA, IDETPOL   
;
----
PROCEDURE CAMBIA_NIVEL_CLIENTE(pcCodcia NUMBER, pcCodempresa NUMBER, pcIdpoliza NUMBER, pcCod_asegurado VARCHAR2, pcResultadoEval VARCHAR2) is
----
BEGIN
  SELECT CODCLIENTE
    INTO nCodcliente
    FROM CLIENTE_ASEG
   WHERE COD_ASEGURADO    = pcCod_asegurado;
   
   SELECT TIPOCLIENTE, TIPO_DOC_IDENTIFICACION, NUM_DOC_IDENTIFICACION
     INTO cTipoCliente, cTipoDocIdent, cNumDocIdent
     FROM CLIENTES
    WHERE CODCLIENTE      = nCodcliente;
    
   IF cTipoCliente != 'ALTO' THEN
      UPDATE CLIENTES
         SET TIPOCLIENTE  = 'ALTO'
       WHERE CODCLIENTE   = nCodcliente;
      
      COMMIT;

      OC_ADMON_RIESGO.INSERTA(pcCodcia,
                           pcCodempresa,
                           1,
                           pcIdpoliza,
                           0,
                           pcCod_asegurado,
                           'AEI',               --EVALUACION AHORRO E INVERSION
                           NULL,                --W_ST_RESOLUCION,
                           cTipoDocIdent,       --P_TIPO_DOC_IDENTIFICACION,
                           cNumDocIdent,        --P_NUM_DOC_IDENTIFICACION,
                           NULL,                --W_TP_RESOLUCION,
                           pcResultadoEval      --W_cObservaciones
                            );
      COMMIT;
      
   END IF;
         
END CAMBIA_NIVEL_CLIENTE;
----     
PROCEDURE INSERTA_ADMON_ACTIVI_FONDOS_H(phCodcia NUMBER, phCodempresa NUMBER,phIdtiposeg VARCHAR2, phIdpoliza NUMBER, 
                phIdetpol NUMBER, phNumsecuencia NUMBER, phCod_asegurado NUMBER, phNombreAsegurado varchar2, phcCodPlanPago VARCHAR2, 
                phNumAportaPlan NUMBER, phNumAportaCritOK NUMBER, phNumAportaReal NUMBER,phImportePlanAporte NUMBER, 
                phImporteAporCritOK NUMBER, phImporteAcumApor NUMBER, phNumRetirosCritOK NUMBER, phNumRetirosReal NUMBER , 
                phResultadoEval VARCHAR2, phstatusrev VARCHAR2, phobservaciones VARCHAR2, phfecharevision DATE, 
                phusuariorevisa VARCHAR2) IS
----
   BEGIN
     OC_ADMON_ACTIVI_FONDOS_H.INSERTA(phCodcia,
		  phCodempresa,
		  phIdtiposeg,
		  phIdpoliza,
		  phIdetpol,
      phNumsecuencia,
		  phCod_asegurado,
      phNombreAsegurado,		
		  phcCodPlanPago,
		  SYSDATE,
		  phNumAportaPlan,	
		  phNumAportaCritOK,
		  phNumAportaReal,
		  phImportePlanAporte,
		  phImporteAporCritOK,
		  phImporteAcumApor,
		  phNumRetirosCritOK,
		  phNumRetirosReal,
		  phResultadoEval,
		  phstatusrev,
		  phobservaciones,
		  phfecharevision,
		  phusuariorevisa	                  
                 );   

END INSERTA_ADMON_ACTIVI_FONDOS_H;

----
PROCEDURE INSERTA_ADMON_ACTIVI_FONDOS(pCodcia NUMBER, pCodempresa NUMBER,pIdtiposeg VARCHAR2, pIdpoliza NUMBER, 
                pIdetpol NUMBER, pNumsecuencia NUMBER, pCod_asegurado NUMBER, pNombreAsegurado varchar2, pcCodPlanPago VARCHAR2, 
                pNumAportaPlan NUMBER, pNumAportaCritOK NUMBER, pNumAportaReal NUMBER,pImportePlanAporte NUMBER,
                pImporteAporCritOK NUMBER, pImporteAcumApor NUMBER, pNumRetirosCritOK NUMBER, pNumRetirosReal NUMBER , 
                pResultadoEval VARCHAR2) IS
    begin
----
     OC_ADMON_ACTIVI_FONDOS.INSERTA(pCodcia,
		  pCodempresa,
		  pIdtiposeg,
		  pIdpoliza,
      pIdetpol,
		  pNumsecuencia,
		  pCod_asegurado,
      pNombreAsegurado,	
		  pcCodPlanPago,
		  SYSDATE,
		  pNumAportaPlan,	
		  pNumAportaCritOK,
		  pNumAportaReal,
		  pImportePlanAporte,
		  pImporteAporCritOK,
		  pImporteAcumApor,
		  pNumRetirosCritOK,
		  pNumRetirosReal,
		  pResultadoEval,
		  'PEND',
		  NULL,
		  SYSDATE,
		  'SICAS');	        
----                 
      CAMBIA_NIVEL_CLIENTE(pCodcia, pCodempresa, pIdpoliza, pCod_asegurado, pResultadoEval);
    
END INSERTA_ADMON_ACTIVI_FONDOS;
----   

PROCEDURE EVALUA_POLIZA(pcIdtiposeg VARCHAR2, pnCodcia NUMBER, pnCodempresa NUMBER, pnIdpoliza NUMBER, 
                pnIdetpol NUMBER, pnCod_asegurado NUMBER, pcNombreAsegurado varchar2, pdFecMovimiento DATE, 
                pdFecIniVig DATE, pdFecFinVig date, pcCodMoneda VARCHAR2, pcCodPlanPago VARCHAR2, pnNumPagos NUMBER, pnMeses NUMBER) IS
BEGIN
    SELECT ROUND((pnNumPagos/ 2)) 
      INTO nAportaPlan
      FROM DUAL;

/*    SELECT ROUND((pnMeses/pnNumPagos)*pnMeses) 
      INTO nAportaPlan
      FROM DUAL;   */         
 
      SELECT DESCVALLST
        INTO nAportaCrit
        FROM valores_de_listas
       WHERE codlista = 'EVAPRODFON'
         AND CODVALOR = 'NACROK';
                    
    nErroresdetectados := 0;  
    
    nAportaCritOK      := nAportaPlan + nAportaCrit;  
    
    SELECT ADD_MONTHS(TRUNC(pdFecIniVig),nMeses) , ADD_MONTHS(TRUNC(pdFecIniVig),12) 
      INTO dFechaEval1, dFechaEval2
      FROM DUAL;

      SELECT DESCVALLST
        INTO nNumRetirosOK
        FROM valores_de_listas
       WHERE codlista = 'EVAPRODFON'
         AND CODVALOR = 'RECROK';
         
--    nNumRetirosOK       := 3;
    
    DBMS_OUTPUT.put_line('nAportaPlan ' || nAportaPlan || ' nAportaCritOK ' || nAportaCritOK || 
    ' dFechaEval1 '|| dFechaEval1 || ' dFechaEval2 ' || dFechaEval1 );     
        
    IF TRUNC(SYSDATE) < TRUNC(dFechaEval2) THEN    ---- PRIMER PERIODO    
       DBMS_OUTPUT.put_line('ENTRE POR PERIODO 1'); 
       SELECT COUNT(1), SUM(MONTOMOVLOCAL)
         INTO nAportaReal, nImporteAcumulado
         FROM FAI_CONCENTRADORA_FONDO
        WHERE CODCIA       = pnCodcia
          AND CODEMPRESA   = pnCodempresa
          AND IDPOLIZA     = pnIdpoliza
          AND CODCPTOMOV   = 'APOADI'
          AND FECMOVIMIENTO BETWEEN TRUNC(pdFecIniVig) AND TRUNC(dFechaEval1);
       -----   
       SELECT COUNT(1)
         INTO nNumRetirosReal
         FROM FAI_CONCENTRADORA_FONDO
        WHERE CODCIA = pnCodcia
          AND CODEMPRESA   = pnCodempresa
          AND IDPOLIZA     = pnIdpoliza
          AND CODCPTOMOV   = 'RETPAR'
          AND FECMOVIMIENTO BETWEEN TRUNC(pdFecIniVig) AND TRUNC(dFechaEval1);      
      ----        
    ELSE                                               ----- SEGUNDO PERIODO
       DBMS_OUTPUT.put_line('ENTRE POR PERIODO 2');
      ----
       SELECT COUNT(1), NVL(SUM(MONTOMOVLOCAL),0)
         INTO nAportaReal, nImporteAcumulado
         FROM FAI_CONCENTRADORA_FONDO
        WHERE CODCIA       = pnCodcia
          AND CODEMPRESA   = pnCodempresa
          AND IDPOLIZA     = pnIdpoliza
          AND CODCPTOMOV   = 'APOADI'
          AND FECMOVIMIENTO BETWEEN TRUNC(dFechaEval1) AND TRUNC(dFechaEval2);
       ----   
       SELECT COUNT(1)
         INTO nNumRetirosReal
         FROM FAI_CONCENTRADORA_FONDO
        WHERE CODCIA = pnCodcia
          AND CODEMPRESA   = pnCodempresa
          AND IDPOLIZA     = pnIdpoliza
          AND CODCPTOMOV   = 'RETPAR'
          AND FECMOVIMIENTO BETWEEN TRUNC(dFechaEval1) AND TRUNC(dFechaEval2);
          
    END IF;               
       DBMS_OUTPUT.put_line('nAportaReal '||nAportaReal||' nImporteAcumulado '||nImporteAcumulado||' nNumRetirosReal '||nNumRetirosReal);
    SELECT CANTTRANSAC, MTOMAXIMO
      INTO nAportaPlan, nImportePlan
      FROM Fai_Conf_Movimientos_Fondo A
     WHERE A.CODCPTOMOV         = 'APOADI'
       AND A.STSMOVFONDO        = 'ACTIVO'
       AND A.FECHAULTREGISTRO  <= (SELECT MAX(B.FECHAULTREGISTRO)
                                     FROM Fai_Conf_Movimientos_Fondo B
                                    WHERE B.CODCPTOMOV         = A.CODCPTOMOV
                                      AND B.STSMOVFONDO        = A.STSMOVFONDO
                                      AND B.FECHAULTREGISTRO  <= TRUNC(SYSDATE));  
  
      SELECT DESCVALLST
        INTO nImporteCrit
        FROM valores_de_listas
       WHERE codlista = 'EVAPRODFON'
         AND CODVALOR = 'IACROK';                                    
                                          
    nImporteCritOK := nImportePlan * nImporteCrit;     --1.5;
                                       
    SELECT CANTTRANSAC
      INTO nNumRetiros
      FROM Fai_Conf_Movimientos_Fondo A
     WHERE A.CODCPTOMOV = 'RETPAR'
       AND A.STSMOVFONDO = 'ACTIVO'
       AND A.FECHAULTREGISTRO  <= (SELECT MAX(B.FECHAULTREGISTRO)
                                     FROM Fai_Conf_Movimientos_Fondo B
                                    WHERE B.CODCPTOMOV = A.CODCPTOMOV
                                      AND B.STSMOVFONDO = A.STSMOVFONDO
                                      AND B.FECHAULTREGISTRO  <= TRUNC(SYSDATE));   
         DBMS_OUTPUT.put_line('nAportaPlan '||nAportaPlan||' nImportePlan '||nImportePlan||' nImporteCritOK '||nImporteCritOK);                                    
    SELECT a.tasa_cambio 
      INTO nTasaCambio
      FROM tasas_cambio a
     WHERE a.cod_moneda        = 'USD'
       AND a.fecha_hora_cambio = (SELECT max(b.fecha_hora_cambio)
                                    FROM tasas_cambio b
                                   WHERE b.cod_moneda         = a.cod_moneda
                                     AND b.fecha_hora_cambio <= trunc(SYSDATE));
    
    IF pcCodMoneda = 'USD' THEN
       nImporteMaximo := 10000;
    ELSE                                 
       nImporteMaximo := 10000 * nTasaCambio; 
    END IF;    
         DBMS_OUTPUT.put_line('nImporteMaximo '||nImporteMaximo||' nTasaCambio '||nTasaCambio);   
    IF nAportaReal > nAportaCritOK THEN
--    IF 9 > nAportaCritOK THEN    
       nErroresdetectados := nErroresdetectados + 1;
       cResulEvalua       := 'COMPORTAMIENTO INUSUAL EN NUMERO DE APORTACIONES';  
       INSERTA_ADMON_ACTIVI_FONDOS(pnCodcia, pnCodempresa, pcIdtiposeg, pnIdpoliza, 
                pnIdetpol,nErroresdetectados, pnCod_asegurado,pcNombreAsegurado, pcCodPlanPago,
                nAportaPlan, nAportaCritOK, nAportaReal,nImportePlan, nImporteCritOK, nImporteAcumulado,
                nNumRetirosOK, nNumRetirosReal , cResulEvalua);
---
    END IF;                          
       
    IF nImporteAcumulado > nImporteCritOK THEN
--    IF 1550000 > nImporteCritOK THEN    
       nErroresdetectados := nErroresdetectados + 1;
       cResulEvalua       := 'COMPORTAMIENTO INUSUAL EN IMPORTE ACUMULADO DE APORTACIONES';  
       INSERTA_ADMON_ACTIVI_FONDOS(pnCodcia, pnCodempresa, pcIdtiposeg, pnIdpoliza, 
                pnIdetpol,nErroresdetectados, pnCod_asegurado,pcNombreAsegurado, pcCodPlanPago,
                nAportaPlan, nAportaCritOK, nAportaReal,nImportePlan, nImporteCritOK, nImporteAcumulado,
                nNumRetirosOK, nNumRetirosReal , cResulEvalua);       
    END IF;
        
    IF nNumRetirosReal > nNumRetirosOK THEN
--    IF 5 > nNumRetirosOK THEN nNumRetirosReal := 5   ;
       nErroresdetectados := nErroresdetectados + 1;
       cResulEvalua       := 'COMPORTAMIENTO INUSUAL EN NUMERO DE RETIROS'; 
       INSERTA_ADMON_ACTIVI_FONDOS(pnCodcia, pnCodempresa, pcIdtiposeg, pnIdpoliza, 
                pnIdetpol,nErroresdetectados, pnCod_asegurado,pcNombreAsegurado, pcCodPlanPago,
                nAportaPlan, nAportaCritOK, nAportaReal,nImportePlan, nImporteCritOK, nImporteAcumulado,
                nNumRetirosOK, nNumRetirosReal , cResulEvalua);       
    END IF;
           
    DBMS_OUTPUT.put_line('EN EVALUA_POLIZA ' || nIdpoliza);
    
---- INICIA APORTACIONES POR MES CALENDARIO
    IF TRUNC(SYSDATE) < TRUNC(dFechaEval2) THEN    ---- PRIMER PERIODO 
       dFecha1 := trunc(pdFecIniVig);
    ELSE
      dFecha1  := trunc(dFechaEval1);
    END IF;

    SELECT ADD_MONTHS(TRUNC(dFecha1),1) 
      INTO dFecha2
      FROM DUAL;    

    nMesesCiclo := 0 ; 
    SW_FIN      := 0;
    SW_SPV      := 0;
    nImporteMes := 0;
    
    DBMS_OUTPUT.put_line('ANTES DE WHILE');    
    DBMS_OUTPUT.put_line('ANTES DE WHILE dFecha1 '||dFecha1||' dFecha2 ' ||dFecha2||' nImporteMes '||nImporteMes );
    WHILE SW_FIN = 0 LOOP
       IF SW_SPV = 0 THEN
          SELECT SUM(MONTOMOVLOCAL)
            INTO nImporteMes
            FROM FAI_CONCENTRADORA_FONDO
           WHERE CODCIA         = pnCodcia
             AND CODEMPRESA     = pnCodempresa
             AND IDPOLIZA       = pnIdpoliza
             AND CODCPTOMOV     = 'APOADI'
             AND FECMOVIMIENTO BETWEEN TRUNC(dFecha1) AND TRUNC(dFecha2);                               
          SW_SPV := 1;
       ELSE
          SELECT SUM(MONTOMOVLOCAL)
            INTO nImporteMes
            FROM FAI_CONCENTRADORA_FONDO
           WHERE CODCIA        = pnCodcia
             AND CODEMPRESA    = pnCodempresa
             AND IDPOLIZA      = pnIdpoliza
             AND CODCPTOMOV    = 'APOADI'
             AND FECMOVIMIENTO BETWEEN TRUNC(dFecha1) AND TRUNC(dFecha2);          
       END IF;
       dFecha1 := trunc(dFecha2);
       SELECT ADD_MONTHS(TRUNC(dFecha1),1) 
         INTO dFecha2
         FROM DUAL;      
       DBMS_OUTPUT.put_line('dFecha1 '||dFecha1||' dFecha2 ' ||dFecha2||' nImporteMes '||nImporteMes );             
       IF nImporteMes > nImporteMaximo THEN       
--         IF 1550000 > nImporteMaximo THEN
          cResulEvalua       := 'COMPORTAMIENTO INUSUAL EN IMPORTE MENSUAL DE APORTACIONES'; 
          nErroresdetectados := nErroresdetectados + 1;
          INSERTA_ADMON_ACTIVI_FONDOS(pnCodcia, pnCodempresa, pcIdtiposeg, pnIdpoliza, 
                pnIdetpol,nErroresdetectados, pnCod_asegurado,pcNombreAsegurado, pcCodPlanPago,
                nAportaPlan, nAportaCritOK, nAportaReal,nImportePlan, nImporteCritOK, nImporteAcumulado,
                nNumRetirosOK, nNumRetirosReal , cResulEvalua);
          SW_FIN := 1;       
       END IF;
       nMesesCiclo := nMesesCiclo + 1 ;
       IF nMesesCiclo >= 6 THEN
          SW_FIN := 1;
       END IF;
    END LOOP;
    DBMS_OUTPUT.put_line('DESPUES DE WHILE');    
    DBMS_OUTPUT.put_line('nErroresdetectados ' || nErroresdetectados);    
    IF nErroresdetectados = 0 THEN
       cResulEvalua       := 'NO SE DETECTO NINGUN COMPORTAMIENTO INUSUAL';
       cObservaciones     := 'NO REQUIERE REVISION POR PARTE DEL OFICIAL DE CUMPLIMIENTO';
       INSERTA_ADMON_ACTIVI_FONDOS_H(pnCodcia, pnCodempresa, pcIdtiposeg, pnIdpoliza, 
                pnIdetpol, nErroresdetectados,pnCod_asegurado,pcNombreAsegurado, pcCodPlanPago,  
                nAportaPlan, nAportaCritOK, nAportaReal,nImportePlan, nImporteCritOK, nImporteAcumulado,
                nNumRetirosOK, nNumRetirosReal , cResulEvalua, 'LIMP', cObservaciones, SYSDATE, 'SICAS' ) ;  
----      
    END IF;    
----    
END EVALUA_POLIZA;                
----     
----   EMPIEZA PROCEDURE          
BEGIN
       dbms_output.put_line('Empieza proceso de evaluación de fondos');
      SELECT DESCVALLST
        INTO nMeses
        FROM valores_de_listas
       WHERE codlista = 'EVAPRODFON'
         AND CODVALOR = 'MESES';
      
--      nMeses := nMeses - 2;   

    INSERT INTO control_procesos_automaticos (NOMBREPROCESO , FECHAEJECUCION)
            VALUES('ADMONEVALUARFONDOS',SYSDATE);
    COMMIT;      
             
      DBMS_OUTPUT.put_line('nMeses ' || nMeses);
      OPEN EVALUAR;
      LOOP
         FETCH EVALUAR INTO cIdtiposeg, cTipo_riesgo, nCodcia, nCodempresa, nIdpoliza, 
                nIdetpol, nCod_asegurado, cNombreAsegurado, dFecMovimiento, dFecIniVig, dFecFinVig,  
                cCodMoneda, cCodPlanPago, nNumPagos; 
         EXIT WHEN EVALUAR%NOTFOUND; 
         DBMS_OUTPUT.put_line('poliza ' || nIdpoliza);             
         EVALUA_POLIZA(cIdtiposeg, nCodcia, nCodempresa, nIdpoliza, 
                nIdetpol, nCod_asegurado, cNombreAsegurado, dFecMovimiento, dFecIniVig, dFecFinVig,
                cCodMoneda, cCodPlanPago, nNumPagos, nMeses);             
--        
      END LOOP;
      CLOSE EVALUAR;
      
END ADMONEVALUARFONDOS;
/

--
-- ADMONEVALUARFONDOS  (Synonym) 
--
--  Dependencies: 
--   ADMONEVALUARFONDOS (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM ADMONEVALUARFONDOS FOR SICAS_OC.ADMONEVALUARFONDOS
/


GRANT EXECUTE ON SICAS_OC.ADMONEVALUARFONDOS TO PUBLIC
/
