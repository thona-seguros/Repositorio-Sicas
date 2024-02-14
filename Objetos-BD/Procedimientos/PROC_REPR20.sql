CREATE OR REPLACE PROCEDURE PROC_REPR20  IS
    codcia          NUMBER        := 1;
    codempresa      NUMBER        := 1;
    PcIdTipoSeg     VARCHAR2(100) := NULL;
    PcPlanCob       VARCHAR2(100) := NULL;
    PcCodMoneda     VARCHAR2(100) := NULL;
    PcCodAgente     VARCHAR2(100) := NULL;
    dFecDesde       DATE :=  SYSDATE-1;
    dFecHasta       DATE :=  SYSDATE-1;
    Formato         VARCHAR2(100) := 'REGISTRO';
    CORREOS         VARCHAR2(100) ; --:= 'i.gomez@darbrain.com;rmartinez@thonaseguros.mx;jcastillo@thonaseguros.mx';
    w_ID_ENVIO      NUMBER;
BEGIN
    OC_REPOFACT.PRIMA_NETA_COB      (codcia, codempresa, PcIdTipoSeg, PcPlanCob, PcCodMoneda, PcCodAgente, dFecDesde, dFecHasta, Formato, CORREOS, w_ID_ENVIO);
    OC_REPOFACT.RECIBOS_ANULADOS_COB(codcia, codempresa, PcIdTipoSeg, PcPlanCob, PcCodMoneda, PcCodAgente, dFecDesde, dFecHasta, Formato, CORREOS, w_ID_ENVIO);
    OC_REPOFACT.RECIBOS_EMITIDOS_COB(codcia, codempresa, PcIdTipoSeg, PcPlanCob, PcCodMoneda, PcCodAgente, dFecDesde, dFecHasta, Formato, CORREOS, w_ID_ENVIO);
    OC_REPOFACT.RECIBOS_PAGADOS_COB (codcia, codempresa, PcIdTipoSeg, PcPlanCob, PcCodMoneda, PcCodAgente, dFecDesde, dFecHasta, Formato, CORREOS, w_ID_ENVIO);
    OC_REPOFACT.DEUDOR_X_PRIMAS_COB (codcia, codempresa, PcIdTipoSeg, PcPlanCob, PcCodMoneda, PcCodAgente,            dFecHasta, Formato, CORREOS, w_ID_ENVIO);
EXCEPTION WHEN OTHERS THEN
   RAISE_APPLICATION_ERROR(-20000, 'Error en el Job de PROC_REPR20 ' || SQLERRM);
END PROC_REPR20;
/
