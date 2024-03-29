--
-- GT_DETALLE_TABLERO_CTRL_PAGO  (Package) 
--
--  Dependencies: 
--   STANDARD (Package)
--   STANDARD (Package)
--   DUAL (Synonym)
--   DBMS_STANDARD (Package)
--   DETALLE_TABLERO_CTRL_PAGO (Table)
--   DETALLE_TABLERO_CTRL_PAGO (Table)
--
CREATE OR REPLACE PACKAGE SICAS_OC.GT_DETALLE_TABLERO_CTRL_PAGO IS

 FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER, nIdProc IN NUMBER) RETURN NUMBER;

  PROCEDURE INSERTAR
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN OUT DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ,in_FOLIO_AGRUP     IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_AGRUP%TYPE
    ,in_AUXILIAR        IN DETALLE_TABLERO_CTRL_PAGO.AUXILIAR%TYPE
    ,in_NOMBRE          IN DETALLE_TABLERO_CTRL_PAGO.NOMBRE%TYPE
    ,in_FECHA           IN DETALLE_TABLERO_CTRL_PAGO.FECHA%TYPE
    ,in_MONEDA          IN DETALLE_TABLERO_CTRL_PAGO.MONEDA%TYPE
    ,in_TIPO_CAMBIO     IN DETALLE_TABLERO_CTRL_PAGO.TIPO_CAMBIO%TYPE
    ,in_TASA_IVA        IN DETALLE_TABLERO_CTRL_PAGO.TASA_IVA%TYPE
    ,in_SUB_TOTAL_MO    IN DETALLE_TABLERO_CTRL_PAGO.SUB_TOTAL_MO%TYPE
    ,in_IVA_MO          IN DETALLE_TABLERO_CTRL_PAGO.IVA_MO%TYPE
    ,in_TOTAL_MO        IN DETALLE_TABLERO_CTRL_PAGO.TOTAL_MO%TYPE
    ,in_TASA_RET_IVA    IN DETALLE_TABLERO_CTRL_PAGO.TASA_RET_IVA%TYPE
    ,in_IMP_RET_IVA     IN DETALLE_TABLERO_CTRL_PAGO.IMP_RET_IVA%TYPE
    ,in_TASA_RET_ISR    IN DETALLE_TABLERO_CTRL_PAGO.TASA_RET_ISR%TYPE
    ,in_IMP_RET_ISR     IN DETALLE_TABLERO_CTRL_PAGO.IMP_RET_ISR%TYPE
    ,in_CCS             IN DETALLE_TABLERO_CTRL_PAGO.CCS%TYPE
    ,in_UEN             IN DETALLE_TABLERO_CTRL_PAGO.UEN%TYPE
    ,in_PYS             IN DETALLE_TABLERO_CTRL_PAGO.PYS%TYPE
    ,in_CONCEPTO        IN DETALLE_TABLERO_CTRL_PAGO.CONCEPTO%TYPE
    ,in_REFERENCIA      IN DETALLE_TABLERO_CTRL_PAGO.REFERENCIA%TYPE
    ,in_GRUPO           IN DETALLE_TABLERO_CTRL_PAGO.GRUPO%TYPE
    ,in_FLUJO           IN DETALLE_TABLERO_CTRL_PAGO.FLUJO%TYPE
    ,in_FACTURA         IN DETALLE_TABLERO_CTRL_PAGO.FACTURA%TYPE
    ,in_ID_CTA_BANCO    IN DETALLE_TABLERO_CTRL_PAGO.ID_CTA_BANCO%TYPE
    ,in_CLABE           IN DETALLE_TABLERO_CTRL_PAGO.CLABE%TYPE
    ,in_PLAZA_CTA       IN DETALLE_TABLERO_CTRL_PAGO.PLAZA_CTA%TYPE
    ,in_TIPO_PAGO       IN DETALLE_TABLERO_CTRL_PAGO.TIPO_PAGO%TYPE
    ,in_FUENTE          IN DETALLE_TABLERO_CTRL_PAGO.FUENTE%TYPE
    ,in_FOLIO_SOLICITUD IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_SOLICITUD%TYPE
    ,in_ERROR           IN DETALLE_TABLERO_CTRL_PAGO.ERROR%TYPE
    ,in_COMENTARIO      IN DETALLE_TABLERO_CTRL_PAGO.COMENTARIO%TYPE
    );

  PROCEDURE ACTUALIZA_RESPUESTA
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ,in_FUENTE          IN DETALLE_TABLERO_CTRL_PAGO.FUENTE%TYPE
    ,in_FOLIO_SOLICITUD IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_SOLICITUD%TYPE
    ,in_REFERENCIA      IN DETALLE_TABLERO_CTRL_PAGO.REFERENCIA%TYPE
    ,in_ERROR           IN DETALLE_TABLERO_CTRL_PAGO.ERROR%TYPE
    ,in_COMENTARIO      IN DETALLE_TABLERO_CTRL_PAGO.COMENTARIO%TYPE
    );
    
  PROCEDURE ACTUALIZA_PAGO
  (      
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ,in_ESTATUS_MIZAR   IN DETALLE_TABLERO_CTRL_PAGO.ESTATUS_MIZAR%TYPE
    ,in_CUENTA_PAGO     IN DETALLE_TABLERO_CTRL_PAGO.CUENTA_PAGO%TYPE
    ,in_NUM_REFERENCIA  IN DETALLE_TABLERO_CTRL_PAGO.NUM_REFERENCIA%TYPE
    ,in_FECHA_PAGO      IN VARCHAR2   
  );
  
  PROCEDURE ELIMINA
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    );

