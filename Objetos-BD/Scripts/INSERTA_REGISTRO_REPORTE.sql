DECLARE
nNumRepor          REPORTE.IDREPORTE %TYPE;
nNumParametro      REPORTE_PARAMETRO.IDPARAMETRO %TYPE;
nNOrden            REPORTE_PARAMETRO.NUMORDEN %TYPE;
cNombPara          REPORTE_PARAMETRO.NOM_PARAM %TYPE;
cDescPara          REPORTE_PARAMETRO.DESC_PARAM %TYPE;
    
BEGIN   
    SELECT MAX(IDREPORTE)
    INTO nNumRepor
    FROM REPORTE;
    
    nNumRepor := nNumRepor +1;
         
         INSERT INTO REPORTE
                (IDREPORTE, REPORTE,DESCRIPCION)
         VALUES (nNumRepor, 'KITEMISI', 'KIT DE DOCUMENTOS DE EMISION O POLIZAS');
        
    COMMIT;
         
    BEGIN
       FOR i in 1..2
       LOOP
       SELECT MAX(IDPARAMETRO)
       INTO nNumParametro
       FROM REPORTE_PARAMETRO;
       
       nNumParametro := nNumParametro +1;
       
       IF i = 1 THEN
        nNOrden := 1;
        cNombPara := 'P_POLIZA';
        cDescPara := 'CONSECUTIVO';
       ELSIF i = 2 THEN
        nNOrden := 2;
        cNombPara := 'P_CODCIA';
        cDescPara := 'CODIGO COMPAÑÍA';
       END IF;
       
       INSERT INTO REPORTE_PARAMETRO
                (IDPARAMETRO, IDREPORTE, NUMORDEN, NOM_PARAM, TIPO_PARAM, DESC_PARAM, VALINI_PARAM, LISTVAL_PARAM)
         VALUES (nNumParametro, nNumRepor, nNOrden, cNombPara, 'VARCHAR', cDescPara, 1, NULL);
       END LOOP;
    END;
COMMIT;
END;