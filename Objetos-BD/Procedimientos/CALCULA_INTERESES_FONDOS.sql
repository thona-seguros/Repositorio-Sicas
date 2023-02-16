PROCEDURE CALCULA_INTERESES_FONDOS IS
dFecCalculo        DATE := TRUNC(SYSDATE);
nSaldoFondo        FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
nMontoInteres      FAI_CONCENTRADORA_FONDO.MontoMovMoneda%TYPE;
cPeriodicidad      FAI_TIPOS_DE_INTERES.Periodicidad%TYPE;
dFecUltInt         FAI_CONCENTRADORA_FONDO.FecMovimiento%TYPE;
cCodCptoRet        FAI_CONCENTRADORA_FONDO.CodCptoMov%TYPE;
nDiasPeriodicidad  NUMBER(5);
cIntCalculados     VARCHAR2(1);

CURSOR FOND_Q IS
   SELECT F.CodCia, F.CodEmpresa, F.IdPoliza, F.IDetPol, F.CodAsegurado, F.IdFondo, F.TipoFondo,
          GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(F.CodCia, F.CodEmpresa, F.IdPoliza, F.IDetPol, 
                                                         F.CodAsegurado, F.IdFondo, dFecCalculo) SaldoFondo,
          GT_FAI_TIPOS_DE_FONDOS.TIPO_INTERES(F.CodCia, F.CodEmpresa, F.TipoFondo) TipoInteres,
          F.FecEmision
     FROM FAI_FONDOS_DETALLE_POLIZA F, POLIZAS P
    WHERE F.CodCia          > 0
      AND F.CodEmpresa      > 0
      AND F.IdPoliza        > 0
      AND F.IDetPol         > 0
      AND F.CodAsegurado    > 0
      AND F.StsFondo        = 'EMITID'
      AND F.CodCia        = P.CodCia
      AND F.CodEmpresa    = P.CodEmpresa
      AND F.IdPoliza      = P.IdPoliza
      AND P.FecFinVig     >= dFecCalculo;
    /*SELECT CodCia, CodEmpresa, IdPoliza, IDetPol, CodAsegurado, IdFondo, TipoFondo,
           GT_FAI_CONCENTRADORA_FONDO.SALDO_CONCENTRADORA(CodCia, CodEmpresa, IdPoliza, IDetPol, 
                                                          CodAsegurado, IdFondo, dFecCalculo) SaldoFondo,
           GT_FAI_TIPOS_DE_FONDOS.TIPO_INTERES(CodCia, CodEmpresa, TipoFondo) TipoInteres,
           FecEmision
      FROM FAI_FONDOS_DETALLE_POLIZA
     WHERE CodCia          > 0
       AND CodEmpresa      > 0
       AND IdPoliza        > 0
       AND IDetPol         > 0
       AND CodAsegurado    > 0
       AND StsFondo        = 'EMITID';*/
BEGIN
   FOR W IN FOND_Q LOOP
      BEGIN
         cPeriodicidad     := GT_FAI_TIPOS_DE_INTERES.PERIODICIDAD(W.TipoInteres);
         nDiasPeriodicidad := TO_NUMBER(OC_VALORES_DE_LISTAS.BUSCA_LVALOR('DIASPERIOD', cPeriodicidad));
      EXCEPTION
         WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20200,'Error en Periodicidad/Intereses de Rutina INTGRAL para Tipo de Interes ' || W.TipoInteres);
      END;

      -- Se Lee Fecha de Ultimo Cálculo de Intereses
      BEGIN
         SELECT MAX(CF.FecMovimiento)
           INTO dFecUltInt
           FROM FAI_CONCENTRADORA_FONDO CF, FAI_MOVIMIENTOS_FONDOS MF
          WHERE MF.TipoMov       IN ('IN','IT')
            AND MF.CodCptoMov     = CF.CodCptoMov
            AND MF.CodCia         = CF.CodCia
            AND MF.CodEmpresa     = CF.CodEmpresa
            AND MF.TipoFondo      = W.TipoFondo
            AND CF.CodCia         = W.CodCia
            AND CF.CodEmpresa     = W.CodEmpresa
            AND CF.IdPoliza       = W.IdPoliza
            AND CF.IDetPol        = W.IDetPol
            AND CF.CodAsegurado   = W.CodAsegurado
            AND CF.IdFondo        = W.IdFondo;

         IF dFecUltInt IS NULL THEN
            cIntCalculados := 'N';
            -- Sino Existe Fecha de Intereses se lee el Primer Movimiento
            BEGIN
               SELECT MIN(FecMovimiento)
                 INTO dFecUltInt
                 FROM FAI_CONCENTRADORA_FONDO
                WHERE CodCia         = W.CodCia
                  AND CodEmpresa     = W.CodEmpresa
                  AND IdPoliza       = W.IdPoliza
                  AND IDetPol        = W.IDetPol
                  AND CodAsegurado   = W.CodAsegurado
                  AND IdFondo        = W.IdFondo;
            END;
         ELSE
            cIntCalculados := 'S';
            dFecUltInt     := TRUNC(dFecUltInt);
         END IF;
      END;

      IF (dFecCalculo - dFecUltInt) >= nDiasPeriodicidad OR 
         (TRUNC(W.FecEmision) = TRUNC(dFecUltInt) AND nDiasPeriodicidad = 1 AND cIntCalculados = 'N') THEN
         IF W.SaldoFondo > 0 THEN
            BEGIN
               GT_FAI_CONCENTRADORA_FONDO.CALCULA_INTERES_FONDO(W.CodCia, W.CodEmpresa, W.IdPoliza, W.IDetPol, 
                                                                W.CodAsegurado, W.TipoFondo, W.IdFondo,
                                                                dFecCalculo, W.SaldoFondo, NULL, nMontoInteres);
               GT_FAI_CONCENTRADORA_FONDO.ACTIVA_MOVIMIENTOS(W.CodCia, W.CodEmpresa, W.IdPoliza, W.IDetPol, 
                                                             W.CodAsegurado, W.IdFondo, 0);

               BEGIN
                  cCodCptoRet := GT_FAI_MOVIMIENTOS_FONDOS.CONCEPTO_MOVIMIENTO(W.CodCia, W.CodEmpresa, W.TipoFondo, 'RE');
                  GT_FAI_CONCENTRADORA_FONDO.APLICA_RETENCION(W.CodCia, W.CodEmpresa, W.IdPoliza, W.IDetPol, 
                                                              W.CodAsegurado, W.TipoFondo, W.IdFondo, 0, 
                                                              dFecCalculo, cCodCptoRet, 0, 0, nDiasPeriodicidad);
               EXCEPTION
                  WHEN OTHERS THEN
                     NULL;
               END;
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE_APPLICATION_ERROR(-20200,'Error en Intereses o Retención ISR para Tipo de Fondo ' || W.TipoFondo);
            END;
         END IF;
      END IF;
   END LOOP;
   COMMIT;
END;
