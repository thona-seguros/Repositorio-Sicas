PROCEDURE              "PROC_EMITAR" IS

CURSOR REG_Q IS
   SELECT IdProcMasivo, TipoProceso
     FROM PROCESOS_MASIVOS
    WHERE StsRegProceso IN ('XPROC','ERROR')
      AND TipoProceso = 'EMITAR'
    ORDER BY IdProcMasivo;
BEGIN
    FOR X IN REG_Q LOOP
      OC_PROCESOS_MASIVOS.PROCESO_REGISTRO(X.IdProcMasivo, X.TipoProceso);
      COMMIT;
    END LOOP;
END;
 
 
 
 
 