END GT_DETALLE_TABLERO_CTRL_PAGO;
/

--
-- GT_DETALLE_TABLERO_CTRL_PAGO  (Package Body) 
--
--  Dependencies: 
--   GT_DETALLE_TABLERO_CTRL_PAGO (Package)
--
CREATE OR REPLACE PACKAGE BODY SICAS_OC.GT_DETALLE_TABLERO_CTRL_PAGO IS

    FUNCTION NUMERO_PROCESO(nCodCia IN NUMBER, nIdProc IN NUMBER) RETURN NUMBER IS
        nIdProcDet DETALLE_TABLERO_CTRL_PAGO.IdProcDet%TYPE;
    BEGIN
        SELECT NVL(MAX(IdProcDet),0) + 1
          INTO nIdProcDet
          FROM DETALLE_TABLERO_CTRL_PAGO
         WHERE CodCia = nCodCia
           AND IdProc = nIdProc;
        RETURN nIdProcDet;
    END NUMERO_PROCESO;


  PROCEDURE INSERTAR
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN OUT DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE    
    ,in_FOLIO_AGRUP     IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_AGRUP%TYPE
    ,in_AUXILIAR        IN DETALLE_TABLERO_CTRL_PAGO.AUXILIAR%TYPE
    ,in_NOMBRE          IN DETALLE_TABLERO_CTRL_PAGO.NOMBRE%TYPE
    ,in_FECHA           IN DETALLE_TABLERO_CTRL_PAGO.FECHA%TYPE
    ,in_MONEDA          IN DETALLE_TABLERO_CTRL_PAGO.MONEDA%TYPE
    ,in_TIPO_CAMBIO     IN DETALLE_TABLERO_CTRL_PAGO.TIPO_CAMBIO%TYPE
    ,in_TASA_IVA        IN DETALLE_TABLERO_CTRL_PAGO.TASA_IVA%TYPE
    ,in_SUB_TOTAL_MO    IN DETALLE_TABLERO_CTRL_PAGO.SUB_TOTAL_MO%TYPE
    ,in_IVA_MO          IN DETALLE_TABLERO_CTRL_PAGO.IVA_MO%TYPE
    ,in_TOTAL_MO        IN DETALLE_TABLERO_CTRL_PAGO.TOTAL_MO%TYPE
    ,in_TASA_RET_IVA    IN DETALLE_TABLERO_CTRL_PAGO.TASA_RET_IVA%TYPE
    ,in_IMP_RET_IVA     IN DETALLE_TABLERO_CTRL_PAGO.IMP_RET_IVA%TYPE
    ,in_TASA_RET_ISR    IN DETALLE_TABLERO_CTRL_PAGO.TASA_RET_ISR%TYPE
    ,in_IMP_RET_ISR     IN DETALLE_TABLERO_CTRL_PAGO.IMP_RET_ISR%TYPE
    ,in_CCS             IN DETALLE_TABLERO_CTRL_PAGO.CCS%TYPE
    ,in_UEN             IN DETALLE_TABLERO_CTRL_PAGO.UEN%TYPE
    ,in_PYS             IN DETALLE_TABLERO_CTRL_PAGO.PYS%TYPE
    ,in_CONCEPTO        IN DETALLE_TABLERO_CTRL_PAGO.CONCEPTO%TYPE
    ,in_REFERENCIA      IN DETALLE_TABLERO_CTRL_PAGO.REFERENCIA%TYPE
    ,in_GRUPO           IN DETALLE_TABLERO_CTRL_PAGO.GRUPO%TYPE
    ,in_FLUJO           IN DETALLE_TABLERO_CTRL_PAGO.FLUJO%TYPE
    ,in_FACTURA         IN DETALLE_TABLERO_CTRL_PAGO.FACTURA%TYPE
    ,in_ID_CTA_BANCO    IN DETALLE_TABLERO_CTRL_PAGO.ID_CTA_BANCO%TYPE
    ,in_CLABE           IN DETALLE_TABLERO_CTRL_PAGO.CLABE%TYPE
    ,in_PLAZA_CTA       IN DETALLE_TABLERO_CTRL_PAGO.PLAZA_CTA%TYPE
    ,in_TIPO_PAGO       IN DETALLE_TABLERO_CTRL_PAGO.TIPO_PAGO%TYPE
    ,in_FUENTE          IN DETALLE_TABLERO_CTRL_PAGO.FUENTE%TYPE
    ,in_FOLIO_SOLICITUD IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_SOLICITUD%TYPE
    ,in_ERROR           IN DETALLE_TABLERO_CTRL_PAGO.ERROR%TYPE
    ,in_COMENTARIO      IN DETALLE_TABLERO_CTRL_PAGO.COMENTARIO%TYPE
    ) IS
    nPos            NUMBER;
    cLinea          VARCHAR2(500);
    nCOD_AGENTE     NUMBER;
    nIDNOMINA       NUMBER;
    nIDPOLIZA       NUMBER;
    nIDSINIESTRO    NUMBER;
    nIDDETSIN       NUMBER;
    nNUM_APROBACION NUMBER;
    nCOD_ASEGURADO  NUMBER;
    cFONDEAR        DETALLE_TABLERO_CTRL_PAGO.FONDEAR%TYPE ;

  BEGIN
  
    in_IDPROCDET := NUMERO_PROCESO(in_CODCIA, in_IDPROC);    
    nPos := INSTR(UPPER(in_REFERENCIA), ':');

    SELECT trim(SUBSTR(UPPER(in_REFERENCIA), nPos+1, 100))
      INTO cLinea   
      FROM DUAL;    
               
    IF in_CONCEPTO = 'COM01' THEN
       nCOD_AGENTE  := SUBSTR(cLinea, 1, INSTR(cLinea, '.')-1);
       nIDNOMINA    := SUBSTR(cLinea, INSTR(cLinea, '.')+1, 100);
    ELSIF in_CONCEPTO = 'SINTS01' THEN
          nPos := 0;
          cFONDEAR := 'S';
          /* SE COMENTA POR LIBERACION DE SOLO COMISIONES 20190213
          FOR ENT IN (select COLUMN_VALUE from table(GT_WEB_SERVICES.split(cLinea, '.'))) LOOP
              nPos := nPos + 1;
              IF nPos = 1 THEN nIDPOLIZA      := ENT.COLUMN_VALUE; END IF;
              IF nPos = 2 THEN nIDSINIESTRO   := ENT.COLUMN_VALUE; END IF;
              IF nPos = 3 THEN nIDDETSIN      := ENT.COLUMN_VALUE; END IF;
              IF nPos = 4 THEN nNUM_APROBACION:= ENT.COLUMN_VALUE; END IF;
              IF nPos = 5 THEN nCOD_ASEGURADO := ENT.COLUMN_VALUE; END IF;                
          END LOOP;
          IF LENGTH(nCOD_ASEGURADO) > 1 THEN
             OC_APROBACION_ASEG.ACTUALIZA_IDLOTE_MIZAR(nIDPOLIZA, nIDSINIESTRO, nIDDETSIN, nNUM_APROBACION, nCOD_ASEGURADO, in_IDPROC, in_IDPROCDET);
          ELSE
             OC_APROBACIONES.ACTUALIZA_IDLOTE_MIZAR(nIDPOLIZA, nIDSINIESTRO, nIDDETSIN, nNUM_APROBACION, in_IDPROC, in_IDPROCDET);
          END IF;     
          */                  
    END IF; 
    
    
    INSERT INTO DETALLE_TABLERO_CTRL_PAGO
      (
       CODCIA
      ,IDPROC
      ,IDPROCDET
      ,COD_AGENTE  
      ,IDNOMINA    
      ,IDPOLIZA    
      ,IDSINIESTRO 
      ,IDDETSIN
      ,NUM_APROBACION
      ,COD_ASEGURADO
      ,FOLIO_AGRUP
      ,AUXILIAR
      ,NOMBRE
      ,FECHA
      ,MONEDA
      ,TIPO_CAMBIO
      ,TASA_IVA
      ,SUB_TOTAL_MO
      ,IVA_MO
      ,TOTAL_MO
      ,TASA_RET_IVA
      ,IMP_RET_IVA
      ,TASA_RET_ISR
      ,IMP_RET_ISR
      ,CCS
      ,UEN
      ,PYS
      ,CONCEPTO
      ,REFERENCIA
      ,GRUPO
      ,FLUJO
      ,FACTURA
      ,ID_CTA_BANCO
      ,CLABE
      ,PLAZA_CTA
      ,TIPO_PAGO
      ,FUENTE
      ,FOLIO_SOLICITUD
      ,ERROR
      ,COMENTARIO
      ,FONDEAR
      )
    VALUES
      (
       in_CODCIA
      ,in_IDPROC
      ,in_IDPROCDET
      ,nCOD_AGENTE  
      ,nIDNOMINA    
      ,nIDPOLIZA    
      ,nIDSINIESTRO       
      ,nIDDETSIN       
      ,nNUM_APROBACION 
      ,nCOD_ASEGURADO  
      ,SUBSTR(TO_CHAR(SYSDATE, 'YYYYMMDD') || '.' || in_IDPROC || '.' || in_IDPROCDET, 1, 32)
      ,in_AUXILIAR
      ,in_NOMBRE
      ,in_FECHA
      ,in_MONEDA
      ,in_TIPO_CAMBIO
      ,in_TASA_IVA
      ,in_SUB_TOTAL_MO
      ,in_IVA_MO
      ,in_TOTAL_MO
      ,in_TASA_RET_IVA
      ,in_IMP_RET_IVA
      ,in_TASA_RET_ISR
      ,in_IMP_RET_ISR
      ,in_CCS
      ,in_UEN
      ,in_PYS
      ,in_CONCEPTO
      ,in_REFERENCIA
      ,in_GRUPO
      ,in_FLUJO
      ,in_FACTURA
      ,in_ID_CTA_BANCO
      ,in_CLABE
      ,in_PLAZA_CTA
      ,in_TIPO_PAGO
      ,in_FUENTE
      ,in_FOLIO_SOLICITUD
      ,in_ERROR
      ,in_COMENTARIO
      ,cFONDEAR
      );
      
  EXCEPTION WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20201, SQLERRM);           
  END INSERTAR;

  PROCEDURE ACTUALIZA_RESPUESTA
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ,in_FUENTE          IN DETALLE_TABLERO_CTRL_PAGO.FUENTE%TYPE
    ,in_FOLIO_SOLICITUD IN DETALLE_TABLERO_CTRL_PAGO.FOLIO_SOLICITUD%TYPE
    ,in_REFERENCIA      IN DETALLE_TABLERO_CTRL_PAGO.REFERENCIA%TYPE
    ,in_ERROR           IN DETALLE_TABLERO_CTRL_PAGO.ERROR%TYPE
    ,in_COMENTARIO      IN DETALLE_TABLERO_CTRL_PAGO.COMENTARIO%TYPE    
    ) IS
    
  BEGIN
            
    UPDATE DETALLE_TABLERO_CTRL_PAGO
    SET 
        FUENTE            = in_FUENTE
       ,FOLIO_SOLICITUD   = in_FOLIO_SOLICITUD
       ,REFERENCIA        = DECODE(TRIM(in_REFERENCIA), TRIM(REFERENCIA), REFERENCIA, SUBSTR('Ref|' || in_REFERENCIA || '-' || REFERENCIA , 1, 100))
       ,ERROR             = in_ERROR
       ,COMENTARIO        = in_COMENTARIO
       ,STSPROCESO        = decode(in_ERROR, 0, 'PROCSR', 'ERRDER')
       ,CODUSUARIO        = user
       ,FECULTMODIF       = sysdate
    WHERE
        CODCIA            = in_CODCIA
    AND IDPROC            = in_IDPROC
    AND IDPROCDET         = in_IDPROCDET;
  END ACTUALIZA_RESPUESTA;

  PROCEDURE ACTUALIZA_PAGO
  (      
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET       IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ,in_ESTATUS_MIZAR   IN DETALLE_TABLERO_CTRL_PAGO.ESTATUS_MIZAR%TYPE
    ,in_CUENTA_PAGO     IN DETALLE_TABLERO_CTRL_PAGO.CUENTA_PAGO%TYPE
    ,in_NUM_REFERENCIA  IN DETALLE_TABLERO_CTRL_PAGO.NUM_REFERENCIA%TYPE
    ,in_FECHA_PAGO      IN VARCHAR2    
  ) IS
    dFecha_Pago     DATE;
    nCOD_AGENTE     NUMBER;
    nIDNOMINA       NUMBER;
    nIDPOLIZA       NUMBER;
    nIDSINIESTRO    NUMBER;
    nIDDETSIN       NUMBER;
    nNUM_APROBACION NUMBER;
    nCOD_ASEGURADO  NUMBER;
  BEGIN
    BEGIN
        DFecha_pago := TO_DATE(SUBSTR(in_FECHA_PAGO, 1, INSTR(in_FECHA_PAGO, 'T')-1), 'YYYY-MM-DD');
        IF DFecha_pago = TO_DATE('01/01/1900', 'DD/MM/YYYY') THEN
            DFecha_pago := NULL;
        END IF;
    EXCEPTION WHEN OTHERS THEN
        DFecha_pago := NULL;
    END;  
  
    UPDATE DETALLE_TABLERO_CTRL_PAGO
    SET 
        ESTA_PAGADO       = CASE WHEN DFecha_pago IS NOT NULL AND ((UPPER(in_ESTATUS_MIZAR) = 'IMPRESO') OR 
                                      (LENGTH(in_CUENTA_PAGO) > 0 AND  LENGTH(in_NUM_REFERENCIA) > 0)) THEN 'S' ELSE 'N' END
       ,ESTATUS_MIZAR     = in_ESTATUS_MIZAR
       ,CUENTA_PAGO       = in_CUENTA_PAGO
       ,NUM_REFERENCIA    = in_NUM_REFERENCIA
       ,FECHA_PAGO        = DFecha_pago
       ,STSPROCESO        = 'CERRAD'
    WHERE
        CODCIA            = in_CODCIA
    AND IDPROC            = in_IDPROC
    AND IDPROCDET         = in_IDPROCDET;  
  END ACTUALIZA_PAGO;
  
  PROCEDURE ELIMINA
    (
     in_CODCIA          IN DETALLE_TABLERO_CTRL_PAGO.CODCIA%TYPE
    ,in_IDPROC          IN DETALLE_TABLERO_CTRL_PAGO.IDPROC%TYPE
    ,in_IDPROCDET          IN DETALLE_TABLERO_CTRL_PAGO.IDPROCDET%TYPE
    ) IS
  BEGIN
    DELETE FROM DETALLE_TABLERO_CTRL_PAGO
    WHERE
        CODCIA            = in_CODCIA
    AND IDPROC            = in_IDPROC
    AND IDPROCDET         = in_IDPROCDET;
  END ELIMINA;

END GT_DETALLE_TABLERO_CTRL_PAGO;
/
