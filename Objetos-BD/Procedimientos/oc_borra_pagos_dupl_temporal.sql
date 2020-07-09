--
-- OC_BORRA_PAGOS_DUPL_TEMPORAL  (Procedure) 
--
--  Dependencies: 
--   STANDARD (Package)
--   DBMS_OUTPUT (Synonym)
--   SYS_STUB_FOR_PURITY_ANALYSIS (Package)
--   SINIESTRO (Table)
--   DETALLE_APROBACION_ASEG (Table)
--   APROBACION_ASEG (Table)
--   COMPROBANTES_CONTABLES (Table)
--   DETALLE_SINIESTRO_ASEG (Table)
--   TRANSACCION (Table)
--
CREATE OR REPLACE PROCEDURE SICAS_OC.OC_BORRA_PAGOS_DUPL_TEMPORAL IS
nIdTransaccion            TRANSACCION.IdTransaccion%TYPE := 0;
nIdSiniestro              SINIESTRO.IdSiniestro%TYPE := 0;
cTipoComp                 COMPROBANTES_CONTABLES.TipoComprob%TYPE;
nNumComprob               COMPROBANTES_CONTABLES.NumComprob%TYPE;
nSaldo                    NUMBER(18,2);
nCountPagado              NUMBER;

CURSOR SIN_Q IS
   SELECT SI.CodCia, SI.CodEmpresa, SI.IdSiniestro, SI.IdPoliza,
          NumSiniRef NumReferencia, TO_DATE('28-02-2015','dd-mm-yyyy') Fecha,
          Sts_Siniestro Estado, IDetPol, SI.Cod_Asegurado
     FROM SINIESTRO SI, aprobacion_aseg AA
    WHERE SI.NumSiniRef IS NOT NULL /*IdSiniestro IN ()*/
--      AND SI.IdPoliza = 2177
      AND SI.IdSiniestro = AA.IdSiniestro
      AND StsAprobacion = 'EMI'
      AND Benef IS NULL;
    
BEGIN
  FOR SIN IN SIN_Q LOOP -- SINIESTROS
    nIdSiniestro := SIN.IdSiniestro;
dbms_output.put_line('Siniestro '||nIdSiniestro);    
    BEGIN
      SELECT NVL(MONTO_RESERVADO_MONEDA,0) - NVL(MONTO_PAGADO_MONEDA,0)
        INTO nSaldo
        FROM DETALLE_SINIESTRO_ASEG
       WHERE IdSiniestro = nIdSiniestro;
    EXCEPTION
      WHEN OTHERS THEN
        nSaldo := 1;
    END;
    
    BEGIN
      SELECT COUNT(*)
        INTO nCountPagado
        FROM APROBACION_ASEG
       WHERE IdSiniestro = nIdSiniestro
         AND StsAprobacion = 'PAG';
    END;
    
dbms_output.put_line('Saldo '||nSaldo);    
dbms_output.put_line('nCountPagado '||nCountPagado);    
--    IF nSaldo = 0 AND nCountPagado > 0 THEN
dbms_output.put_line('Entra a Borrar ');
       --
       DELETE FROM DETALLE_APROBACION_ASEG
        WHERE (IdSiniestro,Num_Aprobacion) IN
              (SELECT IdSiniestro,Num_Aprobacion
                 FROM APROBACION_ASEG
                WHERE IdSiniestro = nIdSiniestro
                  AND StsAprobacion = 'EMI');
       --
       DELETE FROM APROBACION_ASEG
        WHERE IdSiniestro = nIdSiniestro
          AND StsAprobacion = 'EMI';
       --
--    END IF;

  END LOOP; -- SINIESTROS
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Siniestro: '||nIdSiniestro||' Error en '||SQLERRM);
END OC_BORRA_PAGOS_DUPL_TEMPORAL;
/

--
-- OC_BORRA_PAGOS_DUPL_TEMPORAL  (Synonym) 
--
--  Dependencies: 
--   OC_BORRA_PAGOS_DUPL_TEMPORAL (Procedure)
--
CREATE OR REPLACE PUBLIC SYNONYM OC_BORRA_PAGOS_DUPL_TEMPORAL FOR SICAS_OC.OC_BORRA_PAGOS_DUPL_TEMPORAL
/
